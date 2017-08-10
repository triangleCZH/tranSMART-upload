#!/bin/bash

usage() {
  echo $1
  exit 1
}

abort() {
  echo "Error found when uploading the platform"
  exit 1
}


trap abort exit
set -e



PWD_DIR="`pwd`"
SCRIPT_PATH="`dirname $(readlink -f $0)`"
. $SCRIPT_PATH/config.sh

if [ $# -ne 2 ]
then
  usage "This script is used to upload a platform. Please enter two arguments: NO.1 to use as the platform name NO.2 to specify the annotation txt file name" 
  exit 1
fi


cd $PWD_DIR
if [ ! -f $2 ]
then
  usage "the file $2 does not exist"
elif [ ${2: -4} != ".txt" ]
then
  echo "the file $2 needs to be .txt, please check the file format"
elif [ -d $2 ]
then
  usage "$2 needs to be a file, not a directory"
fi

cp $PWD_DIR/$2 $TRANSMART_STUDY/Platform$1.txt

cd $TRANSMART_STUDY

if [ -e Platform$1 ]
then
  echo "the chosen folder name Platform$1 already exist, delete it and override."
  if [ -d Platform$1 ]
  then
    rm -rf Platform$1
  else
    rm Platform$1
  fi
  #exit 1
fi

mkdir Platform$1
echo "making folder Platform$1"
cd Platform$1
echo "PLATFORM=Platform$1" > annotation.params
echo "ANNOTATIONS_FILE=Platform$1.txt" >> annotation.params
echo "PLATFORM_TITLE=\"Gene\"" >> annotation.params

mkdir annotation
cd annotation
mv ../../Platform$1.txt .
#sed -i "s/platform/Platform$1/g" Platform$1.txt
cd $TRANSMART_DATA
. ./vars
make -C samples/postgres load_annotation_Platform$1

trap : 0
