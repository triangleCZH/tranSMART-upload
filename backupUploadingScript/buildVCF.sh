if [ $# -ne 2 ]
then
  echo "please enter two arguments: NO.1 to use as the folder name of the study NO.2 to specify the scp txt file name"
  exit 1
fi
cd /home/transmart/transmart/transmart-data/samples/studies/
#check folder name existence
if [ ! -e $1 ]
then 
  echo "The folder $1 doesn't exist. Fine, create one for you."
  mkdir $1
elif [ -d $1 ]
then
  echo "It seems that the clinical data already exists, will enter the folder and use it."
else
  echo "The name $1 has been used, please choose another one"
  exit 1
fi

#check vcf file existence
if [ ! -f $2 ]
then
  echo "the file $2 does not exist, please make sure scp process successed"
  exit 1
elif [ ${2: -4} != ".vcf" ]
then
  echo "you need a file that ends up with .vcf"
  exit 1
fi

#creating...
cd $1
echo "entering folder $1, please note that vcf will only includes data file and mapping file, not vcf.params" 
mkdir vcf
cd vcf
mkdir tmp
cp ../../$2 $1.vcf
echo "move $2 into vcf folder and renamed as $1.vcf"
echo "creating subject-sample-mapping.txt"
echo "# This file is a sample mapping file for vcf, if you want to use this file ,please delete the comment lines." > subject-sample-mapping.txt
echo "# A mapping file should have at least two columns, the first column is subject from clinical file, the second column is sample from vcf file, delimited by tab" >> subject-sample-mapping.txt
echo "" >> subject-sample-mapping.txt
echo "subject1  sample1" >> subject-sample-mapping.txt
echo "subject2  sample2" >> subject-sample-mapping.txt
echo "finish creating mapping file"
echo ""
echo "Now create the vcf.params"
echo "copy samples/commom/vcf.params-sample to a folder named $1, you can use the file after modifying some details"
cd /home/transmart/transmart/transmart-data/samples/common/
mkdir $1
cp vcf.params-sample $1/vcf.params
sed -i "s/myVCF/$1/g" $1/vcf.params
echo "Process finished"
