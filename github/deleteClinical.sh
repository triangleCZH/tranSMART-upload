abort() {
  exit 1
}

trap abort exit
set -e

SCRIPT_PATH="`dirname $(readlink -f $0)`"
. $SCRIPT_PATH/config.sh

cd $SCRIPT_PATH
STUDYID="`echo $1 | tr [a-z] [A-Z]`"
cp deleteClinical.sql $1-deleteClinical.sql
sed -i "s/myclinical/$1/g" $1-deleteClinical.sql 
sed -i "s/MYCLINICAL/$STUDYID/g" $1-deleteClinical.sql
mv $1-deleteClinical.sql $TRANSMART_DATA
cd $TRANSMART_DATA
sudo -u postgres psql < $1-deleteClinical.sql
rm $1-deleteClinical.sql

trap : 0
