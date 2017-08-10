abort() {
  exit 1
}

trap abort exit
set -e

SCRIPT_PATH="`dirname $(readlink -f $0)`"
. $SCRIPT_PATH/config.sh

echo "When single argument is 'yes', remove all the studies, otherwise keep All-CGDB-Samples"
cd $SCRIPT_PATH
sudo -u postgres psql < deleteAll.sql
if [ $# -eq 0 ]
then
  buildStudy.sh All-CGDB-Samples sample.txt sample.parse.txt
elif [ $1 != 'yes' ]
then 
  buildStudy.sh All-CGDB-Samples sample.txt sample.parse.txt
fi


trap : 0
