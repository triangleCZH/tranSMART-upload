if [ $# -ne 2 ]
then
  echo "please enter two arguments: NO.1 to use as the platform name NO.2 to specify the annotation txt file name" 
  exit 1
fi


if [ ! -f $2 ]
then
  echo "the file $2 does not exist, please make sure is is in transmart-batch/studies"
  #exit 1
elif [ ${2: -4} != ".txt" ]
then
  echo "the file $2 needs to be .txt, please check the file format"
  #exit 1
elif [ -d $2 ]
then
  echo "$2 needs to be a file, not a directory"
  #exit 1
fi

cp $2 /home/transmart/transmart/transmart-data/samples/studies/Platform$1.txt

cd /home/transmart/transmart/transmart-data/samples/studies/

if [ -e Platform$1 ]
then
  #echo "the chosen folder name $1 already exist for a file/folder, please get another name"
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
cd /home/transmart/transmart/transmart-data/
. ./vars
make -C samples/postgres load_annotation_Platform$1
