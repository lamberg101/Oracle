Tbs non asm (auto extend off)

Note!
Nama, Size dan Path nya samain (size dan nama, Check manual ke folder atau pake script)
Nama datafile nya urutin nomer terakhir

#Autoextent (optional)
contoh
SQL> alter tablespace IXL01 add datafile '/oradata/OPPOM/data/tkoms01/dbf/tkoms01_ixl01_198.dbf' size 21G autoextend off;

contoh on
SQL> alter tablespace IXL01 add datafile '/oradata/OPPOM/data/tkoms01/dbf/tkoms01_ixl01_198.dbf' size 1G autoextend on next 100M maxsize 21G;



alter tablespace UNDOTBS add datafile '/oradata/OPPOM/data/tkoms01/dbf/tkoms01_undo_06.dbf' size 21G autoextend off;
alter tablespace UNDOTBS add datafile '/oradata/OPPOM/data/tkoms01/dbf/tkoms01_undo_07.dbf' size 21G autoextend off;
alter tablespace UNDOTBS add datafile '/oradata/OPPOM/data/tkoms01/dbf/tkoms01_undo_08.dbf' size 21G autoextend off;
alter tablespace UNDOTBS add datafile '/oradata/OPPOM/data/tkoms01/dbf/tkoms01_undo_09.dbf' size 21G autoextend off;
alter tablespace UNDOTBS add datafile '/oradata/OPPOM/data/tkoms01/dbf/tkoms01_undo_10.dbf' size 21G autoextend off;




/oradata/OPPOM/data/tkoms01/dbf/tkoms01_undo_01.dbf
/oradata/OPPOM/data/tkoms01/dbf/tkoms01_undo_02.dbf
/oradata/OPPOM/data/tkoms01/dbf/tkoms01_undo_03.dbf
/oradata/OPPOM/data/tkoms01/dbf/tkoms01_undo_04.dbf
/oradata/OPPOM/data/tkoms01/dbf/tkoms01_undo_05.dbf
/oradata/OPPOM/data/tkoms01/datafile/undotbs.651.956222103
/oradata/OPPOM/data/tkoms01/datafile/undotbs.691.971460423

