-- Exercise 4: one row per person in the new-user cohort (drug A vs comparator B).
-- Runs as-is in DuckDB against the CSV files; on PostgreSQL replace read_csv_auto(...) with the table names.
-- Parameter: set :data to the dataset folder (the Python solution does this).

CREATE OR REPLACE VIEW person AS SELECT * FROM read_csv_auto('{data}/omop/person.csv');
CREATE OR REPLACE VIEW drug_exposure AS SELECT * FROM read_csv_auto('{data}/omop/drug_exposure.csv');
CREATE OR REPLACE VIEW condition_occurrence AS SELECT * FROM read_csv_auto('{data}/omop/condition_occurrence.csv');
CREATE OR REPLACE VIEW measurement AS SELECT * FROM read_csv_auto('{data}/omop/measurement.csv');
CREATE OR REPLACE VIEW visit_occurrence AS SELECT * FROM read_csv_auto('{data}/omop/visit_occurrence.csv');
CREATE OR REPLACE VIEW waveform_occurrence AS SELECT * FROM read_csv_auto('{data}/waveform_extension/waveform_occurrence.csv');
CREATE OR REPLACE VIEW waveform_feature AS SELECT * FROM read_csv_auto('{data}/waveform_extension/waveform_feature.csv');

-- 1. Target and comparator: first exposure to drug A (2082599401) or B (2082599402) = index date
CREATE OR REPLACE TABLE cohort_index AS
SELECT person_id,
       MIN(drug_exposure_start_datetime) AS index_datetime,
       MAX(CASE WHEN drug_concept_id = 2082599401 THEN 1 ELSE 0 END) AS treated
FROM drug_exposure
WHERE drug_concept_id IN (2082599401, 2082599402)
GROUP BY person_id;

-- 2. ECG features with their waveform provenance. One row per ECG, one column per feature.
CREATE OR REPLACE TABLE ecg_feature AS
SELECT wo.person_id,
       wo.waveform_occurrence_id,
       wo.waveform_occurrence_start_datetime AS ecg_datetime,
       MAX(CASE WHEN m.measurement_concept_id = 2082599101 THEN wf.value_as_number END) AS qtcf,
       MAX(CASE WHEN m.measurement_concept_id = 2082599102 THEN wf.value_as_number END) AS qtcb,
       MAX(CASE WHEN m.measurement_concept_id = 2082599104 THEN wf.value_as_number END) AS hr,
       MAX(CASE WHEN m.measurement_concept_id = 2082599105 THEN wf.value_as_number END) AS qrs,
       MAX(CASE WHEN wf.value_as_concept_id = 2082499971 THEN 1 ELSE 0 END) AS low_quality
FROM waveform_occurrence wo
JOIN waveform_feature wf ON wf.waveform_occurrence_id = wo.waveform_occurrence_id
JOIN measurement m ON m.measurement_id = wf.measurement_id
GROUP BY wo.person_id, wo.waveform_occurrence_id, wo.waveform_occurrence_start_datetime;

-- 3. Baseline ECG = latest ECG before index; outcome ECG = first ECG 12-72 h after index
CREATE OR REPLACE TABLE analytic AS
WITH base AS (
  SELECT c.person_id, e.qtcf AS base_qtcf, e.qtcb AS base_qtcb, e.hr AS base_hr, e.qrs AS base_qrs,
         e.low_quality AS base_low_quality,
         ROW_NUMBER() OVER (PARTITION BY c.person_id ORDER BY e.ecg_datetime DESC) AS rn
  FROM cohort_index c JOIN ecg_feature e ON e.person_id = c.person_id AND e.ecg_datetime < c.index_datetime
), outc AS (
  SELECT c.person_id, e.qtcf AS out_qtcf, e.qtcb AS out_qtcb, e.hr AS out_hr, e.qrs AS out_qrs,
         e.low_quality AS out_low_quality, e.waveform_occurrence_id AS out_occurrence_id,
         ROW_NUMBER() OVER (PARTITION BY c.person_id ORDER BY e.ecg_datetime) AS rn
  FROM cohort_index c JOIN ecg_feature e
    ON e.person_id = c.person_id
   AND e.ecg_datetime >= c.index_datetime + INTERVAL 12 HOUR
   AND e.ecg_datetime <= c.index_datetime + INTERVAL 72 HOUR
), k AS (
  SELECT c.person_id, m.value_as_number AS potassium,
         ROW_NUMBER() OVER (PARTITION BY c.person_id ORDER BY m.measurement_datetime DESC) AS rn
  FROM cohort_index c JOIN measurement m
    ON m.person_id = c.person_id AND m.measurement_concept_id = 3023103 AND m.measurement_datetime < c.index_datetime
), cond AS (
  SELECT c.person_id,
         MAX(CASE WHEN co.condition_concept_id = 316139 THEN 1 ELSE 0 END) AS heart_failure,
         MAX(CASE WHEN co.condition_concept_id = 320128 THEN 1 ELSE 0 END) AS hypertension,
         MAX(CASE WHEN co.condition_concept_id = 201826 THEN 1 ELSE 0 END) AS t2dm
  FROM cohort_index c LEFT JOIN condition_occurrence co
    ON co.person_id = c.person_id AND co.condition_start_date < CAST(c.index_datetime AS DATE)
  GROUP BY c.person_id
)
SELECT c.person_id, c.treated,
       CASE WHEN p.gender_concept_id = 8532 THEN 1 ELSE 0 END AS female,
       EXTRACT(YEAR FROM c.index_datetime) - p.year_of_birth AS age,
       k.potassium, cond.heart_failure, cond.hypertension, cond.t2dm,
       b.base_qtcf, b.base_qtcb, b.base_hr, b.base_qrs, b.base_low_quality,
       o.out_qtcf, o.out_qtcb, o.out_hr, o.out_qrs, o.out_low_quality, o.out_occurrence_id
FROM cohort_index c
JOIN person p USING (person_id)
LEFT JOIN base b ON b.person_id = c.person_id AND b.rn = 1
LEFT JOIN outc o ON o.person_id = c.person_id AND o.rn = 1
LEFT JOIN k ON k.person_id = c.person_id AND k.rn = 1
LEFT JOIN cond ON cond.person_id = c.person_id
ORDER BY c.person_id;
