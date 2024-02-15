Check PRIMARY KEY GLOBAL

select owner, index_name, index_type, table_name, global_stats 
from dba_index 
where table_name='active over'


