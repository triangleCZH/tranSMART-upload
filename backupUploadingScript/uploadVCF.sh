if [ $# -ne 1 ]
then
  echo "You should have one argument, which is the name of the study folder"
  exit 1
fi
#to set KETTLE_PSQL_JOBS
cd /home/transmart/transmart/transmart-data/
. ./vars
make -C samples/postgres load_VCF_$1 >> /dev/null 2>&1
#start uploading
cd samples/common/$1
. ./vcf.params
cd ../../../
make -C samples/postgres load_vcf
