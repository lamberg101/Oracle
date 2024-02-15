Note! 
- Check dulu last_analyzed table nya dari dba_tables
- Check processs, gunakan longops 
- kalau banyak, gunakan nohup

----------------------------------------------------------------------------------------------------------------------------------------

#QUERY
exec dbms_stats.gather_table_stats('SCHEMA','TABLE_NAME', DEGREE => 20, estimate_percent => dbms_stats.auto_sample_size,cascade => true);
exec dbms_stats.gather_index_stats('SCHEMA','INDEX_NAME', DEGREE => 20, estimate_percent => dbms_stats.auto_sample_size,cascade => true);


Explanation!
- cascade (determines if index stats should be gathered for the current table 'true, false, auto_cascade')	
- degree (degree of parallelism)	
- estimate_percent (percentage of rows to sample when gathering stats '0.000001-100 or auto_sample_size')


#GATHER_STAT_OEM
- Database Home page.
- Performance > SQL > Optimizer Statistics.
- The Optimizer Statistics Console appears.


=======================================================================================================================================

Kalau ada error, stat ORA-20005: Object Statistics Are Locked (Stattype = ALL)

1. Check table
select owner, table_name, stattype_locked 
from DBA_TAB_STATISTICS 
where table_name='CX_BL_NIK' 
and owner='SIEBEL';

OWNER	     TABLE_NAME 	STATT
------------ --------------	---------------- 
SIEBEL	     CX_BL_NIK		ALL

--STATTYPE_LOCKED – ALL -> stats are locked for the table
--STATTYPE_LOCKED – NULL – > stats are not locked

2. Unlock stats:
EXEC DBMS_STATS.UNLOCK_TABLE_STATS('SCHEMA','TABLE_NAME');

3. Unlock shcema --jika perlu
EXEC DBMS_STATS.UNLOCK_SCHEMA_STATS('SCHEMA_NAME');






 