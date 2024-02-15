set pages 50000 lines 32767
select owner,table_name,
round((blocks*8),2)||'kb' "Fragmented size", 
round((num_rows*avg_row_len/1024),2)||'kb' "Actual size", 
round((blocks*8),2)-round((num_rows*avg_row_len/1024),2)||'kb',
((round((blocks*8),2)-round((num_rows*avg_row_len/1024),2))/round((blocks*8),2))*100 -10 "reclaimable space % " 
from dba_tables 
where table_name ='&table_Name' 
AND OWNER LIKE '&schema_name';