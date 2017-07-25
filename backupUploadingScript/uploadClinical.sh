if [ $# -ne 1 ]
then
  echo "You should have one argument, which is the name of the study folder"
  exit 1
fi
cd /home/transmart/transmart/transmart-data/
. ./vars
make -C samples/postgres load_clinical_$1
