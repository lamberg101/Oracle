1. Check/collect file name.

select 'alter database datafile '|| file_name||' '||' autoextend on maxsize unlimited;' 
from dba_data_files;


------------------------------------------------------------------------------------------------------------------------------------------------

2. Check autoextensible

select TABLESPACE_NAME, FILE_NAME,AUTOEXTENSIBLE,MAXBYTES 
from dba_Data_files 
where autoextensible='NO';



------------------------------------------------------------------------------------------------------------------------------------------------

3. Add datafile autoextend off

alter tablespace DATAM01 add datafile '+OMSDATA' size 20G autoextend off;
alter tablespace IXL01 add datafile '/oradata/OPPOM/data/tkoms01/dbf/tkoms01_ixl01_198.dbf' size 21G autoextend off;

Note!
Check dulu numbering file nya, dan incremental from the last number.

