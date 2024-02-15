
---Check UNDO RETENTION
set linesize 300
SELECT d.undo_size/(1024*1024) "ACTUAL UNDO SIZE [MByte]",
       SUBSTR(e.value,1,25) "UNDO RETENTION [Sec]",
       ROUND((d.undo_size / (to_number(f.value) *
       g.undo_block_per_sec))) "OPTIMAL UNDO RETENTION [Sec]",
     (TO_NUMBER(e.value) * TO_NUMBER(f.value) *
       g.undo_block_per_sec) / (1024*1024) "NEEDED UNDO SIZE [MByte]"
  FROM (
       SELECT SUM(a.bytes) undo_size
          FROM v$datafile a,
               v$tablespace b,
               dba_tablespaces c
         WHERE c.contents = 'UNDO'
           AND c.status = 'ONLINE'
           AND b.name = c.tablespace_name
           AND a.ts# = b.ts#
       ) d,
       v$parameter e,
       v$parameter f,
       (
       SELECT MAX(undoblks/((end_time-begin_time)*3600*24))
              undo_block_per_sec
         FROM v$undostat
       ) g
WHERE e.name = 'undo_retention'
  AND f.name = 'db_block_size';


ACTUAL UNDO SIZE [MByte] 	UNDO RETENTION [Sec]	OPTIMAL UNDO RETENTION [Sec] 	NEEDED UNDO SIZE [MByte]
--------------------------	----------------------- ------------------------------  --------------------------
402459 						30000					948153 	      					12733.9844


Note!
--actual = size undo tbs nya (karena rac itu di gabung)
--undo retention = parameter sekarang
--optimal undo = parameter undo retention yang disarankan dengan total size yang sekarang
--needed undo = size undo kalo undo retention nya di set 900



----------------------------------------------------------------------------------------------------------------------------------

2. Set/resize undo retention

SQL> show parameter undo

NAME				     	TYPE	 	VALUE
------------------------	---------- -----------
temp_undo_enabled		    boolean	 	FALSE
undo_management 		    string	 	AUTO
undo_retention			    integer	 	28800
undo_tablespace 		    string	 	UNDOTBS1

SQL> alter system set undo_retention=90000 scope=both sid='*';


----------------------------------------------------------------------------------------------------------------------------------

3. Others.

alter system set undo_retention=450000 scope=both sid='*';
-->
alter system set undo_retention=450000 DEFERRED;
-->
alter system set undo_retention=450000 sid='TKOMS01';

alter system set undo_retention=3000 scope=both sid='*';

1. Check current state
sho parameter undo

2. resize undo_retention parameter
alter system set undo_retention=3000 scope=both sid='*';

3. Check the newest state
sho paremter undo
