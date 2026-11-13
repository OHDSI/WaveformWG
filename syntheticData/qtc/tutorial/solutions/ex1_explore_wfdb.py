"""Exercise 1 (reference solution): open a WFDB record and read what it does - and does not - tell you."""
import sys
from pathlib import Path

import numpy as np
import pandas as pd
import wfdb

DATA = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parents[2] / "data"

# 1.1 The header
hdr = wfdb.rdheader(str(DATA / "wfdb" / "A0000001"))
print("record:", hdr.record_name, "| fs:", hdr.fs, "Hz | samples:", hdr.sig_len, "| duration:", hdr.sig_len / hdr.fs, "s")
print("leads:", hdr.sig_name, "| units:", hdr.units, "| gain (ADU/mV):", hdr.adc_gain, "| baseline:", hdr.baseline)
print("start:", hdr.base_date, hdr.base_time, "| comments:", hdr.comments)

# 1.2 Digital vs physical samples
rec = wfdb.rdrecord(str(DATA / "wfdb" / "A0000001"))                      # physical units (mV)
raw = wfdb.rdrecord(str(DATA / "wfdb" / "A0000001"), physical=False).d_signal   # the integers actually stored in the .dat file
mv = rec.p_signal
print("digital:", raw[:3, 1], "-> physical (mV):", mv[:3, 1], "  = digital / gain:", np.allclose(mv, raw / 1000))

# 1.3 Lead III should equal II - I (Einthoven), up to quantization
print("max |III - (II - I)| =", float(np.abs(mv[:, 2] - (mv[:, 1] - mv[:, 0])).max()), "mV")

# 1.4 Who is this? The header only has an accession number. The export manifest links it to a patient and encounter.
manifest = pd.read_csv(DATA / "source" / "ecg_manifest.csv")
print(manifest[manifest.accession == hdr.record_name].T)

# 1.5 Compare a clean and a noisy recording
truth = pd.read_csv(DATA / "answer_key" / "records_truth.csv")
for acc in (truth[truth.noisy == 0].accession.iloc[0], truth[truth.noisy == 1].accession.iloc[0]):
    s = wfdb.rdrecord(str(DATA / "wfdb" / acc)).p_signal[:, 1]
    hf = s - np.convolve(s, np.ones(5) / 5, mode="same")        # crude high-pass: sample minus 5-point moving average
    print(acc, "noisy" if acc in set(truth[truth.noisy == 1].accession) else "clean", "| high-frequency SD (mV):", round(float(hf.std()), 4))

# 1.6 (optional) plot
try:
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    wfdb.plot_wfdb(record=rec, title="A0000001", figsize=(10, 5))
    plt.savefig("ex1_a0000001.png", dpi=120)
except ImportError:
    pass
