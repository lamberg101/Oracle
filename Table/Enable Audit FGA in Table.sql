1. Check TABLESPACE AUDIT
SQL> 
SELECT table_name,tablespace_name 
FROM dba_tables 
WHERE owner='SYS' 
AND table_name IN ('AUD$','FGA_LOG$');


2. create tablespace for audit
SQL> CREATE TABLESPACE AUDIT_TBS DATAFILE '+DATAC5' SIZE 1G AUTOEXTEND ON NEXT 1G MAXSIZE 30G;


3. MOVE TABLESPACE AUDIT TO NEW TABLESPACE:
SQL> begin
dbms_audit_mgmt.set_audit_trail_location(
audit_trail_type => dbms_audit_mgmt.audit_trail_aud_std,
audit_trail_location_value => 'AUDIT_TBS');
end;
/

SQL> begin
dbms_audit_mgmt.set_audit_trail_location(
audit_trail_type => dbms_audit_mgmt.audit_trail_fga_std,
audit_trail_location_value => 'AUDIT_TBS');
end;
/


4. Check STATUS POLICY
SQL>
col object_schema for a30
col object_name for a30
col policy_name for a30
SELECT object_schema,object_name,policy_name,enabled,audit_trail 
FROM DBA_AUDIT_POLICIES;



5. ENABLE LOG AUDIT:
--running nya pake ini:
$> nohup sqlplus / as sysdba @audit_EPC.sql > /home/oracle/audit_script.log &

SET TIMING ON
EXEC DBMS_FGA.ADD_POLICY(object_schema => 'EPC',object_name=>'CD_TRACKING_REF',policy_name=>'log_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.ADD_POLICY(object_schema => 'EPC',object_name=>'IFRS_PARAMS_DETAILS',policy_name=>'log_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.ADD_POLICY(object_schema => 'EPC',object_name=>'IFRS_POST_CATALOG',policy_name=>'log_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.ADD_POLICY(object_schema => 'EPC',object_name=>'PAYER_IDS_SIMULATOR',policy_name=>'log_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.ADD_POLICY(object_schema => 'EPC',object_name=>'REF_DEALER',policy_name=>'log_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.ADD_POLICY(object_schema => 'EPC',object_name=>'TB_ORDER_ACTION_IMPACT',policy_name=>'log_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.ADD_POLICY(object_schema => 'EPC',object_name=>'TBACT_TASK_DEFINITION',policy_name=>'log_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.ADD_POLICY(object_schema => 'EPC',object_name=>'TBACT_TASK_REJECT_CODES',policy_name=>'log_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.ADD_POLICY(object_schema => 'EPC',object_name=>'TBAUTO_OPERATIONS',policy_name=>'log_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.ADD_POLICY(object_schema => 'EPC',object_name=>'TBBO_ACT_OVERDUE',policy_name=>'log_audit', statement_types=>'insert,delete,update');
--Dan seterusnya.....



FOR Check AUDIT LOG:
===============
SET lines 200
col object_name FOR a30
col object_schema for a20
col policy_name for a20
col sql_text for a80
col db_user for a10
ALTER SESSION SET nls_date_format='dd-mon-yyyy hh24:mi:ss';
SELECT timestamp,db_user,object_schema,object_name,policy_name,sql_text 
FROM DBA_FGA_AUDIT_TRAIL 
ORDER by timestamp desc;



ROLLBACK PLAN:
================
EXEC DBMS_FGA.DROP_POLICY(object_name=>'EPC',object_name=>'CD_TRACKING_REF',policy_name=>'test_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.DROP_POLICY(object_name=>'EPC',object_name=>'IFRS_PARAMS_DETAILS',policy_name=>'test_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.DROP_POLICY(object_name=>'EPC',object_name=>'IFRS_POST_CATALOG',policy_name=>'test_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.DROP_POLICY(object_name=>'EPC',object_name=>'PAYER_IDS_SIMULATOR',policy_name=>'test_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.DROP_POLICY(object_name=>'EPC',object_name=>'REF_DEALER',policy_name=>'test_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.DROP_POLICY(object_name=>'EPC',object_name=>'TB_ORDER_ACTION_IMPACT',policy_name=>'test_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.DROP_POLICY(object_name=>'EPC',object_name=>'TBACT_TASK_DEFINITION',policy_name=>'test_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.DROP_POLICY(object_name=>'EPC',object_name=>'TBACT_TASK_REJECT_CODES',policy_name=>'test_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.DROP_POLICY(object_name=>'EPC',object_name=>'TBAUTO_OPERATIONS',policy_name=>'test_audit', statement_types=>'insert,delete,update');
EXEC DBMS_FGA.DROP_POLICY(object_name=>'EPC',object_name=>'TBBO_ACT_OVERDUE',policy_name=>'test_audit', statement_types=>'insert,delete,update');
--Dan seterusnya.....
