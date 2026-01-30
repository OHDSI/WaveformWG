CREATE VIEW omopwave.concept AS
    (SELECT * FROM vocabulary.concept
     UNION
     SELECT * FROM omopwave.concept_wave);

CREATE VIEW omopwave.concept_relationship AS
    (SELECT * FROM vocabulary.concept_relationship
     UNION
     SELECT * FROM omopwave.concept_relationship_wave);

CREATE VIEW omopwave.concept_ancestor AS
    (SELECT * FROM vocabulary.concept_ancestor
     UNION
     SELECT * FROM omopwave.concept_ancestor_wave);

CREATE VIEW omopwave.concept_class AS
    (SELECT * FROM vocabulary.concept_class
     UNION
     SELECT * FROM omopwave.concept_class_wave);

CREATE VIEW omopwave.concept_recommended AS
    (SELECT * FROM vocabulary.concept_recommended
     UNION
     SELECT * FROM omopwave.concept_recommended_wave);

CREATE VIEW omopwave.concept_synonym AS
    (SELECT * FROM vocabulary.concept_synonym
     UNION
     SELECT * FROM omopwave.concept_synonym_wave);

CREATE VIEW omopwave.domain AS
    (SELECT * FROM vocabulary.domain
     UNION
     SELECT * FROM omopwave.domain_wave);

CREATE VIEW omopwave.drug_strength AS
    (SELECT * FROM vocabulary.drug_strength
     UNION
     SELECT * FROM omopwave.drug_strength_wave);

CREATE VIEW omopwave.relationship AS
    (SELECT * FROM vocabulary.relationship
     UNION
     SELECT * FROM omopwave.relationship_wave);

CREATE VIEW omopwave.source_to_concept_map AS
    (SELECT * FROM vocabulary.source_to_concept_map
     UNION
     SELECT * FROM omopwave.source_to_concept_map_wave);

CREATE VIEW omopwave.vocabulary AS
    (SELECT * FROM vocabulary.vocabulary
     UNION
     SELECT * FROM omopwave.vocabulary_wave);