checkExist () {
echo "checking the existence and format of $1"
if [ ! -f $1 ]
then
  echo "the file $1 does not exist"
  #exit 1
elif [ ${1: -4} != ".txt" ]
then
  echo "you need a file that ends up with .txt"
  #exit 1
fi
echo "the file $1 has correct format."
}

createFolder () {
echo ""

cp $2 /home/transmart/transmart/transmart-data/samples/studies/data.txt

#create expression.params
cd /home/transmart/transmart/transmart-data/samples/studies/$1
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
echo $col_num
x=2
while [ $x -le $col_num ]
do
  echo -n "$1		" >> map.txt
  echo -n "`cut -d'	' -f1-2 ../clinical/$1_Clinical_Data.txt | awk "NR==$x"`" >> map.txt
  echo  "	Platform$1				Mutation" >> map.txt
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

cd /home/transmart/transmart/transmart-data/samples/studies/
if [ ! -e $1 ]
then
  echo "You must first have the clinical data before you want to create the expression folder"
  exit 1
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

cd /home/transmart/transmart/transmart-data/
. ./vars
make -C samples/postgres load_expression_$1
cd samples/studies
#rm -rf $1
#rm -rf Platform$1
