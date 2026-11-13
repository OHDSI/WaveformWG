"""Exercise 3 (reference solution): extract ECG intervals, compare with the answer key, check QTc corrections."""
import sys
from pathlib import Path

import numpy as np
import pandas as pd
import wfdb

SRC = Path(__file__).resolve().parents[2] / "src"
sys.path.insert(0, str(SRC))
from qtcdetect import analyze          # noqa: E402  the detector used to build the dataset

DATA = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parents[2] / "data"
truth = pd.read_csv(DATA / "answer_key" / "records_truth.csv")

# 3.1 One record, by hand
acc = "A0000001"
rec = wfdb.rdrecord(str(DATA / "wfdb" / acc))
f = analyze(rec.p_signal[:, rec.sig_name.index("II")], rec.fs)
t = truth[truth.accession == acc].iloc[0]
print({k: round(v, 1) for k, v in f.items() if k in ("hr_bpm", "qt_ms", "qtcf_ms", "qtcb_ms", "qrs_ms")})
print({k: round(t[k], 1) for k in ("true_hr_bpm", "true_qt_ms", "true_qtcf_ms", "true_qtcb_ms", "true_qrs_ms")})

# 3.2 All records: bias and spread against the answer key, split by signal quality
rows = []
for a in truth.accession:
    r = wfdb.rdrecord(str(DATA / "wfdb" / a))
    rows.append(analyze(r.p_signal[:, 1], r.fs))
est = pd.concat([truth, pd.DataFrame(rows)], axis=1)
est["flagged"] = est.low_quality.astype(int)
est["err_qtcf"] = est.qtcf_ms - est.true_qtcf_ms
print("\nQTcF error vs truth (ms) by detector quality flag")
print(est.groupby("flagged").err_qtcf.agg(["count", "mean", "std", lambda x: x.abs().max()]).round(1).rename(columns={"<lambda_0>": "max|err|"}))
print("flag agrees with the simulated-noise truth:", bool((est.flagged == est.noisy).all()))

# 3.3 Bazett over-corrects at high heart rate; Fridericia does not (in this dataset truth is Fridericia)
ok = est[est.flagged == 0]
print("\ncorrelation of heart rate with (QTc - true QTcF):  Bazett %.2f   Fridericia %.2f" % (
    np.corrcoef(ok.hr_bpm, ok.qtcb_ms - ok.true_qtcf_ms)[0, 1], np.corrcoef(ok.hr_bpm, ok.qtcf_ms - ok.true_qtcf_ms)[0, 1]))
