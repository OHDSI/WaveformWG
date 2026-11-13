# Synthetic QTc study: WFDB files to an effect estimate

A small, fully synthetic dataset with **real WFDB files**, the OMOP tables they link to, the OMOP CDM Waveform Extension tables built from them, and an **answer key**. It supports the [tutorial](https://ohdsi.github.io/WaveformWG/tutorial.html).

**The question:** among hospitalized adults who start one of two antiemetics, does drug A (a QT-prolonging drug) lengthen the QTc interval compared with drug B (a comparator)? The QTc is not in the EHR; it is measured from the ECG waveform.

All data are synthetic. The drugs are generic placeholders. The simulated effects are exaggerated: **do not quote them.**

## Quick start

```sh
cd syntheticData/qtc
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python3 tutorial/solutions/ex2_waveform_etl.py        # validates the shipped Waveform Extension tables
python3 tutorial/solutions/ex4_effect_estimation.py   # cohort in SQL (DuckDB), crude vs adjusted estimates
```

The dataset is already built and committed under `data/`. `./build.sh` rebuilds it (deterministic, about a minute).

## What is here

| Path | Content |
|---|---|
| `data/wfdb/` | 542 WFDB records (`A0000001.hea` / `.dat`): 10 s, 250 Hz, leads I, II, III, 1000 ADU/mV, acquisition time in the header |
| `data/source/ecg_manifest.csv` | what an ECG export system knows: accession, MRN, encounter id, acquisition time, export path |
| `data/omop/` | `person`, `observation_period`, `visit_occurrence`, `condition_occurrence`, `drug_exposure`, `measurement` (labs and ECG-derived values), `concept` |
| `data/waveform_extension/` | `waveform_occurrence`, `waveform_registry`, `waveform_channel_metadata`, `waveform_feature` |
| `data/derived/` | analytic dataset and effect estimates written by Exercise 4 |
| `data/answer_key/` | the truth: per-record intervals, per-person potential outcomes, true effects (`effects.json`) |
| `src/` | generator and reference transformation (see below) |
| `tutorial/` | SQL and reference solutions for Exercises 1-4 (Python; Exercise 4 also in base R) |

## The pipeline

| Step | Script | Reads | Writes |
|---|---|---|---|
| 1. Simulate the source | `src/simulate.py` | | cohort, EHR facts, WFDB files, manifest, answer key |
| 2. ETL to the extension | `src/etl_waveform.py` | WFDB headers, manifest, `PERSON`, `VISIT_OCCURRENCE` | occurrence, registry, channel metadata, `concept.csv` |
| 3. Derive features | `src/extract_features.py` | WFDB signals | `waveform_feature` and matching `MEASUREMENT` rows |
| 4. Estimate and plot | `tutorial/solutions/ex4_effect_estimation.py`, `src/summarize.py` | the tables | `data/derived/`, figures for the website |

`src/ecgsim.py` builds each beat from known parts (the QRS onset and T-wave end are exact, QT follows the preceding RR by Fridericia's relation); `src/qtcdetect.py` is a deliberately simple interval detector (not a validated clinical algorithm).

## Concepts

`2082499xxx` ids are the existing WAVEFORM vocabulary delta (`../vocab_temp/concept_delta.csv`). `2082599xxx` ids are **tutorial placeholders** for what the vocabulary does not define yet (derived ECG measurements, algorithms, a few units, the two drugs); they are listed in `data/omop/concept.csv`.

## Data-generating process (summary)

- 300 inpatients; 262 start A or B; 242 have both a baseline and a follow-up ECG.
- Baseline QTcF = 400 + 8 (female) + 0.5 per year above 60 + 10 (heart failure) + 3 (type 2 diabetes) - 14 per mmol/L potassium above 4 + person effect (SD 12).
- The chance of receiving A rises with age, female sex and low potassium and falls with heart failure: confounded by design.
- True effect of A on QTcF: +14 ms (women), +6 ms (men). Heart rate and QRS duration are unaffected (negative controls).
- About 7% of recordings are heavy-noise; about 8% of users have no follow-up ECG.

All parameters are in `src/simulate.py`. Seed: `20261113`.

## Checks

`python3 ../../.github/benchmark/check_qtc.py` asserts the documented row counts, that the detector's quality flag matches the simulated noise, that the clean-record error is small, and that the crude, adjusted and IPW estimates behave as the tutorial says. CI runs it (`.github/workflows/synthetic-data.yml`).
