"""A deliberately simple, readable ECG interval detector (lead II) used by the tutorial.

Not a validated clinical algorithm. Per beat: R peak -> QRS onset/offset from the
slope -> T end where the smoothed signal returns to within 5% of the T amplitude.
"""
import numpy as np
from scipy.signal import butter, sosfiltfilt, find_peaks

NOISE_LIMIT_MV = 0.05          # high-frequency noise above this => "low signal quality"


def _bp(x, fs, lo, hi):
    return sosfiltfilt(butter(3, [lo, hi], btype="band", fs=fs, output="sos"), x)


def analyze(mv, fs):
    """mv: lead II in mV. Returns a dict of features (NaN where not computable)."""
    x = _bp(mv, fs, 0.5, 40)
    # noise level: SD of the 60-100 Hz band, away from the 50 Hz powerline line
    noise = float(np.std(_bp(mv, fs, 60, 100)))
    d = np.gradient(_bp(mv, fs, 0.5, 40))
    qrs = _bp(mv, fs, 5, 25)
    pk, _ = find_peaks(np.abs(qrs), height=0.5 * np.max(np.abs(qrs)), distance=int(0.3 * fs))
    # choose R as the local max of x near each detected QRS energy peak
    rs = []
    for p in pk:
        lo, hi = max(0, p - int(0.05 * fs)), min(len(x), p + int(0.05 * fs))
        rs.append(lo + int(np.argmax(x[lo:hi])))
    rs = np.array(sorted(set(rs)))
    out = dict(n_beats=len(rs), noise_mv=noise, low_quality=noise > NOISE_LIMIT_MV)
    if len(rs) < 4:
        return {**out, **{k: np.nan for k in ("hr_bpm", "rr_ms", "qt_ms", "qtcb_ms", "qtcf_ms", "qrs_ms")}}
    rr = np.diff(rs) / fs
    xs = _bp(mv, fs, 0.5, 20)
    qts, qtcb, qtcf, qrsd = [], [], [], []
    for b in range(1, len(rs) - 1):
        r = rs[b]
        # QRS onset / offset: start at the steepest up-/down-slope around R, walk outward until the slope is small
        win = d[r - int(0.08 * fs): r + int(0.08 * fs)]
        thr = 0.15 * np.max(np.abs(win))
        on = r - int(0.08 * fs) + int(np.argmax(win[: int(0.08 * fs)]))
        while on > r - int(0.14 * fs) and np.abs(d[on]) > thr:
            on -= 1
        off = r + int(np.argmin(d[r: r + int(0.08 * fs)]))
        while off < r + int(0.16 * fs) and np.abs(d[off]) > thr:
            off += 1
        # T wave: peak in window after the QRS, then first return to 5% of its height
        w0 = off + int(0.05 * fs)
        w1 = min(r + int(0.7 * rr[b]*fs), len(xs) - 1)
        if w1 - w0 < int(0.1 * fs):
            continue
        base = np.median(xs[max(0, on - int(0.04 * fs)): on])
        seg = xs[w0:w1] - base
        tp = w0 + int(np.argmax(seg))
        amp = xs[tp] - base
        if amp < 0.03:
            continue
        te = tp
        while te < w1 and xs[te] - base > 0.05 * amp:
            te += 1
        qt = (te - on) / fs
        qts.append(qt * 1000)
        qtcb.append(qt / np.sqrt(rr[b - 1]) * 1000)           # preceding RR
        qtcf.append(qt / rr[b - 1] ** (1 / 3) * 1000)
        qrsd.append((off - on) / fs * 1000)
    if len(qts) < 3:
        return {**out, **{k: np.nan for k in ("hr_bpm", "rr_ms", "qt_ms", "qtcb_ms", "qtcf_ms", "qrs_ms")}}
    out.update(hr_bpm=60 / float(np.mean(rr)), rr_ms=1000 * float(np.mean(rr)), qt_ms=float(np.median(qts)),
               qtcb_ms=float(np.median(qtcb)), qtcf_ms=float(np.median(qtcf)), qrs_ms=float(np.median(qrsd)))
    return out
