1. Check last analyst

SET PAGESIZE 60
SET LINESIZE 300
SELECT T.OWNER,
       T.TABLE_NAME AS "TABLE NAME", 
       T.NUM_ROWS AS "ROWS", 
       T.AVG_ROW_LEN AS "AVG ROW LEN", 
       TRUNC((T.BLOCKS * P.VALUE)/1024) AS "SIZE KB", 
       TO_CHAR(T.LAST_ANALYZED,'DD/MM/YYYY HH24:MM:SS') AS "LAST ANALYZED"
FROM   DBA_TABLES T,
       V$PARAMETER P
WHERE T.OWNER = DECODE(UPPER('&&TABLE_OWNER'), 'ALL', T.OWNER, UPPER('&&TABLE_OWNER'))
AND   P.NAME = 'DB_BLOCK_SIZE'
AND T.TABLE_NAME='TABLE_NAME'
ORDER BY T.OWNER,T.LAST_ANALYZED,T.TABLE_NAME;


--------------------------------------------------------------------------------------------------------------
select OWNER, TABLE_NAME, LAST_ANALYZED 
from dba_tables 
where TABLE_NAME='COUNTER';

select index_name, owner, global_stats, last_analyzed 
from dba_indexes 
where owner ='OWNER' 
order by last_analyzed asc;

select table_name, owner, stale_stats, last_analyzed 
from dba_tab_statistics 
where owner='OWNER' 
order by last_analyzed asc;


via OEM: schema > database object > table/index..

--------------------------------------------------------------------------------------------------------------

2. Check LAST MODIF (dba_tab_modifications)

SELECT TABLE_OWNER, TABLE_NAME, INSERTS,UPDATES,DELETES,TRUNCATED,TIMESTAMP 
FROM DBA_TAB_MODIFICATIONS 
WHERE TABLE_NAME='PRODUCT_DISTRIBUTION' 
--TABLE_OWNER='PREPRD_ACTIVEOFFER'
GROUP BY TABLE_OWNER, TABLE_NAME, INSERTS,UPDATES,DELETES,TRUNCATED,TIMESTAMP;

