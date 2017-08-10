\c transmart
delete from I2B2METADATA.I2B2 where c_fullname = '\Public Studies\CGDB\myGene\Variant\Variant\';
delete from I2B2METADATA.I2B2_SECURE where c_fullname = '\Public Studies\CGDB\myGene\Variant\Variant\';
delete from I2B2DEMODATA.CONCEPT_DIMENSION where concept_path = '\Public Studies\CGDB\myGene\Variant\Variant\';
delete from deapp.de_subject_sample_mapping where trial_name='MYGENE';
delete from deapp.de_subject_microarray_data where trial_name = 'MYGENE';
delete from deapp.de_gpl_info where platform = 'PlatformmyGene';
delete from deapp.de_mrna_annotation where gpl_id = 'PlatformmyGene';
\q
