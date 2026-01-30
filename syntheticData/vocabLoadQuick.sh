#!/bin/bash

psql postgresql://localhost:5432 -U postgres -c "TRUNCATE TABLE omopwave.concept_wave;" 2>/dev/null || true
psql postgresql://localhost:5432 -U postgres -c "\COPY omopwave.concept_wave FROM './vocab_temp/concept_delta.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '\"', ESCAPE '\"')" 2>/dev/null || true

psql postgresql://localhost:5432 -U postgres -c "TRUNCATE TABLE omopwave.vocabulary_wave;" 2>/dev/null || true
psql postgresql://localhost:5432 -U postgres -c "\COPY omopwave.vocabulary_wave FROM './vocab_temp/vocabulary_delta.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '\"', ESCAPE '\"')" 2>/dev/null || true

psql postgresql://localhost:5432 -U postgres -c "TRUNCATE TABLE omopwave.domain_wave;" 2>/dev/null || true
psql postgresql://localhost:5432 -U postgres -c "\COPY omopwave.domain_wave FROM './vocab_temp/domain_delta.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '\"', ESCAPE '\"')" 2>/dev/null || true

psql postgresql://localhost:5432 -U postgres -c "TRUNCATE TABLE omopwave.concept_class_wave;" 2>/dev/null || true
psql postgresql://localhost:5432 -U postgres -c "\COPY omopwave.concept_class_wave FROM './vocab_temp/concept_class_delta.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '\"', ESCAPE '\"')" 2>/dev/null || true

psql postgresql://localhost:5432 -U postgres -c "TRUNCATE TABLE omopwave.concept_relationship_wave;" 2>/dev/null || true
psql postgresql://localhost:5432 -U postgres -c "\COPY omopwave.concept_relationship_wave FROM './vocab_temp/concept_relationship_delta.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '\"', ESCAPE '\"')" 2>/dev/null || true

psql postgresql://localhost:5432 -U postgres -c "TRUNCATE TABLE omopwave.relationship_wave;" 2>/dev/null || true
psql postgresql://localhost:5432 -U postgres -c "\COPY omopwave.relationship_wave FROM './vocab_temp/relationship_delta.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '\"', ESCAPE '\"')" 2>/dev/null || true

psql postgresql://localhost:5432 -U postgres -c "TRUNCATE TABLE omopwave.concept_synonym_wave;" 2>/dev/null || true
psql postgresql://localhost:5432 -U postgres -c "\COPY omopwave.concept_synonym_wave FROM './vocab_temp/concept_synonym_delta.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '\"', ESCAPE '\"')" 2>/dev/null || true

psql postgresql://localhost:5432 -U postgres -c "TRUNCATE TABLE omopwave.concept_ancestor_wave;" 2>/dev/null || true
psql postgresql://localhost:5432 -U postgres -c "\COPY omopwave.concept_ancestor_wave FROM './vocab_temp/concept_ancestor_delta.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '\"', ESCAPE '\"')" 2>/dev/null || true

# drug_strength - no file available
# psql postgresql://localhost:5432 -U postgres -c "TRUNCATE TABLE omopwave.drug_strength_wave;" 2>/dev/null || true

psql postgresql://localhost:5432 -U postgres -c "TRUNCATE TABLE omopwave.source_to_concept_map_wave;" 2>/dev/null || true
psql postgresql://localhost:5432 -U postgres -c "\COPY omopwave.source_to_concept_map_wave FROM './vocab_temp/source_to_concept_map.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '\"', ESCAPE '\"')" 2>/dev/null || true

# concept_recommended - no file available
# psql postgresql://localhost:5432 -U postgres -c "TRUNCATE TABLE omopwave.concept_recommended_wave;" 2>/dev/null || true

# concept_hierarchy - no file available
# psql postgresql://localhost:5432 -U postgres -c "TRUNCATE TABLE omopwave.concept_hierarchy_wave;" 2>/dev/null || true
