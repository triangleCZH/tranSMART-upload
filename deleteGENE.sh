STUDYID="`echo $1 | tr [a-z] [A-Z]`"
#sed -i "/^$STUDYID	MICRO$/d" study_id.txt
cp deleteGENE.txt $1-deleteGENE.sql
sed -i "s/myGene/$1/g" $1-deleteGENE.sql 
sed -i "s/MYGENE/$STUDYID/g" $1-deleteGENE.sql
mv $1-deleteGENE.sql transmart/transmart-data
cd transmart/transmart-data
sudo -u postgres psql < $1-deleteGENE.sql
rm $1-deleteGENE.sql
