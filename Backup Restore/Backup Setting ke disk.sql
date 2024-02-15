30 4 * * 1 /home/oracle/script/backup/opurptrx.sh > /dev/null 2>&1 >> /home/oracle/script/backup/log/OPURPTRX.log
30 5 * * 1 /home/oracle/script/backup/opurprms.sh > /dev/null 2>&1 >> /home/oracle/script/backup/log/OPURPRMS.log


cd /datadump1
mkdir opiris
chmod 777 opiris
cd opiris
mkdir db arch
chmod 777 db arch


[oracle@exa62pdb1-mgt ~]$ vi /home/oracle/script/backup/opurptrx.sh
[oracle@exa62pdb1-mgt ~]$ chmod 777 /home/oracle/script/backup/opurptrx.sh
echo '======================================='
echo `date`
export ORACLE_SID=OPURPTRX1
export ORACLE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/home/oracle/script/backup/log/OPURPTRX.log << EOF

crosscheck backup;
delete force noprompt expired backup;
run
{
allocate channel ch01 device type disk format '/datadump1/opurptrx/db/%d_db_%T_%U.bk';
allocate channel ch03 device type disk format '/datadump3/opurptrx/db/%d_db_%T_%U.bk';
allocate channel ch05 device type disk format '/datadump5/opurptrx/db/%d_db_%T_%U.bk';
allocate channel ch07 device type disk format '/datadump7/opurptrx/db/%d_db_%T_%U.bk';
allocate channel ch09 device type disk format '/datadump9/opurptrx/db/%d_db_%T_%U.bk';
allocate channel ch11 device type disk format '/datadump11/opurptrx/db/%d_db_%T_%U.bk';
allocate channel ch13 device type disk format '/datadump13/opurptrx/db/%d_db_%T_%U.bk';
allocate channel ch15 device type disk format '/datadump15/opurptrx/db/%d_db_%T_%U.bk';
backup database;
backup current controlfile format '/datadump15/opurptrx/db/%d_db_control_%T_%U.bkp';
release channel ch01;
release channel ch03;
release channel ch05;
release channel ch07;
release channel ch09;
release channel ch11;
release channel ch13;
release channel ch15;
}

crosscheck archivelog all;
delete force noprompt expired archivelog all;
run
{
allocate channel ch01 device type disk format '/datadump1/opurptrx/arch/%d_arch_%T_%U.bk';
allocate channel ch03 device type disk format '/datadump3/opurptrx/arch/%d_arch_%T_%U.bk';
allocate channel ch05 device type disk format '/datadump5/opurptrx/arch/%d_arch_%T_%U.bk';
allocate channel ch07 device type disk format '/datadump7/opurptrx/arch/%d_arch_%T_%U.bk';
allocate channel ch09 device type disk format '/datadump9/opurptrx/arch/%d_arch_%T_%U.bk';
allocate channel ch11 device type disk format '/datadump11/opurptrx/arch/%d_arch_%T_%U.bk';
allocate channel ch13 device type disk format '/datadump13/opurptrx/arch/%d_arch_%T_%U.bk';
allocate channel ch15 device type disk format '/datadump15/opurptrx/arch/%d_arch_%T_%U.bk';
backup archivelog all delete input;
release channel ch01;
release channel ch03;
release channel ch05;
release channel ch07;
release channel ch09;
release channel ch11;
release channel ch13;
release channel ch15;
}

exit
EOF

dba=`cat /home/oracle/script/backup/dba_list`
if [ -z `grep ORA- /home/oracle/script/backup/log/opurptrx.log` ];
then
   echo "Thank you" | mail -s "OPURPTRX Backup Success" $dba
else
   echo "Backup contain ORA error. Please check!!! Log location=/home/oracle/script/backup/log/OPURPTRX.log" | mail -s "opurptrx Backup Failed" $dba
fi
rm /home/oracle/script/backup/log/opurptrx.log

chmod 666 /datadump*/opurptrx/db/*
chmod 666 /datadump*/opurptrx/arch/*

#find /datadump*/opurptrx/arch/*.bk -mtime +6 -exec rm {} \;
#find /datadump*/opurptrx/db/*.bk -mtime +6 -exec rm {} \;
echo '======================================='

[oracle@exa62pdb1-mgt ~]$ 
