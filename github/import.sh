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

if [ $# -ne 1 ]
then
  usage "Please enter one argument, which is the study_id of the study"
fi

$SCRIPT_PATH/buildStudy.sh $1 $DATA_PATH/$1.sample $DATA_PATH/$1.parse.txt
$SCRIPT_PATH/buildVCF.sh $1 $DATA_PATH/$1.vcf
$SCRIPT_PATH/buildPlatform.sh $1 $DATA_PATH/$1.platform
$SCRIPT_PATH/buildMicroarray.sh $1 $DATA_PATH/$1.data
$SCRIPT_PATH/deleteFolders.sh $1

trap : 0
