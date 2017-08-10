\c transmart
delete from deapp.de_variant_subject_detail where dataset_id='myvcf';
delete from deapp.de_variant_subject_summary where dataset_id='myvcf';
delete from deapp.de_variant_subject_idx where dataset_id='myvcf';
delete from deapp.de_variant_population_data where dataset_id='myvcf';
delete from deapp.de_variant_population_info where dataset_id='myvcf';
delete from deapp.de_variant_metadata where dataset_id='myvcf';
delete from deapp.de_variant_dataset where dataset_id='myvcf';
delete from deapp.de_subject_sample_mapping where trial_name='myvcf';
delete from i2b2demodata.observation_fact where sourcesystem_cd like 'myvcf:%'
\q
