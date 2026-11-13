"""Beat-by-beat synthetic ECG with known interval truth.

Every beat is built from explicit parts so the true QRS onset, QRS offset and
T-wave end are known: the T wave is two half-cosines that reach exactly zero at
the T end, and QT = (T end - QRS onset). QT follows the Fridericia relation to
the *preceding* RR interval, so QTcF is a person-level truth.
"""
import numpy as np

from common import FS, DURATION_S, GAIN


def _gauss(t, mu, sigma, amp):
    return amp * np.exp(-0.5 * ((t - mu) / sigma) ** 2)


def _beat(t, qrs_ms, qt_ms, rr_s, amp):
    """One beat on time axis t (seconds relative to the R peak). Lead II shape."""
    qrsd = qrs_ms / 1000.0
    onset, j = -0.4 * qrsd, 0.6 * qrsd
    tend = onset + qt_ms / 1000.0
    s = qrsd / 5.0
    y = (_gauss(t, -0.22 * qrsd - 0.0, s * 0.8, -0.10 * amp["r"])            # Q
         + _gauss(t, 0.0, s * 0.9, 1.00 * amp["r"])                         # R
         + _gauss(t, 0.28 * qrsd, s * 0.8, -0.22 * amp["r"]))               # S
    # P wave
    y += _gauss(t, onset - 0.11 - 0.05 * min(rr_s, 1.0), 0.022, 0.12 * amp["p"])
    # T wave: asymmetric raised cosine, exactly zero outside [t0, tend]
    t0 = j + 0.07
    w = tend - t0
    rise = 0.6 * w
    up = (t >= t0) & (t < t0 + rise)
    dn = (t >= t0 + rise) & (t <= tend)
    tw = np.zeros_like(t)
    tw[up] = 0.5 * (1 - np.cos(np.pi * (t[up] - t0) / rise))
    tw[dn] = 0.5 * (1 + np.cos(np.pi * (t[dn] - (t0 + rise)) / (w - rise)))
    return y + 0.30 * amp["t"] * tw


def simulate_lead_pair(rng, hr_bpm, qtcf_ms, qrs_ms, noisy):
    """Return (lead_I_mV, lead_II_mV, truth dict). Lead III = II - I is derived by the caller."""
    n = FS * DURATION_S
    t = np.arange(n) / FS
    rr_mean = 60.0 / hr_bpm
    # beat times with respiratory sinus arrhythmia + random HRV
    rs, r = [], 0.55 + rng.uniform(0, 0.2)
    k = 0
    while r < DURATION_S - 0.7:
        rs.append(r)
        k += 1
        r += rr_mean * (1 + 0.035 * np.sin(2 * np.pi * 0.25 * r + 1.0) + 0.02 * rng.standard_normal())
    rs = np.array(rs)
    rr_prev = np.diff(rs, prepend=rs[0] - rr_mean)
    qt_beat = qtcf_ms * rr_prev ** (1 / 3)               # Fridericia, ms
    a2 = dict(r=rng.uniform(0.9, 1.3), p=rng.uniform(0.8, 1.2), t=rng.uniform(0.8, 1.2))
    sig2, sig1 = np.zeros(n), np.zeros(n)
    for r, qt, rrp in zip(rs, qt_beat, rr_prev):
        lo, hi = max(0, int((r - 0.35) * FS)), min(n, int((r + 1.0) * FS))
        tt = t[lo:hi] - r
        sig2[lo:hi] += _beat(tt, qrs_ms, qt, rrp, a2)
        a1 = dict(r=a2["r"] * 0.62, p=a2["p"] * 0.7, t=a2["t"] * 0.55)
        sig1[lo:hi] += _beat(tt, qrs_ms, qt, rrp, a1)
    # noise
    if noisy:
        hf, wander, emg = 0.12, 0.35, 0.25
    else:
        hf, wander, emg = 0.008, 0.06, 0.0
    ph = rng.uniform(0, 2 * np.pi, 4)
    for sig in (sig1, sig2):
        sig += wander * 0.5 * np.sin(2 * np.pi * 0.28 * t + ph[0]) + wander * 0.25 * np.sin(2 * np.pi * 0.11 * t + ph[1])
        sig += 0.006 * np.sin(2 * np.pi * 50 * t + ph[2])
        sig += hf * rng.standard_normal(n)
        if emg:
            bursts = (np.sin(2 * np.pi * 0.7 * t + ph[3]) > 0.4).astype(float)
            sig += emg * bursts * rng.standard_normal(n)
    truth = dict(
        n_beats=int(len(rs)), true_hr_bpm=float(60.0 / np.mean(np.diff(rs))),
        true_rr_ms=float(1000 * np.mean(rr_prev[1:])),
        true_qt_ms=float(np.mean(qt_beat[1:-1])),
        true_qtcf_ms=float(qtcf_ms),
        true_qtcb_ms=float(np.mean(qt_beat[1:-1] / np.sqrt(rr_prev[1:-1]))),
        true_qrs_ms=float(qrs_ms),
    )
    return sig1, sig2, truth


def to_digital(*sigs):
    out = np.stack([np.clip(np.round(s * GAIN), -32768, 32767) for s in sigs], axis=1)
    return out.astype(np.int16)
