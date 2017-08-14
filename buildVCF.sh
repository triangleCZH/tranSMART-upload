#!/bin/bash

usage() {
  echo $1
  exit 1
}

abort() {
  echo "Error found when uploading vcf file"
  exit 1
}

trap abort exit
set -e


PWD_DIR="`pwd`"
SCRIPT_PATH="`dirname $(readlink -f $0)`"
. $SCRIPT_PATH/config.sh

#The function to check vcf file existence, has one argument, which is the name of target vcf file
checkExistVCF () {
  cd $PWD_DIR
  echo "checking the existence and format of $1"
  if [ ! -f $1 ]
  then
    usage "the file $1 does not exist"
  elif [ ${1: -4} != ".vcf" ]
  then
    usage "you need a file that ends up with .vcf"
  fi
  echo "the file $1 has correct format."
}

#The function to create the folder in studies/ and commom/ , has two arguments, 1) the study name, 2) name of the vcf file
createFolderVCF () {
  cd $PWD_DIR
  cp $2 $TRANSMART_STUDY/$1.vcf
  cd $TRANSMART_STUDY/$1
  echo "copy vcf file to $1 study folder"
  mkdir vcf 
  cd vcf
  echo "created and enter in vcf/ folder"
  mv $TRANSMART_STUDY/$1.vcf .
  echo "build tmp folder in vcf/"
  mkdir tmp >> /dev/null 2>&1
  echo "creating subject-sample-mapping.txt"
  echo "# This file is a sample mapping file for vcf, if you want to use this file ,please delete these two comment lines." #> subject-sample-mapping.txt
  echo "# A mapping file should have at least two columns, the first column is subject from clinical file, the second column is sample from vcf file, delimited by tab" #>> subject-sample-mapping.txt
  echo -n "`cat $TRANSMART_STUDY/$1/clinical/$1_Clinical_Data.txt | head -2 | tail -1 | cut -d'	' -f1`" > subject-sample-mapping.txt
  echo  "	AggregatedSample" >> subject-sample-mapping.txt
  echo "finish creating mapping file"
  echo "Now create the vcf.params"
  echo "copy samples/commom/vcf.params-sample to a folder named $1, you can use the file after modifying some details"
  cd $TRANSMART_COMMON
  mkdir $1 >> /dev/null 2>&1
  echo "Made a directory called $1"
  cp $SCRIPT_PATH/vcf.params-sample $1/vcf.params
  sed -i "s/study_name/$1/g" $1/vcf.params
  echo "Finish process with $2"
}


#The start
if [ $# -lt 2 ]
then
  usage "This script is used to upload vcf file. Please enter at least two arguments: NO.1 to use as the study name, NO.2 to specify the vcf files' names"
  exit 1
fi

#make sure the old one, if exists, is deleted in psql


cd $TRANSMART_STUDY

#check study folder name existence
if [ ! -e $1 ]
then 
  usage "$1 folder does not exists"
elif [ -d $1 ]
then
  echo "It seems that the $1 folder already exists, will enter the folder and use it."
else
  usage "The name $1 has been used as a file, please choose another one"
fi

#check vcf files
for var in "$@"
do
  if [ $var != $1 ]
  then
    checkExistVCF $var
  fi
done

#creawte the folders for vcf files
for var in "$@"
do
  if [ $var != $1 ]
  then
    createFolderVCF $1 $var
  fi
done

echo ""
echo "Finish the whole process"


#####upload vcf
#to set KETTLE_JOBS_PSQL
#cd $TRANSMART_DATA
#. ./vars
#make -C samples/postgres load_VCF_$1 >> /dev/null 2>&1


#the uploading function, which takes two arguments, the study name and a specific vcf file's name
upload () {
  cd $TRANSMART_STUDY/$1/vcf
  cd $TRANSMART_COMMON/$1
  echo "use the $vcfName-vcf.params as source"
  . ./vcf.params

  cd $TRANSMART_DATA
  . ./vars
  make -C samples/postgres load_vcf
  echo "finish uploading $1"
}

upload $1 $2
trap : 0
