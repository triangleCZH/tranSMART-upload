abort() {
  exit 1
}

trap abort exit
set -e

SCRIPT_PATH="`dirname $(readlink -f $0)`"
. $SCRIPT_PATH/config.sh

cd $SCRIPT_PATH
STUDYID="`echo $1 | tr [a-z] [A-Z]`"
cp deleteVCF.sql $1-deleteVCF.sql
sed -i "s/myvcf/$1/g" $1-deleteVCF.sql 
sed -i "s/MYVCF/$STUDYID/g" $1-deleteVCF.sql
mv $1-deleteVCF.sql $TRANSMART_DATA
cd $TRANSMART_DATA
sudo -u postgres psql < $1-deleteVCF.sql
rm $1-deleteVCF.sql

trap : 0
