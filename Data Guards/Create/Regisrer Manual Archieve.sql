PRIMARY exa62B - OPUIMIMC.

Masuk pake profile grid
. .grid_profile
asmcmd
ASMCMD> cd +RECOC2/OPUIMTBS/ARCHIVELOG/2020_03_21
ASMCMD> cp thread_1_seq_1623* /datadump9/opuimtbs/temp_archive/

********* Jika sudah copy diatas, lanjut copy lagi yang dibawah (ada ratusan files)*******
ASMCMD> cp thread_1_seq_1624* /datadump9/opuimtbs/temp_archive/
ASMCMD> exit


Catatan : 
- Sequences Thread#1 terakhir di 162439, dan itu akan generate terus
- jadi kalau pas copy file di asm nya ada yg sequence thread_1_seq_1625*
- langsung copy lagi dan tinggal register sesuai path nya yang di standby


***REGISTER ARCHIVE MANUAL****
STANDBY exaIMC - OPUIMIMC

Masuk profile OPUIMIMC
cd /zfssa/testet/backup9/opuimtbs/temp_archive/
chmod 777 thread*
cd
******
sqlplus / as sysdba
******
alter database register or replace logfile '/zfssa/testet/backup9/opuimtbs/temp_archive/thread_1_seq_162329.127188.1035590707';
alter database register or replace logfile '/zfssa/testet/backup9/opuimtbs/temp_archive/thread_1_seq_162330.40728.1035591713';
alter database register or replace logfile '/zfssa/testet/backup9/opuimtbs/temp_archive/thread_1_seq_162331.91736.1035592571';
alter database register or replace logfile '/zfssa/testet/backup9/opuimtbs/temp_archive/thread_1_seq_162332.127281.1035592945';
alter database register or replace logfile '/zfssa/testet/backup9/opuimtbs/temp_archive/thread_1_seq_162333.61561.1035593221';
alter database register or replace logfile '/zfssa/testet/backup9/opuimtbs/temp_archive/thread_1_seq_162334.38117.1035593505';
alter database register or replace logfile '/zfssa/testet/backup9/opuimtbs/temp_archive/thread_1_seq_162335.73645.1035593697';
alter database register or replace logfile '/zfssa/testet/backup9/opuimtbs/temp_archive/thread_1_seq_162336.142152.1035593879';
alter database register or replace logfile '/zfssa/testet/backup9/opuimtbs/temp_archive/thread_1_seq_162337.24827.1035594107';
alter database register or replace logfile '/zfssa/testet/backup9/opuimtbs/temp_archive/thread_1_seq_162338.141470.1035594399';
alter database register or replace logfile '/zfssa/testet/backup9/opuimtbs/temp_archive/thread_1_seq_162339.115385.1035594551';
--dan seterunsya, di sesuakian dengan gap nya


ngeCheck nya nanti kalau sudah register manual yah kaka :

#Check thread 1
select max(sequence#), thread#, applied from v$archived_log group by thread#,applied;

#Check thread 2
select min(sequence#), thread#, applied from v$archived_log group by thread#,applied;

#Check
SELECT PROCESS, STATUS, THREAD#, SEQUENCE#, BLOCK#, BLOCKS FROM V$MANAGED_STANDBY;