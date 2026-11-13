"""Step 4 - figures and small summary tables used by the website (rmd/images, rmd/data)."""
import json

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import wfdb

from common import *

IMG = ROOT.parents[1] / "rmd" / "images"
OUT = ROOT.parents[1] / "rmd" / "data" / "qtc-dataset"
IMG.mkdir(parents=True, exist_ok=True)
OUT.mkdir(parents=True, exist_ok=True)
INK, MUTED, A_COL, B_COL = "#222222", "#888888", "#c0392b", "#2c6fbb"
plt.rcParams.update({"font.size": 10, "axes.spines.top": False, "axes.spines.right": False, "axes.edgecolor": MUTED,
                     "axes.labelcolor": INK, "xtick.color": INK, "ytick.color": INK})


def example_ecg():
    truth = pd.read_csv(KEY / "records_truth.csv")
    pers = pd.read_csv(KEY / "persons_truth.csv")
    pid = int(pers[(pers.treated_A == 1) & (pers.has_followup == 1) & (pers.female == 1)].person_id.iloc[0])
    b = truth[(truth.person_id == pid) & (truth.period == "baseline")].iloc[0]
    f = truth[(truth.person_id == pid) & (truth.period == "followup")].iloc[0]
    fig, axes = plt.subplots(2, 1, figsize=(9, 4.4), sharex=True, sharey=True)
    for ax, rowt, ttl in ((axes[0], b, "Baseline, before antiemetic A"), (axes[1], f, "Follow-up, about a day after")):
        rec = wfdb.rdrecord(str(WFDB / rowt.accession))
        t = np.arange(rec.sig_len) / rec.fs
        ax.plot(t, rec.p_signal[:, 1], color=INK, lw=0.9)
        ax.set_title(f"{ttl}  ({rowt.accession}, lead II)   true QTcF {rowt.true_qtcf_ms:.0f} ms", loc="left", fontsize=10)
        ax.set_ylabel("mV")
    axes[1].set_xlabel("seconds")
    fig.tight_layout()
    fig.savefig(IMG / "qtc-example-ecg.png", dpi=130)
    plt.close(fig)


def detector_vs_truth():
    truth = pd.read_csv(KEY / "records_truth.csv")
    meas = pd.read_csv(OMOP / "measurement.csv")
    wf = pd.read_csv(WFE / "waveform_feature.csv")
    occ = pd.read_csv(WFE / "waveform_occurrence.csv")
    q = wf.merge(meas[["measurement_id", "measurement_concept_id"]], on="measurement_id")
    q = q[q.measurement_concept_id == C_QTCF].merge(occ[["waveform_occurrence_id", "waveform_occurrence_source_value"]], on="waveform_occurrence_id")
    q = q.merge(truth, left_on="waveform_occurrence_source_value", right_on="accession")
    q["flagged"] = q.value_as_concept_id.notna()
    fig, ax = plt.subplots(figsize=(4.6, 4.4))
    lim = [330, 500]
    ax.plot(lim, lim, color=MUTED, lw=1, ls="--")
    ax.scatter(q[~q.flagged].true_qtcf_ms, q[~q.flagged].value_as_number, s=9, color=B_COL, alpha=.6, label="acceptable signal")
    ax.scatter(q[q.flagged].true_qtcf_ms, q[q.flagged].value_as_number, s=14, color=A_COL, alpha=.8, label="flagged low quality")
    ax.set_xlim(lim); ax.set_ylim(lim)
    ax.set_xlabel("true QTcF in the answer key (ms)"); ax.set_ylabel("QTcF from waveform_feature (ms)")
    ax.legend(frameon=False, loc="upper left")
    fig.tight_layout(); fig.savefig(IMG / "qtc-detector-vs-truth.png", dpi=130); plt.close(fig)


def forest():
    est = pd.read_csv(DATA / "derived" / "effect_estimates.csv")
    key = json.load(open(KEY / "effects.json"))["true_effect_on_qtcf_ms"]["ATE"]
    est = est.iloc[::-1].reset_index(drop=True)
    fig, ax = plt.subplots(figsize=(8, 4))
    ax.axvline(key, color=A_COL, lw=1.2, ls="--")
    ax.text(key + .2, len(est) - .35, f"true ATE {key} ms", color=A_COL, fontsize=9, va="bottom")
    ax.errorbar(est.effect_ms, range(len(est)), xerr=[est.effect_ms - est.ci_low, est.ci_high - est.effect_ms],
                fmt="o", color=B_COL, ecolor=B_COL, capsize=2, ms=5)
    ax.set_yticks(range(len(est))); ax.set_yticklabels(est.estimate)
    ax.set_xlabel("estimated effect of drug A vs B on QTcF (ms, 95% CI)")
    fig.tight_layout(); fig.savefig(IMG / "qtc-effect-estimates.png", dpi=130); plt.close(fig)


def tables():
    pers = pd.read_csv(KEY / "persons_truth.csv")
    t = pers[pers.exposed == 1].groupby("treated_A")[["age", "female", "heart_failure", "potassium", "baseline_qtcf_true"]].mean().round(2)
    t.to_csv(OUT / "cohort_characteristics_by_arm.csv")
    pd.read_csv(OMOP / "concept.csv").to_csv(OUT / "concept.csv", index=False)


if __name__ == "__main__":
    example_ecg(); detector_vs_truth(); tables()
    if (DATA / "derived" / "effect_estimates.csv").exists():
        forest()
    print("figures written to", IMG)
