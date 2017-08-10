########The sample.txt should be put in transmart-data/samples/studies folder
#check number of arguments
if [ $# -ne 2 ]
then
  echo "please enter two arguments: NO.1 to use as the study name NO.2 to specify the sample txt file name"
  exit 1
fi

#delete the study and the mutation if they exist
echo "#############################################"
echo "# Delete the study $1 and mutation if exist #"
echo "#############################################"
./deleteGENEDB.sh $1


#check if sample and parsed vcf data file exist
if [ ! -f $2 ]
then
  echo "the file $2 does not exist, please make sure is is in transmart-batch/studies"
  #exit 1
elif [ ${2: -4} != ".txt" ]
then
  echo "the file $2 needs to be .txt, please check the file format"
  #exit 1
elif [ -d $2 ]
then
  echo "$2 needs to be a file, not a directory"
  #exit 1
fi
cp $2 /home/transmart/transmart/transmart-data/samples/studies/$1_Clinical_Data.txt

cd /home/transmart/transmart/transmart-data/samples/studies/
#check folder name existence
if [ -e $1 ]
then
  #echo "the chosen folder name $1 already exist for a file/folder, please get another name"
  echo "the chosen folder name $1 already exist, delete it and override."
  if [ -d $1 ]
  then
    rm -rf $1
  else
    rm $1
  fi
  #exit 1
fi

#build study folder
mkdir $1
echo "making folder $1"
cd $1

#build clinical.params
echo "entering folder $1, starts to create clinical.params"
echo "COLUMN_MAP_FILE=$1_Column_Mapping.txt" > clinical.params
echo "WORD_MAP_FILE=x" >> clinical.params
echo "RECORD_EXCLUSION_FILE=x" >> clinical.params
echo "STUDY_ID=\"$1\"" >> clinical.params
echo "SECURITY_REQUIRED=N" >> clinical.params
echo "TOP_NODE_PREFIX=\"Public Studies\\CGDB\"" >> clinical.params
echo "STUDY_NAME=\"$1\"" >> clinical.params

#build study_Clinical_Data file and sample-part study_Column_Mapping file
mkdir clinical
cd clinical
mv ../../$1_Clinical_Data.txt .
echo "move $2 into clinical folder and renamed as $1_Clinical_Data.txt"

#copy the column mapping file
echo "start doing naughty things! haha"
cp ~/transmart/transmart-data/samples/studies/Sample_Column_Mapping_Microarray.txt ~/transmart/transmart-data/samples/studies/$1/clinical/$1_Column_Mapping.txt
cd ~/transmart/transmart-data/samples/studies/$1/clinical/
sed -i "s/Sample_Clinical/$1_Clinical/g" $1_Column_Mapping.txt

#start to upload
echo ""
echo ""
echo "Start to upload $1"
#cd /home/transmart/transmart/transmart-batch/
#build/libs/transmart-batch-1.1-SNAPSHOT-capsule.jar -c batchdb.properties -p studies/$1/clinical.params
cd ~/transmart/transmart-data
. ./vars
make -C samples/postgres load_clinical_$1
