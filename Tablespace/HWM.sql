Contoh kasus
Resize tidak bisa dilakukan karena dulunya space 3G itu pernah kepakai. 
Mungkin dulu pernah sempat ada segment (table/index/temp segment) yang memakai tablespace SYSTEM, namun sekarang sudah dihapus.
Konsep yang berkaitan dengan hal ini adalah “High Water Mark”.

Kalau size tablespace (datafile) tidak bisa dikurangi dengan “alter database datafile ‘…’ resize” 
sementara itu free space-nya masih sangat banyak, satu-satunya solusi adalah recreate tablespace yang bersangkutan. 
Caranya:
	– export data-data yang ada di tablespace tsb
	– create tablespace baru
	– import data-data tsb ke tablespace baru
	– drop tablespace lama.

Namun sayangnya, tablespace SYSTEM tidak bisa di-recreate. Kalau masih mau dipaksa, ya dengan recreate database:
	– export database full
	– buat database baru
	– import database
	– drop database lama


==============================================================================================================================


set linesize 1000 pagesize 0 feedback off trimspool on
with
 hwm as (
  -- get highest block id from each datafiles ( from x$ktfbue as we don't need all joins from dba_extents )
  select /*+ materialize */ ktfbuesegtsn ts#,ktfbuefno relative_fno,max(ktfbuebno+ktfbueblks-1) hwm_blocks
  from sys.x$ktfbue group by ktfbuefno,ktfbuesegtsn
 ),
 hwmts as (
  -- join ts# with tablespace_name
  select name tablespace_name,relative_fno,hwm_blocks
  from hwm join v$tablespace using(ts#)
 ),
 hwmdf as (
  -- join with datafiles, put 5M minimum for datafiles with no extents
  select file_name,nvl(hwm_blocks*(bytes/blocks),5*1024*1024) hwm_bytes,bytes,autoextensible,maxbytes
  from hwmts right join dba_data_files using(tablespace_name,relative_fno)
 )
select
 case when autoextensible='YES' and maxbytes>=bytes
 then -- we generate resize statements only if autoextensible can grow back to current size
  '/* reclaim '||to_char(ceil((bytes-hwm_bytes)/1024/1024),999999)
   ||'M from '||to_char(ceil(bytes/1024/1024),999999)||'M */ '
   ||'alter database datafile '''||file_name||''' resize '||ceil(hwm_bytes/1024/1024)||'M;'
 else -- generate only a comment when autoextensible is off
  '/* reclaim '||to_char(ceil((bytes-hwm_bytes)/1024/1024),999999)
   ||'M from '||to_char(ceil(bytes/1024/1024),999999)
   ||'M after setting autoextensible maxsize higher than current size for file '
   || file_name||' */'
 end SQL
from hwmdf
where
 bytes-hwm_bytes>1024*1024 -- resize only if at least 1MB can be reclaimed
order by bytes-hwm_bytes desc
/



