***Administrasi Tablespace***
=============================

Check type-type segment.
	SQL> select distinct SEGMENT_TYPE from dba_segments;


Secara fisik, tablespace terdiri atas satu atau lebih datafile. 
Informasi tentang tablespace ada di view v$tablespace , dba_tablespaces, dba_data_files, dba_temp_files, dll.


Check types of tablespaces
	SQL> select distinct CONTENTS from dba_tablespaces; 

Berdasarkan hasil query tersebut, berikut ini 3 tipe tablespace:
1. UNDO. Untuk menyimpan rollback (undo) segment
2. TEMPORARY. Untuk menyimpan temporary segment
3. PERMANENT. Untuk menyimpan segment selain dua di atas (contoh tabel, index)

--------------------------------------------------------------------------------------------------------------------------------------------------

**UNDO TABLESPACE

1. Membuat Undo Tablespace undotbs2, datafile /oradata/oracle/ts_bak/undotbs201.dbf, 10M. 
	
	SQL> create undo tablespace undotbs2 datafile '/oradata/oracle/ts_bak/undotbs201.dbf' size 10m;

2. Menambah (menaikkan size/space) 
	
	SQL> alter database datafile '/oradata/oracle/ts_bak/undotbs201.dbf' resize 20m; 
	SQL> alter tablespace undotbs2 add datafile '/oradata/oracle/ts_bak/undotbs202.dbf' size 10m;

3. Melihat datafile dan size dari tablespace UNDOTBS2
	
	SQL> select file_name,bytes from dba_data_files where tablespace_name='UNDOTBS2';

4. Melihat free space tiap-tiap datafile dari tablespace UNDOTBS2

	SQL> select a.name, sum(b.bytes) from v$datafile a, dba_free_space b where a.file#=b.file_id and b.TABLESPACE_NAME='UNDOTBS2' group by a.name;

5. Melihat undo tablespace yang aktif saat ini gunakan 
	
	SQL> show parameter undo_tablespace
	
6. Mengubah undo_tablespace ke tablespace yang baru saja kita buat 

	SQL> alter system set undo_tablespace=UNDOTBS2;



--------------------------------------------------------------------------------------------------------------------------------------------------


**TEMPORARY TABLESPACE

1. Membuat temporay tablespace TEMP2 (!!!Gunakan tempfile bukan datafile)

	SQL> create temporary tablespace temp2 tempfile '/oradata/oracle/ts/temp21.dbf' size 10m;

2. Menambah (menaikkan size/space) 

	SQL> alter database tempfile '/oradata/oracle/ts/temp21.dbf' resize 20m; 
	SQL> alter tablespace temp2 add tempfile '/oradata/oracle/ts/temp22.dbf' size 10m;

3. Melihat temp file (file-file milik TEMPORARY tablespace) dan sizenya. 
	Contoh, misalkan nama TEMPORARY tablespace tersebut adalah TEMP:

	SQL> select file_name,bytes from dba_temp_files where tablespace_name='TEMP';

	Untuk melihat free spacenya
	SQL> select a.name, sum(b.BYTES_FREE) from v$tempfile a, V$TEMP_SPACE_HEADER b 
		where a.file#=b.file_id and b.TABLESPACE_NAME='TEMP' group by a.name;

4. Melihat temporary tablespace yang digunakan sebagai DEFAULT di db.

	SQL> select PROPERTY_VALUE from database_properties where PROPERTY_NAME='DEFAULT_TEMP_TABLESPACE'; 
	
5. Mengubah default temporary tablespace menjadi tablespace yang baru saja kita buat 
	
	SQL> alter database default temporary tablespace temp2;



--------------------------------------------------------------------------------------------------------------------------------------------------

**PERMANENT TABLESPACE

1. Membuat permanent tablespace DATA, datafile /oradata/oracle/ts_bak/data01.dbf, 10M. 

	SQL> create tablespace DATA datafile '/oradata/oracle/ts_bak/data01.dbf' size 10m;

2. Menambah (menaikkan size/space) 

	SQL> alter database datafile '/oradata/oracle/ts_bak/data01.dbf' resize 20m; 
	SQL> alter tablespace DATA add datafile '/oradata/oracle/ts_bak/data02.dbf' size 10m;

3. Melihat datafile, size, dan free size dari PERMANENT tablespace; 
	caranya seperti untuk UNDO tablespace, yaitu gunakan view dba_data_files, v$datafile, dan dba_free_space.

4. Melihat permanent tablespace yang digunakan sebagai DEFAULT di db.

	SQL> select PROPERTY_VALUE from database_properties where PROPERTY_NAME='DEFAULT_PERMANENT_TABLESPACE';

5. Mengubah default permanent tablespace menjadi tablespace yang baru saja kita buat
	
	SQL> alter database default tablespace data;














