\c transmart
delete from i2b2demodata.concept_dimension where sourcesystem_cd = 'MYCLINICAL';
delete from i2b2demodata.concept_counts where concept_path like '%\\myclinical\\%';
delete from i2b2metadata.i2b2 where c_fullname like '%\\myclinical\\%';
delete from i2b2demodata.patient_dimension where sourcesystem_cd like 'MYCLINICAL:%';
delete from i2b2demodata.observation_fact where sourcesystem_cd like 'MYCLINICAL';
delete from i2b2metadata.i2b2_secure where c_fullname like '%\\myclinical\\%';
\q
