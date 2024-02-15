
--RMAN>
DELETE force noprompt archivelog until time 'sysdate-1';
DELETE force noprompt archivelog all;
DELETE noprompt foreign archivelog  until time 'sysdate-1/2';
DELETE noprompt archivelog until time '(sysdate - 1)' backed up 1 times to device type SBT_TAPE; --untuk db yg backup ke zdlra
DELETE noprompt archivelog all backed up 1 times to device type SBT_TAPE;
CROSSCHECK archivelog all;
CROSSCHECK foreign archivelog all;

DELETE noprompt archivelog all backed up 1 times to device type SBT_TAPE;


----BTB
delete noprompt archivelog until time 'sysdate-2';
delete noprompt archivelog until time 'sysdate-2' backed up 1 times to device type sbt_tape;
crosscheck archivelog all;
delete noprompt expired archivelog all;

----------------------------------------------------------------------------------------------------------------------------------------

--RESIZE FILE_DEST
alter system set db_recovery_file_dest_size =300G scope=both sid='*';

--Check RECOVERY USAGE&DEST
select * from v$recovery_area_usage;
select * from v$recovery_file_dest;

----------------------------------------------------------------------------------------------------------------------------------------

--FLASHBACK
select flashback_on from v$database;
alter database flashback off;

----------------------------------------------------------------------------------------------------------------------------------------

crosscheck backup;
delete expired backup;

========================================================================================================================================

--cat null_listener.sh 
#!/bin/bash
for i in listener*.log
do
echo "null > $i";
cat /dev/null > $i;
done

----------------------------------------------------------------------------------------------------------------------------------------


--CHECK LS -LRTH 
ls -lrth /backup*/prod/arch/PROD_arch_*.bk
find /backup*/prod/db/PROD_db_*.bk -mtime +3 -print -exec rm -fr {} \;

ls -lrth /zfssa/exapdb/backup*/opcbdl/db/
find /incdir_*/OPPRCISEIMC*.tr* -mtime +50 -exec rm -fr {} \;


----------------------------------------------------------------------------------------------------------------------------------------

--HK EXACM /u02
find /u02/app/oracle/diag/rdbms/od*/OD*/trace \( -name "OD*_ora_*.tr*" -a -type f \) -mtime +1 -exec rm -fr {} \;


--FILE_AUDIT
find /path/to/dir -name "*.aud" -mtime +14 -print -delete
nohup find /u02/app/oracle/product/12.1.0/dbhome_*/rdbms/audit -name '*.aud' -mtime +1 -exec rm -f {} \; &
find /u02/app/oracle/product/*/dbhome_*/rdbms/audit -name '*.aud' -mtime +1 -exec rm -f {} \;

--ADDM
find *addm*.txt -mtime +14 -exec rm -fr {} \;



----------------------------------------------------------------------------------------------------------------------------------------

--hitung berapa banyak file opscv yang lebih dari sehari
find . -name "OPRFSEVBSD1_ora*.tr*" -mtime +7 -print | wc -l
find . -name "OPSCVTBS2*.tr*" -mtime +1 -print | head

--delete file mtime +1
find . -name "OPRFSEVBSD1_ora*.tr*" -mtime +5 -print -delete 


--HK exacm
find /u01/app/oracle/admin/OP*/adump -name "*.aud" -mtime +7 -print -delete
find /u01/app/oracle/diag/rdbms/op*/OP*/trace -name "*.tr*" -mtime +7 -print -delete

----------------------------------------------------------------------------------------------------------------------------------------

--FILE_TRACE
find /var/opt/oracle/log/OD*/* -name "*.log" -mtime +1 -exec rm rm {} \;
find /u01/app/oracle/diag/rdbms/opccm/OPCCM2/trace \( -name "*.trc" -a -type f \) -mtime +6 -exec rm -fr {} \;
find /tmp/*.tmp -mtime +90 -print > /home/oracle/delete.txt

find /u01/app/oracle/diag/rdbms/opccm/OPCCM2/trace \( -name "*.trc" -a -type f \) -mtime +6 -exec rm -fr {} \;
find /u01/app/oracle/diag/rdbms/opccm/OPCCM2/trace \( -name "*.trm" -a -type f \) -mtime +6 -exec rm -fr {} \;
find /path/to/dir -name "*.aud" -mtime +14 -print -delete

nohup find /u01/app/oracle/diag/rdbms/op*/OP*/trace \( -name "OP*_ora_*.tr*" -a -type f \) -mtime +1 -exec rm -fr {} \; &
nohup find /u01/app/oracle/diag/rdbms/opicasmstbs/OPICASMSTBS1/trace \( -name "OP*_ora_*.tr*" -a -type f \) -mtime +1 -exec rm -fr {} \; 

nohup find /u01/app/oracle/admin/OP*/adump/ \( -name "*.aud" -a -type f \) -mtime +90 -exec rm -fr {} \; &


----------------------------------------------------------------------------------------------------------------------------------------

--FILE_CORE
find . -name "incdir*" -mtime +1 -print -delete 
find core* -mtime +2 | wc -l
find core* -mtime +2 -print -delete

find /u01/app/oracle/diag/rdbms/opdmsnew/OPDMS1/cdump/core* -mmin +30 -exec  rm -fr {} \;
find /u01/app/oracle/diag/rdbms/opdmsnew/OPDMS2/cdump/core* -mmin +30 -exec  rm -fr {} \;

----------------------------------------------------------------------------------------------------------------------------------------

find . -name "ohs1-201*.log" -mtime +90 -exec ls {} \;
find . -name "ohs1-20*.log" -mtime +90 -exec rm -fr {} \;


----------------------------------------------------------------------------------------------------------------------------------------
--HK SERVER APPS

mv *0_04_2022* 04_10_2023/
mv *1_04_2022* 04_10_2023/
mv *2_04_2022* 04_10_2023/
mv *3_04_2022* 04_10_2023/
mv *4_04_2022* 04_10_2023/
mv *5_04_2022* 04_10_2023/
mv *6_04_2022* 04_10_2023/
mv *7_04_2022* 04_10_2023/
mv *8_04_2022* 04_10_2023/
mv *9_04_2022* 04_10_2023/


rm *0_03_2022*
rm *2_03_2022*
rm *1_03_2022*
rm *3_03_2022*
rm *4_03_2022*
rm *5_03_2022*
rm *6_03_2022*
rm *7_03_2022*
rm *8_03_2022*
rm *9_03_2022*