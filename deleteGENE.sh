abort() {
  exit 1
}

trap abort exit
set -e

SCRIPT_PATH="`dirname $(readlink -f $0)`"
. $SCRIPT_PATH/config.sh

echo "You want to delete mutations for $1"
cd $SCRIPT_PATH
STUDYID="`echo $1 | tr [a-z] [A-Z]`"
cp deleteGENE.sql $1-deleteGENE.sql
sed -i "s/myGene/$1/g" $1-deleteGENE.sql 
sed -i "s/MYGENE/$STUDYID/g" $1-deleteGENE.sql
mv $1-deleteGENE.sql $TRANSMART_DATA 
cd $TRANSMART_DATA
sudo -u postgres psql < $1-deleteGENE.sql
rm $1-deleteGENE.sql

trap : 0
