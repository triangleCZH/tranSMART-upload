cd ~/transmart/transmart-data/
. ./vars
nohup make -C solr start > ~/transmart/transmart-data/solr.log 2&>1 &
make -C solr browse_full_import rwg_full_import sample_full_import
