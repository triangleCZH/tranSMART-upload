scripts in ~ directory for starting:
sh runAll.sh:	 	 to run Rserve, Solr and tomcat (execute runXXX.sh to run one of the three individually)
sh checksError.sh:	 to check the running process, checks.log presented in home directory
sh checkRun.sh:		 to check if the requried tools are running
visit transmart by http://localhost:8080/transmart/

scripts in ~ directory for uploading:
./buildStudy.sh:	 generate the dataset folder in the studies/ , then please enter the position and manually edit the mapping file 
./uploadClinical.sh:	 upload the study to transmart
./buildVCF.sh:		 generate the folder for vcf in studies/, will enter the folder if already exists
./uploadVCF.sh:		 upload the vcf file to transmart, please note that uploadClinical.sh must be executed before vcf is uploaded
INSTRUCTIONS:
After scp the files from cgdb, first buildStudy and modify MYSTUDY_column.txt and clinical.params, then uploadClinical.
After clinical uplaoded, buildVCF and modify subject-sample-mapping file and vcf.params, then uploadVCF.

username and passwords
the virtual machine: username = password = transmart
postgresql: username = password = postgres (if necessary)
transmart: username = password = admin

Directory explanation:
in ~/transmart/transmart-data/samples:
studies/ stores all the dataset files
common/ stores the load scripts
postgres/ stores the load scripts (as transmart is based on postgresql, oracle/ will not be involved)

Usually we will work in ~/transmart/transmart-data/
With the following commands in this directory, enter postgresql:
. ./vars
$PGSQL_BIN\psql postgres

TODO: more information in https://wiki.transmartfoundation.org/
# tranSMART-upload
