--postgresql CDM DDL Specification for OMOP Common Data Model 5.4

CREATE SCHEMA IF NOT EXISTS omopwave;

DROP TABLE IF EXISTS omopwave.DEATH CASCADE;
DROP TABLE IF EXISTS omopwave.MEASUREMENT CASCADE;
DROP TABLE IF EXISTS omopwave.CONDITION_OCCURRENCE CASCADE;
DROP TABLE IF EXISTS omopwave.OBSERVATION CASCADE;
DROP TABLE IF EXISTS omopwave.DRUG_EXPOSURE CASCADE;
DROP TABLE IF EXISTS omopwave.PROCEDURE_OCCURRENCE CASCADE;
DROP TABLE IF EXISTS omopwave.OBSERVATION_PERIOD CASCADE;
DROP TABLE IF EXISTS omopwave.CDM_SOURCE CASCADE;
DROP TABLE IF EXISTS omopwave.VISIT_OCCURRENCE CASCADE;
DROP TABLE IF EXISTS omopwave.PERSON CASCADE;
DROP TABLE IF EXISTS omopwave.DRUG_ERA CASCADE;
DROP TABLE IF EXISTS omopwave.CONDITION_ERA CASCADE;
DROP TABLE IF EXISTS omopwave.FACT_RELATIONSHIP CASCADE;
DROP TABLE IF EXISTS omopwave.PROVIDER CASCADE;
DROP TABLE IF EXISTS omopwave.CARE_SITE CASCADE;
DROP TABLE IF EXISTS omopwave.VISIT_DETAIL CASCADE;
DROP TABLE IF EXISTS omopwave.DEVICE_EXPOSURE CASCADE;
DROP TABLE IF EXISTS omopwave.SPECIMEN CASCADE;
DROP TABLE IF EXISTS omopwave.NOTE CASCADE;
DROP TABLE IF EXISTS omopwave.COST CASCADE;
DROP TABLE IF EXISTS omopwave.DOSE_ERA CASCADE;
DROP TABLE IF EXISTS omopwave.LOCATION CASCADE;
DROP TABLE IF EXISTS omopwave.NOTE_NLP CASCADE;
DROP TABLE IF EXISTS omopwave.PAYER_PLAN_PERIOD CASCADE;
DROP TABLE IF EXISTS omopwave.METADATA CASCADE;
DROP TABLE IF EXISTS omopwave.EPISODE CASCADE;
DROP TABLE IF EXISTS omopwave.EPISODE_EVENT CASCADE;


CREATE TABLE IF NOT EXISTS omopwave.PERSON
(
    person_id                   integer     NOT NULL,
    gender_concept_id           integer     NOT NULL,
    year_of_birth               integer     NOT NULL,
    month_of_birth              integer     NULL,
    day_of_birth                integer     NULL,
    birth_datetime              TIMESTAMP   NULL,
    race_concept_id             integer     NOT NULL,
    ethnicity_concept_id        integer     NOT NULL,
    location_id                 integer     NULL,
    provider_id                 integer     NULL,
    care_site_id                integer     NULL,
    person_source_value         varchar(50) NULL,
    gender_source_value         varchar(50) NULL,
    gender_source_concept_id    integer     NULL,
    race_source_value           varchar(50) NULL,
    race_source_concept_id      integer     NULL,
    ethnicity_source_value      varchar(50) NULL,
    ethnicity_source_concept_id integer     NULL
);


CREATE TABLE IF NOT EXISTS omopwave.OBSERVATION_PERIOD
(
    observation_period_id         serial  PRIMARY KEY,
    person_id                     integer NOT NULL,
    observation_period_start_date date    NOT NULL,
    observation_period_end_date   date    NOT NULL,
    period_type_concept_id        integer NOT NULL
);


CREATE TABLE IF NOT EXISTS omopwave.VISIT_OCCURRENCE
(
    visit_occurrence_id           integer     NOT NULL,
    person_id                     integer     NOT NULL,
    visit_concept_id              integer     NOT NULL,
    visit_start_date              date        NOT NULL,
    visit_start_datetime          TIMESTAMP   NULL,
    visit_end_date                date        NOT NULL,
    visit_end_datetime            TIMESTAMP   NULL,
    visit_type_concept_id         Integer     NOT NULL,
    provider_id                   integer     NULL,
    care_site_id                  integer     NULL,
    visit_source_value            varchar(50) NULL,
    visit_source_concept_id       integer     NULL,
    admitted_from_concept_id      integer     NULL,
    admitted_from_source_value    varchar(50) NULL,
    discharged_to_concept_id      integer     NULL,
    discharged_to_source_value    varchar(50) NULL,
    preceding_visit_occurrence_id integer     NULL
);


CREATE TABLE IF NOT EXISTS omopwave.VISIT_DETAIL
(
    visit_detail_id                integer     NOT NULL,
    person_id                      integer     NOT NULL,
    visit_detail_concept_id        integer     NOT NULL,
    visit_detail_start_date        date        NOT NULL,
    visit_detail_start_datetime    TIMESTAMP   NULL,
    visit_detail_end_date          date        NOT NULL,
    visit_detail_end_datetime      TIMESTAMP   NULL,
    visit_detail_type_concept_id   integer     NOT NULL,
    provider_id                    integer     NULL,
    care_site_id                   integer     NULL,
    visit_detail_source_value      varchar(50) NULL,
    visit_detail_source_concept_id Integer     NULL,
    admitted_from_concept_id       Integer     NULL,
    admitted_from_source_value     varchar(50) NULL,
    discharged_to_source_value     varchar(50) NULL,
    discharged_to_concept_id       integer     NULL,
    preceding_visit_detail_id      integer     NULL,
    parent_visit_detail_id         integer     NULL,
    visit_occurrence_id            integer     NOT NULL
);


CREATE TABLE IF NOT EXISTS omopwave.CONDITION_OCCURRENCE
(
    condition_occurrence_id       integer     NOT NULL,
    person_id                     integer     NOT NULL,
    condition_concept_id          integer     NOT NULL,
    condition_start_date          date        NOT NULL,
    condition_start_datetime      TIMESTAMP   NULL,
    condition_end_date            date        NULL,
    condition_end_datetime        TIMESTAMP   NULL,
    condition_type_concept_id     integer     NOT NULL,
    condition_status_concept_id   integer     NULL,
    stop_reason                   varchar(20) NULL,
    provider_id                   integer     NULL,
    visit_occurrence_id           integer     NULL,
    visit_detail_id               integer     NULL,
    condition_source_value        varchar(50) NULL,
    condition_source_concept_id   integer     NULL,
    condition_status_source_value varchar(50) NULL
);


CREATE TABLE IF NOT EXISTS omopwave.DRUG_EXPOSURE
(
    drug_exposure_id             integer     NOT NULL,
    person_id                    integer     NOT NULL,
    drug_concept_id              integer     NOT NULL,
    drug_exposure_start_date     date        NOT NULL,
    drug_exposure_start_datetime TIMESTAMP   NULL,
    drug_exposure_end_date       date        NOT NULL,
    drug_exposure_end_datetime   TIMESTAMP   NULL,
    verbatim_end_date            date        NULL,
    drug_type_concept_id         integer     NOT NULL,
    stop_reason                  varchar(20) NULL,
    refills                      integer     NULL,
    quantity                     NUMERIC     NULL,
    days_supply                  integer     NULL,
    sig                          TEXT        NULL,
    route_concept_id             integer     NULL,
    lot_number                   varchar(50) NULL,
    provider_id                  integer     NULL,
    visit_occurrence_id          integer     NULL,
    visit_detail_id              integer     NULL,
    drug_source_value            varchar(50) NULL,
    drug_source_concept_id       integer     NULL,
    route_source_value           varchar(50) NULL,
    dose_unit_source_value       varchar(50) NULL
);


CREATE TABLE IF NOT EXISTS omopwave.PROCEDURE_OCCURRENCE
(
    procedure_occurrence_id     integer     NOT NULL,
    person_id                   integer     NOT NULL,
    procedure_concept_id        integer     NOT NULL,
    procedure_date              date        NOT NULL,
    procedure_datetime          TIMESTAMP   NULL,
    procedure_end_date          date        NULL,
    procedure_end_datetime      TIMESTAMP   NULL,
    procedure_type_concept_id   integer     NOT NULL,
    modifier_concept_id         integer     NULL,
    quantity                    integer     NULL,
    provider_id                 integer     NULL,
    visit_occurrence_id         integer     NULL,
    visit_detail_id             integer     NULL,
    procedure_source_value      varchar(50) NULL,
    procedure_source_concept_id integer     NULL,
    modifier_source_value       varchar(50) NULL
);


CREATE TABLE IF NOT EXISTS omopwave.DEVICE_EXPOSURE
(
    device_exposure_id             integer      NOT NULL,
    person_id                      integer      NOT NULL,
    device_concept_id              integer      NOT NULL,
    device_exposure_start_date     date         NOT NULL,
    device_exposure_start_datetime TIMESTAMP    NULL,
    device_exposure_end_date       date         NULL,
    device_exposure_end_datetime   TIMESTAMP    NULL,
    device_type_concept_id         integer      NOT NULL,
    unique_device_id               varchar(255) NULL,
    production_id                  varchar(255) NULL,
    quantity                       integer      NULL,
    provider_id                    integer      NULL,
    visit_occurrence_id            integer      NULL,
    visit_detail_id                integer      NULL,
    device_source_value            varchar(50)  NULL,
    device_source_concept_id       integer      NULL,
    unit_concept_id                integer      NULL,
    unit_source_value              varchar(50)  NULL,
    unit_source_concept_id         integer      NULL
);


CREATE TABLE IF NOT EXISTS omopwave.MEASUREMENT
(
    measurement_id                integer     NOT NULL,
    person_id                     integer     NOT NULL,
    measurement_concept_id        integer     NOT NULL,
    measurement_date              date        NOT NULL,
    measurement_datetime          TIMESTAMP   NULL,
    measurement_time              varchar(10) NULL,
    measurement_type_concept_id   integer     NOT NULL,
    operator_concept_id           integer     NULL,
    value_as_number               NUMERIC     NULL,
    value_as_concept_id           integer     NULL,
    unit_concept_id               integer     NULL,
    range_low                     NUMERIC     NULL,
    range_high                    NUMERIC     NULL,
    provider_id                   integer     NULL,
    visit_occurrence_id           integer     NULL,
    visit_detail_id               integer     NULL,
    measurement_source_value      varchar(50) NULL,
    measurement_source_concept_id integer     NULL,
    unit_source_value             varchar(50) NULL,
    unit_source_concept_id        integer     NULL,
    value_source_value            varchar(50) NULL,
    measurement_event_id          bigint      NULL,
    meas_event_field_concept_id   integer     NULL
);


CREATE TABLE IF NOT EXISTS omopwave.OBSERVATION
(
    observation_id                integer     NOT NULL,
    person_id                     integer     NOT NULL,
    observation_concept_id        integer     NOT NULL,
    observation_date              date        NOT NULL,
    observation_datetime          TIMESTAMP   NULL,
    observation_type_concept_id   integer     NOT NULL,
    value_as_number               NUMERIC     NULL,
    value_as_string               varchar(60) NULL,
    value_as_concept_id           Integer     NULL,
    qualifier_concept_id          integer     NULL,
    unit_concept_id               integer     NULL,
    provider_id                   integer     NULL,
    visit_occurrence_id           integer     NULL,
    visit_detail_id               integer     NULL,
    observation_source_value      varchar(50) NULL,
    observation_source_concept_id integer     NULL,
    unit_source_value             varchar(50) NULL,
    qualifier_source_value        varchar(50) NULL,
    value_source_value            varchar(50) NULL,
    observation_event_id          bigint      NULL,
    obs_event_field_concept_id    integer     NULL
);


CREATE TABLE IF NOT EXISTS omopwave.DEATH
(
    person_id               integer     NOT NULL,
    death_date              date        NOT NULL,
    death_datetime          TIMESTAMP   NULL,
    death_type_concept_id   integer     NULL,
    cause_concept_id        integer     NULL,
    cause_source_value      varchar(50) NULL,
    cause_source_concept_id integer     NULL
);


CREATE TABLE IF NOT EXISTS omopwave.NOTE
(
    note_id                     integer      NOT NULL,
    person_id                   integer      NOT NULL,
    note_date                   date         NOT NULL,
    note_datetime               TIMESTAMP    NULL,
    note_type_concept_id        integer      NOT NULL,
    note_class_concept_id       integer      NOT NULL,
    note_title                  varchar(250) NULL,
    note_text                   TEXT         NOT NULL,
    encoding_concept_id         integer      NOT NULL,
    language_concept_id         integer      NOT NULL,
    provider_id                 integer      NULL,
    visit_occurrence_id         integer      NULL,
    visit_detail_id             integer      NULL,
    note_source_value           varchar(50)  NULL,
    note_event_id               bigint       NULL,
    note_event_field_concept_id integer      NULL
);


CREATE TABLE IF NOT EXISTS omopwave.NOTE_NLP
(
    note_nlp_id                integer       NOT NULL,
    note_id                    integer       NOT NULL,
    section_concept_id         integer       NULL,
    snippet                    varchar(250)  NULL,
    "offset"                   varchar(50)   NULL,
    lexical_variant            varchar(250)  NOT NULL,
    note_nlp_concept_id        integer       NULL,
    note_nlp_source_concept_id integer       NULL,
    nlp_system                 varchar(250)  NULL,
    nlp_date                   date          NOT NULL,
    nlp_datetime               TIMESTAMP     NULL,
    term_exists                varchar(1)    NULL,
    term_temporal              varchar(50)   NULL,
    term_modifiers             varchar(2000) NULL
);


CREATE TABLE IF NOT EXISTS omopwave.SPECIMEN
(
    specimen_id                 integer     NOT NULL,
    person_id                   integer     NOT NULL,
    specimen_concept_id         integer     NOT NULL,
    specimen_type_concept_id    integer     NOT NULL,
    specimen_date               date        NOT NULL,
    specimen_datetime           TIMESTAMP   NULL,
    quantity                    NUMERIC     NULL,
    unit_concept_id             integer     NULL,
    anatomic_site_concept_id    integer     NULL,
    disease_status_concept_id   integer     NULL,
    specimen_source_id          varchar(50) NULL,
    specimen_source_value       varchar(50) NULL,
    unit_source_value           varchar(50) NULL,
    anatomic_site_source_value  varchar(50) NULL,
    disease_status_source_value varchar(50) NULL
);


CREATE TABLE IF NOT EXISTS omopwave.FACT_RELATIONSHIP
(
    domain_concept_id_1     integer NOT NULL,
    fact_id_1               integer NOT NULL,
    domain_concept_id_2     integer NOT NULL,
    fact_id_2               integer NOT NULL,
    relationship_concept_id integer NOT NULL
);


CREATE TABLE IF NOT EXISTS omopwave.LOCATION
(
    location_id           integer     NOT NULL,
    address_1             varchar(50) NULL,
    address_2             varchar(50) NULL,
    city                  varchar(50) NULL,
    state                 varchar(2)  NULL,
    zip                   varchar(9)  NULL,
    county                varchar(20) NULL,
    location_source_value varchar(50) NULL,
    country_concept_id    integer     NULL,
    country_source_value  varchar(80) NULL,
    latitude              NUMERIC     NULL,
    longitude             NUMERIC     NULL
);


CREATE TABLE IF NOT EXISTS omopwave.CARE_SITE
(
    care_site_id                  integer      NOT NULL,
    care_site_name                varchar(255) NULL,
    place_of_service_concept_id   integer      NULL,
    location_id                   integer      NULL,
    care_site_source_value        varchar(50)  NULL,
    place_of_service_source_value varchar(50)  NULL
);


CREATE TABLE IF NOT EXISTS omopwave.PROVIDER
(
    provider_id                 integer      NOT NULL,
    provider_name               varchar(255) NULL,
    npi                         varchar(20)  NULL,
    dea                         varchar(20)  NULL,
    specialty_concept_id        integer      NULL,
    care_site_id                integer      NULL,
    year_of_birth               integer      NULL,
    gender_concept_id           integer      NULL,
    provider_source_value       varchar(50)  NULL,
    specialty_source_value      varchar(50)  NULL,
    specialty_source_concept_id integer      NULL,
    gender_source_value         varchar(50)  NULL,
    gender_source_concept_id    integer      NULL
);


CREATE TABLE IF NOT EXISTS omopwave.PAYER_PLAN_PERIOD
(
    payer_plan_period_id          integer     NOT NULL,
    person_id                     integer     NOT NULL,
    payer_plan_period_start_date  date        NOT NULL,
    payer_plan_period_end_date    date        NOT NULL,
    payer_concept_id              integer     NULL,
    payer_source_value            varchar(50) NULL,
    payer_source_concept_id       integer     NULL,
    plan_concept_id               integer     NULL,
    plan_source_value             varchar(50) NULL,
    plan_source_concept_id        integer     NULL,
    sponsor_concept_id            integer     NULL,
    sponsor_source_value          varchar(50) NULL,
    sponsor_source_concept_id     integer     NULL,
    family_source_value           varchar(50) NULL,
    stop_reason_concept_id        integer     NULL,
    stop_reason_source_value      varchar(50) NULL,
    stop_reason_source_concept_id integer     NULL
);


CREATE TABLE IF NOT EXISTS omopwave.COST
(
    cost_id                   integer     NOT NULL,
    cost_event_id             integer     NOT NULL,
    cost_domain_id            varchar(20) NOT NULL,
    cost_type_concept_id      integer     NOT NULL,
    currency_concept_id       integer     NULL,
    total_charge              NUMERIC     NULL,
    total_cost                NUMERIC     NULL,
    total_paid                NUMERIC     NULL,
    paid_by_payer             NUMERIC     NULL,
    paid_by_patient           NUMERIC     NULL,
    paid_patient_copay        NUMERIC     NULL,
    paid_patient_coinsurance  NUMERIC     NULL,
    paid_patient_deductible   NUMERIC     NULL,
    paid_by_primary           NUMERIC     NULL,
    paid_ingredient_cost      NUMERIC     NULL,
    paid_dispensing_fee       NUMERIC     NULL,
    payer_plan_period_id      integer     NULL,
    amount_allowed            NUMERIC     NULL,
    revenue_code_concept_id   integer     NULL,
    revenue_code_source_value varchar(50) NULL,
    drg_concept_id            integer     NULL,
    drg_source_value          varchar(3)  NULL
);


CREATE TABLE IF NOT EXISTS omopwave.DRUG_ERA
(
    drug_era_id         integer   NOT NULL,
    person_id           integer   NOT NULL,
    drug_concept_id     integer   NOT NULL,
    drug_era_start_date TIMESTAMP NOT NULL,
    drug_era_end_date   TIMESTAMP NOT NULL,
    drug_exposure_count integer   NULL,
    gap_days            integer   NULL
);


CREATE TABLE IF NOT EXISTS omopwave.DOSE_ERA
(
    dose_era_id         integer   NOT NULL,
    person_id           integer   NOT NULL,
    drug_concept_id     integer   NOT NULL,
    unit_concept_id     integer   NOT NULL,
    dose_value          NUMERIC   NOT NULL,
    dose_era_start_date TIMESTAMP NOT NULL,
    dose_era_end_date   TIMESTAMP NOT NULL
);


CREATE TABLE IF NOT EXISTS omopwave.CONDITION_ERA
(
    condition_era_id           integer   NOT NULL,
    person_id                  integer   NOT NULL,
    condition_concept_id       integer   NOT NULL,
    condition_era_start_date   TIMESTAMP NOT NULL,
    condition_era_end_date     TIMESTAMP NOT NULL,
    condition_occurrence_count integer   NULL
);


CREATE TABLE IF NOT EXISTS omopwave.EPISODE
(
    episode_id                bigint      NOT NULL,
    person_id                 bigint      NOT NULL,
    episode_concept_id        integer     NOT NULL,
    episode_start_date        date        NOT NULL,
    episode_start_datetime    TIMESTAMP   NULL,
    episode_end_date          date        NULL,
    episode_end_datetime      TIMESTAMP   NULL,
    episode_parent_id         bigint      NULL,
    episode_number            integer     NULL,
    episode_object_concept_id integer     NOT NULL,
    episode_type_concept_id   integer     NOT NULL,
    episode_source_value      varchar(50) NULL,
    episode_source_concept_id integer     NULL
);


CREATE TABLE IF NOT EXISTS omopwave.EPISODE_EVENT
(
    episode_id                     bigint  NOT NULL,
    event_id                       bigint  NOT NULL,
    episode_event_field_concept_id integer NOT NULL
);


CREATE TABLE IF NOT EXISTS omopwave.METADATA
(
    metadata_id              integer      NOT NULL,
    metadata_concept_id      integer      NOT NULL,
    metadata_type_concept_id integer      NOT NULL,
    name                     varchar(250) NOT NULL,
    value_as_string          varchar(250) NULL,
    value_as_concept_id      integer      NULL,
    value_as_number          NUMERIC      NULL,
    metadata_date            date         NULL,
    metadata_datetime        TIMESTAMP    NULL
);


CREATE TABLE IF NOT EXISTS omopwave.CDM_SOURCE
(
    cdm_source_name                varchar(255) NOT NULL,
    cdm_source_abbreviation        varchar(25)  NOT NULL,
    cdm_holder                     varchar(255) NOT NULL,
    source_description             TEXT         NULL,
    source_documentation_reference varchar(255) NULL,
    cdm_etl_reference              varchar(255) NULL,
    source_release_date            date         NOT NULL,
    cdm_release_date               date         NOT NULL,
    cdm_version                    varchar(10)  NULL,
    cdm_version_concept_id         integer      NOT NULL,
    vocabulary_version             varchar(20)  NOT NULL
);


CREATE TABLE IF NOT EXISTS omopwave.DRUG_STRENGTH
(
    drug_concept_id             integer    NOT NULL,
    ingredient_concept_id       integer    NOT NULL,
    amount_value                NUMERIC    NULL,
    amount_unit_concept_id      integer    NULL,
    numerator_value             NUMERIC    NULL,
    numerator_unit_concept_id   integer    NULL,
    denominator_value           NUMERIC    NULL,
    denominator_unit_concept_id integer    NULL,
    box_size                    integer    NULL,
    valid_start_date            date       NOT NULL,
    valid_end_date              date       NOT NULL,
    invalid_reason              varchar(1) NULL
);


CREATE TABLE IF NOT EXISTS omopwave.COHORT
(
    cohort_definition_id integer NOT NULL,
    subject_id           integer NOT NULL,
    cohort_start_date    date    NOT NULL,
    cohort_end_date      date    NOT NULL
);


CREATE TABLE IF NOT EXISTS omopwave.COHORT_DEFINITION
(
    cohort_definition_id          integer      NOT NULL,
    cohort_definition_name        varchar(255) NOT NULL,
    cohort_definition_description TEXT         NULL,
    definition_type_concept_id    integer      NOT NULL,
    cohort_definition_syntax      TEXT         NULL,
    subject_concept_id            integer      NOT NULL,
    cohort_initiation_date        date         NULL
);

-- FAKE PEOPLE

INSERT INTO omopwave.PERSON(person_id,
                           gender_concept_id,
                           year_of_birth,
                           month_of_birth,
                           day_of_birth,
                           birth_datetime,
                           race_concept_id,
                           ethnicity_concept_id,
                           location_id,
                           provider_id,
                           care_site_id,
                           person_source_value,
                           gender_source_value,
                           gender_source_concept_id,
                           race_source_value,
                           race_source_concept_id,
                           ethnicity_source_value,
                           ethnicity_source_concept_id)
SELECT row_number() over (),
       (select (array [8532, 8507])[floor(random() * 2 * (i / i) + 1)]),
       (select floor(random() * 30 * (i / i) + 1940)),
       (select floor(random() * 11.99 * (i / i) + 1)),
       NULL,
       NULL,
       0,
       0,
       NULL,
       NULL,
       NULL,
       (select CONCAT('FAKE PERSON: ', substr(md5(i::text), 0, 10))),
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL
FROM generate_series(1, 10000) s(i);

UPDATE omopwave.PERSON
SET gender_source_value = 'M'
WHERE gender_concept_id = 8507;

UPDATE omopwave.PERSON
SET gender_source_value = 'F'
WHERE gender_concept_id = 8532;

-- ============================================================================
-- CARDIAC CONDITIONS
-- ============================================================================
-- Primary focus: Atrial Fibrillation for ~3,000 patients (target cohort)
-- Additional cardiac conditions: MI, CHF, Hypertension, CAD

-- Atrial Fibrillation (313217) - Primary condition of interest
INSERT INTO omopwave.condition_occurrence(condition_occurrence_id,
                                         person_id,
                                         condition_concept_id,
                                         condition_start_date,
                                         condition_start_datetime,
                                         condition_end_date,
                                         condition_end_datetime,
                                         condition_type_concept_id,
                                         condition_status_concept_id,
                                         stop_reason,
                                         provider_id,
                                         visit_occurrence_id,
                                         visit_detail_id,
                                         condition_source_value,
                                         condition_source_concept_id,
                                         condition_status_source_value)
SELECT row_number() over (),
       (select (array(select person_id from omopwave.person ORDER BY person_id))[i]),
       313217, -- Atrial Fibrillation
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       NULL,
       32817, -- EHR
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'AFIB',
       313217,
       NULL
FROM generate_series(1, 3000) s(i);

-- Myocardial Infarction (4329847)
INSERT INTO omopwave.condition_occurrence(condition_occurrence_id,
                                         person_id,
                                         condition_concept_id,
                                         condition_start_date,
                                         condition_start_datetime,
                                         condition_end_date,
                                         condition_end_datetime,
                                         condition_type_concept_id,
                                         condition_status_concept_id,
                                         stop_reason,
                                         provider_id,
                                         visit_occurrence_id,
                                         visit_detail_id,
                                         condition_source_value,
                                         condition_source_concept_id,
                                         condition_status_source_value)
SELECT (row_number() over () + 3000),
       (select (array(select person_id from omopwave.person))[floor(random() * 10000 * (i / i) + 1)]),
       4329847, -- Myocardial Infarction
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       NULL,
       32817,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'MI',
       4329847,
       NULL
FROM generate_series(1, 1500) s(i);

-- Heart Failure (316139)
INSERT INTO omopwave.condition_occurrence(condition_occurrence_id,
                                         person_id,
                                         condition_concept_id,
                                         condition_start_date,
                                         condition_start_datetime,
                                         condition_end_date,
                                         condition_end_datetime,
                                         condition_type_concept_id,
                                         condition_status_concept_id,
                                         stop_reason,
                                         provider_id,
                                         visit_occurrence_id,
                                         visit_detail_id,
                                         condition_source_value,
                                         condition_source_concept_id,
                                         condition_status_source_value)
SELECT (row_number() over () + 4500),
       (select (array(select person_id from omopwave.person))[floor(random() * 10000 * (i / i) + 1)]),
       316139, -- Heart Failure
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       NULL,
       32817,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'CHF',
       316139,
       NULL
FROM generate_series(1, 2000) s(i);

-- Essential Hypertension (320128)
INSERT INTO omopwave.condition_occurrence(condition_occurrence_id,
                                         person_id,
                                         condition_concept_id,
                                         condition_start_date,
                                         condition_start_datetime,
                                         condition_end_date,
                                         condition_end_datetime,
                                         condition_type_concept_id,
                                         condition_status_concept_id,
                                         stop_reason,
                                         provider_id,
                                         visit_occurrence_id,
                                         visit_detail_id,
                                         condition_source_value,
                                         condition_source_concept_id,
                                         condition_status_source_value)
SELECT (row_number() over () + 6500),
       (select (array(select person_id from omopwave.person))[floor(random() * 10000 * (i / i) + 1)]),
       320128, -- Essential Hypertension
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       NULL,
       32817,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'HTN',
       320128,
       NULL
FROM generate_series(1, 4500) s(i);

-- Coronary Arteriosclerosis (317576)
INSERT INTO omopwave.condition_occurrence(condition_occurrence_id,
                                         person_id,
                                         condition_concept_id,
                                         condition_start_date,
                                         condition_start_datetime,
                                         condition_end_date,
                                         condition_end_datetime,
                                         condition_type_concept_id,
                                         condition_status_concept_id,
                                         stop_reason,
                                         provider_id,
                                         visit_occurrence_id,
                                         visit_detail_id,
                                         condition_source_value,
                                         condition_source_concept_id,
                                         condition_status_source_value)
SELECT (row_number() over () + 11000),
       (select (array(select person_id from omopwave.person))[floor(random() * 10000 * (i / i) + 1)]),
       317576, -- Coronary Arteriosclerosis
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       NULL,
       32817,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'CAD',
       317576,
       NULL
FROM generate_series(1, 2500) s(i);


-- ============================================================================
-- CARDIAC PROCEDURES
-- ============================================================================

-- Electrocardiogram (EKG/ECG) - 4269893 - Most patients will have at least one
INSERT INTO omopwave.procedure_occurrence(procedure_occurrence_id,
                                         person_id,
                                         procedure_concept_id,
                                         procedure_date,
                                         procedure_datetime,
                                         procedure_end_date,
                                         procedure_end_datetime,
                                         procedure_type_concept_id,
                                         modifier_concept_id,
                                         quantity,
                                         provider_id,
                                         visit_occurrence_id,
                                         visit_detail_id,
                                         procedure_source_value,
                                         procedure_source_concept_id,
                                         modifier_source_value)
SELECT row_number() over (),
       (select (array(select person_id from omopwave.person))[floor(random() * 10000 * (i / i) + 1)]),
       4269893, -- Electrocardiogram
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       NULL,
       32817,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'EKG',
       4269893,
       NULL
FROM generate_series(1, 7000) s(i);

-- Echocardiography - 4324693
INSERT INTO omopwave.procedure_occurrence(procedure_occurrence_id,
                                         person_id,
                                         procedure_concept_id,
                                         procedure_date,
                                         procedure_datetime,
                                         procedure_end_date,
                                         procedure_end_datetime,
                                         procedure_type_concept_id,
                                         modifier_concept_id,
                                         quantity,
                                         provider_id,
                                         visit_occurrence_id,
                                         visit_detail_id,
                                         procedure_source_value,
                                         procedure_source_concept_id,
                                         modifier_source_value)
SELECT (row_number() over () + 7000),
       (select (array(select person_id from omopwave.condition_occurrence))[floor(random() * (SELECT count(*) FROM omopwave.condition_occurrence) * (i / i) + 1)]),
       4324693, -- Echocardiography
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       NULL,
       32817,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'ECHO',
       4324693,
       NULL
FROM generate_series(1, 3000) s(i);

-- Cardiac catheterization - 4178650
INSERT INTO omopwave.procedure_occurrence(procedure_occurrence_id,
                                         person_id,
                                         procedure_concept_id,
                                         procedure_date,
                                         procedure_datetime,
                                         procedure_end_date,
                                         procedure_end_datetime,
                                         procedure_type_concept_id,
                                         modifier_concept_id,
                                         quantity,
                                         provider_id,
                                         visit_occurrence_id,
                                         visit_detail_id,
                                         procedure_source_value,
                                         procedure_source_concept_id,
                                         modifier_source_value)
SELECT (row_number() over () + 10000),
       (select (array(select person_id from omopwave.condition_occurrence))[floor(random() * (SELECT count(*) FROM omopwave.condition_occurrence) * (i / i) + 1)]),
       4178650, -- Cardiac catheterization
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       NULL,
       32817,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'CATH',
       4178650,
       NULL
FROM generate_series(1, 1000) s(i);

-- Exercise stress test - 4273307
INSERT INTO omopwave.procedure_occurrence(procedure_occurrence_id,
                                         person_id,
                                         procedure_concept_id,
                                         procedure_date,
                                         procedure_datetime,
                                         procedure_end_date,
                                         procedure_end_datetime,
                                         procedure_type_concept_id,
                                         modifier_concept_id,
                                         quantity,
                                         provider_id,
                                         visit_occurrence_id,
                                         visit_detail_id,
                                         procedure_source_value,
                                         procedure_source_concept_id,
                                         modifier_source_value)
SELECT (row_number() over () + 11000),
       (select (array(select person_id from omopwave.condition_occurrence))[floor(random() * (SELECT count(*) FROM omopwave.condition_occurrence) * (i / i) + 1)]),
       4273307, -- Exercise stress test
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       NULL,
       32817,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'STRESS_TEST',
       4273307,
       NULL
FROM generate_series(1, 2000) s(i);

-- Cardiac MRI - 4052893
INSERT INTO omopwave.procedure_occurrence(procedure_occurrence_id,
                                         person_id,
                                         procedure_concept_id,
                                         procedure_date,
                                         procedure_datetime,
                                         procedure_end_date,
                                         procedure_end_datetime,
                                         procedure_type_concept_id,
                                         modifier_concept_id,
                                         quantity,
                                         provider_id,
                                         visit_occurrence_id,
                                         visit_detail_id,
                                         procedure_source_value,
                                         procedure_source_concept_id,
                                         modifier_source_value)
SELECT (row_number() over () + 13000),
       (select (array(select person_id from omopwave.condition_occurrence))[floor(random() * (SELECT count(*) FROM omopwave.condition_occurrence) * (i / i) + 1)]),
       4052893, -- Cardiac MRI
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       NULL,
       32817,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'CARDIAC_MRI',
       4052893,
       NULL
FROM generate_series(1, 500) s(i);

-- Update procedure dates to be relative to condition onset dates
UPDATE omopwave.procedure_occurrence
SET procedure_date = foo.condition_start_date +
                     floor(random() * 30 * (condition_occurrence_id / condition_occurrence_id) + 1) *
                     Interval '1 Day'
FROM (SELECT condition_occurrence_id, condition_start_date, c.person_id
      FROM omopwave.condition_occurrence c
               INNER JOIN omopwave.procedure_occurrence p ON c.person_id = p.person_id) foo
WHERE foo.person_id = omopwave.procedure_occurrence.person_id
AND omopwave.procedure_occurrence.procedure_source_value IN ('EKG', 'ECHO', 'CATH', 'STRESS_TEST', 'CARDIAC_MRI');

-- ============================================================================
-- CARDIAC DRUG EXPOSURES
-- ============================================================================

-- Warfarin (1310149) - Anticoagulant for AFib patients
INSERT INTO omopwave.drug_exposure (drug_exposure_id,
                                   person_id,
                                   drug_concept_id,
                                   drug_exposure_start_date,
                                   drug_exposure_start_datetime,
                                   drug_exposure_end_date,
                                   drug_exposure_end_datetime,
                                   verbatim_end_date,
                                   drug_type_concept_id,
                                   stop_reason,
                                   refills,
                                   quantity,
                                   days_supply,
                                   sig,
                                   route_concept_id,
                                   lot_number,
                                   provider_id,
                                   visit_occurrence_id,
                                   visit_detail_id,
                                   drug_source_value,
                                   drug_source_concept_id,
                                   route_source_value,
                                   dose_unit_source_value)
SELECT row_number() over (),
       (select (array(select person_id from omopwave.condition_occurrence WHERE condition_concept_id = 313217))[floor(random() * 3000 * (i / i) + 1)]),
       1310149, -- Warfarin
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       32817,
       NULL,
       NULL,
       NULL,
       90,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'WARFARIN',
       1310149,
       NULL,
       NULL
FROM generate_series(1, 15000) s(i);

-- Metoprolol (1307046) - Beta-blocker
INSERT INTO omopwave.drug_exposure (drug_exposure_id,
                                   person_id,
                                   drug_concept_id,
                                   drug_exposure_start_date,
                                   drug_exposure_start_datetime,
                                   drug_exposure_end_date,
                                   drug_exposure_end_datetime,
                                   verbatim_end_date,
                                   drug_type_concept_id,
                                   stop_reason,
                                   refills,
                                   quantity,
                                   days_supply,
                                   sig,
                                   route_concept_id,
                                   lot_number,
                                   provider_id,
                                   visit_occurrence_id,
                                   visit_detail_id,
                                   drug_source_value,
                                   drug_source_concept_id,
                                   route_source_value,
                                   dose_unit_source_value)
SELECT (row_number() over () + 15000),
       (select (array(select person_id from omopwave.condition_occurrence))[floor(random() * (SELECT count(*) FROM omopwave.condition_occurrence) * (i / i) + 1)]),
       1307046, -- Metoprolol
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       32817,
       NULL,
       NULL,
       NULL,
       90,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'METOPROLOL',
       1307046,
       NULL,
       NULL
FROM generate_series(1, 20000) s(i);

-- Lisinopril (1308216) - ACE Inhibitor
INSERT INTO omopwave.drug_exposure (drug_exposure_id,
                                   person_id,
                                   drug_concept_id,
                                   drug_exposure_start_date,
                                   drug_exposure_start_datetime,
                                   drug_exposure_end_date,
                                   drug_exposure_end_datetime,
                                   verbatim_end_date,
                                   drug_type_concept_id,
                                   stop_reason,
                                   refills,
                                   quantity,
                                   days_supply,
                                   sig,
                                   route_concept_id,
                                   lot_number,
                                   provider_id,
                                   visit_occurrence_id,
                                   visit_detail_id,
                                   drug_source_value,
                                   drug_source_concept_id,
                                   route_source_value,
                                   dose_unit_source_value)
SELECT (row_number() over () + 35000),
       (select (array(select person_id from omopwave.condition_occurrence))[floor(random() * (SELECT count(*) FROM omopwave.condition_occurrence) * (i / i) + 1)]),
       1308216, -- Lisinopril
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       32817,
       NULL,
       NULL,
       NULL,
       90,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'LISINOPRIL',
       1308216,
       NULL,
       NULL
FROM generate_series(1, 25000) s(i);

-- Furosemide (1719286) - Diuretic
INSERT INTO omopwave.drug_exposure (drug_exposure_id,
                                   person_id,
                                   drug_concept_id,
                                   drug_exposure_start_date,
                                   drug_exposure_start_datetime,
                                   drug_exposure_end_date,
                                   drug_exposure_end_datetime,
                                   verbatim_end_date,
                                   drug_type_concept_id,
                                   stop_reason,
                                   refills,
                                   quantity,
                                   days_supply,
                                   sig,
                                   route_concept_id,
                                   lot_number,
                                   provider_id,
                                   visit_occurrence_id,
                                   visit_detail_id,
                                   drug_source_value,
                                   drug_source_concept_id,
                                   route_source_value,
                                   dose_unit_source_value)
SELECT (row_number() over () + 60000),
       (select (array(select person_id from omopwave.condition_occurrence WHERE condition_concept_id = 316139))[floor(random() * 2000 * (i / i) + 1)]),
       1719286, -- Furosemide
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       32817,
       NULL,
       NULL,
       NULL,
       90,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'FUROSEMIDE',
       1719286,
       NULL,
       NULL
FROM generate_series(1, 10000) s(i);

-- Atorvastatin (1539403) - Statin
INSERT INTO omopwave.drug_exposure (drug_exposure_id,
                                   person_id,
                                   drug_concept_id,
                                   drug_exposure_start_date,
                                   drug_exposure_start_datetime,
                                   drug_exposure_end_date,
                                   drug_exposure_end_datetime,
                                   verbatim_end_date,
                                   drug_type_concept_id,
                                   stop_reason,
                                   refills,
                                   quantity,
                                   days_supply,
                                   sig,
                                   route_concept_id,
                                   lot_number,
                                   provider_id,
                                   visit_occurrence_id,
                                   visit_detail_id,
                                   drug_source_value,
                                   drug_source_concept_id,
                                   route_source_value,
                                   dose_unit_source_value)
SELECT (row_number() over () + 70000),
       (select (array(select person_id from omopwave.condition_occurrence))[floor(random() * (SELECT count(*) FROM omopwave.condition_occurrence) * (i / i) + 1)]),
       1539403, -- Atorvastatin
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       32817,
       NULL,
       NULL,
       NULL,
       90,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'ATORVASTATIN',
       1539403,
       NULL,
       NULL
FROM generate_series(1, 18000) s(i);

-- Update drug dates to be relative to condition onset
UPDATE omopwave.drug_exposure
SET drug_exposure_start_date = foo.condition_start_date +
                     floor(random() * 365 * (condition_occurrence_id / condition_occurrence_id) + 7) *
                     Interval '1 Day'
FROM (SELECT condition_occurrence_id, condition_start_date, c.person_id
      FROM omopwave.condition_occurrence c
               INNER JOIN omopwave.drug_exposure d ON c.person_id = d.person_id) foo
WHERE foo.person_id = omopwave.drug_exposure.person_id;

UPDATE omopwave.drug_exposure
SET drug_exposure_end_date = drug_exposure_start_date + (days_supply * Interval '1 Day')
WHERE drug_exposure_end_date IS NOT NULL;


-- ============================================================================
-- CARDIAC MEASUREMENTS
-- ============================================================================

-- Troponin I (3020891) - Cardiac biomarker
INSERT INTO omopwave.measurement (measurement_id,
                                 person_id,
                                 measurement_concept_id,
                                 measurement_date,
                                 measurement_datetime,
                                 measurement_time,
                                 measurement_type_concept_id,
                                 operator_concept_id,
                                 value_as_number,
                                 value_as_concept_id,
                                 unit_concept_id,
                                 range_low,
                                 range_high,
                                 provider_id,
                                 visit_occurrence_id,
                                 visit_detail_id,
                                 measurement_source_value,
                                 measurement_source_concept_id,
                                 unit_source_value,
                                 unit_source_concept_id,
                                 value_source_value,
                                 measurement_event_id,
                                 meas_event_field_concept_id)
SELECT row_number() over (),
       (select (array(select person_id from omopwave.condition_occurrence WHERE condition_concept_id = 4329847))[floor(random() * 1500 * (i / i) + 1)]),
       3020891, -- Troponin I
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       32817,
       NULL,
       (select random() * 50 * (i / i)),  -- 0-50 ng/L range
       NULL,
       8837, -- nanogram per liter
       0,
       0.04,
       NULL,
       NULL,
       NULL,
       'TROPONIN_I',
       3020891,
       'ng/L',
       8837,
       NULL,
       NULL,
       NULL
FROM generate_series(1, 5000) s(i);

-- BNP - Brain Natriuretic Peptide (3024561)
INSERT INTO omopwave.measurement (measurement_id,
                                 person_id,
                                 measurement_concept_id,
                                 measurement_date,
                                 measurement_datetime,
                                 measurement_time,
                                 measurement_type_concept_id,
                                 operator_concept_id,
                                 value_as_number,
                                 value_as_concept_id,
                                 unit_concept_id,
                                 range_low,
                                 range_high,
                                 provider_id,
                                 visit_occurrence_id,
                                 visit_detail_id,
                                 measurement_source_value,
                                 measurement_source_concept_id,
                                 unit_source_value,
                                 unit_source_concept_id,
                                 value_source_value,
                                 measurement_event_id,
                                 meas_event_field_concept_id)
SELECT (row_number() over () + 5000),
       (select (array(select person_id from omopwave.condition_occurrence WHERE condition_concept_id = 316139))[floor(random() * 2000 * (i / i) + 1)]),
       3024561, -- BNP
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       32817,
       NULL,
       (select 50 + random() * 950 * (i / i)),  -- 50-1000 pg/mL range (elevated in CHF)
       NULL,
       8718, -- picogram per milliliter
       0,
       100,
       NULL,
       NULL,
       NULL,
       'BNP',
       3024561,
       'pg/mL',
       8718,
       NULL,
       NULL,
       NULL
FROM generate_series(1, 6000) s(i);

-- Heart Rate (3027018)
INSERT INTO omopwave.measurement (measurement_id,
                                 person_id,
                                 measurement_concept_id,
                                 measurement_date,
                                 measurement_datetime,
                                 measurement_time,
                                 measurement_type_concept_id,
                                 operator_concept_id,
                                 value_as_number,
                                 value_as_concept_id,
                                 unit_concept_id,
                                 range_low,
                                 range_high,
                                 provider_id,
                                 visit_occurrence_id,
                                 visit_detail_id,
                                 measurement_source_value,
                                 measurement_source_concept_id,
                                 unit_source_value,
                                 unit_source_concept_id,
                                 value_source_value,
                                 measurement_event_id,
                                 meas_event_field_concept_id)
SELECT (row_number() over () + 11000),
       (select (array(select person_id from omopwave.person))[floor(random() * 10000 * (i / i) + 1)]),
       3027018, -- Heart Rate
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       32817,
       NULL,
       (select 50 + random() * 70 * (i / i)),  -- 50-120 bpm
       NULL,
       8541, -- beats per minute
       60,
       100,
       NULL,
       NULL,
       NULL,
       'HR',
       3027018,
       'bpm',
       8541,
       NULL,
       NULL,
       NULL
FROM generate_series(1, 25000) s(i);

-- Systolic Blood Pressure (3004249)
INSERT INTO omopwave.measurement (measurement_id,
                                 person_id,
                                 measurement_concept_id,
                                 measurement_date,
                                 measurement_datetime,
                                 measurement_time,
                                 measurement_type_concept_id,
                                 operator_concept_id,
                                 value_as_number,
                                 value_as_concept_id,
                                 unit_concept_id,
                                 range_low,
                                 range_high,
                                 provider_id,
                                 visit_occurrence_id,
                                 visit_detail_id,
                                 measurement_source_value,
                                 measurement_source_concept_id,
                                 unit_source_value,
                                 unit_source_concept_id,
                                 value_source_value,
                                 measurement_event_id,
                                 meas_event_field_concept_id)
SELECT (row_number() over () + 36000),
       (select (array(select person_id from omopwave.person))[floor(random() * 10000 * (i / i) + 1)]),
       3004249, -- Systolic BP
       (select '2020-01-01 00:00:00'::timestamp +
               random() * (i / i) * ('2024-12-31 23:59:59'::timestamp -
                                     '2020-01-01 00:00:00'::timestamp))::date,
       NULL,
       NULL,
       32817,
       NULL,
       (select 100 + random() * 80 * (i / i)),  -- 100-180 mmHg
       NULL,
       8876, -- mmHg
       90,
       140,
       NULL,
       NULL,
       NULL,
       'SBP',
       3004249,
       'mmHg',
       8876,
       NULL,
       NULL,
       NULL
FROM generate_series(1, 25000) s(i);

-- Update measurement dates to be relative to condition onset
UPDATE omopwave.measurement
SET measurement_date = foo.condition_start_date +
                     floor(random() * 30 * (condition_occurrence_id / condition_occurrence_id) + 1) *
                     Interval '1 Day'
FROM (SELECT condition_occurrence_id, condition_start_date, c.person_id
      FROM omopwave.condition_occurrence c
               INNER JOIN omopwave.measurement m ON c.person_id = m.person_id) foo
WHERE foo.person_id = omopwave.measurement.person_id;



-- ============================================================================
-- WAVEFORM EXTENSION TABLES - DDL
-- ============================================================================
-- Drop existing waveform extension tables
DROP TABLE IF EXISTS omopwave.waveform_feature CASCADE;
DROP TABLE IF EXISTS omopwave.waveform_channel_metadata CASCADE;
DROP TABLE IF EXISTS omopwave.waveform_registry CASCADE;
DROP TABLE IF EXISTS omopwave.waveform_occurrence CASCADE;

-- waveform_occurrence table
CREATE TABLE omopwave.waveform_occurrence (
  waveform_occurrence_id INTEGER PRIMARY KEY,
  waveform_occurrence_concept_id INTEGER NOT NULL,
  person_id INTEGER NOT NULL,
  waveform_occurrence_start_datetime TIMESTAMP NOT NULL,
  waveform_occurrence_end_datetime TIMESTAMP NOT NULL,
  visit_occurrence_id INTEGER,
  visit_detail_id INTEGER,
  preceding_waveform_occurrence_id INTEGER,
  waveform_format_concept_id INTEGER,
  waveform_occurrence_source_value VARCHAR(255),
  num_of_files INTEGER,
  waveform_format_source_value VARCHAR(50),
  CONSTRAINT chk_wo_dates CHECK (waveform_occurrence_end_datetime >= waveform_occurrence_start_datetime)
);

-- waveform_registry table
CREATE TABLE omopwave.waveform_registry (
  waveform_registry_id INTEGER PRIMARY KEY,
  waveform_occurrence_id INTEGER NOT NULL,
  waveform_feature_id INTEGER,
  person_id INTEGER NOT NULL,
  waveform_file_start_datetime TIMESTAMP NOT NULL,
  waveform_file_end_datetime TIMESTAMP NOT NULL,
  visit_occurrence_id INTEGER,
  visit_detail_id INTEGER,
  file_extension_concept_id INTEGER,
  file_extension_source_value VARCHAR(50) NOT NULL,
  waveform_source_file_uri VARCHAR(500),
  waveform_target_file_uri VARCHAR(500) NOT NULL,
  CONSTRAINT fk_wr_occurrence FOREIGN KEY (waveform_occurrence_id) REFERENCES omopwave.waveform_occurrence(waveform_occurrence_id),
  CONSTRAINT chk_wr_dates CHECK (waveform_file_end_datetime >= waveform_file_start_datetime)
);

-- waveform_channel_metadata table
CREATE TABLE omopwave.waveform_channel_metadata (
  waveform_channel_metadata_id INTEGER PRIMARY KEY,
  waveform_registry_id INTEGER NOT NULL,
  procedure_occurrence_id INTEGER,
  device_exposure_id INTEGER,
  waveform_channel_source_value VARCHAR(100),
  channel_concept_id INTEGER NOT NULL,
  metadata_source_value VARCHAR(100) NOT NULL,
  metadata_concept_id INTEGER NOT NULL,
  value_as_number NUMERIC,
  value_as_concept_id INTEGER,
  value_as_string VARCHAR(255),
  unit_concept_id INTEGER,
  unit_source_value VARCHAR(50),
  CONSTRAINT fk_wcm_registry FOREIGN KEY (waveform_registry_id) REFERENCES omopwave.waveform_registry(waveform_registry_id)
);

-- waveform_feature table
CREATE TABLE omopwave.waveform_feature (
  waveform_feature_id INTEGER PRIMARY KEY,
  waveform_occurrence_id INTEGER NOT NULL,
  waveform_registry_id INTEGER NOT NULL,
  waveform_channel_metadata_id INTEGER NOT NULL,
  measurement_id INTEGER,
  observation_id INTEGER,
  algorithm_concept_id INTEGER NOT NULL,
  algorithm_source_value VARCHAR(255),
  anatomic_site_concept_id INTEGER,
  waveform_feature_start_timestamp TIME,
  waveform_feature_end_timestamp TIME,
  is_feature_overflow BOOLEAN,
  value_as_number NUMERIC,
  value_as_concept_id INTEGER,
  value_as_string VARCHAR(255),
  value_is_a_registry_file BOOLEAN,
  unit_concept_id INTEGER,
  unit_source_value VARCHAR(50),
  CONSTRAINT fk_wf_occurrence FOREIGN KEY (waveform_occurrence_id) REFERENCES omopwave.waveform_occurrence(waveform_occurrence_id),
  CONSTRAINT fk_wf_registry FOREIGN KEY (waveform_registry_id) REFERENCES omopwave.waveform_registry(waveform_registry_id),
  CONSTRAINT fk_wf_channel FOREIGN KEY (waveform_channel_metadata_id) REFERENCES omopwave.waveform_channel_metadata(waveform_channel_metadata_id)
);

-- ============================================================================
-- WAVEFORM EXTENSION DATA POPULATION
-- ============================================================================
-- Populate with synthetic 3-lead EKG data in WFDB format
-- ~7,000 EKG sessions linked to EKG procedures

-- 1. WAVEFORM_OCCURRENCE - EKG recording sessions
-- Link to the 7,000 EKG procedures created earlier
INSERT INTO omopwave.waveform_occurrence (
    waveform_occurrence_id,
    waveform_occurrence_concept_id,
    person_id,
    waveform_occurrence_start_datetime,
    waveform_occurrence_end_datetime,
    visit_occurrence_id,
    visit_detail_id,
    preceding_waveform_occurrence_id,
    waveform_format_concept_id,
    waveform_occurrence_source_value,
    num_of_files,
    waveform_format_source_value
)
SELECT
    procedure_occurrence_id AS waveform_occurrence_id,
    2082499974 AS waveform_occurrence_concept_id, -- "Diagnostic ECG"
    person_id,
    start_time AS waveform_occurrence_start_datetime,
    start_time + INTERVAL '10 seconds' AS waveform_occurrence_end_datetime,
    NULL AS visit_occurrence_id,
    NULL AS visit_detail_id,
    NULL AS preceding_waveform_occurrence_id,
    2082499975 AS waveform_format_concept_id, -- "WFDB"
    'EKG-' || procedure_occurrence_id AS waveform_occurrence_source_value,
    2 AS num_of_files, -- .hea and .dat files
    'WFDB' AS waveform_format_source_value
FROM (
    SELECT
        p.procedure_occurrence_id,
        p.person_id,
        (p.procedure_date || ' ' || LPAD(floor(random() * 24)::text, 2, '0') || ':' || LPAD(floor(random() * 60)::text, 2, '0') || ':00')::timestamp AS start_time
    FROM omopwave.procedure_occurrence p
    WHERE p.procedure_source_value = 'EKG'
) sub;

-- 2. WAVEFORM_REGISTRY - Individual WFDB files (.hea header and .dat data)
-- Create 2 files per occurrence: .hea (header) and .dat (data)

-- .hea header files
INSERT INTO omopwave.waveform_registry (
    waveform_registry_id,
    waveform_occurrence_id,
    waveform_feature_id,
    person_id,
    waveform_file_start_datetime,
    waveform_file_end_datetime,
    visit_occurrence_id,
    visit_detail_id,
    file_extension_concept_id,
    file_extension_source_value,
    waveform_source_file_uri,
    waveform_target_file_uri
)
SELECT
    (wo.waveform_occurrence_id * 2 - 1) AS waveform_registry_id,
    wo.waveform_occurrence_id,
    NULL AS waveform_feature_id,
    wo.person_id,
    wo.waveform_occurrence_start_datetime AS waveform_file_start_datetime,
    wo.waveform_occurrence_end_datetime AS waveform_file_end_datetime,
    wo.visit_occurrence_id,
    wo.visit_detail_id,
    2082499961 AS file_extension_concept_id, -- "HEA"
    '.hea' AS file_extension_source_value,
    '/source/ekg/patient_' || wo.person_id || '/ekg_' || wo.waveform_occurrence_id || '.hea' AS waveform_source_file_uri,
    's3://omop-waveforms/ekg/person_' || wo.person_id || '/record_' || wo.waveform_occurrence_id || '.hea' AS waveform_target_file_uri
FROM omopwave.waveform_occurrence wo;

-- .dat data files
INSERT INTO omopwave.waveform_registry (
    waveform_registry_id,
    waveform_occurrence_id,
    waveform_feature_id,
    person_id,
    waveform_file_start_datetime,
    waveform_file_end_datetime,
    visit_occurrence_id,
    visit_detail_id,
    file_extension_concept_id,
    file_extension_source_value,
    waveform_source_file_uri,
    waveform_target_file_uri
)
SELECT
    (wo.waveform_occurrence_id * 2) AS waveform_registry_id,
    wo.waveform_occurrence_id,
    NULL AS waveform_feature_id,
    wo.person_id,
    wo.waveform_occurrence_start_datetime AS waveform_file_start_datetime,
    wo.waveform_occurrence_end_datetime AS waveform_file_end_datetime,
    wo.visit_occurrence_id,
    wo.visit_detail_id,
    2082499965 AS file_extension_concept_id, -- "DAT"
    '.dat' AS file_extension_source_value,
    '/source/ekg/patient_' || wo.person_id || '/ekg_' || wo.waveform_occurrence_id || '.dat' AS waveform_source_file_uri,
    's3://omop-waveforms/ekg/person_' || wo.person_id || '/record_' || wo.waveform_occurrence_id || '.dat' AS waveform_target_file_uri
FROM omopwave.waveform_occurrence wo;

-- 3. WAVEFORM_CHANNEL_METADATA - Metadata for 3 ECG leads (I, II, III)
-- For each .dat file, create metadata for 3 channels (leads)

-- Create a temporary table to generate channel metadata
DROP TABLE IF EXISTS temp_channels;
CREATE TEMP TABLE temp_channels AS
SELECT
    wr.waveform_registry_id,
    wr.person_id,
    channel.lead_num,
    channel.channel_name,
    channel.channel_concept_id
FROM omopwave.waveform_registry wr
CROSS JOIN (
    VALUES
        (1, 'Lead I', 2082499990),
        (2, 'Lead II', 2082499966),
        (3, 'Lead III', 2082499947)
) AS channel(lead_num, channel_name, channel_concept_id)
WHERE wr.file_extension_source_value = '.dat';

-- Sampling rate metadata (500 Hz for all channels)
INSERT INTO omopwave.waveform_channel_metadata (
    waveform_channel_metadata_id,
    waveform_registry_id,
    procedure_occurrence_id,
    device_exposure_id,
    waveform_channel_source_value,
    channel_concept_id,
    metadata_source_value,
    metadata_concept_id,
    value_as_number,
    value_as_concept_id,
    value_as_string,
    unit_concept_id,
    unit_source_value
)
SELECT
    ((tc.waveform_registry_id * 10) + (tc.lead_num * 3) - 2) AS waveform_channel_metadata_id,
    tc.waveform_registry_id,
    NULL AS procedure_occurrence_id,
    NULL AS device_exposure_id,
    tc.channel_name AS waveform_channel_source_value,
    tc.channel_concept_id,
    'sampling_rate' AS metadata_source_value,
    2082499968 AS metadata_concept_id, -- "SAMPLERATE"
    500 AS value_as_number,
    NULL AS value_as_concept_id,
    NULL AS value_as_string,
    2082499972 AS unit_concept_id, -- sps (samples per second)
    'sps' AS unit_source_value
FROM temp_channels tc;

-- Gain/calibration factor metadata (varies by channel)
INSERT INTO omopwave.waveform_channel_metadata (
    waveform_channel_metadata_id,
    waveform_registry_id,
    procedure_occurrence_id,
    device_exposure_id,
    waveform_channel_source_value,
    channel_concept_id,
    metadata_source_value,
    metadata_concept_id,
    value_as_number,
    value_as_concept_id,
    value_as_string,
    unit_concept_id,
    unit_source_value
)
SELECT
    ((tc.waveform_registry_id * 10) + (tc.lead_num * 3) - 1) AS waveform_channel_metadata_id,
    tc.waveform_registry_id,
    NULL AS procedure_occurrence_id,
    NULL AS device_exposure_id,
    tc.channel_name AS waveform_channel_source_value,
    tc.channel_concept_id,
    'resolution' AS metadata_source_value,
    2082499969 AS metadata_concept_id, -- "RESOLUTION"
    200 AS value_as_number, -- 200 ADC units per mV
    NULL AS value_as_concept_id,
    NULL AS value_as_string,
    9484 AS unit_concept_id, -- ADU/mV
    'ADU/mV' AS unit_source_value
FROM temp_channels tc;

-- Signal quality metadata
INSERT INTO omopwave.waveform_channel_metadata (
    waveform_channel_metadata_id,
    waveform_registry_id,
    procedure_occurrence_id,
    device_exposure_id,
    waveform_channel_source_value,
    channel_concept_id,
    metadata_source_value,
    metadata_concept_id,
    value_as_number,
    value_as_concept_id,
    value_as_string,
    unit_concept_id,
    unit_source_value
)
SELECT
    ((tc.waveform_registry_id * 10) + (tc.lead_num * 3)) AS waveform_channel_metadata_id,
    tc.waveform_registry_id,
    NULL AS procedure_occurrence_id,
    NULL AS device_exposure_id,
    tc.channel_name AS waveform_channel_source_value,
    tc.channel_concept_id,
    'signal_quality' AS metadata_source_value,
    tc.channel_concept_id AS metadata_concept_id, -- Use channel concept as metadata type
    NULL AS value_as_number,
    CASE
        WHEN random() < 0.1 THEN 2082499971 -- "Low signal quality" for 10% of signals
        ELSE NULL -- Good quality (no specific concept needed)
    END AS value_as_concept_id,
    CASE
        WHEN random() < 0.1 THEN 'Low'
        ELSE 'Good'
    END AS value_as_string,
    NULL AS unit_concept_id,
    NULL AS unit_source_value
FROM temp_channels tc;

-- 4. WAVEFORM_FEATURE - Derived features from ECG signals
-- Focus on features relevant to AFib detection

-- Heart Rate feature (from all patients)
INSERT INTO omopwave.waveform_feature (
    waveform_feature_id,
    waveform_occurrence_id,
    waveform_registry_id,
    waveform_channel_metadata_id,
    measurement_id,
    observation_id,
    algorithm_concept_id,
    algorithm_source_value,
    anatomic_site_concept_id,
    waveform_feature_start_timestamp,
    waveform_feature_end_timestamp,
    is_feature_overflow,
    value_as_number,
    value_as_concept_id,
    value_as_string,
    value_is_a_registry_file,
    unit_concept_id,
    unit_source_value
)
SELECT
    wo.waveform_occurrence_id AS waveform_feature_id,
    wo.waveform_occurrence_id,
    (wo.waveform_occurrence_id * 2) AS waveform_registry_id, -- Link to .dat file
    ((wo.waveform_occurrence_id * 2 * 10) + (2 * 3) - 2) AS waveform_channel_metadata_id, -- Lead II sampling rate metadata
    NULL AS measurement_id,
    NULL AS observation_id,
    2082499946 AS algorithm_concept_id, -- "GE 12-lead ECG Measurements GE12SL"
    'Heart Rate from QRS Detection' AS algorithm_source_value,
    NULL AS anatomic_site_concept_id,
    '00:00:00'::TIME AS waveform_feature_start_timestamp,
    '00:00:10'::TIME AS waveform_feature_end_timestamp,
    FALSE AS is_feature_overflow,
    CASE
        -- AFib patients have higher, more variable heart rates
        WHEN EXISTS (SELECT 1 FROM omopwave.condition_occurrence co
                     WHERE co.person_id = wo.person_id AND co.condition_concept_id = 313217)
        THEN 70 + random() * 50  -- AFib: 70-120 bpm
        ELSE 60 + random() * 30  -- Normal: 60-90 bpm
    END AS value_as_number,
    NULL AS value_as_concept_id,
    NULL AS value_as_string,
    FALSE AS value_is_a_registry_file,
    8541 AS unit_concept_id, -- beats per minute
    'bpm' AS unit_source_value
FROM omopwave.waveform_occurrence wo;

-- RR Interval Irregularity Score - KEY FEATURE FOR AFIB DETECTION
-- This is the derived feature that distinguishes AFib patients
INSERT INTO omopwave.waveform_feature (
    waveform_feature_id,
    waveform_occurrence_id,
    waveform_registry_id,
    waveform_channel_metadata_id,
    measurement_id,
    observation_id,
    algorithm_concept_id,
    algorithm_source_value,
    anatomic_site_concept_id,
    waveform_feature_start_timestamp,
    waveform_feature_end_timestamp,
    is_feature_overflow,
    value_as_number,
    value_as_concept_id,
    value_as_string,
    value_is_a_registry_file,
    unit_concept_id,
    unit_source_value
)
SELECT
    (wo.waveform_occurrence_id + 10000) AS waveform_feature_id,
    wo.waveform_occurrence_id,
    (wo.waveform_occurrence_id * 2) AS waveform_registry_id, -- Link to .dat file
    ((wo.waveform_occurrence_id * 2 * 10) + (2 * 3) - 2) AS waveform_channel_metadata_id, -- Lead II
    NULL AS measurement_id,
    NULL AS observation_id,
    2082499949 AS algorithm_concept_id, -- "Phillips 12-lead ECG Measurements 09"
    'RR Interval Irregularity Score (SDNN)' AS algorithm_source_value,
    NULL AS anatomic_site_concept_id,
    '00:00:00'::TIME AS waveform_feature_start_timestamp,
    '00:00:10'::TIME AS waveform_feature_end_timestamp,
    FALSE AS is_feature_overflow,
    CASE
        -- AFib patients have HIGHLY irregular RR intervals (elevated SDNN)
        WHEN EXISTS (SELECT 1 FROM omopwave.condition_occurrence co
                     WHERE co.person_id = wo.person_id AND co.condition_concept_id = 313217)
        THEN 100 + random() * 150  -- AFib: 100-250 ms (highly irregular)
        ELSE 20 + random() * 60    -- Normal: 20-80 ms (regular)
    END AS value_as_number,
    NULL AS value_as_concept_id,
    NULL AS value_as_string,
    FALSE AS value_is_a_registry_file,
    8643 AS unit_concept_id, -- millisecond
    'ms' AS unit_source_value
FROM omopwave.waveform_occurrence wo;

-- QTc Interval (Bazett's formula) - Important for drug safety
INSERT INTO omopwave.waveform_feature (
    waveform_feature_id,
    waveform_occurrence_id,
    waveform_registry_id,
    waveform_channel_metadata_id,
    measurement_id,
    observation_id,
    algorithm_concept_id,
    algorithm_source_value,
    anatomic_site_concept_id,
    waveform_feature_start_timestamp,
    waveform_feature_end_timestamp,
    is_feature_overflow,
    value_as_number,
    value_as_concept_id,
    value_as_string,
    value_is_a_registry_file,
    unit_concept_id,
    unit_source_value
)
SELECT
    (wo.waveform_occurrence_id + 20000) AS waveform_feature_id,
    wo.waveform_occurrence_id,
    (wo.waveform_occurrence_id * 2) AS waveform_registry_id, -- Link to .dat file
    ((wo.waveform_occurrence_id * 2 * 10) + (2 * 3) - 2) AS waveform_channel_metadata_id, -- Lead II
    NULL AS measurement_id,
    NULL AS observation_id,
    2082499955 AS algorithm_concept_id, -- "Hewlett-Packard 12-lead ECG Interpretation ECL07"
    'QTc Interval (Bazett Formula)' AS algorithm_source_value,
    NULL AS anatomic_site_concept_id,
    '00:00:00'::TIME AS waveform_feature_start_timestamp,
    '00:00:10'::TIME AS waveform_feature_end_timestamp,
    FALSE AS is_feature_overflow,
    380 + random() * 80 AS value_as_number,  -- 380-460 ms (normal < 450 ms)
    NULL AS value_as_concept_id,
    NULL AS value_as_string,
    FALSE AS value_is_a_registry_file,
    8643 AS unit_concept_id, -- millisecond
    'ms' AS unit_source_value
FROM omopwave.waveform_occurrence wo;

-- Clean up temp table
DROP TABLE IF EXISTS temp_channels;

INSERT INTO omopwave.death(person_id,
                          death_date,
                          death_datetime,
                          death_type_concept_id,
                          cause_concept_id,
                          cause_source_value,
                          cause_source_concept_id)
SELECT (select (array(select person_id from omopwave.person))[floor(random() * 10000 * (i / i) + 1)]),
       now()::date,
       NULL,
       32817,
       40480476, --unknown cause
       (select substr(md5(i::text), 0, 15)),
       NULL
FROM generate_series(1, 5000) s(i);

DELETE
FROM omopwave.death a USING (
    SELECT MIN(ctid) as ctid,
           person_id
    FROM omopwave.death
    GROUP BY person_id
    HAVING COUNT(*) > 1
) b
WHERE (a.person_id = b.person_id)
  AND a.ctid <> b.ctid;

UPDATE omopwave.death
SET death_date = foo.condition_start_date +
                     floor(random() * 300 * (condition_occurrence_id / condition_occurrence_id) + 50) *
                     Interval '1 Day'
FROM (SELECT condition_occurrence_id, condition_start_date, c.person_id
      FROM omopwave.condition_occurrence c
               INNER JOIN omopwave.death p ON c.person_id = p.person_id) foo
WHERE foo.person_id = omopwave.death.person_id;

-- EVENT-BASED OBS PERIOD TRANSFORM

with measurement_dates as
         (
             SELECT person_id,
                    min(measurement_date) as measurement_least_value,
                    max(measurement_date) as measurement_greatest_value
             FROM omopwave.measurement
             group by person_id
         ),
     condition_dates as
         (
             SELECT person_id,
                    min(condition_start_date) as condition_least_start_value,
                    max(condition_end_date)   as condition_greatest_end_value,
                    max(condition_start_date) as condition_greatest_start_value
             FROM omopwave.condition_occurrence
             group by person_id
         ),
     observation_dates as
         (
             SELECT person_id,
                    min(observation_date) as observation_least_value,
                    max(observation_date) as observation_greatest_value
             FROM omopwave.observation
             group by person_id
         ),
     procedure_dates as
         (
             SELECT person_id,
                    min(procedure_date) as procedure_least_value,
                    max(procedure_date) as procedure_greatest_value
             FROM omopwave.procedure_occurrence
             group by person_id
         ),
     drug_dates as
         (
             SELECT person_id,
                    min(drug_exposure_start_date) as drug_least_value,
                    max(drug_exposure_end_date)   as drug_greatest_value
             FROM omopwave.drug_exposure
             group by person_id
         ),
     dev_dates as
         (
             SELECT person_id,
                    min(device_exposure_start_date) as dev_least_value,
                    max(device_exposure_end_date)   as dev_greatest_value
             FROM omopwave.device_exposure
             group by person_id
         ),
     spec_dates as
         (
             SELECT person_id,
                    min(specimen_date) as spec_least_value,
                    max(specimen_date) as spec_greatest_value
             FROM omopwave.specimen
             group by person_id
         ),
     death_dates as
         (
             SELECT person_id,
                    min(death_date) as death_least_value,
                    max(death_date) as death_greatest_value
             FROM omopwave.death
             group by person_id
         ),
     least_mes_date as
         (SELECT distinct s1.person_id,
                          LEAST(m.measurement_least_value, co.condition_least_start_value, o.observation_least_value,
                                po.procedure_least_value, dr.drug_least_value, de.dev_least_value, sp.spec_least_value,
                                d.death_least_value)       as least_value,
                          GREATEST(m.measurement_greatest_value, co.condition_greatest_start_value,
                                   co.condition_greatest_end_value,
                                   o.observation_greatest_value, po.procedure_greatest_value, dr.drug_greatest_value,
                                   de.dev_greatest_value, sp.spec_greatest_value,
                                   d.death_greatest_value) as greatest_value
          FROM omopwave.person s1
                   LEFT JOIN observation_dates o ON o.person_id = s1.person_id
                   LEFT JOIN condition_dates co ON co.person_id = s1.person_id
                   LEFT JOIN measurement_dates m ON m.person_id = s1.person_id
                   LEFT JOIN procedure_dates po ON po.person_id = s1.person_id
                   LEFT JOIN drug_dates dr ON dr.person_id = s1.person_id
                   LEFT JOIN dev_dates de ON de.person_id = s1.person_id
                   LEFT JOIN spec_dates sp ON sp.person_id = s1.person_id
                   LEFT JOIN death_dates d ON d.person_id = s1.person_id)

INSERT INTO omopwave.observation_period (person_id,
                                             observation_period_start_date,
                                             observation_period_end_date,
                                             period_type_concept_id)
SELECT p.person_id,
       MIN(ld.least_value)    as observation_period_start_date,
       MAX(ld.greatest_value) as observation_period_end_date,
       32880                  as period_type_concept_id
FROM omopwave.person p
         inner join least_mes_date ld on ld.person_id = p.person_id
where ld.least_value IS NOT NULL AND ld.greatest_value IS NOT NULL GROUP BY p.person_id;

CREATE INDEX idx_person_id ON omopwave.person (person_id ASC);
CLUSTER omopwave.person USING idx_person_id;
CREATE INDEX idx_gender ON omopwave.person (gender_concept_id ASC);

CREATE INDEX idx_observation_period_id_1 ON omopwave.observation_period (person_id ASC);
CLUSTER omopwave.observation_period USING idx_observation_period_id_1;

CREATE INDEX idx_visit_person_id_1 ON omopwave.visit_occurrence (person_id ASC);
CLUSTER omopwave.visit_occurrence USING idx_visit_person_id_1;
CREATE INDEX idx_visit_concept_id_1 ON omopwave.visit_occurrence (visit_concept_id ASC);

CREATE INDEX idx_visit_det_person_id_1 ON omopwave.visit_detail (person_id ASC);
CLUSTER omopwave.visit_detail USING idx_visit_det_person_id_1;
CREATE INDEX idx_visit_det_concept_id_1 ON omopwave.visit_detail (visit_detail_concept_id ASC);
CREATE INDEX idx_visit_det_occ_id ON omopwave.visit_detail (visit_occurrence_id ASC);

CREATE INDEX idx_condition_person_id_1 ON omopwave.condition_occurrence (person_id ASC);
CLUSTER omopwave.condition_occurrence USING idx_condition_person_id_1;
CREATE INDEX idx_condition_concept_id_1 ON omopwave.condition_occurrence (condition_concept_id ASC);
CREATE INDEX idx_condition_visit_id_1 ON omopwave.condition_occurrence (visit_occurrence_id ASC);

CREATE INDEX idx_drug_person_id_1 ON omopwave.drug_exposure (person_id ASC);
CLUSTER omopwave.drug_exposure USING idx_drug_person_id_1;
CREATE INDEX idx_drug_concept_id_1 ON omopwave.drug_exposure (drug_concept_id ASC);
CREATE INDEX idx_drug_visit_id_1 ON omopwave.drug_exposure (visit_occurrence_id ASC);

CREATE INDEX idx_procedure_person_id_1 ON omopwave.procedure_occurrence (person_id ASC);
CLUSTER omopwave.procedure_occurrence USING idx_procedure_person_id_1;
CREATE INDEX idx_procedure_concept_id_1 ON omopwave.procedure_occurrence (procedure_concept_id ASC);
CREATE INDEX idx_procedure_visit_id_1 ON omopwave.procedure_occurrence (visit_occurrence_id ASC);

CREATE INDEX idx_device_person_id_1 ON omopwave.device_exposure (person_id ASC);
CLUSTER omopwave.device_exposure USING idx_device_person_id_1;
CREATE INDEX idx_device_concept_id_1 ON omopwave.device_exposure (device_concept_id ASC);
CREATE INDEX idx_device_visit_id_1 ON omopwave.device_exposure (visit_occurrence_id ASC);

CREATE INDEX idx_measurement_person_id_1 ON omopwave.measurement (person_id ASC);
CLUSTER omopwave.measurement USING idx_measurement_person_id_1;
CREATE INDEX idx_measurement_concept_id_1 ON omopwave.measurement (measurement_concept_id ASC);
CREATE INDEX idx_measurement_visit_id_1 ON omopwave.measurement (visit_occurrence_id ASC);

CREATE INDEX idx_observation_person_id_1 ON omopwave.observation (person_id ASC);
CLUSTER omopwave.observation USING idx_observation_person_id_1;
CREATE INDEX idx_observation_concept_id_1 ON omopwave.observation (observation_concept_id ASC);
CREATE INDEX idx_observation_visit_id_1 ON omopwave.observation (visit_occurrence_id ASC);

CREATE INDEX idx_death_person_id_1 ON omopwave.death (person_id ASC);
CLUSTER omopwave.death USING idx_death_person_id_1;

CREATE INDEX idx_note_person_id_1 ON omopwave.note (person_id ASC);
CLUSTER omopwave.note USING idx_note_person_id_1;
CREATE INDEX idx_note_concept_id_1 ON omopwave.note (note_type_concept_id ASC);
CREATE INDEX idx_note_visit_id_1 ON omopwave.note (visit_occurrence_id ASC);

CREATE INDEX idx_note_nlp_note_id_1 ON omopwave.note_nlp (note_id ASC);
CLUSTER omopwave.note_nlp USING idx_note_nlp_note_id_1;
CREATE INDEX idx_note_nlp_concept_id_1 ON omopwave.note_nlp (note_nlp_concept_id ASC);

CREATE INDEX idx_fact_relationship_id1 ON omopwave.fact_relationship (domain_concept_id_1 ASC);
CREATE INDEX idx_fact_relationship_id2 ON omopwave.fact_relationship (domain_concept_id_2 ASC);
CREATE INDEX idx_fact_relationship_id3 ON omopwave.fact_relationship (relationship_concept_id ASC);


CREATE INDEX idx_location_id_1 ON omopwave.location (location_id ASC);
CLUSTER omopwave.location USING idx_location_id_1;

CREATE INDEX idx_care_site_id_1 ON omopwave.care_site (care_site_id ASC);
CLUSTER omopwave.care_site USING idx_care_site_id_1;

CREATE INDEX idx_provider_id_1 ON omopwave.provider (provider_id ASC);
CLUSTER omopwave.provider USING idx_provider_id_1;

CREATE INDEX idx_period_person_id_1 ON omopwave.payer_plan_period (person_id ASC);
CLUSTER omopwave.payer_plan_period USING idx_period_person_id_1;

CREATE INDEX idx_cost_event_id ON omopwave.cost (cost_event_id ASC);



CREATE INDEX idx_metadata_concept_id_1 ON omopwave.metadata (metadata_concept_id ASC);
CLUSTER omopwave.metadata USING idx_metadata_concept_id_1;

ALTER TABLE omopwave.PERSON
    ADD CONSTRAINT xpk_PERSON PRIMARY KEY (person_id);

ALTER TABLE omopwave.VISIT_OCCURRENCE
    ADD CONSTRAINT xpk_VISIT_OCCURRENCE PRIMARY KEY (visit_occurrence_id);

ALTER TABLE omopwave.VISIT_DETAIL
    ADD CONSTRAINT xpk_VISIT_DETAIL PRIMARY KEY (visit_detail_id);

ALTER TABLE omopwave.CONDITION_OCCURRENCE
    ADD CONSTRAINT xpk_CONDITION_OCCURRENCE PRIMARY KEY (condition_occurrence_id);

ALTER TABLE omopwave.DRUG_EXPOSURE
    ADD CONSTRAINT xpk_DRUG_EXPOSURE PRIMARY KEY (drug_exposure_id);

ALTER TABLE omopwave.PROCEDURE_OCCURRENCE
    ADD CONSTRAINT xpk_PROCEDURE_OCCURRENCE PRIMARY KEY (procedure_occurrence_id);

ALTER TABLE omopwave.DEVICE_EXPOSURE
    ADD CONSTRAINT xpk_DEVICE_EXPOSURE PRIMARY KEY (device_exposure_id);

ALTER TABLE omopwave.MEASUREMENT
    ADD CONSTRAINT xpk_MEASUREMENT PRIMARY KEY (measurement_id);

ALTER TABLE omopwave.OBSERVATION
    ADD CONSTRAINT xpk_OBSERVATION PRIMARY KEY (observation_id);

ALTER TABLE omopwave.NOTE
    ADD CONSTRAINT xpk_NOTE PRIMARY KEY (note_id);

ALTER TABLE omopwave.NOTE_NLP
    ADD CONSTRAINT xpk_NOTE_NLP PRIMARY KEY (note_nlp_id);

ALTER TABLE omopwave.LOCATION
    ADD CONSTRAINT xpk_LOCATION PRIMARY KEY (location_id);

ALTER TABLE omopwave.CARE_SITE
    ADD CONSTRAINT xpk_CARE_SITE PRIMARY KEY (care_site_id);

ALTER TABLE omopwave.PROVIDER
    ADD CONSTRAINT xpk_PROVIDER PRIMARY KEY (provider_id);

ALTER TABLE omopwave.PAYER_PLAN_PERIOD
    ADD CONSTRAINT xpk_PAYER_PLAN_PERIOD PRIMARY KEY (payer_plan_period_id);

ALTER TABLE omopwave.COST
    ADD CONSTRAINT xpk_COST PRIMARY KEY (cost_id);


-- Create indexes for waveform extension tables
CREATE INDEX idx_wo_person ON omopwave.waveform_occurrence(person_id);
CREATE INDEX idx_wo_visit ON omopwave.waveform_occurrence(visit_occurrence_id);
CREATE INDEX idx_wo_dates ON omopwave.waveform_occurrence(waveform_occurrence_start_datetime, waveform_occurrence_end_datetime);

CREATE INDEX idx_wr_occurrence ON omopwave.waveform_registry(waveform_occurrence_id);
CREATE INDEX idx_wr_person ON omopwave.waveform_registry(person_id);

CREATE INDEX idx_wcm_registry ON omopwave.waveform_channel_metadata(waveform_registry_id);
CREATE INDEX idx_wcm_channel ON omopwave.waveform_channel_metadata(channel_concept_id);

CREATE INDEX idx_wf_occurrence ON omopwave.waveform_feature(waveform_occurrence_id);
CREATE INDEX idx_wf_registry ON omopwave.waveform_feature(waveform_registry_id);
CREATE INDEX idx_wf_channel ON omopwave.waveform_feature(waveform_channel_metadata_id);



-- START THE ERA TABLE LOADING

DROP TABLE IF EXISTS cteDrugTarget;
/* / */
-- Normalize DRUG_EXPOSURE_END_DATE to either the existing drug exposure end date, or add days supply, or add 1 day to the start date
CREATE TEMP TABLE cteDrugTarget
AS
SELECT d.DRUG_EXPOSURE_ID
     , d.PERSON_ID
     , c.CONCEPT_ID
     , d.DRUG_TYPE_CONCEPT_ID
     , DRUG_EXPOSURE_START_DATE
     , COALESCE(DRUG_EXPOSURE_END_DATE, (DRUG_EXPOSURE_START_DATE + DAYS_SUPPLY * INTERVAL '1 day'),
                (DRUG_EXPOSURE_START_DATE + 1 * INTERVAL '1 day')) AS DRUG_EXPOSURE_END_DATE
     , c.CONCEPT_ID                                                AS INGREDIENT_CONCEPT_ID

FROM omopwave.DRUG_EXPOSURE d
         INNER JOIN omopwave.CONCEPT_ANCESTOR ca ON ca.DESCENDANT_CONCEPT_ID = d.DRUG_CONCEPT_ID
         INNER JOIN omopwave.CONCEPT c ON ca.ANCESTOR_CONCEPT_ID = c.CONCEPT_ID
WHERE c.VOCABULARY_ID = 'RxNorm'
  AND c.CONCEPT_CLASS_ID = 'Ingredient';


/* / */
DROP TABLE IF EXISTS cteEndDates;
/* / */
CREATE TEMP TABLE cteEndDates
AS
SELECT PERSON_ID
     , INGREDIENT_CONCEPT_ID
     , (EVENT_DATE + - 30 * INTERVAL '1 day') AS END_DATE -- unpad the end date

FROM (
         SELECT E1.PERSON_ID
              , E1.INGREDIENT_CONCEPT_ID
              , E1.EVENT_DATE
              , COALESCE(E1.START_ORDINAL, MAX(E2.START_ORDINAL)) START_ORDINAL
              , E1.OVERALL_ORD
         FROM (
                  SELECT PERSON_ID
                       , INGREDIENT_CONCEPT_ID
                       , EVENT_DATE
                       , EVENT_TYPE
                       , START_ORDINAL
                       , ROW_NUMBER() OVER (
                      PARTITION BY PERSON_ID
                          ,INGREDIENT_CONCEPT_ID ORDER BY EVENT_DATE
                          ,EVENT_TYPE
                      ) AS OVERALL_ORD -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
                  FROM (
                           -- select the start dates, assigning a row number to each
                           SELECT PERSON_ID
                                , INGREDIENT_CONCEPT_ID
                                , DRUG_EXPOSURE_START_DATE AS EVENT_DATE
                                , 0                        AS EVENT_TYPE
                                , ROW_NUMBER() OVER (
                               PARTITION BY PERSON_ID
                                   ,INGREDIENT_CONCEPT_ID ORDER BY DRUG_EXPOSURE_START_DATE
                               )                           AS START_ORDINAL
                           FROM cteDrugTarget
                           UNION ALL
                           -- add the end dates with NULL as the row number, padding the end dates by 30 to allow a grace period for overlapping ranges.
                           SELECT PERSON_ID
                                , INGREDIENT_CONCEPT_ID
                                , (DRUG_EXPOSURE_END_DATE + 30 * INTERVAL '1 day')
                                , 1 AS EVENT_TYPE
                                , NULL
                           FROM cteDrugTarget
                       ) RAWDATA
              ) E1
                  INNER JOIN (
             SELECT PERSON_ID
                  , INGREDIENT_CONCEPT_ID
                  , DRUG_EXPOSURE_START_DATE AS EVENT_DATE
                  , ROW_NUMBER() OVER (
                 PARTITION BY PERSON_ID
                     ,INGREDIENT_CONCEPT_ID ORDER BY DRUG_EXPOSURE_START_DATE
                 )                           AS START_ORDINAL
             FROM cteDrugTarget
         ) E2 ON E1.PERSON_ID = E2.PERSON_ID
             AND E1.INGREDIENT_CONCEPT_ID = E2.INGREDIENT_CONCEPT_ID
             AND E2.EVENT_DATE <= E1.EVENT_DATE
         GROUP BY E1.PERSON_ID
                , E1.INGREDIENT_CONCEPT_ID
                , E1.EVENT_DATE
                , E1.START_ORDINAL
                , E1.OVERALL_ORD
     ) E
WHERE 2 * E.START_ORDINAL - E.OVERALL_ORD = 0;
/* / */
DROP TABLE IF EXISTS cteDrugExpEnds;
/* / */
CREATE TEMP TABLE cteDrugExpEnds
AS
SELECT d.PERSON_ID
     , d.INGREDIENT_CONCEPT_ID
     , d.DRUG_TYPE_CONCEPT_ID
     , d.DRUG_EXPOSURE_START_DATE
     , MIN(e.END_DATE) AS ERA_END_DATE

FROM cteDrugTarget d
         INNER JOIN cteEndDates e ON d.PERSON_ID = e.PERSON_ID
    AND d.INGREDIENT_CONCEPT_ID = e.INGREDIENT_CONCEPT_ID
    AND e.END_DATE >= d.DRUG_EXPOSURE_START_DATE
GROUP BY d.PERSON_ID
       , d.INGREDIENT_CONCEPT_ID
       , d.DRUG_TYPE_CONCEPT_ID
       , d.DRUG_EXPOSURE_START_DATE;
/* / */
INSERT INTO omopwave.drug_era
SELECT row_number() OVER (
    ORDER BY person_id
    )                                AS drug_era_id
     , person_id
     , INGREDIENT_CONCEPT_ID
     , min(DRUG_EXPOSURE_START_DATE) AS drug_era_start_date
     , ERA_END_DATE
     , COUNT(*)                      AS DRUG_EXPOSURE_COUNT
     , 30                            AS gap_days
FROM cteDrugExpEnds
GROUP BY person_id
       , INGREDIENT_CONCEPT_ID
       , drug_type_concept_id
       , ERA_END_DATE;
/****
CONDITION ERA
Note: Eras derived from CONDITION_OCCURRENCE table, using 30d gap
 ****/
DROP TABLE IF EXISTS condition_era_phase_1;
/* / */
DROP TABLE IF EXISTS cteConditionTarget;
/* / */
-- create base eras from the concepts found in condition_occurrence
CREATE TEMP TABLE cteConditionTarget
AS
SELECT co.PERSON_ID
     , co.condition_concept_id
     , co.CONDITION_START_DATE
     , COALESCE(co.CONDITION_END_DATE, (CONDITION_START_DATE + 1 * INTERVAL '1 day')) AS CONDITION_END_DATE

FROM omopwave.CONDITION_OCCURRENCE co
WHERE co.CONDITION_CONCEPT_ID != 0;
/* / */
DROP TABLE IF EXISTS cteCondEndDates;
/* / */
CREATE TEMP TABLE cteCondEndDates
AS
SELECT PERSON_ID
     , CONDITION_CONCEPT_ID
     , (EVENT_DATE + - 30 * INTERVAL '1 day') AS END_DATE -- unpad the end date

FROM (
         SELECT E1.PERSON_ID
              , E1.CONDITION_CONCEPT_ID
              , E1.EVENT_DATE
              , COALESCE(E1.START_ORDINAL, MAX(E2.START_ORDINAL)) START_ORDINAL
              , E1.OVERALL_ORD
         FROM (
                  SELECT PERSON_ID
                       , CONDITION_CONCEPT_ID
                       , EVENT_DATE
                       , EVENT_TYPE
                       , START_ORDINAL
                       , ROW_NUMBER() OVER (
                      PARTITION BY PERSON_ID
                          ,CONDITION_CONCEPT_ID ORDER BY EVENT_DATE
                          ,EVENT_TYPE
                      ) AS OVERALL_ORD -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
                  FROM (
                           -- select the start dates, assigning a row number to each
                           SELECT PERSON_ID
                                , CONDITION_CONCEPT_ID
                                , CONDITION_START_DATE AS EVENT_DATE
                                , - 1                  AS EVENT_TYPE
                                , ROW_NUMBER() OVER (
                               PARTITION BY PERSON_ID
                                   ,CONDITION_CONCEPT_ID ORDER BY CONDITION_START_DATE
                               )                       AS START_ORDINAL
                           FROM cteConditionTarget
                           UNION ALL
                           -- pad the end dates by 30 to allow a grace period for overlapping ranges.
                           SELECT PERSON_ID
                                , CONDITION_CONCEPT_ID
                                , (CONDITION_END_DATE + 30 * INTERVAL '1 day')
                                , 1 AS EVENT_TYPE
                                , NULL
                           FROM cteConditionTarget
                       ) RAWDATA
              ) E1
                  INNER JOIN (
             SELECT PERSON_ID
                  , CONDITION_CONCEPT_ID
                  , CONDITION_START_DATE AS EVENT_DATE
                  , ROW_NUMBER() OVER (
                 PARTITION BY PERSON_ID
                     ,CONDITION_CONCEPT_ID ORDER BY CONDITION_START_DATE
                 )                       AS START_ORDINAL
             FROM cteConditionTarget
         ) E2 ON E1.PERSON_ID = E2.PERSON_ID
             AND E1.CONDITION_CONCEPT_ID = E2.CONDITION_CONCEPT_ID
             AND E2.EVENT_DATE <= E1.EVENT_DATE
         GROUP BY E1.PERSON_ID
                , E1.CONDITION_CONCEPT_ID
                , E1.EVENT_DATE
                , E1.START_ORDINAL
                , E1.OVERALL_ORD
     ) E
WHERE (2 * E.START_ORDINAL) - E.OVERALL_ORD = 0;
/* / */
DROP TABLE IF EXISTS cteConditionEnds;
/* / */
CREATE TEMP TABLE cteConditionEnds
AS
SELECT c.PERSON_ID
     , c.CONDITION_CONCEPT_ID
     , c.CONDITION_START_DATE
     , MIN(e.END_DATE) AS ERA_END_DATE

FROM cteConditionTarget c
         INNER JOIN cteCondEndDates e ON c.PERSON_ID = e.PERSON_ID
    AND c.CONDITION_CONCEPT_ID = e.CONDITION_CONCEPT_ID
    AND e.END_DATE >= c.CONDITION_START_DATE
GROUP BY c.PERSON_ID
       , c.CONDITION_CONCEPT_ID
       , c.CONDITION_START_DATE;
/* / */
INSERT INTO omopwave.condition_era ( condition_era_id
                                  , person_id
                                  , condition_concept_id
                                  , condition_era_start_date
                                  , condition_era_end_date
                                  , condition_occurrence_count)
SELECT row_number() OVER (
    ORDER BY person_id
    )                            AS condition_era_id
     , person_id
     , CONDITION_CONCEPT_ID
     , min(CONDITION_START_DATE) AS CONDITION_ERA_START_DATE
     , ERA_END_DATE              AS CONDITION_ERA_END_DATE
     , COUNT(*)                  AS CONDITION_OCCURRENCE_COUNT
FROM cteConditionEnds
GROUP BY person_id
       , CONDITION_CONCEPT_ID
       , ERA_END_DATE;

CREATE INDEX idx_drug_era_person_id_1 ON omopwave.drug_era (person_id ASC);
CLUSTER omopwave.drug_era USING idx_drug_era_person_id_1;
CREATE INDEX idx_drug_era_concept_id_1 ON omopwave.drug_era (drug_concept_id ASC);

CREATE INDEX idx_dose_era_person_id_1 ON omopwave.dose_era (person_id ASC);
CLUSTER omopwave.dose_era USING idx_dose_era_person_id_1;
CREATE INDEX idx_dose_era_concept_id_1 ON omopwave.dose_era (drug_concept_id ASC);

CREATE INDEX idx_condition_era_person_id_1 ON omopwave.condition_era (person_id ASC);
CLUSTER omopwave.condition_era USING idx_condition_era_person_id_1;
CREATE INDEX idx_condition_era_concept_id_1 ON omopwave.condition_era (condition_concept_id ASC);

ALTER TABLE omopwave.DRUG_ERA
    ADD CONSTRAINT xpk_DRUG_ERA PRIMARY KEY (drug_era_id);

ALTER TABLE omopwave.DOSE_ERA
    ADD CONSTRAINT xpk_DOSE_ERA PRIMARY KEY (dose_era_id);

ALTER TABLE omopwave.CONDITION_ERA
    ADD CONSTRAINT xpk_CONDITION_ERA PRIMARY KEY (condition_era_id);

-- ============================================================================
-- CDM SOURCE METADATA
-- ============================================================================
INSERT INTO omopwave.cdm_source(cdm_source_name,
                               cdm_source_abbreviation,
                               cdm_holder,
                               source_description,
                               source_documentation_reference,
                               cdm_etl_reference,
                               source_release_date,
                               cdm_release_date,
                               cdm_version,
                               cdm_version_concept_id,
                               vocabulary_version)
VALUES ('Waveform WG Cardiac Synthetic Dataset with EKG Waveforms',
        'Wave Cardiac',
        'Waveform WG',
        'Synthetic cardiac dataset with 10,000 patients including ~3,000 with Atrial Fibrillation. Includes 3-lead EKG waveforms in WFDB format with derived features.',
        'https://github.com/OHDSI/WaveformWG',
        'https://github.com/OHDSI/WaveformWG',
        now(),
        now(),
        'v5.4',
        756265,
        'v5');



/*
SYNTHETIC CARDIAC DATASET WITH WAVEFORM EXTENSION

Created: 2025
Purpose: Demonstrate cohort creation and patient-level prediction using waveform-derived features

DATASET OVERVIEW:
-----------------
- Total Patients: 10,000
- Patients with Atrial Fibrillation: ~3,000 (target condition)
- EKG Procedures: ~7,000
- Waveform Files: ~14,000 (7,000 .hea headers + 7,000 .dat data files)
- Waveform-Derived Features: ~21,000 (Heart Rate, RR Irregularity, QTc)

KEY TABLES:
-----------
Core OMOP CDM Tables:
  - PERSON: 10,000 synthetic patients
  - CONDITION_OCCURRENCE: Cardiac conditions (AFib, MI, CHF, HTN, CAD)
  - DRUG_EXPOSURE: Cardiac medications (Warfarin, Metoprolol, Lisinopril, Furosemide, Atorvastatin)
  - MEASUREMENT: Cardiac biomarkers (Troponin I, BNP, Heart Rate, Blood Pressure)
  - PROCEDURE_OCCURRENCE: Cardiac procedures (EKG, Echo, Cardiac Cath, Stress Test)

Waveform Extension Tables:
  - WAVEFORM_OCCURRENCE: ~7,000 EKG recording sessions
  - WAVEFORM_REGISTRY: ~14,000 WFDB files (.hea and .dat)
  - WAVEFORM_CHANNEL_METADATA: ~63,000 metadata records (3 leads × 3 metadata types × 7,000 files)
  - WAVEFORM_FEATURE: ~21,000 derived features (3 feature types × 7,000 sessions)

TARGET COHORT:
--------------
- Condition: Atrial Fibrillation (concept_id: 313217)
- Patients: First 3,000 patients in PERSON table
- Key Feature: RR Interval Irregularity Score (SDNN)
  * AFib patients: 100-250 ms (highly irregular)
  * Non-AFib patients: 20-80 ms (regular)

WAVEFORM DATA SPECIFICATIONS:
------------------------------
- Format: WFDB (Waveform Database format)
- Leads: 3-lead ECG (Lead I, Lead II, Lead III)
- Sampling Rate: 500 Hz
- Recording Duration: 10 seconds per session
- Gain: 200 ADC units per mV
- Signal Quality: 90% high quality, 10% acceptable quality

DERIVED FEATURES:
-----------------
1. Heart Rate (concept_id: 2082499946)
   - Algorithm: GE 12-lead ECG Measurements GE12SL (QRS Detection)
   - AFib patients: 70-120 bpm (elevated, variable)
   - Non-AFib patients: 60-90 bpm (normal)

2. RR Interval Irregularity Score (concept_id: 2082499949) ** KEY FEATURE **
   - Algorithm: Phillips 12-lead ECG Measurements 09 (SDNN)
   - AFib patients: 100-250 ms (highly irregular - DISCRIMINATIVE)
   - Non-AFib patients: 20-80 ms (regular)
   - This feature can be used as a covariate in patient-level prediction models

3. QTc Interval (concept_id: 2082499955)
   - Algorithm: Hewlett-Packard 12-lead ECG Interpretation ECL07 (Bazett Formula)
   - All patients: 380-460 ms (normal < 450 ms)
   - Important for drug safety monitoring

EXAMPLE USE CASES:
------------------

1. COHORT CREATION - Identify AFib patients with EKG data:

   SELECT DISTINCT p.person_id, p.gender_source_value, p.year_of_birth,
          co.condition_start_date,
          COUNT(DISTINCT wo.waveform_occurrence_id) as ekg_count
   FROM omopwave.person p
   INNER JOIN omopwave.condition_occurrence co ON p.person_id = co.person_id
   INNER JOIN omopwave.waveform_occurrence wo ON p.person_id = wo.person_id
   WHERE co.condition_concept_id = 313217 -- Atrial Fibrillation
   GROUP BY p.person_id, p.gender_source_value, p.year_of_birth, co.condition_start_date;

2. EXTRACT WAVEFORM FEATURES AS COVARIATES - Get RR Irregularity for prediction:

   SELECT p.person_id,
          co.condition_concept_id,
          wf.algorithm_source_value,
          AVG(wf.value_as_number) as avg_rr_irregularity_ms,
          STDDEV(wf.value_as_number) as std_rr_irregularity_ms
   FROM omopwave.person p
   INNER JOIN omopwave.waveform_occurrence wo ON p.person_id = wo.person_id
   INNER JOIN omopwave.waveform_feature wf ON wo.waveform_occurrence_id = wf.waveform_occurrence_id
   LEFT JOIN omopwave.condition_occurrence co ON p.person_id = co.person_id
   WHERE wf.algorithm_concept_id = 2082499949 -- RR Interval Irregularity (Phillips 09)
   GROUP BY p.person_id, co.condition_concept_id, wf.algorithm_source_value
   ORDER BY avg_rr_irregularity_ms DESC;

3. PATIENT-LEVEL PREDICTION PIPELINE - Features for AFib prediction:

   -- Create features for baseline covariates
   WITH patient_demographics AS (
     SELECT person_id,
            EXTRACT(YEAR FROM CURRENT_DATE) - year_of_birth as age,
            CASE WHEN gender_concept_id = 8507 THEN 1 ELSE 0 END as is_male
     FROM omopwave.person
   ),
   waveform_features AS (
     SELECT wo.person_id,
            MAX(CASE WHEN wf.algorithm_concept_id = 2082499949
                THEN wf.value_as_number END) as rr_irregularity_ms,
            MAX(CASE WHEN wf.algorithm_concept_id = 2082499946
                THEN wf.value_as_number END) as heart_rate_bpm,
            MAX(CASE WHEN wf.algorithm_concept_id = 2082499955
                THEN wf.value_as_number END) as qtc_ms
     FROM omopwave.waveform_occurrence wo
     INNER JOIN omopwave.waveform_feature wf ON wo.waveform_occurrence_id = wf.waveform_occurrence_id
     GROUP BY wo.person_id
   ),
   outcomes AS (
     SELECT person_id, 1 as has_afib
     FROM omopwave.condition_occurrence
     WHERE condition_concept_id = 313217
   )
   SELECT pd.person_id,
          pd.age,
          pd.is_male,
          COALESCE(wf.rr_irregularity_ms, 0) as rr_irregularity_ms,
          COALESCE(wf.heart_rate_bpm, 0) as heart_rate_bpm,
          COALESCE(wf.qtc_ms, 0) as qtc_ms,
          COALESCE(o.has_afib, 0) as outcome_afib
   FROM patient_demographics pd
   LEFT JOIN waveform_features wf ON pd.person_id = wf.person_id
   LEFT JOIN outcomes o ON pd.person_id = o.person_id;

4. COHORT WITH DRUG EXPOSURE - AFib patients on anticoagulation:

   SELECT p.person_id,
          co.condition_start_date as afib_onset,
          de.drug_exposure_start_date as warfarin_start,
          AVG(wf.value_as_number) as avg_rr_irregularity
   FROM omopwave.person p
   INNER JOIN omopwave.condition_occurrence co ON p.person_id = co.person_id
   INNER JOIN omopwave.drug_exposure de ON p.person_id = de.person_id
   INNER JOIN omopwave.waveform_occurrence wo ON p.person_id = wo.person_id
   INNER JOIN omopwave.waveform_feature wf ON wo.waveform_occurrence_id = wf.waveform_occurrence_id
   WHERE co.condition_concept_id = 313217 -- AFib
     AND de.drug_concept_id = 1310149 -- Warfarin
     AND wf.algorithm_concept_id = 2082499949 -- RR Irregularity (Phillips 09)
   GROUP BY p.person_id, co.condition_start_date, de.drug_exposure_start_date
   ORDER BY avg_rr_irregularity DESC;

EXPECTED RESULTS:
-----------------
When using RR Interval Irregularity as a covariate:
- AFib patients should have significantly higher RR irregularity scores (100-250 ms)
- Non-AFib patients should have lower RR irregularity scores (20-80 ms)
- This creates a clear discriminative feature for patient-level prediction models
- Expected AUC for AFib prediction using RR irregularity: > 0.90

INTEGRATION WITH OHDSI TOOLS:
------------------------------
This dataset can be used with:
- ATLAS: For cohort creation and characterization
- PatientLevelPrediction: Extract waveform features as custom covariates
- FeatureExtraction: Create aggregate features from waveform data
- CohortMethod: Compare outcomes in patients with different waveform characteristics

NOTES:
------
- Waveform-specific concept_ids (208xxxxx) are from the WAVEFORM vocabulary
- Standard OMOP concept_ids (313217 for AFib, 1310149 for Warfarin, etc.) are from OMOP vocabularies
- File URIs (s3://...) are synthetic and point to non-existent locations
- For real implementation, replace with actual waveform file storage locations
- The dataset demonstrates the capability to link waveform-derived features
  to standard OMOP CDM tables for comprehensive patient-level analysis
- Waveform concepts include:
  * File formats: WFDB (2082499975), HEA (2082499961), DAT (2082499965)
  * ECG Leads: I (2082499990), II (2082499966), III (2082499947)
  * Algorithms: GE12SL (2082499946), Phillips 09 (2082499949), HP ECL07 (2082499955)
  * Metadata: SAMPLERATE (2082499968), RESOLUTION (2082499969)
  * Quality: Low signal quality (2082499971)

For questions or issues, visit: https://github.com/OHDSI/WaveformWG
*/
