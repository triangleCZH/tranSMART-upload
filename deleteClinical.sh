#cd /etc/postgresql/9.3/main
#sed -i 's/local   all             postgres                                peer/local   all             postgres                                md5/g' pg_hba.conf
#sudo service postgresql restart
cd ~
STUDYID="`echo $1 | tr [a-z] [A-Z]`"
#sed -i "/^$STUDYID	VCF$/d" study_id.txt
cp deleteClinical.txt $1-deleteClinical.sql
sed -i "s/myclinical/$1/g" $1-deleteClinical.sql 
sed -i "s/MYCLINICAL/$STUDYID/g" $1-deleteClinical.sql
mv $1-deleteClinical.sql transmart/transmart-data
cd transmart/transmart-data
#. ./vars
#PGPASSWORD=postgres psql -Upostgres < $1-deleteVCF.sql
sudo -u postgres psql < $1-deleteClinical.sql
rm $1-deleteClinical.sql
#cd /etc/postgresql/9.3/main
#sed -i 's/local   all             postgres                                md5/local   all             postgres                                peer/g' pg_hba.conf
#sudo service postgresql restart
