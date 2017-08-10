usage() {
  echo $1
  exit 1
}

abort() {
  echo "Error found when uploading mutation file"
  exit 1
}

trap abort exit
set -e


PWD_DIR="`pwd`"
SCRIPT_PATH="`dirname $(readlink -f $0)`"
. $SCRIPT_PATH/config.sh


checkExist () {
cd $PWD_DIR
echo "checking the existence and format of $1"
if [ ! -f $1 ]
then
  usage "the file $1 does not exist"
elif [ ${1: -4} != ".txt" ]
then
  echo "you need a file that ends up with .txt"
else
  echo "the file $1 has correct format."
fi
}

createFolder () {
cd $PWD_DIR
cp $2 $TRANSMART_STUDY/data.txt

#create expression.params
cd $TRANSMART_STUDY/$1
echo "DATA_FILE_PREFIX=\"data\"" > expression.params
echo "MAP_FILENAME=\"map.txt\"" >> expression.params
echo "STUDY_ID=$1" >> expression.params
echo "STUDY_NAME=\"$1\"" >> expression.params
echo "TOP_NODE_PREFIX=\"Public Studies\\CGDB\"" >> expression.params

#create expression folder
mkdir expression >> /dev/null 2>&1
cd expression
#data.txt
mv ../../data.txt .
#map.txt
echo "STUDY_ID	SITE_ID	SUBJECT_ID	SAMPLE_CD	PLATFORM	TISSUETYPE	ATTR1	ATTR2	category_cd" > map.txt
col_num="`wc -l ../clinical/$1_Clinical_Data.txt | cut -d' ' -f1`"
echo "There are $col_num columns in total"
x=2
while [ $x -le $col_num ]
do
  echo -n "$1		" >> map.txt
  echo -n "`cut -d'	' -f1-2 ../clinical/$1_Clinical_Data.txt | awk "NR==$x"`" >> map.txt
  echo  "	Platform$1				Gene-Variant" >> map.txt
  x=$(( $x + 1 ))
done 

}

#The start
if [ $# -lt 2 ]
then
  echo "please enter at least two arguments: NO.1 to use as the study name, NO.2 to specify the expression file  name"
  exit 1
fi


checkExist $2

cd $TRANSMART_STUDY
if [ ! -e $1 ]
then
  usage "You must first have the clinical data before you want to create the expression folder"
fi

createFolder $1 $2

#make sure the old one, if exists, is deleted in psql
#cd ~
#STUDYID="`echo $1 | tr [a-z] [A-Z]`"
#let searchExistence="`grep -e "^$STUDYID	MICRO$" study_id.txt | wc -l`"
#echo -n "Check if the mutation already exist, this is the time of existence: "
#echo $searchExistence
#if [ $searchExistence -eq 0 ]
#then
#  echo "This is a new file, record the study name in study_id.txt"
#else
#  ./deleteGENEDB.sh $1
#  echo "$1 old vcf file is deleted"
#fi
#echo "$STUDYID	MICRO" >> study_id.txt

cd $TRANSMART_DATA
. ./vars
make -C samples/postgres load_expression_$1

trap : 0
