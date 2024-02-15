Note!
- temp tablespace itu temporary
- setelah process biasanya langsung realese
- contohnya, ada process insert dan size nya besar, setelah insert size akan kecil lagi.


2. TEMP Tablespace

--CREATE TEMP
SQL> CREATE TEMPORARY TABLESPACE TEMP TEMPFILE '+DATAC1' size 30G autoextend on next 1G maxsize 30G;


--INCREASE TEMP
SQL> ALTER TABLESPACE TEMP ADD TEMPFILE '+DATAC1' size 30G autoextend on next 1G maxsize 30G;



--DROP 
SQL> ALTER DATABASE TEMPFILE '/oradata/OPPOM/data/tkoms01/tempfile/temp.696.974173809' drop;


--SET DEFAULT
SQL>
select property_value
from database_properties
where property_name = 'DEFAULT_TEMP_TABLESPACE';

SQL> 
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE tbs_temp_01;