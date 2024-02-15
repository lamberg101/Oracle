-- EXPDP
$> nohup expdp \'/ as sysdba\' 
directory=DUMP_C2PEVEN_NEW 
dumpfile=opc2pevn_tables_clone_120422_%U.dmp 
logfile=expdp_opc2pevn_tables_clone_120422.log 
PARALLEL=4 
tables=C2P_PROD.C2P_POSTPAID_TRANSACTION &


-- IMPDP
$> nohup impdp system/oracle@ODC2P3 
directory=DUMP_ODC2P3 
TABLES=C2P_PROD.C2P_POSTPAID_TRANSACTION 
REMAP_SCHEMA=C2P_PROD:C2PEVEN_DEV11 
REMAP_TABLESPACE=TRX_DATA_EVEN:TRX_DATA_EVEN 
dumpfile=opc2pevn_tables_clone_120422_%U.dmp 
logfile=imp_c2pevn_clone_12042022_new3.log 
CONTENT=DATA_ONLY 
parallel=4 &


--------------------------------------

--EXTRACT DLL from DUMP
nohup impdp system/oracle@ODC2P3 
directory=DUMP_ODC2P3 
TABLES=C2P_PROD.C2P_POSTPAID_TRANSACTION 
REMAP_SCHEMA=C2P_PROD:C2PEVEN_DEV11 
REMAP_TABLESPACE=TRX_DATA_ODD:TRX_DATA_EVEN 
dumpfile=opc2pevn_tables_clone_120422_%U.dmp 
logfile=imp_c2podd_clone_12042022_new1.log 
sqlfile=opc2evn_tables_clone_120422.sql &


Note! create table and solve acodringly
err sequence, create sequence then the table

select dbms_metadata.get_ddl('SEQUENCE', 'C2PPOSTPAIDTRX_ID_SEQ','C2P_PROD')from dual;
CREATE SEQUENCE  "C2PEVEN_DEV11"."C2PPOSTPAIDTRX_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 
START WITH 7465037 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
