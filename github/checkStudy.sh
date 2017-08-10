abort() {
  echo $1
  exit 1
}

usage() {
  echo $1
  exit 1
}

trap abort exit
set -e

SCRIPT_PATH="`dirname $(readlink -f $0)`"
. $SCRIPT_PATH/config.sh


if [ $# -ne 1 ]
then
  usage "You should enter one argument, which is the study_id existense you want to observe in database"
fi

STUDY_ID="`echo $1 | tr [a-z] [A-Z]`"
if [ $STUDY_ID == "ALL-CGDB-SAMPLES" ]
then
  usage "Users are not allowed to modify the All-CGDB-Samples, or affect it by uploading a study with same uppercase study id"
fi

echo "Error detection finish, dive into database"

cd $SCRIPT_PATH
sudo -u postgres psql < checkStudy.sql > checkStudy.result

col_num="`wc -l checkStudy.result | cut -d' ' -f1`"
echo "The checkStudy.result has $col_num columns"
head_num=$(($col_num - 2))
tail_num=$(($head_num - 3))
head -$head_num checkStudy.result |  tail -$tail_num | sed  "s/^ //g"> checkStudy.list
cat checkStudy.list

while read line
do
  echo $line
  list_result="`echo $line | tr [a-z] [A-Z]`"
  if [ $list_result == $STUDY_ID ]
  then
    echo "Need to override $line with trial name $list_result"
    $SCRIPT_PATH/deleteVCF.sh $line
    $SCRIPT_PATH/deleteGENE.sh $line
    $SCRIPT_PATH/deleteClinical.sh $line
  else
    echo "$line is no match for $STUDY_ID"
  fi
done < checkStudy.list


rm checkStudy.result
rm checkStudy.list
trap : 0
