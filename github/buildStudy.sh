#!/bin/bash

usage() {
  echo $1 
  exit 1
}

abort() {
  echo "Error found when uploading clinical data of $1"
  exit 1
}

trap abort exit
set -e



PWD_DIR="`pwd`"
SCRIPT_PATH="`dirname $(readlink -f $0)`"
. $SCRIPT_PATH/config.sh

########The sample.txt should be put in transmart-data/samples/studies folder
#check number of arguments
if [ $# -ne 3 ]
then
  usage "Please enter three arguments: NO.1 to use as the study name NO.2 to specify the sample txt file name NO.3 to specify the vcf parsed txt file name. This script will upload the study clinical data, together with vcf-parsed data"
fi

#first delete study and its vcf, if exist
echo "##################################################"
echo "# Delete the study $1 ,vcf and mutation if exist #"
echo "##################################################"
$SCRIPT_PATH/deleteVCF.sh $1
$SCRIPT_PATH/deleteGENE.sh $1
$SCRIPT_PATH/deleteClinical.sh $1


cd $PWD_DIR
#check if sample and parsed vcf data file exist
if [ ! -f $2 ]
then
  usage "the file $2 does not exist, please make sure is is in the correct path"
elif [ ! -f $3 ]
then
  usage "the file $3 does not exist, please make sure it is in the correct paht"
elif [ ${2: -4} != ".txt" ]
then
  echo "the file $2 needs to be .txt, please check the file format"
elif [ -d $2 ]
then
  usage "$2 needs to be a file, not a directory"
elif [ ${3: -4} != ".txt" ]
then
  echo "the file $3 needs to be .txt, please check the file format"
elif [ -d $2 ]
then
  usage "$3 needs to be a file, not a directory"
fi
cp $PWD_DIR/$2 $TRANSMART_STUDY/$1_Clinical_Data.txt
cp $PWD_DIR/$3 $TRANSMART_STUDY/$1_VCF_Data.txt

cd $TRANSMART_STUDY 
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
echo "STUDY_ID=$1" >> clinical.params
echo "SECURITY_REQUIRED=N" >> clinical.params
#echo "TOP_NODE=\"\\Public Data\\$1\"" >> clinical.params
echo "TOP_NODE_PREFIX=\"Public Studies\\CGDB\"" >> clinical.params
echo "STUDY_NAME=\"$1\"" >> clinical.params

#build study_Clinical_Data file and sample-part study_Column_Mapping file
mkdir clinical
cd clinical
mv ../../$1_Clinical_Data.txt .
echo "move $2 into clinical folder and renamed as $1_Clinical_Data.txt"
let col_at_least=1
let col_num="`cat $TRANSMART_STUDY/$1/clinical/$1_Clinical_Data.txt |  head -1 | sed 's/	/\n/g' | wc -l`"
if [ $col_num -lt $col_at_least ]
then 
  echo "$1_Clinical_Data.txt should be a tab-delimited file with at least one column, but less than one column is found"
  exit 1
fi
#echo "filename	category_cd	col_nbr	data_label	data_label_source	control_vocab_cd	concept_type" > $1_Column_Mapping.txt
#for ((count=$col_at_least; count<=$col_num; count++ ))
#do
#  if [ $count -eq 1 ]
#  then
#    echo "$1_Clinical_Data.txt	\	1	SUBJ_ID" >> $1_Column_Mapping.txt
#  else
#    echo -n "$1_Clinical_Data.txt	Sample	$count	" >> $1_Column_Mapping.txt
#    echo "`cut -d'	' -f$count $1_Clinical_Data.txt | head -1`" >> $1_Column_Mapping.txt
#  fi
#done
echo "sample data build and sample-part mapping file done"

#build study_VCF_Data file and vcf-part study_Column_Mapping file
mv ../../$1_VCF_Data.txt .
#mv ../../$3 $1_Clinical_Data.txt
echo "move $3 into clinical folder and renamed as $3_VCF_Data.txt"
let col_at_least=1
let col_num="`cat $TRANSMART_STUDY/$1/clinical/$1_VCF_Data.txt |  head -1 | sed 's/	/\n/g' | wc -l`"
if [ $col_num -lt $col_at_least ]
then 
  echo "$1_VCF_Data.txt should be a tab-delimited file with at least one column, but less than one column is found"
  exit 1
fi
#for ((count=$col_at_least; count<=$col_num; count++ ))
#do
#  if [ $count -eq 1 ]
#  then
#    echo "$1_VCF_Data.txt	\	1	SUBJ_ID" >> $1_Column_Mapping.txt
#  else
#    echo -n "$1_VCF_Data.txt	Variant	$count	" >> $1_Column_Mapping.txt
#    echo "`cut -d'	' -f$count $1_VCF_Data.txt | head -1`" >> $1_Column_Mapping.txt
#  fi
#done
echo "parsed vcf data build and sample-part mapping file done"

echo "In the mapping file all columns are tab-delimited, where category_cd and data_label can be \"\" by default" 
echo "Please note the already written tabs when filling information"
echo "Building folder success!"


echo "Generating map files from sample map"
cp $SCRIPT_PATH/Sample_Column_Mapping.txt $TRANSMART_STUDY/$1/clinical/$1_Column_Mapping.txt
cd $TRANSMART_STUDY/$1/clinical/
sed -i "s/Sample_VCF/$1_VCF/g" $1_Column_Mapping.txt
sed -i "s/Sample_Clinical/$1_Clinical/g" $1_Column_Mapping.txt

#start to upload
echo ""
echo ""
echo "Start to upload $1"
#cd /home/transmart/transmart/transmart-batch/
#build/libs/transmart-batch-1.1-SNAPSHOT-capsule.jar -c batchdb.properties -p studies/$1/clinical.params
cd $TRANSMART_DATA
. ./vars
make -C samples/postgres load_clinical_$1


trap : 0
