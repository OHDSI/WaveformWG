# Exercise 4, R track (base R only): effect of drug A vs comparator B on QTcF.
# Needs data/derived/analytic_dataset.csv, written by solutions/ex4_effect_estimation.py (step 4.1, the SQL cohort build).
# Run:  Rscript ex4_effect_estimation.R [path/to/syntheticData/qtc/data]
args <- commandArgs(trailingOnly = TRUE)
data_dir <- if (length(args)) args[1] else "data"      # run from syntheticData/qtc, or pass the data folder
df <- read.csv(file.path(data_dir, "derived", "analytic_dataset.csv"))

# Attrition and analysis set
d <- subset(df, !is.na(base_qtcf) & !is.na(out_qtcf) & base_low_quality == 0 & out_low_quality == 0)
cat("New users:", nrow(df), " analysis set:", nrow(d), " (A:", sum(d$treated), " B:", sum(1 - d$treated), ")\n")

# Crude vs adjusted
est <- function(fit) { ci <- confint(fit)["treated", ]; c(effect = unname(coef(fit)["treated"]), low = ci[[1]], high = ci[[2]]) }
crude <- lm(out_qtcf ~ treated, d)
adj   <- lm(out_qtcf ~ treated + age + female + heart_failure + hypertension + t2dm + potassium + base_qtcf, d)

# Propensity score, IPW (ATE)
ps_fit <- glm(treated ~ age + female + heart_failure + hypertension + t2dm + potassium + base_qtcf, binomial, d)
d$ps <- fitted(ps_fit)
d$w  <- ifelse(d$treated == 1, 1 / d$ps, 1 / (1 - d$ps))
ipw  <- lm(out_qtcf ~ treated, d, weights = w)

# Effect modification by sex
sex <- lm(out_qtcf ~ treated * female + age + heart_failure + hypertension + t2dm + potassium + base_qtcf, d)

# Negative control: QRS duration (true effect 0)
nc <- lm(out_qrs ~ treated + age + female + heart_failure + hypertension + t2dm + potassium + base_qrs, d)

res <- rbind(`Crude` = est(crude), `Adjusted (+ baseline QTcF)` = est(adj), `IPW (ATE)` = est(ipw),
             `Negative control: QRS, adjusted` = est(nc))
print(round(res, 1))
cat(sprintf("Men: %.1f ms   Women: %.1f ms\n", coef(sex)["treated"], coef(sex)["treated"] + coef(sex)["treated:female"]))
