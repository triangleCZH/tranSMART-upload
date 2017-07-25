#$name = ls | grep ".log" | wc -l
cd Scripts/install-ubuntu/checks/
sudo ./checkAll.sh 2>&1 2>&1 | tee ~/checks.log
#todo: put the count in the name of the log file!
