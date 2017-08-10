abort() {
  exit 1
}

trap abort exit
set -e

SCRIPT_PATH="`dirname $(readlink -f $0)`"
. $SCRIPT_PATH/config.sh

if [ $# -ne 1 ]
then
  echo "Please enter one argument, the study_name to delete" 
  exit 1
fi


cd $TRANSMART_STUDY
rm -rf $1
echo "$1 folder deleted"
rm -rf Platform$1
echo "Platform$1 deleted"
cd $TRANSMART_COMMON
rm -rf $1
echo "common/$1 folder deleted"
cd $DATA_PATH
rm -rf $1
echo "$DATA_PATH/$1 deleted"
trap : 0
