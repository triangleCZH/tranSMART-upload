#check number of arguments
if [ $# -ne 2 ]
then
  echo "please enter two arguments: NO.1 to use as the folder name of the study NO.2 to specify the scp txt file name"
  exit 1
fi
cd /home/transmart/transmart/transmart-data/samples/studies/
#check folder name existence
if [ -e $1 ]
then
  echo "the chosen folder name $1 already exist for a file/folder, please get another name"
  exit 1
fi
#check if data file exist
if [ ! -f $2 ]
then
  echo "the file $2 does not exist, please make sure scp process successed"
  exit 1
elif [ ${2: -4} != ".txt" ]
then 
  echo "the file needs to be .txt, please check the file format"
elif [ -d $2 ]
then
  echo "it needs to be a file, not a directory"
fi
mkdir $1
echo "making folder $1"
cd $1
echo "entering folder $1, starts to create clinical.params"
echo "COLUMN_MAP_FILE=$1_Column_Mapping.txt" > clinical.params
echo "WORD_MAP_FILE=x 						#x by default" >> clinical.params
echo "RECORD_EXCLUSION_FILE=x 					#x by default" >> clinical.params
echo "STUDY_ID=$1 						#set the same name as folder by default, please change according when need" >> clinical.params
echo "STUDY_NAME=$1 						#set the same name as folder by default, please change according when need" >> clinical.params 
echo "SECURITY_REQUIRED=N					#N by default" >> clinical.params
echo "TOP_NODE_PREFIX=\"Public Studies\"			#change when need" >> clinical.params
mkdir clinical
cd clinical
cp ../../$2 $1_Clinical_Data.txt
echo "move $2 into clinical folder and renamed as $1_Clinical_Data.txt"
let col_at_least=1
let col_num="`cat /home/transmart/transmart/transmart-data/samples/studies/sample.txt |  head -1 | sed 's/	/\n/g' | wc -l`-1"
if [ $col_num -lt $col_at_least ]
then 
  echo "$1_Clinical_Data.txt should be a tab-delimited file with at least one column, but less than one column is found"
  exit 1
fi
echo "filename	category_cd	col_nbr	data_label" > $1_Column_Mapping.txt
for ((count=$col_at_least; count<=$col_num; count++ ))
do
  if [ $count -eq 1 ]
  then
    echo "$1_Clinical_Data.txt	example_category	1	SUBJ_ID" >> $1_Column_Mapping.txt
  else
    echo "$1_Clinical_Data.txt		$count	" >> $1_Column_Mapping.txt
  fi
done
echo "In the mapping file all columns are tab-delimited, where category_cd and data_label can be \"\" by default" 
echo "Please note the already written tabs when filling information"
echo "Building folder success!"
