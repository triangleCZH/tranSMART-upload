#The function to check vcf file existence, has one argument, which is the name of target vcf file
checkExistVCF () {
echo "checking the existence and format of $1"
if [ ! -f $1 ]
then
  echo "the file $1 does not exist"
  exit 1
elif [ ${1: -4} != ".vcf" ]
then
  echo "you need a file that ends up with .vcf"
  exit 1
fi
echo "the file $1 has correct format."
}

#The function to create the folder in studies/ and commom/ , has two arguments, 1) the study name, 2) name of the vcf file
createFolderVCF () {
echo ""
cd /home/transmart/transmart/transmart-data/samples/studies/$1
mkdir vcf >> /dev/null 2>&1
cd vcf
cp $2 .
vcfFile="`ls | grep ".vcf"`"
vcfName=${vcfFile:0:-4}
echo "entering folder $1, start creating folders for $vcfFile" 
mkdir $vcfName >> /dev/null 2>&1
cd $vcfName
mkdir tmp >> /dev/null 2>&1
#mv $2 .
#mv ../../../$2 .
mv ../$vcfFile .
echo "move $vcfFile into $vcfName vcf folder"
echo "creating subject-sample-mapping.txt"
echo "# This file is a sample mapping file for vcf, if you want to use this file ,please delete these two comment lines." #> subject-sample-mapping.txt
echo "# A mapping file should have at least two columns, the first column is subject from clinical file, the second column is sample from vcf file, delimited by tab" #>> subject-sample-mapping.txt
echo -n "`cat ../../clinical/$1_Clinical_Data.txt | head -2 | tail -1 | cut -d'	' -f1`" > subject-sample-mapping.txt
#echo "	SRR1539005" >> subject-sample-mapping.txt
echo  "	AggregatedSample" >> subject-sample-mapping.txt
echo "finish creating mapping file"
echo "Now create the vcf.params"
echo "copy samples/commom/vcf.params-sample to a folder named $1, you can use the file after modifying some details"
cd /home/transmart/transmart/transmart-data/samples/common/
mkdir $1 >> /dev/null 2>&1
echo "Made a directory called $1"
cp vcf.params-sample $1/$vcfName-vcf.params
hashCode="`ls -l | wc -l`"
echo "Made a distinct dataset_id $hashCode"
sed -i "s/DATASET_ID=myVCF/DATASET_ID=myVCF$hashCode/g"  $1/$vcfName-vcf.params
sed -i "s/myVCF/$vcfName/g" $1/$vcfName-vcf.params
sed -i "s/study_name/$1/g" $1/$vcfName-vcf.params
#sed -i "s/study_id/$1/g" $1/$vcfname-vcf.params
echo "Finish process with $2"
}


#The start
if [ $# -lt 2 ]
then
  echo "please enter at least two arguments: NO.1 to use as the study name, NO.2...n to specify the vcf files' names"
  exit 1
fi
cd /home/transmart/transmart/transmart-data/samples/studies/

#check study folder name existence
if [ ! -e $1 ]
then 
  echo "The folder $1 doesn't exist. Fine, create one for you."
  mkdir $1
elif [ -d $1 ]
then
  echo "It seems that the $1 folder already exists, will enter the folder and use it."
else
  echo "The name $1 has been used as a file, please choose another one"
  exit 1
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
cd /home/transmart/transmart/transmart-data/
. ./vars
make -C samples/postgres load_VCF_$1 >> /dev/null 2>&1


#the uploading function, which takes two arguments, the study name and a specific vcf file's name
upload () {
if [ ${2: -4} != ".vcf" ]
then
  echo "The file needs to be in .vcf format"
  exit 1
fi
cd /home/transmart/transmart/transmart-data/samples/studies/$1/vcf
vcfName="`ls`" #by default, we should only have one vcf file for this study, or else ls may not work
echo "I know that the vcf file name is $vcfName"
cd /home/transmart/transmart/transmart-data/samples/common/_scripts/vcf
echo "Now dealing with the converMappingIntoSQLFiles.pl"
sed -i "s/\$ARGV\[2\]/\"$1\"/g" convertMappingIntoSQLFiles.pl
cd ../../$1
echo "use the $vcfName-vcf.params as source"
. ./$vcfName-vcf.params

cd ../../../
make -C samples/postgres load_vcf
cd samples/common/_scripts/vcf
#back to original version every time
sed -i "s/\"$1\"/\$ARGV\[2\]/g" convertMappingIntoSQLFiles.pl
echo "finish uploading $vcfName"
}


for var in "$@"
do
  if [ $var != $1 ]
  then
    upload $1 $var
  fi
done

#cd ~/transmart/transmart-data/samples/studies
#rm -rf $1
#echo "clean $1 study folder now"
#cd ../common
#rm -rf $1
#echo "clean $1 vcf.params now"
echo "everything finished"
