/*
 *  @description    : Master DDL for privileges
 *  @author        : Nicholas.Setiawan
 *  @creation_date    : 08-11-2018
 *  @last_update_date  : 08-11-2018
 */


GRANT CREATE PROCEDURE TO new_user;
GRANT CREATE ANY PROCEDURE TO new_user;
GRANT DEBUG ANY PROCEDURE TO new_user;
GRANT DROP ANY PROCEDURE TO new_user;
GRANT ALTER ANY PROCEDURE TO new_user;
GRANT EXECUTE ANY PROCEDURE TO new_user;

GRANT CREATE VIEW TO new_user;
GRANT CREATE ANY VIEW TO new_user;
GRANT DROP ANY VIEW TO new_user;

GRANT CREATE SEQUENCE TO new_user;
GRANT CREATE ANY SEQUENCE TO new_user;

GRANT CREATE PROCEDURE TO new_user;
GRANT CREATE ANY PROCEDURE TO new_user;
GRANT CREATE TRIGGER TO new_user;
GRANT CREATE ANY TRIGGER TO new_user;

GRANT CREATE MATERIALIZED VIEW TO new_user;
GRANT CREATE ANY MATERIALIZED VIEW TO new_user;
GRANT ALTER ANY MATERIALIZED VIEW TO new_user;
GRANT DROP ANY MATERIALIZED VIEW TO new_user;

GRANT CREATE TYPE TO new_user;
GRANT CREATE ANY TYPE TO new_user;

GRANT CREATE SYNONYM TO new_user;
GRANT CREATE ANY SYNONYM TO new_user;
GRANT DROP ANY SYNONYM TO new_user;
GRANT CREATE PUBLIC SYNONYM TO new_user;
GRANT DROP PUBLIC SYNONYM TO new_user;
GRANT SELECT ON SYS.dba_objects TO TO new_user;

GRANT SELECT ON SYS.V_$DATABASE TO new_user;
GRANT SELECT ON SYS.V_$INSTANCE TO new_user;
GRANT EXECUTE ON SYS.DBMS_WORKLOAD_REPOSITORY TO new_user;
GRANT SELECT ON SYS.DBA_HIST_DATABASE_INSTANCE TO new_user;
GRANT SELECT ON SYS.DBA_HIST_SNAPSHOT TO new_user;
GRANT SELECT ON dba_data_files TO new_user;
GRANT SELECT ON dba_users TO new_user;
GRANT SELECT ON dba_tables TO new_user;
GRANT SELECT ON dba_segments TO new_user;
GRANT SELECT ON dba_free_space TO new_user;
GRANT SELECT ON dba_tablespaces TO new_user;
GRANT SELECT ON dba_tab_partitions TO new_user;
GRANT SELECT ON dba_ind_partitions TO new_user;
GRANT SELECT ON dba_tab_subpartitions TO new_user;
GRANT SELECT ON dba_synonyms TO new_user;
GRANT SELECT ON dba_indexes TO new_user;
GRANT SELECT ON dba_extents TO new_user;
GRANT SELECT ON v$sql_plan TO new_user;
GRANT SELECT ON v$sql TO new_user;
GRANT SELECT ON v$sqltext TO new_user;
GRANT SELECT ON v$sqltext_with_newlines TO new_user;
GRANT SELECT ON v$transaction TO new_user;
GRANT SELECT ON v$sqlarea TO new_user;
GRANT SELECT ON v$locked_object TO new_user;
GRANT SELECT ON v$lock TO new_user;
GRANT SELECT ON v$process TO new_user;
GRANT SELECT ON v$session TO new_user;
GRANT SELECT ON v$parameter TO new_user;
GRANT SELECT ON v$datafile TO new_user;
GRANT SELECT ON v$instance TO new_user;
GRANT SELECT ON v$sqlarea TO new_user;
GRANT SELECT ON v$session_longops TO new_user;

GRANT SELECT ANY DICTIONARY TO new_user;
GRANT CREATE SESSION TO TO new_user;

GRANT SELECT ON dba_data_files TO new_user;
GRANT SELECT ON dba_users TO new_user;
GRANT SELECT ON dba_tables TO new_user;
GRANT SELECT ON dba_segments TO new_user;
GRANT SELECT ON dba_free_space TO new_user;
GRANT SELECT ON dba_tablespaces TO new_user;
GRANT SELECT ON dba_tab_partitions TO new_user;
GRANT SELECT ON dba_ind_partitions TO new_user;
GRANT SELECT ON dba_tab_subpartitions TO new_user;
GRANT SELECT ON dba_synonyms TO new_user;
GRANT SELECT ON dba_indexes TO new_user;
GRANT SELECT ON dba_extents TO new_user;
GRANT SELECT ON v$sql_plan TO new_user;
GRANT SELECT ON v$sql TO new_user;
GRANT SELECT ON v$sqltext TO new_user;
GRANT SELECT ON v$sqltext_with_newlines TO new_user;
GRANT SELECT ON v$transaction TO new_user;
GRANT SELECT ON v$sqlarea TO new_user;
GRANT SELECT ON v$locked_object TO new_user;
GRANT SELECT ON v$lock TO new_user;
GRANT SELECT ON v$process TO new_user;
GRANT SELECT ON v$session TO new_user;
GRANT SELECT ON v$parameter TO new_user;
GRANT SELECT ON v$datafile TO new_user;
GRANT SELECT ON v$instance TO new_user;
GRANT SELECT ON v$sqlarea TO new_user;
GRANT SELECT ON v$session_longops TO new_user;

GRANT CREATE JOB TO new_user;
GRANT CREATE EXTERNAL JOB TO new_user;
GRANT CREATE ANY JOB TO new_user;
GRANT EXECUTE ANY PROGRAM TO new_user;
GRANT EXECUTE ANY CLASS TO new_user;
GRANT MANAGE SCHEDULER TO new_user;