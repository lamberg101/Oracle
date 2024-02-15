1. offline 
alter tablespace TRACKINGSTREAM_IDX_032019 offline;



2. online
alter tablespace TS_CMR_OFF_WL_DTL_201506 online;



SQL> select count(status) from dba_tablespaces where status='OFFLINE' group by status;

no rows selected

SQL> select count(status) from dba_tablespaces where status='ONLINE' group by status;

COUNT(STATUS)
-------------
	  675

SQL> select name from v$database;
!hostname
!date

NAME
---------
OPHPOINT

SQL> exaimcpdb01-mgt.telkomsel.co.id

SQL> Wed Jul 29 13:51:47 WIB 2020
