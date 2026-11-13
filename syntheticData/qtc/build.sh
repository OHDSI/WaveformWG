#!/usr/bin/env bash
# Rebuild the whole synthetic QTc dataset (deterministic: fixed seed).
# Requires python3 with the packages in requirements.txt (pip install -r requirements.txt).
set -euo pipefail
export MPLBACKEND=Agg
cd "$(dirname "$0")/src"
python3 simulate.py                                       # source data: cohort, EHR facts, WFDB recordings, answer key
python3 etl_waveform.py                                   # WFDB + manifest -> waveform_occurrence / registry / channel_metadata
python3 extract_features.py                               # lead II intervals -> MEASUREMENT + waveform_feature
python3 ../tutorial/solutions/ex4_effect_estimation.py > /dev/null   # writes data/derived/*
python3 summarize.py                                      # figures and summary tables for the website
