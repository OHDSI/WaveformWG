"""Exercise 2 (reference solution): load the Waveform Extension tables and validate them.

You write the transformation yourself in the exercise; src/etl_waveform.py is the full reference.
This script runs the checks you should apply to *your* tables (point TABLES at your output folder).
"""
import sys
from pathlib import Path

import pandas as pd

DATA = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parents[2] / "data"
WFE = DATA / "waveform_extension"
t = {n: pd.read_csv(WFE / f"{n}.csv") for n in ("waveform_occurrence", "waveform_registry", "waveform_channel_metadata", "waveform_feature")}
occ, reg, chan, feat = (t[n] for n in ("waveform_occurrence", "waveform_registry", "waveform_channel_metadata", "waveform_feature"))
person = pd.read_csv(DATA / "omop" / "person.csv"); visit = pd.read_csv(DATA / "omop" / "visit_occurrence.csv")

checks = {
    # referential integrity
    "occurrence -> person": occ.person_id.isin(person.person_id).all(),
    "occurrence -> visit": occ.visit_occurrence_id.isin(visit.visit_occurrence_id).all(),
    "registry -> occurrence": reg.waveform_occurrence_id.isin(occ.waveform_occurrence_id).all(),
    "channel_metadata -> registry": chan.waveform_registry_id.isin(reg.waveform_registry_id).all(),
    "feature -> registry": feat.waveform_registry_id.isin(reg.waveform_registry_id).all(),
    "feature -> channel_metadata": feat.waveform_channel_metadata_id.isin(chan.waveform_channel_metadata_id).all(),
    # temporal consistency
    "occurrence end >= start": (pd.to_datetime(occ.waveform_occurrence_end_datetime) >= pd.to_datetime(occ.waveform_occurrence_start_datetime)).all(),
    "registry end >= start": (pd.to_datetime(reg.waveform_file_end_datetime) >= pd.to_datetime(reg.waveform_file_start_datetime)).all(),
    # completeness / consistency
    "num_of_files matches registry": (occ.set_index("waveform_occurrence_id").num_of_files
                                      == reg.groupby("waveform_occurrence_id").size()).all(),
    "every registry target file exists": all((DATA / u).exists() for u in reg.waveform_target_file_uri),
    "ECG falls inside its visit (plausibility)": bool(
        (lambda m: ((m.waveform_occurrence_start_datetime >= m.visit_start_datetime) & (m.waveform_occurrence_end_datetime <= m.visit_end_datetime)).all())(
            occ.assign(waveform_occurrence_start_datetime=pd.to_datetime(occ.waveform_occurrence_start_datetime),
                       waveform_occurrence_end_datetime=pd.to_datetime(occ.waveform_occurrence_end_datetime))
               .merge(visit.assign(visit_start_datetime=pd.to_datetime(visit.visit_start_datetime), visit_end_datetime=pd.to_datetime(visit.visit_end_datetime)),
                      on="visit_occurrence_id"))),
    "feature has a value": (feat.value_as_number.notna() | feat.value_as_concept_id.notna() | feat.value_as_string.notna()).all(),
}
for name, ok in checks.items():
    print(("PASS  " if ok else "FAIL  ") + name)
print(f"\noccurrences={len(occ)} registry files={len(reg)} channel metadata rows={len(chan)} features={len(feat)}")
per = occ.groupby("person_id").size()
print(f"persons with ECGs={len(per)}  with 1 ECG={int((per == 1).sum())}  with 2 ECGs={int((per == 2).sum())}")
sys.exit(0 if all(checks.values()) else 1)
