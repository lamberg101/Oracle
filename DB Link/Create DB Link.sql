--SOURCE 
10.49.31.170
. .OPCRMBE

--TARGET
10.251.33.88
. .OPRFWL

--TANAM DI SOURCE
OPRFWL_link =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = exapdb62b-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPRFWL)
    )
  )

CREATE PUBLIC DATABASE LINK <NAMAUSER_SOURCE> CONNECT TO <USERNAME_TARGET> IDENTIFIED BY <PASSWD_USERNAME_TARGET> USING OPRFWL_link;


==================================================================================================================================


BOLAK BALIK
- source (OPBIBSD1) --ODBIBSDUSR/Tsel#2019
- target (OPTOIPIMC) --BPFORM/Tsel2012

--pre-check 
pastikan telnet and tnsping sudah aman, kalau belum, conn string di taru di target dan source


1. DATABASE SOURCE

--create (public) database link

CREATE PUBLIC DATABASE LINK MYLINK CONNECT TO REMOTE_USERNAME IDENTIFIED BY MYPASSWORD USING 'TNS_SERVICE_NAME';

contoh:
CREATE PUBLIC DATABASE LINK BPFORM_OPBIBSD CONNECT TO BPFORM IDENTIFIED BY Tsel2012 USING 'OPTOIPIMC';


--tes select.
select count(*) from BPFORM.DIGIPOS_OUTLET_REC_TMP@OPTOIPIMC;


-------------------------------------------------------------------------------------------------------------------------

2. DATABASE TARGET


--grant create db link
`GRANT CREATE DATABASE LINK to BPFORM;

--connect to user bpform
$ sqlplus BPFORM@OPTOIPIMC

create db link :
CREATE DATABASE LINK OPBIBSD_LINK CONNECT TO ODBIBSDUSR identified by Tsel#2019 USING 'OPBIBSD';
   
--check link
select count(*) from nama_segment@OPBIBSD_LINK;


--kalau tidak bisa pakai tns_names, pakai tns_connecction.
CREATE DATABASE LINK OPBIBSD_LINK CONNECT TO ODBIBSDUSR identified by Tsel#2019 USING 
'(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = exa62bsda-scan)(PORT = 1521))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = OPBIBSD)';


-------------------------------------------------------------------------------------------------------------------------

CREATE PUBLIC DATABASE LINK LINK_OPPREPRG 
CONNECT TO PREPREG IDENTIFIED BY pr3pR3g17 USING 'OPPREPRG';


create database link "DBLINKNAME"
connect to ICACB_SMS3
identified by "<pwd>"
using '(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = exapdb62tbsa-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = OPSMSICA19)))';

test connect
sqlplus CRM_RO@'(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = exapdb62tbsa-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = OPSCVTBS)))'

Note!
Kalau ga kebaca description nya using service, ngakalin di state description nya
yg existing di drop dulu.



jdbc:oracle:thin:@(DESCRIPTION=(TRANSPORT_CONNECT_TIMEOUT=5)(CONNECT_TIMEOUT=5)(RETRY_DELAY=10)(RETRY_COUNT=2)(FAILOVER=ON)(LOAD_BALANCE=off)(ADDRESS=(PROTOCOL=TCP)(HOST=db1-scan)(PORT=1521))(ADDRESS=(PROTOCOL=TCP)(HOST=db2-scan)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=testsrv)))

sqlplus HDPPOIN@'(DESCRIPTION =(ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = 10.2.230.105)(PORT = 1521)))(CONNECT_DATA =(SERVICE_NAME = ODPOINT)(UR = A)))'













