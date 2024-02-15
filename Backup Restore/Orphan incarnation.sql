Errors in file /u01/app/oracle/diag/rdbms/opdgpostbs/OPDGPOSTBS1/trace/OPDGPOSTBS1_pr00_290219.trc:
ORA-19909: datafile 1 belongs to an orphan incarnation
ORA-01110: data file 1: '+DATAC2/OPDGPOSTBS/DATAFILE/system.7476.1062559129'


pastikan current dari list incarnation of database; antara primary dan standby sama.


RMAN> list incarnation of database;

using target database control file instead of recovery catalog

List of Database Incarnations
DB Key  Inc Key DB Name  DB ID            STATUS  Reset SCN  Reset Time
------- ------- -------- ---------------- --- ---------- ----------
1       1       OPDGPOS  2422706096       PARENT  1          15-JAN-18
2       2       OPDGPOS  2422706096       CURRENT 16027589716889 15-OCT-20
3       3       OPDGPOS  2422706096       ORPHAN  16141361709923 22-JAN-21

RMAN> 

change 
RMAN> reset database to incarnation 2;
