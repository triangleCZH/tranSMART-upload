########The sample.txt should be put in transmart-batch/studies folder
#check number of arguments
if [ $# -ne 3 ]
then
  echo "please enter three arguments: NO.1 to use as the study name NO.2 to specify the sample txt file name NO.3 to specify the vcf parsed txt file name"
  exit 1
fi
cd /home/transmart/transmart/transmart-batch/studies #/home/transmart/transmart/transmart-data/samples/studies/
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
#check if sample and parsed vcf data file exist
if [ ! -f $2 ]
then
  echo "the file $2 does not exist, please make sure is is in transmart-batch/studies"
  exit 1
elif [ ! -f $3 ]
then
  echo "the file $3 does not exist, please make sure it is in transmart-batch/studies"
  exit 1
elif [ ${2: -4} != ".txt" ]
then 
  echo "the file $2 needs to be .txt, please check the file format"
elif [ -d $2 ]
then
  echo "$2 needs to be a file, not a directory"
elif [ ${3: -4} != ".txt" ]
then 
  echo "the file $3 needs to be .txt, please check the file format"
elif [ -d $2 ]
then
  echo "$3 needs to be a file, not a directory"
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
echo "STUDY_ID=$1" >> clinical.params
echo "SECURITY_REQUIRED=N" >> clinical.params
echo "TOP_NODE=\"\\Public Data\\$1\"" >> clinical.params

#build study_Clinical_Data file and sample-part study_Column_Mapping file
mkdir clinical
cd clinical
mv $2 $1_Clinical_Data.txt
#mv ../../$2 $1_Clinical_Data.txt
echo "move $2 into clinical folder and renamed as $1_Clinical_Data.txt"
let col_at_least=1
let col_num="`cat /home/transmart/transmart/transmart-batch/studies/$1/clinical/$1_Clinical_Data.txt |  head -1 | sed 's/	/\n/g' | wc -l`"
if [ $col_num -lt $col_at_least ]
then 
  echo "$1_Clinical_Data.txt should be a tab-delimited file with at least one column, but less than one column is found"
  exit 1
fi
echo "filename	category_cd	col_nbr	data_label	data_label_source	control_vocab_cd	concept_type" > $1_Column_Mapping.txt
for ((count=$col_at_least; count<=$col_num; count++ ))
do
  if [ $count -eq 1 ]
  then
    echo "$1_Clinical_Data.txt	\	1	SUBJ_ID" >> $1_Column_Mapping.txt
  else
    echo -n "$1_Clinical_Data.txt	Sample	$count	" >> $1_Column_Mapping.txt
    echo "`cut -d'	' -f$count $1_Clinical_Data.txt | head -1`" >> $1_Column_Mapping.txt
  fi
done
echo "sample data build and sample-part mapping file done"

#build study_VCF_Data file and vcf-part study_Column_Mapping file
mv $3 $1_VCF_Data.txt
#mv ../../$3 $1_Clinical_Data.txt
echo "move $3 into clinical folder and renamed as $3_VCF_Data.txt"
let col_at_least=1
let col_num="`cat /home/transmart/transmart/transmart-batch/studies/$1/clinical/$1_VCF_Data.txt |  head -1 | sed 's/	/\n/g' | wc -l`"
if [ $col_num -lt $col_at_least ]
then 
  echo "$1_VCF_Data.txt should be a tab-delimited file with at least one column, but less than one column is found"
  exit 1
fi
for ((count=$col_at_least; count<=$col_num; count++ ))
do
  if [ $count -eq 1 ]
  then
    echo "$1_VCF_Data.txt	\	1	SUBJ_ID" >> $1_Column_Mapping.txt
  else
    echo -n "$1_VCF_Data.txt	Variant	$count	" >> $1_Column_Mapping.txt
    echo "`cut -d'	' -f$count $1_VCF_Data.txt | head -1`" >> $1_Column_Mapping.txt
  fi
done
echo "parsed vcf data build and sample-part mapping file done"

echo "In the mapping file all columns are tab-delimited, where category_cd and data_label can be \"\" by default" 
echo "Please note the already written tabs when filling information"
echo "Building folder success!"


echo "start doing naughty things! haha"
cp ~/transmart/transmart-batch/studies/CGDB/clinical/5variants2_Column_Mapping.txt ~/transmart/transmart-batch/studies/$1/clinical/$1_Column_Mapping.txt
cd ~/transmart/transmart-batch/studies/$1/clinical/
sed -i "s/5variants2_Clinical/$1_VCF/g" $1_Column_Mapping.txt
sed -i "s/5variants/$1/g" $1_Column_Mapping.txt

#start to upload
echo ""
echo ""
echo "Start to upload $1"
cd /home/transmart/transmart/transmart-batch/
build/libs/transmart-batch-1.1-SNAPSHOT-capsule.jar -c batchdb.properties -p studies/$1/clinical.params

