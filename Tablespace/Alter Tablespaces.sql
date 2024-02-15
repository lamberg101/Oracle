
alter tablespace TBS_PART_ add datafile '+DATA1' size 100M autoextend on next 512M maxsize 30G;

ALTER TABLESPACE CUSTORDER_TRX AUTOEXTEND ON NEXT 1G MAXSIZE 300G;

------------------------------------------------------------------------------------------------------------------------

--RESIZE TABLESPACE
alter tablespace TEMP resize 30G;
alter database datafile '+DATAC5/OPPOMTBS/DATAFILE/probttbs2_ias_opss.6477.1024238345' resize 120M;
alter database datafile '/+DATA/df0101.dbf' resize 180G;


alter tablespace DATA resize 400G;
alter tablespace SYSAUX resize 30G;
alter tablespace SYSTEM resize 30G;

alter tablespace UNDOTBS1 resize 30G;



--UNDO 
create UNDO TABLESPACE UNDOTBS1 datafile '+DATAC1/ODBIC/DATAFILE/undotbs1.dbf' size 100G;
alter tablespace UNDOTBS1 add datafile '+DATAC5' size 1G autoextend on next 100M maxsize 30G;
alter tablespace UNDOTBS add datafile '/DATA5/ORADISK08/OPRD016/UNDOTBS_003.DBF' size 1G autoextend on next 100M maxsize 3G;

create UNDO TABLESPACE UNDOTBS2 datafile '+DATAC1' size 1G autoextend on next 100M maxsize 30G;


--CREATE BIGFILE TABLESPACE
CREATE BIGFILE TABLESPACE TRX_DATA_TEMP  DATAFILE '+DATAC4' SIZE 1G AUTOEXTEND ON NEXT 512M MAXSIZE 300G;


--CONTAINER DATABASE
alter tablespace DATA autoextend on next 100M maxsize 100G;

alter tablespace UNDOTBS1 autoextend on next 100M maxsize 50G;
alter tablespace TEMP autoextend on next 100M maxsize 100G;


--INCREASE TEMP
alter tablespace TEMP add tempfile '+DATAC1' size 30G autoextend on next 1G maxsize 30G;


--AUTOEXTEND OFF
alter tablespace TBS_NAME add datafile '+OMSDATA' size 30G autoextend off;
alter tablespace TBS_NAME add datafile '/oradata/OPPOM/data/tkoms01/dbf/tkoms01_undo_06.dbf' size 21G autoextend off;

--ADD BIGFILE TABLESPACE
ALTER TABLESPACE DOM AUTOEXTEND ON NEXT 1G MAXSIZE 250G;

--when used nya minus
alter database datafile '+ASM/path/path/datafile.dbf' autoextend on next 5G maxsize 1200G;
alter database datafile '+ASM/path/path/datafile.dbf' resize 1000G;


--OFFLINE TABLESPACE
alter tablespace DGPOS_DATA offline;


--CHANGE MAXSIZE
ALTER DATABASE DATAFILE '+DATAC1/ODDPOSC/ODDPOS/oddpos_users.dbf' AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
Note! 
Itu karena maxsize nya lebih kecil dari alokasi bytes nya gung, makanya minus
Ubah maxsize nya aja jadi 30gb

------------------------------------------------------------------------------------------------------------------------

resize to be 30G:
-----------------
ALTER DATABASE DATAFILE '+DATAC5/OPPOMTBS/DATAFILE/datal04.2207.1096831849' RESIZE 30720M;

disable autoextend:
-------------------
ALTER DATABASE DATAFILE '+DATAC5/OPPOMTBS/DATAFILE/datal04.2207.1096831849' AUTOEXTEND OFF;
