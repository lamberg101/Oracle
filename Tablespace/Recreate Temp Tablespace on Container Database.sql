1. Connect to the database (without login to the container)
$. ODPOMC.env
$cd /u02/dpump/lina
$sqlplus / as sysdba

2. Create Temporary tablespace (ex. bellow is bigfile)
SQL> CREATE BIGFILE TEMPORARY TABLESPACE TEMP2 TEMPFILE '+DATAC1' SIZE 500G AUTOEXTEND ON NEXT 4G MAXSIZE 1000G;  

3. Alter default temporary tablespace
SQL> ALTER DATABASE DEFAULT TEMPORARY TABLESPACE TEMP2;

4. Login to container and alter default temporary
SQL> ALTER session set container=ODPOM;
SQL> ALTER PLUGGABLE DATABASE DEFAULT TEMPORARY TABLESPACE TEMP2;
SQL> exit

5. Crosschek
$sqlplus / as sysdba
SQL> SELECT PROPERTY_VALUE FROM DATABASE_PROPERTIES WHERE PROPERTY_NAME = 'DEFAULT_TEMP_TABLESPACE';

6. Drop the Old temporary tablespace
SQL> DROP TABLESPACE TEMP INCLUDING CONTENTS AND DATAFILES;