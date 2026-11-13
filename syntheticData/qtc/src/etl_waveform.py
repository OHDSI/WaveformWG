"""Step 2 - the reference transformation: WFDB files + ECG export manifest -> Waveform Extension tables.

Reads only what a real ETL would have: the WFDB headers, the export manifest, and the
OMOP PERSON / VISIT_OCCURRENCE tables (to resolve MRN and encounter ids).

Writes data/waveform_extension/{waveform_occurrence,waveform_registry,waveform_channel_metadata}.csv
and data/omop/concept.csv.
"""
import datetime as dt

import pandas as pd
import wfdb

from common import *


def main():
    WFE.mkdir(parents=True, exist_ok=True)
    man = pd.read_csv(DATA / "source" / "ecg_manifest.csv", parse_dates=["acquisition_datetime"])
    person = pd.read_csv(OMOP / "person.csv", usecols=["person_id", "person_source_value"])
    visit = pd.read_csv(OMOP / "visit_occurrence.csv", usecols=["visit_occurrence_id", "visit_source_value"])
    man = (man.merge(person, left_on="mrn", right_on="person_source_value", how="left", validate="m:1")
              .merge(visit, left_on="encounter", right_on="visit_source_value", how="left", validate="m:1")
              .sort_values("accession").reset_index(drop=True))
    assert man.person_id.notna().all() and man.visit_occurrence_id.notna().all(), "unlinked ECG"

    occ, reg, chan = [], [], []
    cm_id = 0
    for n, row in man.iterrows():
        oid, hdr = n + 1, wfdb.rdheader(str(WFDB / row.accession))
        start = dt.datetime.combine(hdr.base_date, hdr.base_time)
        assert start == row.acquisition_datetime, "header and manifest disagree on acquisition time"
        end = start + dt.timedelta(seconds=hdr.sig_len / hdr.fs)
        occ.append(dict(
            waveform_occurrence_id=oid, waveform_occurrence_concept_id=C_DIAGNOSTIC_ECG, person_id=int(row.person_id),
            waveform_occurrence_start_datetime=start, waveform_occurrence_end_datetime=end,
            visit_occurrence_id=int(row.visit_occurrence_id), visit_detail_id="", preceding_waveform_occurrence_id="",
            waveform_format_concept_id=C_WFDB, waveform_occurrence_source_value=row.accession, num_of_files=2,
            waveform_format_source_value="WFDB"))
        for ext, cid in ((".hea", C_HEA), (".dat", C_DAT)):
            rid = len(reg) + 1
            reg.append(dict(
                waveform_registry_id=rid, waveform_occurrence_id=oid, waveform_feature_id="", person_id=int(row.person_id),
                waveform_file_start_datetime=start, waveform_file_end_datetime=end,
                visit_occurrence_id=int(row.visit_occurrence_id), visit_detail_id="", file_extension_concept_id=cid,
                file_extension_source_value=ext, waveform_source_file_uri=row.export_path.replace(".hea", ext),
                waveform_target_file_uri=f"wfdb/{row.accession}{ext}"))
            if ext == ".dat":
                for ch, lead in enumerate(hdr.sig_name):
                    for src, cons, val, unit_c, unit_s in (
                            ("sampling_rate", C_SAMPLERATE, hdr.fs, C_SPS, "sps"),
                            ("resolution", C_RESOLUTION, hdr.adc_gain[ch], C_ADU_PER_MV, "ADU/mV")):
                        cm_id += 1
                        chan.append(dict(
                            waveform_channel_metadata_id=cm_id, waveform_registry_id=rid, procedure_occurrence_id="",
                            device_exposure_id="", waveform_channel_source_value=f"Lead {lead}",
                            channel_concept_id=C_LEAD[lead], metadata_source_value=src, metadata_concept_id=cons,
                            value_as_number=val, value_as_concept_id="", value_as_string="",
                            unit_concept_id=unit_c, unit_source_value=unit_s))
    occ = pd.DataFrame(occ)
    # link each follow-up ECG to the same person's previous ECG
    occ = occ.sort_values(["person_id", "waveform_occurrence_start_datetime"])
    prev = occ.groupby("person_id").waveform_occurrence_id.shift(1)
    occ["preceding_waveform_occurrence_id"] = prev.astype("Int64")
    occ.sort_values("waveform_occurrence_id").to_csv(WFE / "waveform_occurrence.csv", index=False)
    pd.DataFrame(reg).to_csv(WFE / "waveform_registry.csv", index=False)
    pd.DataFrame(chan).to_csv(WFE / "waveform_channel_metadata.csv", index=False)

    concepts = {**{k: (v[0], v[1], "WAVEFORM" if k > 2082490000 else "OMOP") for k, v in STANDARD_NAMES.items()},
                **{k: (v[0], v[1], "TutorialLocal") for k, v in LOCAL.items()}}
    pd.DataFrame([dict(concept_id=k, concept_name=v[0], domain_id=v[1], vocabulary_id=v[2]) for k, v in sorted(concepts.items())]) \
        .to_csv(OMOP / "concept.csv", index=False)
    print(f"occurrences={len(occ)} registry={len(reg)} channel_metadata={len(chan)}")


if __name__ == "__main__":
    main()
