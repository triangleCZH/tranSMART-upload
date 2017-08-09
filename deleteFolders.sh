if [ $# -ne 1 ]
then
  echo "Please enter one argument, the study_name to delete" 
  exit 1
fi


cd ~/transmart/transmart-data/samples/studies
rm -rf $1
echo "$1 folder deleted"
rm -rf Platform$1
echo "Platform$1 deleted"
cd ~/transmart/transmart-data/samples/common/
rm -rf $1
echo "common/$1 folder deleted"
