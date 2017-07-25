cd /etc/postgresql/9.3/main
sed -i 's/local   all             postgres                                peer/local   all             postgres                                md5/g' pg_hba.conf
sudo service postgresql restart
cd ~
sed -i "/^$1$/d" study_id.txt
cp deleteVCFDB.txt $1-deleteVCF.sql
sed -i "s/myvcf/$1/g" $1-deleteVCF.sql 
mv $1-deleteVCF.sql transmart/transmart-data
cd transmart/transmart-data
. ./vars
PGPASSWORD=postgres psql -Upostgres < $1-deleteVCF.sql
cd /etc/postgresql/9.3/main
sed -i 's/local   all             postgres                                md5/local   all             postgres                                peer/g' pg_hba.conf
sudo service postgresql restart
