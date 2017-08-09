#cd /etc/postgresql/9.3/main
cd ~
STUDYID="`echo $1 | tr [a-z] [A-Z]`"
#sed -i "/^$STUDYID	VCF$/d" study_id.txt
cp deleteVCF.txt $1-deleteVCF.sql
sed -i "s/myvcf/$1/g" $1-deleteVCF.sql 
sed -i "s/MYVCF/$STUDYID/g" $1-deleteVCF.sql
mv $1-deleteVCF.sql transmart/transmart-data
cd transmart/transmart-data
#. ./vars
#PGPASSWORD=postgres psql -Upostgres < $1-deleteVCF.sql
sudo -u postgres psql < $1-deleteVCF.sql
rm $1-deleteVCF.sql
#cd /etc/postgresql/9.3/main
#sed -i 's/local   all             postgres                                md5/local   all             postgres                                peer/g' pg_hba.conf
#sudo service postgresql restart
