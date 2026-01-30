CREATE TABLE omopwave.concept_wave (
  concept_id integer NOT NULL,
  concept_name text NOT NULL,
  domain_id text NOT NULL,
  vocabulary_id text NOT NULL,
  concept_class_id text NOT NULL,
  standard_concept text,
  concept_code text NOT NULL,
  valid_start_date date NOT NULL,
  valid_end_date date NOT NULL,
  invalid_reason text
);

CREATE TABLE omopwave.vocabulary_wave (
  vocabulary_id text NOT NULL,
  vocabulary_name text NOT NULL,
  vocabulary_reference text,
  vocabulary_version text,
  vocabulary_concept_id integer NOT NULL
);

CREATE TABLE omopwave.domain_wave (
  domain_id text NOT NULL,
  domain_name text NOT NULL,
  domain_concept_id integer NOT NULL
);

CREATE TABLE omopwave.concept_class_wave (
  concept_class_id text NOT NULL,
  concept_class_name text NOT NULL,
  concept_class_concept_id integer NOT NULL
);

CREATE TABLE omopwave.concept_relationship_wave (
  concept_id_1 integer NOT NULL,
  concept_id_2 integer NOT NULL,
  relationship_id text NOT NULL,
  valid_start_date date NOT NULL,
  valid_end_date date NOT NULL,
  invalid_reason text
);

CREATE TABLE omopwave.relationship_wave (
  relationship_id text NOT NULL,
  relationship_name text NOT NULL,
  is_hierarchical text NOT NULL,
  defines_ancestry text NOT NULL,
  reverse_relationship_id text NOT NULL,
  relationship_concept_id integer NOT NULL
);

CREATE TABLE omopwave.concept_synonym_wave (
  concept_id integer NOT NULL,
  concept_synonym_name text NOT NULL,
  language_concept_id integer NOT NULL
);

CREATE TABLE omopwave.concept_ancestor_wave (
  ancestor_concept_id integer NOT NULL,
  descendant_concept_id integer NOT NULL,
  min_levels_of_separation integer NOT NULL,
  max_levels_of_separation integer NOT NULL
);

CREATE TABLE omopwave.drug_strength_wave (
  drug_concept_id integer NOT NULL,
  ingredient_concept_id integer NOT NULL,
  amount_value float,
  amount_unit_concept_id integer,
  numerator_value float,
  numerator_unit_concept_id integer,
  denominator_value float,
  denominator_unit_concept_id integer,
  box_size integer,
  valid_start_date date NOT NULL,
  valid_end_date date NOT NULL,
  invalid_reason text
);

CREATE TABLE omopwave.source_to_concept_map_wave (
    source_code varchar(50)  NOT NULL,
    source_concept_id  integer NOT NULL,
    source_vocabulary_id varchar(30) NOT NULL,
    source_code_description varchar(255) NULL,
    target_concept_id integer NOT NULL,
    target_vocabulary_id varchar(30) NOT NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason varchar(1) NULL
);

CREATE TABLE omopwave.concept_recommended_wave (
  concept_id_1 integer NOT NULL,
  concept_id_2 integer NOT NULL,
  relationship_id text NOT NULL
);

CREATE TABLE omopwave.concept_hierarchy_wave
 (concept_id             INT,
  concept_name           VARCHAR(400),
  treemap                VARCHAR(20),
  concept_hierarchy_type VARCHAR(20),
  level1_concept_name    VARCHAR(255),
  level2_concept_name    VARCHAR(255),
  level3_concept_name    VARCHAR(255),
  level4_concept_name    VARCHAR(255)
);