"""Step 1 - simulate the *source* data: a cohort, its EHR facts, and WFDB ECG recordings.

Outputs
  data/omop/{person,observation_period,visit_occurrence,condition_occurrence,
             drug_exposure,measurement}.csv       (labs only at this stage)
  data/source/ecg_manifest.csv                    (what the ECG export system knows)
  data/wfdb/A*.hea|.dat                           (real WFDB records, format 16)
  data/answer_key/{persons,records}_truth.csv, effects.json
"""
import datetime as dt
import json

import numpy as np
import pandas as pd
import wfdb

from common import *
from ecgsim import simulate_lead_pair, to_digital

N = 300
TRUE_TAU = {"female": 14.0, "male": 6.0}          # ms effect of drug A on QTcF


def expit(x):
    return 1 / (1 + np.exp(-x))


def main():
    rng = np.random.default_rng(SEED)
    for d in (OMOP, WFDB, KEY, DATA / "source"):
        d.mkdir(parents=True, exist_ok=True)
    for f in WFDB.glob("A*"):
        f.unlink()

    # ---- person-level covariates ---------------------------------------
    pid = np.arange(1, N + 1)
    age = np.clip(rng.normal(62, 14, N), 25, 92).round().astype(int)
    female = rng.binomial(1, 0.5, N)
    hf = rng.binomial(1, expit(-2.2 + 0.035 * (age - 60)))
    htn = rng.binomial(1, expit(-0.4 + 0.04 * (age - 60)))
    t2dm = rng.binomial(1, expit(-1.6 + 0.02 * (age - 60)))
    k = np.clip(rng.normal(4.0, 0.45, N) - 0.15 * hf, 2.8, 5.4).round(1)

    # ---- treatment: new user of drug A vs comparator B (or neither) -------
    ps = expit(-0.5 + 0.03 * (age - 60) + 0.35 * female - 0.8 * hf + 1.5 * (4.0 - k))
    exposed = rng.binomial(1, 0.88, N)                       # 12% receive neither drug
    treated = rng.binomial(1, ps)

    # ---- ECG truth -------------------------------------------------------
    u = rng.normal(0, 12, N)
    base_qtcf = 400 + 8 * female + 0.50 * (age - 60) + 10 * hf + 3 * t2dm - 14 * (k - 4.0) + u
    tau = np.where(female == 1, TRUE_TAU["female"], TRUE_TAU["male"])
    y0 = base_qtcf + rng.normal(0, 5, N)                     # follow-up QTcF if given B / nothing
    y1 = y0 + tau                                            # ... if given A
    base_hr = np.clip(78 - 0.25 * (age - 60) + 6 * hf + rng.normal(0, 8, N), 48, 125)
    qrs = np.clip(92 + 0.2 * (age - 60) + 8 * hf + rng.normal(0, 6, N), 70, 140)
    has_followup = (rng.random(N) > 0.08) & (exposed == 1)

    # ---- visits, periods, conditions, drugs, labs -------------------------
    start0 = dt.date(2024, 1, 8)
    vstart = [start0 + dt.timedelta(days=int(d)) for d in rng.integers(0, 520, N)]
    vlen = rng.integers(3, 11, N)
    person = pd.DataFrame(dict(
        person_id=pid, gender_concept_id=np.where(female == 1, C_FEMALE, C_MALE),
        year_of_birth=[v.year - a for v, a in zip(vstart, age)], month_of_birth=rng.integers(1, 13, N),
        day_of_birth=rng.integers(1, 29, N), birth_datetime="", race_concept_id=0, ethnicity_concept_id=0,
        location_id="", provider_id="", care_site_id="", person_source_value=[f"MRN{100000 + i * 7}" for i in pid],
        gender_source_value=np.where(female == 1, "F", "M"), gender_source_concept_id=0, race_source_value="",
        race_source_concept_id=0, ethnicity_source_value="", ethnicity_source_concept_id=0))
    visit = pd.DataFrame(dict(
        visit_occurrence_id=pid, person_id=pid, visit_concept_id=C_INPATIENT,
        visit_start_date=vstart, visit_start_datetime=[f"{v} 06:00:00" for v in vstart],
        visit_end_date=[v + dt.timedelta(days=int(l)) for v, l in zip(vstart, vlen)],
        visit_end_datetime=[f"{v + dt.timedelta(days=int(l))} 12:00:00" for v, l in zip(vstart, vlen)],
        visit_type_concept_id=32817, provider_id="", care_site_id="",
        visit_source_value=[f"ENC{200000 + i * 3}" for i in pid], visit_source_concept_id=0))
    obsp = pd.DataFrame(dict(
        observation_period_id=pid, person_id=pid,
        observation_period_start_date=[v - dt.timedelta(days=365) for v in vstart],
        observation_period_end_date=[v + dt.timedelta(days=int(l) + 30) for v, l in zip(vstart, vlen)],
        period_type_concept_id=32817))
    cond = []
    for name, flag, cid in (("Heart failure", hf, C_HEART_FAILURE), ("Essential hypertension", htn, C_HYPERTENSION),
                            ("Type 2 diabetes mellitus", t2dm, C_T2DM)):
        for i in np.where(flag == 1)[0]:
            d = vstart[i] - dt.timedelta(days=int(rng.integers(30, 2000)))
            cond.append(dict(person_id=pid[i], condition_concept_id=cid, condition_start_date=d,
                             condition_start_datetime=f"{d} 00:00:00", condition_end_date="",
                             condition_end_datetime="", condition_type_concept_id=32817, condition_status_concept_id=0,
                             stop_reason="", provider_id="", visit_occurrence_id="", visit_detail_id="",
                             condition_source_value=name, condition_source_concept_id=0, condition_status_source_value=""))
    cond = pd.DataFrame(cond).sort_values(["person_id", "condition_concept_id"])
    cond.insert(0, "condition_occurrence_id", range(1, len(cond) + 1))

    # index = drug start: day 1 of the visit, 12:00-17:59
    idx_dt = [dt.datetime.combine(v + dt.timedelta(days=1), dt.time(int(rng.integers(12, 18)), int(rng.integers(0, 60))))
              for v in vstart]
    de = []
    for i in np.where(exposed == 1)[0]:
        de.append(dict(person_id=pid[i], drug_concept_id=C_DRUG_A if treated[i] else C_DRUG_B,
                       drug_exposure_start_date=idx_dt[i].date(), drug_exposure_start_datetime=idx_dt[i],
                       drug_exposure_end_date=(idx_dt[i] + dt.timedelta(days=3)).date(),
                       drug_exposure_end_datetime=idx_dt[i] + dt.timedelta(days=3), verbatim_end_date="",
                       drug_type_concept_id=32817, stop_reason="", refills="", quantity="", days_supply=3,
                       sig="", route_concept_id=0, lot_number="", provider_id="", visit_occurrence_id=pid[i],
                       visit_detail_id="", drug_source_value="ANTIEMETIC_A" if treated[i] else "ANTIEMETIC_B",
                       drug_source_concept_id=0, route_source_value="", dose_unit_source_value=""))
    de = pd.DataFrame(de)
    de.insert(0, "drug_exposure_id", range(1, len(de) + 1))
    meas = pd.DataFrame(dict(
        measurement_id=pid, person_id=pid, measurement_concept_id=C_POTASSIUM,
        measurement_date=vstart, measurement_datetime=[f"{v} 07:00:00" for v in vstart], measurement_time="",
        measurement_type_concept_id=C_LAB_TYPE, operator_concept_id=0, value_as_number=k, value_as_concept_id=0,
        unit_concept_id=C_MMOL_L, range_low=3.5, range_high=5.1, provider_id="", visit_occurrence_id=pid,
        visit_detail_id="", measurement_source_value="K_SERUM", measurement_source_concept_id=0,
        unit_source_value="mmol/L", unit_source_concept_id=0, value_source_value=k.astype(str)))

    # ---- ECG recordings (WFDB) --------------------------------------------
    manifest, truth = [], []
    acc = 0

    def record(i, period, when, qtcf, hr, noisy):
        nonlocal acc
        acc += 1
        name = f"A{acc:07d}"
        s1, s2, tr = simulate_lead_pair(rng, hr, qtcf, qrs[i], noisy)
        d = to_digital(s1, s2)
        d3 = (d[:, 1].astype(np.int32) - d[:, 0]).astype(np.int16)      # Einthoven: III = II - I
        wfdb.wrsamp(name, fs=FS, units=["mV"] * 3, sig_name=LEADS, d_signal=np.column_stack([d, d3]),
                    fmt=["16"] * 3, adc_gain=[GAIN] * 3, baseline=[0] * 3, base_time=when.time(),
                    base_date=when.date(), write_dir=str(WFDB),
                    comments=["Synthetic ECG, OHDSI Waveform WG tutorial. No real patient data.",
                              f"Accession: {name}"])
        manifest.append(dict(accession=name, mrn=person.person_source_value[i], encounter=visit.visit_source_value[i],
                             acquisition_datetime=when, export_path=f"/exports/ecg/{name}.hea"))
        truth.append(dict(accession=name, person_id=pid[i], period=period, noisy=int(noisy), **tr))

    for i in range(N):
        noisy = lambda: bool(rng.random() < 0.07)
        hr_b = base_hr[i]
        base_when = idx_dt[i] - dt.timedelta(hours=int(rng.integers(1, 7)))
        record(i, "baseline", base_when, base_qtcf[i], hr_b, noisy())
        if has_followup[i]:
            when = idx_dt[i] + dt.timedelta(hours=int(rng.integers(20, 40)))
            record(i, "followup", when, y1[i] if treated[i] else y0[i], np.clip(hr_b + rng.normal(0, 5), 45, 130), noisy())

    pd.DataFrame(manifest).to_csv(DATA / "source" / "ecg_manifest.csv", index=False)
    rec_truth = pd.DataFrame(truth).round(3)
    rec_truth.to_csv(KEY / "records_truth.csv", index=False)

    pt = pd.DataFrame(dict(person_id=pid, age=age, female=female, heart_failure=hf, hypertension=htn, t2dm=t2dm,
                           potassium=k, exposed=exposed, treated_A=treated, true_propensity=ps.round(4),
                           baseline_qtcf_true=base_qtcf.round(2), qtcf_if_A=y1.round(2), qtcf_if_B_or_none=y0.round(2),
                           effect_on_qtcf=tau, qrs_ms_true=qrs.round(1), has_followup=has_followup.astype(int)))
    pt.to_csv(KEY / "persons_truth.csv", index=False)

    cohort = (exposed == 1) & has_followup
    effects = dict(
        note="Sample-level truths from the simulated potential outcomes. Synthetic and exaggerated; do not quote.",
        n_persons=N, n_cohort=int(cohort.sum()), n_treated_A=int((cohort & (treated == 1)).sum()),
        n_comparator_B=int((cohort & (treated == 0)).sum()),
        true_effect_on_qtcf_ms={
            "ATE": round(float(tau[cohort].mean()), 2), "ATT": round(float(tau[cohort & (treated == 1)].mean()), 2),
            "by_sex": TRUE_TAU},
        true_effect_on_qrs_ms=0.0, true_effect_on_heart_rate_bpm=0.0)
    json.dump(effects, open(KEY / "effects.json", "w"), indent=2)

    for df, nm in ((person, "person"), (obsp, "observation_period"), (visit, "visit_occurrence"), (cond, "condition_occurrence"),
                   (de, "drug_exposure"), (meas, "measurement")):
        df.to_csv(OMOP / f"{nm}.csv", index=False)
    print(f"persons={N} cohort={int(cohort.sum())} records={acc}")


if __name__ == "__main__":
    main()
