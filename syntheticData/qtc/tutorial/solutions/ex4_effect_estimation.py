"""Exercise 4 (reference solution): effect of drug A vs comparator B on QTc, from waveform features.

Run from anywhere:  python ex4_effect_estimation.py [path/to/syntheticData/qtc/data]
"""
import json
import sys
from pathlib import Path

import duckdb
import numpy as np
import pandas as pd
import statsmodels.api as sm
import statsmodels.formula.api as smf

HERE = Path(__file__).resolve().parent
DATA = Path(sys.argv[1]) if len(sys.argv) > 1 else HERE.parents[1] / "data"
rng = np.random.default_rng(1)

# ---- 4.1 Build the analytic table in SQL ---------------------------------------------
con = duckdb.connect()
con.execute((HERE.parent / "sql" / "ex4_analytic_dataset.sql").read_text().replace("{data}", str(DATA)))
df = con.execute("SELECT * FROM analytic").df()
(DATA / "derived").mkdir(exist_ok=True)
df.to_csv(DATA / "derived" / "analytic_dataset.csv", index=False)      # also used by the R track

steps = [("New users of A or B", len(df))]
d = df[df.base_qtcf.notna()];                         steps.append(("... with a baseline ECG", len(d)))
d = d[d.out_qtcf.notna()];                            steps.append(("... and an outcome ECG 12-72 h after index", len(d)))
d = d[(d.base_low_quality == 0) & (d.out_low_quality == 0)]; steps.append(("... both ECGs of acceptable signal quality", len(d)))
print("\n== 4.1 Attrition"); print(pd.DataFrame(steps, columns=["step", "persons"]).to_string(index=False))
print(d.groupby("treated").size().rename("n").to_string())

# ---- 4.2 Table 1 with standardized mean differences -----------------------------------
covs = ["age", "female", "heart_failure", "hypertension", "t2dm", "potassium", "base_qtcf", "base_hr"]


def smd(x, t, w=None):
    w = np.ones(len(x)) if w is None else np.asarray(w)
    x, t = np.asarray(x, float), np.asarray(t)
    m1, m0 = np.average(x[t == 1], weights=w[t == 1]), np.average(x[t == 0], weights=w[t == 0])
    v1 = np.average((x[t == 1] - m1) ** 2, weights=w[t == 1]); v0 = np.average((x[t == 0] - m0) ** 2, weights=w[t == 0])
    return (m1 - m0) / np.sqrt((v1 + v0) / 2)


print("\n== 4.2 Balance before adjustment (SMD)")
print(pd.Series({c: round(smd(d[c], d.treated), 2) for c in covs}).to_string())

# ---- 4.3 Crude vs adjusted ------------------------------------------------------------
crude = smf.ols("out_qtcf ~ treated", d).fit(cov_type="HC3")
adj = smf.ols("out_qtcf ~ treated + age + female + heart_failure + hypertension + t2dm + potassium", d).fit(cov_type="HC3")
adj_base = smf.ols("out_qtcf ~ treated + age + female + heart_failure + hypertension + t2dm + potassium + base_qtcf", d).fit(cov_type="HC3")
d = d.assign(change=d.out_qtcf - d.base_qtcf)
chg = smf.ols("change ~ treated", d).fit(cov_type="HC3")


def row(name, fit):
    ci = fit.conf_int().loc["treated"]
    return dict(estimate=name, effect_ms=round(fit.params["treated"], 1), ci_low=round(ci[0], 1), ci_high=round(ci[1], 1))


# ---- 4.4 Propensity score: IPW (ATE) and 1:1 matching (ATT) ---------------------------
ps_model = smf.logit("treated ~ age + female + heart_failure + hypertension + t2dm + potassium + base_qtcf", d).fit(disp=0)
d["ps"] = ps_model.predict(d)
d["w_ate"] = np.where(d.treated == 1, 1 / d.ps, 1 / (1 - d.ps))
ipw = smf.wls("out_qtcf ~ treated", d, weights=d.w_ate).fit(cov_type="HC3")
print("\n== 4.4 Propensity score overlap:", d.groupby("treated").ps.describe()[["min", "50%", "max"]].round(2).to_dict("index"))
print("Balance after IPW (SMD):", {c: round(smd(d[c], d.treated, d.w_ate), 2) for c in covs})

lp = np.log(d.ps / (1 - d.ps)); cal = 0.2 * lp.std()
trt, ctl = d[d.treated == 1], d[d.treated == 0]
pairs, used = [], set()
for i, r in trt.sample(frac=1, random_state=1).iterrows():
    dist = (np.log(ctl.ps / (1 - ctl.ps)) - np.log(r.ps / (1 - r.ps))).abs()
    dist = dist[~dist.index.isin(used)]
    if len(dist) and dist.min() <= cal:
        j = dist.idxmin(); used.add(j); pairs.append((i, j))
att_diff = np.array([d.loc[i, "out_qtcf"] - d.loc[j, "out_qtcf"] for i, j in pairs])
match = dict(estimate="PS matching, 1:1 caliper (ATT)", effect_ms=round(att_diff.mean(), 1),
             ci_low=round(att_diff.mean() - 1.96 * att_diff.std(ddof=1) / np.sqrt(len(att_diff)), 1),
             ci_high=round(att_diff.mean() + 1.96 * att_diff.std(ddof=1) / np.sqrt(len(att_diff)), 1))
print(f"Matched pairs: {len(pairs)} of {len(trt)} treated")

# ---- 4.5 Effect modification by sex ---------------------------------------------------
sex = smf.ols("out_qtcf ~ treated*female + age + heart_failure + hypertension + t2dm + potassium + base_qtcf", d).fit(cov_type="HC3")
eff_m = sex.params["treated"]; eff_f = eff_m + sex.params["treated:female"]

# ---- 4.6 Negative control outcomes (true effect = 0) ------------------------------------
nc = {}
for out in ("out_qrs", "out_hr"):
    c_ = smf.ols(f"{out} ~ treated", d).fit(cov_type="HC3")
    a_ = smf.ols(f"{out} ~ treated + age + female + heart_failure + hypertension + t2dm + potassium + base_{out[4:]}", d).fit(cov_type="HC3")
    nc[out] = (row("crude", c_), row("adjusted", a_))

# ---- 4.7 Measurement choices ------------------------------------------------------------
truth = pd.read_csv(DATA / "answer_key" / "records_truth.csv")
occ = pd.read_csv(DATA / "waveform_extension" / "waveform_occurrence.csv", usecols=["waveform_occurrence_id", "waveform_occurrence_source_value"])
d = d.merge(occ, left_on="out_occurrence_id", right_on="waveform_occurrence_id").merge(
    truth[["accession", "true_qtcf_ms"]], left_on="waveform_occurrence_source_value", right_on="accession")
rhs = "treated + age + female + heart_failure + hypertension + t2dm + potassium + base_qtcf"
by_truth = smf.ols(f"true_qtcf_ms ~ {rhs}", d).fit(cov_type="HC3")
by_bazett = smf.ols(f"out_qtcb ~ treated + age + female + heart_failure + hypertension + t2dm + potassium + base_qtcb", d).fit(cov_type="HC3")
allq = df[df.base_qtcf.notna() & df.out_qtcf.notna()]
no_qc = smf.ols(f"out_qtcf ~ {rhs}", allq).fit(cov_type="HC3")

key = json.load(open(DATA / "answer_key" / "effects.json"))["true_effect_on_qtcf_ms"]
rows = [row("Crude difference in follow-up QTcF", crude), row("Adjusted for baseline covariates", adj),
        row("... plus baseline QTcF", adj_base), row("Change from baseline, crude", chg),
        row("IPW (ATE)", ipw), match, row("Adjusted, no signal-quality exclusion", no_qc),
        row("Adjusted, outcome = Bazett QTcB", by_bazett),
        row("Adjusted, outcome = TRUE QTcF (answer key)", by_truth)]
est = pd.DataFrame(rows)
est.to_csv(DATA / "derived" / "effect_estimates.csv", index=False)
print("\n== Effect of drug A vs B on QTcF (ms)")
print(est.to_string(index=False))
print(f"\nAnswer key: ATE = {key['ATE']} ms, ATT = {key['ATT']} ms (female {key['by_sex']['female']}, male {key['by_sex']['male']})")
print(f"Effect modification: men {eff_m:.1f} ms, women {eff_f:.1f} ms")
print("\n== Negative control outcomes (truth = 0)")
for k, v in nc.items():
    print(k, {r['estimate']: (float(r['effect_ms']), float(r['ci_low']), float(r['ci_high'])) for r in v})
