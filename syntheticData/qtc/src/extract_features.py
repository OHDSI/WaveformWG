"""Step 3 - derive ECG features and store them the Waveform Extension way.

For each ECG: read the WFDB record, run the lead II interval detector, then write
  * one MEASUREMENT row per feature (the standard, analyzable fact), and
  * one waveform_feature row per feature (provenance: which file, channel, algorithm),
    linked by measurement_id.
Records flagged as low signal quality carry value_as_concept_id = 'Low signal quality'.
"""
import datetime as dt

import pandas as pd
import wfdb

from common import *
from qtcdetect import analyze

FEATURES = [  # key in detector output, measurement concept, unit concept, unit text, algorithm concept, algorithm text
    ("hr_bpm", C_HR, C_BPM, "bpm", C_ALGO, "tutorial detector v1 (mean RR)"),
    ("rr_ms", C_RR, C_MS, "ms", C_ALGO, "tutorial detector v1"),
    ("qt_ms", C_QT, C_MS, "ms", C_ALGO, "tutorial detector v1 (median of beats)"),
    ("qtcb_ms", C_QTCB, C_MS, "ms", C_ALGO_BAZETT, "Bazett: QT / sqrt(RR)"),
    ("qtcf_ms", C_QTCF, C_MS, "ms", C_ALGO_FRIDERICIA, "Fridericia: QT / RR^(1/3)"),
    ("qrs_ms", C_QRS, C_MS, "ms", C_ALGO, "tutorial detector v1 (median of beats)"),
    ("noise_mv", C_NOISE, C_MV, "mV", C_ALGO, "SD of 60-100 Hz band"),
]


def main():
    occ = pd.read_csv(WFE / "waveform_occurrence.csv", parse_dates=["waveform_occurrence_start_datetime", "waveform_occurrence_end_datetime"])
    reg = pd.read_csv(WFE / "waveform_registry.csv")
    chan = pd.read_csv(WFE / "waveform_channel_metadata.csv")
    dat = reg[reg.file_extension_source_value == ".dat"].set_index("waveform_occurrence_id")
    lead2 = chan[(chan.channel_concept_id == C_LEAD["II"]) & (chan.metadata_source_value == "sampling_rate")] \
        .set_index("waveform_registry_id").waveform_channel_metadata_id

    meas, feat = [], []
    mid, fid = 1_000_000, 0
    for o in occ.itertuples():
        r = wfdb.rdrecord(str(WFDB / o.waveform_occurrence_source_value))
        f = analyze(r.p_signal[:, r.sig_name.index("II")], r.fs)
        rid = int(dat.loc[o.waveform_occurrence_id, "waveform_registry_id"])
        t0, t1 = o.waveform_occurrence_start_datetime, o.waveform_occurrence_end_datetime
        for key, mconc, uconc, utxt, aconc, atxt in FEATURES:
            val = f.get(key)
            if val is None or pd.isna(val):
                continue
            mid += 1
            fid += 1
            meas.append(dict(
                measurement_id=mid, person_id=o.person_id, measurement_concept_id=mconc,
                measurement_date=t0.date(), measurement_datetime=t0, measurement_time="",
                measurement_type_concept_id=C_DERIVED_TYPE, operator_concept_id=0, value_as_number=round(float(val), 3),
                value_as_concept_id=0, unit_concept_id=uconc, range_low="", range_high="", provider_id="",
                visit_occurrence_id=o.visit_occurrence_id, visit_detail_id="",
                measurement_source_value=f"ECG_{key.upper()}", measurement_source_concept_id=0, unit_source_value=utxt,
                unit_source_concept_id=0, value_source_value=""))
            feat.append(dict(
                waveform_feature_id=fid, waveform_occurrence_id=o.waveform_occurrence_id, waveform_registry_id=rid,
                waveform_channel_metadata_id=int(lead2[rid]), measurement_id=mid, observation_id="",
                algorithm_concept_id=aconc, algorithm_source_value=atxt, anatomic_site_concept_id="",
                waveform_feature_start_timestamp=t0.time(), waveform_feature_end_timestamp=t1.time(),
                is_feature_overflow=False, value_as_number=round(float(val), 3),
                value_as_concept_id=C_LOW_QUALITY if f["low_quality"] else "", value_as_string="",
                value_is_a_registry_file=False, unit_concept_id=uconc, unit_source_value=utxt))
    labs = pd.read_csv(OMOP / "measurement.csv")
    labs = labs[labs.measurement_id < 1_000_000]
    pd.concat([labs, pd.DataFrame(meas)], ignore_index=True).to_csv(OMOP / "measurement.csv", index=False)
    pd.DataFrame(feat).to_csv(WFE / "waveform_feature.csv", index=False)
    print(f"features={len(feat)} low_quality_records={int(sum(1 for x in feat if x['value_as_concept_id'] != '') / len(FEATURES))}")


if __name__ == "__main__":
    main()
