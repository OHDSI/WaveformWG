#!/usr/bin/env python3
"""Checks for the synthetic QTc dataset and its tutorial. Run after syntheticData/qtc/build.sh.

  python3 .github/benchmark/check_qtc.py

Asserts invariants (not byte-for-byte equality), so library upgrades that change floating point noise do not fail it.
"""
import json
import subprocess
import sys
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parents[2] / "syntheticData" / "qtc"
D = ROOT / "data"
failures = []


def check(name, ok, detail=""):
    print(("PASS  " if ok else "FAIL  ") + name + (f"  [{detail}]" if detail else ""))
    if not ok:
        failures.append(name)


# 1. Exercise 2 validation checks pass
r = subprocess.run([sys.executable, str(ROOT / "tutorial/solutions/ex2_waveform_etl.py"), str(D)], capture_output=True, text=True)
check("Exercise 2 validation checks", r.returncode == 0, r.stdout.strip().splitlines()[-1] if r.stdout else r.stderr[-200:])

# 2. Counts documented on the website
occ = pd.read_csv(D / "waveform_extension/waveform_occurrence.csv")
reg = pd.read_csv(D / "waveform_extension/waveform_registry.csv")
chan = pd.read_csv(D / "waveform_extension/waveform_channel_metadata.csv")
check("table row counts match the documentation", (len(occ), len(reg), len(chan)) == (542, 1084, 3252), f"{len(occ)}/{len(reg)}/{len(chan)}")
check("one .hea and one .dat per record", len(list((D / "wfdb").glob("*.hea"))) == 542 and len(list((D / "wfdb").glob("*.dat"))) == 542)

# 3. Detector against the answer key (Exercise 3)
truth = pd.read_csv(D / "answer_key/records_truth.csv")
wf = pd.read_csv(D / "waveform_extension/waveform_feature.csv")
meas = pd.read_csv(D / "omop/measurement.csv")
q = wf.merge(meas[["measurement_id", "measurement_concept_id"]], on="measurement_id")
q = q[q.measurement_concept_id == 2082599101].merge(occ[["waveform_occurrence_id", "waveform_occurrence_source_value"]], on="waveform_occurrence_id")
q = q.merge(truth, left_on="waveform_occurrence_source_value", right_on="accession")
q["flag"] = q.value_as_concept_id.notna().astype(int)
check("quality flag equals simulated noise", (q.flag == q.noisy).all())
err = (q.value_as_number - q.true_qtcf_ms)[q.flag == 0]
check("clean-record QTcF error small", abs(err.mean()) < 6 and err.std() < 4, f"mean {err.mean():.1f}, sd {err.std():.1f}")

# 4. Effect estimation against the answer key (Exercise 4)
subprocess.run([sys.executable, str(ROOT / "tutorial/solutions/ex4_effect_estimation.py"), str(D)], check=True, capture_output=True)
est = pd.read_csv(D / "derived/effect_estimates.csv").set_index("estimate").effect_ms
ate = json.load(open(D / "answer_key/effects.json"))["true_effect_on_qtcf_ms"]["ATE"]
check("crude estimate is visibly confounded", est["Crude difference in follow-up QTcF"] - ate > 4, f"crude {est.iloc[0]}, truth {ate}")
check("adjusted estimate close to truth", abs(est["... plus baseline QTcF"] - ate) < 3)
check("IPW estimate close to truth", abs(est["IPW (ATE)"] - ate) < 4)

sys.exit(1 if failures else 0)
