\c transmart
truncate deapp.de_variant_dataset cascade;
delete from i2b2demodata.concept_dimension;
delete from i2b2demodata.concept_counts;
delete from I2B2DEMODATA.PATIENT_DIMENSION;
delete from i2b2demodata.observation_fact;
delete from i2b2metadata.i2b2;
delete from I2B2METADATA.I2B2_SECURE;
delete from i2b2metadata.table_access;
delete from deapp.de_subject_sample_mapping;
delete from deapp.de_subject_microarray_data;
delete from deapp.de_gpl_info;
delete from deapp.de_mrna_annotation;
\q
