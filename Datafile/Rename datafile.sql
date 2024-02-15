
ORA-01110: data file 46: '/u01/app/oracle/product/12.1.0.2/dbhome_1/dbs/UNNAMED00046'
ORA-01157: cannot identify/lock data file 46 - see DBWR trace file
ORA-01111: name for data file 46 is unknown - rename to correct file
ORA-01110: data file 46: '/u01/app/oracle/product/12.1.0.2/dbhome_1/dbs/UNNAMED00046'
Mon Nov 29 23:23:05 2021
MRP0: Background Media Recovery process shutdown (OPB2BOPA1)
Mon Nov 29 23:56:51 2021


STANDBY
SQL>
select * from v$recover_file where error like '%FILE%';
SQL> 
select name from v$datafile where name like '%UNNAMED%';

PRIMARY
SQL> 
select file#, name from v$datafile where file#=46;

file#	name
---------------------
 46 	+DATAC4/OPB2BOP/DATAFILE/data_tables.42633.1089889463

Check path di asm standby
+DATAC1/OPB2BOPA/DATAFILE/DATA_TABLES_xxx


di standby
SQL> show parameter standby_file_management; --kalau belom manual di set ke manual
SQL> alter system set standby_file_management='manual';
SQL> show parameter standby_file_management;



rename datafile
alter database create datafile '/u01/app/oracle/product/12.1.0.2/dbhome_1/dbs/UNNAMED00046' as new;


setelah selesai, di balikin ke auto (kalau bikin dtaaguard standby_file_management nya auto
SQL> show parameter standby_file_management; --kalau belom manual di set ke manual
SQL> alter system set standby_file_management='auto';
SQL> show parameter standby_file_management;