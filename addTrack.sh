SCRIPT_PATH="`dirname $(readlink -f $0)`"

if [ -z $1 ]
then
    echo "usage: `basename $0` <study_name>" &&
    exit 255;
fi

#. $SCRIPT_PATH/config.sh

study_name=$1
web_path=/var/lib/tomcat7/webapps/ROOT/hubDirectory/hg19

set -e

echo >> ${web_path}/trackDb.txt
echo "track ${study_name}" >> ${web_path}/trackDb.txt
echo "bigDataUrl ${study_name}.vcf.gz" >> ${web_path}/trackDb.txt
echo "shortLabel L3 bio ${study_name}" >> ${web_path}/trackDb.txt
echo "longLabel L3 bio ${study_name}" >> ${web_path}/trackDb.txt
echo "type vcfTabix" >> ${web_path}/trackDb.txt
echo 'visibility dense' >> ${web_path}/trackDb.txt
