BOLAK BALIK
- source (OPRCSBSD) LOOPPROD/ values 146489F3D64E6EB2
- target (OPHPOINTIMC) NEWTSPOIN/ values 9A4A39AF463BAC0E

grant ke view berikut V_LOYALTY_PERFORMANCE

OWNER				 VIEW_NAME
-------------------------------- -----------------------------------
NEWTSPOIN			 V_LOYALTY_PERFORMANCE


--pre-check 
(SERVICE_NAME = OPHPOINTIMC)
(SERVICE_NAME = OPRCSBSD)

select count(*) from nama_segment@OPBIBSD_LINK;

username : newtspoin
password : Tspoin#2013

-------------------------------------------------------------------------------------------------------------------------

1. DATABASE SOURCE

--create (public) database link

CREATE PUBLIC DATABASE LINK MYLINK CONNECT TO REMOTE_USERNAME IDENTIFIED BY MYPASSWORD USING 'TNS_SERVICE_NAME';

contoh:
CREATE PUBLIC DATABASE LINK NEWTSPOIN_LINK CONNECT TO NEWTSPOIN IDENTIFIED BY Tspoin#2013 USING 'OPHPOINTIMC';


--tes select.
select /*+ PARALLEL 4 */ COUNT(*) FROM NEWTSPOIN.V_LOYALTY_PERFORMANCE@NEWTSPOIN_LINK;
select * from dual@NEWTSPOIN_LINK;

-------------------------------------------------------------------------------------------------------------------------

2. DATABASE TARGET


--grant create db link
`GRANT CREATE DATABASE LINK to BPFORM;

--connect to user bpform
$ sqlplus BPFORM@OPTOIPIMC

create db link :
CREATE DATABASE LINK OPBIBSD_LINK CONNECT TO ODBIBSDUSR identified by Tsel#2019 USING 'OPBIBSD';
   
--check link


--kalau tidak bisa pakai tns_names, pakai tns_connecction.
CREATE DATABASE LINK OPBIBSD_LINK CONNECT TO ODBIBSDUSR identified by Tsel#2019 USING 
'(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = exa62bsda-scan)(PORT = 1521))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = OPBIBSD)';

















