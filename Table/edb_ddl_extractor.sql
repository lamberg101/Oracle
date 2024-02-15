/*
################################################################################################
© 2019 EnterpriseDB® Corporation. All rights reserved.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


Author: EnterpriseDB
Version: 2.0.7

PreRequisites - Script USER must have SELECT_CATALOG_ROLE or SELECT ANY DICTIONARY privileges
              - SQLPLUS  prompts for the location to store extracted script 
Execution 
    SQL>@edb_ddl_extractor_multi_schema.sql 
        Enter SCHEMA NAME[S] (use ',' delimiter for multiple schemas) to extract DDLs  : HR
	Enter  PATH  to store DDL file	: /home/oracle/extracted_ddls/
 
 Following object types will be extracted by the SCRIPT 
 DB_LINK - FUNCTION - INDEXES - PACKAGE - PACKAGE_BODY - PROCEDURE
 SEQUENCES - SYNONYMS - TABLE - TRIGGER - TYPE - TYPE_BODY - VIEW 
 MT_VIEW - CONSTRAINTS

################################################################################################
*/
set verify off
set serveroutput on
set feed off

col uname new_value v_username
col sfile new_value v_filelocation

prompt 
prompt # -- EDB DDL Extractor Version 2.0.7 for Oracle Database -- # 
prompt # --------------------------------------------------------- #
accept v_s char prompt "Enter comma separated list of schemas to be extracted: "
accept v_path char prompt "Location for output file : "


set termout off

SELECT 
    '&v_s' uname,
    CASE 
        WHEN '&v_s' LIKE '%,%' THEN
            '&v_path'||'_gen_multi_ddls_'|| to_char(sysdate,'YYMMDDHH24MISS') ||'.sql'
        ELSE
            '&v_path'||'_gen_'|| replace(LOWER('&v_s'),'$','') || '_ddls_'|| to_char(sysdate,'YYMMDDHH24MISS') ||'.sql' 
    END sfile
FROM 
    dual;


--Create temporary table to hold names of schemas. 
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE edb$tmp_mp_tbl11001101';
   EXECUTE IMMEDIATE 'DROP TABLE edb$tmp_mp_tbl11001101';
   COMMIT;
EXCEPTION
    WHEN others THEN
        NULL;	
END;
/

BEGIN
    EXECUTE IMMEDIATE 'CREATE global temporary TABLE edb$tmp_mp_tbl11001101(srno varchar2(30),schema_name varchar2(300),schema_validation varchar2(10)) ON COMMIT PRESERVE ROWS';
EXCEPTION
    WHEN others THEN
        NULL;	
END;
/

set termout on

-- use binds to avoid stressing shared pool and hard parsing
var v_owner varchar2(300)
var v_count varchar2(30)
var v_count_system varchar2(30)
var v_count_invalid varchar2(30)

WHENEVER SQLERROR EXIT 0
BEGIN
    :v_owner := '&&v_username';
    INSERT INTO
        edb$tmp_mp_tbl11001101(schema_name,schema_validation)
    SELECT 
        DISTINCT schema_name, 
        CASE
            WHEN dba_users.username IN ('ANONYMOUS','APEX_PUBLIC_USER','APEX_030200','APEX_040000','APEX_040200','APPQOSSYS','AUDSYS','BI','CTXSYS','DMSYS','DBSNMP','DEMO','DIP','DMSYS',
					'DVF','DVSYS','EXFSYS','FLOWS_FILES','FLOWS_020100', 'FRANCK','GSMADMIN_INTERNAL','GSMCATUSER','GSMUSER','IX','LBACSYS','MDDATA','MDSYS','MGMT_VIEW','OE','OJVMSYS',
					'OLAPSYS','ORDPLUGINS','ORDSYS','ORDDATA','OUTLN','ORACLE_OCM','OWBSYS','OWBYSS_AUDIT','PM','RMAN','SH','SI_INFORMTN_SCHEMA','SPATIAL_CSW_ADMIN_USR',
					'SPATIAL_WFS_ADMIN_USR','SQLTXADMIN','SQLTXPLAIN','SYS','SYSBACKUP','SYSDG','SYSKM','SYSTEM','SYSMAN','TSMSYS','WKPROXY','WKSYS','WK_TEST','WMSYS','XDB','XS$NULL') THEN
                'SYSTEM'
            WHEN dba_users.username IS NOT NULL THEN
                'VALID'
            ELSE
                'INVALID'
        END schema_validation
    FROM
        (SELECT 
            CASE
            WHEN regexp_substr(:v_owner,'[^,]+',1,level) like '%"%"%' THEN
                replace(trim(regexp_substr(:v_owner,'[^,]+',1,level)),'"','')
            ELSE 
                trim(upper(regexp_substr(:v_owner,'[^,]+',1,level)))
            END schema_name
        FROM
            dual
        CONNECT BY 
            regexp_substr(:v_owner,'[^,]+',1,level) is not null) schema_names
        LEFT OUTER JOIN 
            dba_users dba_users
        ON 
        schema_names.schema_name = dba_users.username;

    SELECT count(*) INTO :v_count FROM edb$tmp_mp_tbl11001101 WHERE schema_validation = 'VALID';
    SELECT count(*) INTO :v_count_system FROM edb$tmp_mp_tbl11001101 WHERE schema_validation = 'SYSTEM';
    SELECT count(*) INTO :v_count_invalid FROM edb$tmp_mp_tbl11001101 WHERE schema_validation = 'INVALID';

    IF (:v_count < 1 AND (:v_count_system > 0 OR :v_count_invalid > 0)) THEN
        RAISE_APPLICATION_ERROR(-20001,'Looks like either you have entered system schema(s) or the entered schema(s) are not found.');
    END IF; 
END;
/
WHENEVER SQLERROR CONTINUE


-- Makeup SQLPLUS script parameters to write ddl in file
col ddl format a32000
set pagesize 0 tab off newp none emb on heading off feedback off verify off echo off trimspool on
set long 2000000000 linesize 9999 


-- Below statement gives message and list of dependant schemas which are not included in the list of extraction. 
prompt
SELECT
    'Given schema(s) list contain(s) objects which are dependant on objects from other schema(s), not mentioned in the list. EDB Migration Portal assessment may fail for such objects. It is suggested to extract all the related schemas together.' || CHR(10) ||
    'Dependant Schema name(s) : ' || SUBSTR (SYS_CONNECT_BY_PATH (referenced_owner , ', '), 2) ddl
FROM 
    (SELECT
        DISTINCT referenced_owner,
        ROW_NUMBER () OVER (ORDER BY referenced_owner ) s_name,
        COUNT (*) OVER () cnt
    FROM
        (SELECT 
            DISTINCT dba_dep.referenced_owner
        FROM 
            dba_dependencies dba_dep,
            edb$tmp_mp_tbl11001101 scm_tab
        WHERE
            dba_dep.owner = scm_tab.schema_name
            AND dba_dep.referenced_owner not in (select schema_name from edb$tmp_mp_tbl11001101 where schema_validation = 'VALID')
            AND scm_tab.SCHEMA_VALIDATION = 'VALID'
            AND dba_dep.referenced_owner not in
            ('ANONYMOUS','APEX_PUBLIC_USER','APEX_030200','APEX_040000','APEX_040200','APPQOSSYS','AUDSYS','BI','CTXSYS','DMSYS','DBSNMP','DEMO','DIP','DMSYS',
            'DVF','DVSYS','EXFSYS','FLOWS_FILES','FLOWS_020100', 'FRANCK','GSMADMIN_INTERNAL','GSMCATUSER','GSMUSER','IX','LBACSYS','MDDATA','MDSYS','MGMT_VIEW','OE','OJVMSYS',
            'OLAPSYS','ORDPLUGINS','ORDSYS','ORDDATA','OUTLN','ORACLE_OCM','OWBSYS','OWBYSS_AUDIT','PM','PUBLIC','RMAN','SH','SI_INFORMTN_SCHEMA','SPATIAL_CSW_ADMIN_USR',
            'SPATIAL_WFS_ADMIN_USR','SQLTXADMIN','SQLTXPLAIN','SYS','SYSBACKUP','SYSDG','SYSKM','SYSTEM','SYSMAN','TSMSYS','WKPROXY','WKSYS','WK_TEST','WMSYS','XDB','XS$NULL')))
WHERE 
    s_name = cnt
START WITH 
    s_name = 1
CONNECT BY s_name = PRIOR s_name + 1;


-- Makeup ddl transformation for dbms_metadata.get_ddl
BEGIN
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'PRETTY',TRUE);
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SQLTERMINATOR',TRUE);
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES',FALSE);
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE', FALSE);
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',FALSE);
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SPECIFICATION',FALSE);
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'CONSTRAINTS',TRUE);
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'REF_CONSTRAINTS',FALSE);
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SIZE_BYTE_KEYWORD',   FALSE);
END;
/


-- Start writing to file 


prompt 
SELECT 
    'Writing ' || SUBSTR (SYS_CONNECT_BY_PATH (schema_name , ', '), 2) || ' DDLs to ' || '&&v_filelocation' ddl
FROM 
    (SELECT 
        schema_name , 
        ROW_NUMBER () OVER (ORDER BY schema_name ) s_name,
        COUNT (*) OVER () cnt
    FROM 
        edb$tmp_mp_tbl11001101 
    WHERE 
        schema_validation = 'VALID')
WHERE 
    s_name = cnt
START WITH 
    s_name = 1
CONNECT BY s_name = PRIOR s_name + 1;

spool on
spool &&v_filelocation
prompt ######################################################################################################################
prompt ## EDB DDL Extractor Utility. Version: 2.0.7
prompt ##
SELECT '## Source Database Version: '|| banner FROM V$VERSION where rownum =1;
prompt ##
SELECT '## Extracted On: ' ||to_char(sysdate, 'DD-MM-YYYY HH24:MI:SS') EXTRACTION_TIME FROM dual;
prompt ######################################################################################################################
set termout off



spool off
set termout on
prompt Extracting SYNONYMS...
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## SYNONYM
prompt ########################################

SELECT
    dbms_metadata.get_ddl('SYNONYM', synonym_name, dba_syn.owner) ddl
FROM
    dba_synonyms dba_syn,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_syn.owner = scm_tab.schema_name
    AND scm_tab.schema_validation = 'VALID'
ORDER BY
    synonym_name;


spool off
set termout on
prompt Extracting DATABASE LINKS...
set termout off
spool &&v_filelocation append


prompt ########################################
prompt ## DATABASE LINKS
prompt ########################################

SELECT
    dbms_metadata.get_ddl('DB_LINK', db_link, dba_lin.owner) ddl
FROM
    dba_db_links dba_lin,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_lin.owner = scm_tab.schema_name
    AND scm_tab.schema_validation = 'VALID'
ORDER BY
    db_link;


spool off
set termout on
prompt Extracting TYPE/TYPE BODY...
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## TYPE SPECIFICATION
prompt ########################################

SELECT
    dbms_metadata.get_ddl('TYPE_SPEC', dba_obj.object_name,dba_obj.owner) ddl
FROM
    dba_objects dba_obj,
    (SELECT 
        NAME, 
        max(LEVEL) lvl 
    FROM
        (SELECT
            * 
        FROM 
            dba_dependencies dba_dep,
            edb$tmp_mp_tbl11001101 scm_tab 
        WHERE 
            dba_dep.type = 'TYPE' 
        AND 
            dba_dep.owner = scm_tab.schema_name) 
    CONNECT BY NOCYCLE referenced_name = PRIOR name 
    GROUP BY 
        name 
    ORDER BY 
        lvl) dba_dep,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_obj.object_type = 'TYPE'
    AND dba_obj.object_name NOT LIKE 'SYS_PLSQL_%'
    AND dba_obj.object_name = dba_dep.name
    AND dba_obj.owner = scm_tab.schema_name
    AND dba_obj.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID'
    AND NOT EXISTS 
    (SELECT
        * 
    FROM 
        all_source
    WHERE
        line = 1
        AND owner = scm_tab.schema_name
        AND type = dba_obj.object_type
        AND dba_obj.object_name = name
        AND regexp_like(text, '( wrapped$)|( wrapped )', 'cm'))
ORDER BY
    dba_dep.lvl;


prompt ########################################
prompt ## TYPE BODY
prompt ########################################

SELECT
    dbms_metadata.get_ddl('TYPE_BODY', dba_obj.object_name, dba_obj.owner) ddl
FROM
    dba_objects dba_obj,
    (SELECT 
        NAME, 
        max(LEVEL) lvl 
    FROM
        (SELECT 
            * 
        FROM 
            DBA_dependencies dba_dep,
            edb$tmp_mp_tbl11001101 scm_tab 
        WHERE 
            dba_dep.type = 'TYPE BODY' 
        AND dba_dep.owner = scm_tab.schema_name) 
    CONNECT BY NOCYCLE referenced_name = PRIOR name 
    GROUP BY 
        name 
    ORDER BY 
        lvl) dba_dep,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_obj.owner = scm_tab.schema_name
    AND dba_obj.object_type = 'TYPE BODY'
    AND dba_obj.object_name NOT LIKE 'SYS_PLSQL_%'
    AND dba_obj.object_name = dba_dep.name
    AND dba_obj.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID'
    AND NOT EXISTS 
    (SELECT
        * 
    FROM 
        all_source
    WHERE
        line = 1
        AND owner = scm_tab.schema_name
        AND type = dba_obj.object_type
        AND dba_obj.object_name = name
        AND regexp_like(text, '( wrapped$)|( wrapped )', 'cm'))
ORDER BY
    dba_dep.lvl;



spool off
set termout on
prompt Extracting SEQUENCES...
set termout off
spool &&v_filelocation append


prompt ########################################
prompt ## SEQUENCES 
prompt ########################################

SELECT
    dbms_metadata.get_ddl('SEQUENCE', sequence_name, dba_seq.SEQUENCE_OWNER) ddl
FROM
    dba_sequences dba_seq,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_seq.sequence_owner = scm_tab.SCHEMA_NAME 
    AND NOT EXISTS  
        (SELECT 
            object_name 
        FROM 
            dba_objects 
        WHERE 
            object_type='SEQUENCE' 
        AND generated='Y' 
        AND dba_objects.owner= dba_seq.SEQUENCE_OWNER 
        AND dba_objects.object_name=dba_seq.sequence_name)
    AND scm_tab.schema_validation = 'VALID'
ORDER BY
   sequence_name;
   


spool off
set termout on
prompt Extracting TABLEs...
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## TABLE DDL
prompt ########################################

SELECT
    CASE
        WHEN logging = 'NO' THEN
            replace(dbms_metadata.get_ddl('TABLE', dba_tab.table_name, dba_tab.owner),'CREATE TABLE','CREATE UNLOGGED TABLE') 
        ELSE
            dbms_metadata.get_ddl('TABLE', dba_tab.table_name, dba_tab.owner)
    END
    ddl 
FROM
    dba_tables dba_tab, 
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_tab.owner = scm_tab.schema_name
    AND dba_tab.IOT_TYPE IS NULL 
    AND dba_tab.CLUSTER_NAME IS NULL 
    AND TRIM(dba_tab.CACHE) = 'N' 
    AND dba_tab.COMPRESSION != 'ENABLED' 
    AND TRIM(dba_tab.BUFFER_POOL) != 'KEEP' 
    AND dba_tab.NESTED = 'NO'
    AND dba_tab.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID'
    AND NOT EXISTS 
        (SELECT 
            object_name 
        FROM 
            dba_objects 
        WHERE 
            object_type = 'MATERIALIZED VIEW' 
			AND owner = dba_tab.owner
			AND object_name=dba_tab.table_name)
    AND NOT EXISTS 
        (SELECT 
            table_name
        FROM 
            dba_external_tables
        WHERE 
            owner = dba_tab.owner
            AND table_name =dba_tab.table_name)
    AND NOT EXISTS 
        (SELECT 
            queue_table
        FROM 
            DBA_QUEUE_TABLES
        WHERE 
            owner = dba_tab.owner
            AND queue_table = dba_tab.table_name)
    AND dba_tab.table_name NOT LIKE 'BIN$%$_'
    AND lower(dba_tab.table_name) != 'edb$tmp_mp_tbl11001101'
    AND lower(dba_tab.table_name) != 'edb$tmp_mp_mw11001101'
ORDER BY
    dba_tab.table_name;

spool off
set termout on
prompt Extracting PARTITION Tables...
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## PARTITION TABLE DDL
prompt ########################################

SELECT
    dbms_metadata.get_ddl('TABLE', table_name, dba_par.owner) ddl
FROM
    dba_part_tables dba_par,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_par.owner = scm_tab.schema_name
    AND dba_par.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID'
    AND table_name NOT LIKE 'BIN$%$_'
ORDER BY
    table_name;

spool off
set termout on 
prompt Extracting CACHE Tables...
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## CACHE TABLE DDL
prompt ########################################

SELECT
    dbms_metadata.get_ddl('TABLE', table_name, dba_tab.owner) ddl
FROM
    dba_tables dba_tab,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_tab.owner = scm_tab.schema_name 
    AND trim(CACHE) = 'Y'
    AND dba_tab.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID'
ORDER BY 
    table_name;

spool off
set termout on
prompt Extracting CLUSTER Tables...
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## CLUSTER TABLE DDL
prompt ########################################

SELECT
    dbms_metadata.get_ddl('TABLE', table_name, dba_tab.owner) ddl
FROM
    dba_tables dba_tab,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_tab.owner = scm_tab.schema_name
    AND CLUSTER_NAME IS NOT NULL
    AND dba_tab.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID' 
ORDER BY
    table_name;

spool off
set termout on
prompt Extracting KEEP Tables...
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## KEEP TABLE DDL
prompt ########################################

SELECT
    dbms_metadata.get_ddl('TABLE', table_name, dba_tab.owner) ddl
FROM
    dba_tables dba_tab,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_tab.owner = scm_tab.schema_name
    AND BUFFER_POOL != 'DEFAULT'
    AND dba_tab.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID'
ORDER BY
    table_name;

spool off
set termout on
prompt Extracting INDEX ORGANIZED Tables...
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## IOT TABLE DDL
prompt ########################################

SELECT
    dbms_metadata.get_ddl('TABLE', table_name, dba_tab.owner) ddl
FROM
    dba_tables dba_tab,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_tab.owner = scm_tab.schema_name
    AND IOT_TYPE = 'IOT'
    AND dba_tab.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID'
    AND table_name NOT LIKE 'BIN$%$_'
ORDER BY
    table_name;

spool off
set termout on
prompt Extracting COMPRESSED Tables...
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## COMPRESSED TABLE DDL
prompt ########################################

SELECT
    dbms_metadata.get_ddl('TABLE', table_name, dba_tab.owner) ddl
FROM
    dba_tables dba_tab,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_tab.owner = scm_tab.schema_name
    AND COMPRESSION = 'ENABLED'
    AND dba_tab.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID'
ORDER BY
    table_name;


spool off
set termout on
prompt Extracting EXTERNAL Tables..
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## EXTERNAL TABLE DDL
prompt ########################################

SELECT
    dbms_metadata.get_ddl('TABLE', table_name, dba_ext.owner) ddl
FROM
    dba_external_tables dba_ext,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_ext.owner = scm_tab.schema_name
    AND scm_tab.schema_validation = 'VALID'
ORDER BY
    table_name;


spool off
set termout on
prompt Extracting INDEXES...
set termout off 
spool &&v_filelocation append

prompt ########################################
prompt ## INDEXES DDL
prompt ########################################

SELECT
    dbms_metadata.get_ddl('INDEX', index_name, dba_ind.owner) ddl
FROM
    dba_indexes dba_ind,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_ind.owner = scm_tab.schema_name
    AND generated = 'N'
    AND index_type != 'LOB'
    AND status != 'UNUSABLE'
    AND scm_tab.schema_validation = 'VALID'
    AND NOT EXISTS 
        (SELECT 
            constraint_name 
        FROM 
            dba_constraints 
        WHERE 
            owner=dba_ind.owner 
			AND constraint_type IN('P','U') 
			AND dba_ind.index_name=dba_constraints.constraint_name)
    AND NOT EXISTS 
        (SELECT 
            object_name 
        FROM 
            dba_objects 
        WHERE 
            object_type = 'MATERIALIZED VIEW' 
			AND owner = dba_ind.owner 
			AND dba_objects.object_name=dba_ind.table_name)
    AND NOT EXISTS 
        (SELECT 
            queue_table
        FROM 
            DBA_QUEUE_TABLES
        WHERE 
            owner = dba_ind.owner
            AND queue_table = dba_ind.table_name)
    AND index_name NOT LIKE 'BIN$%$_'
ORDER BY
    index_name;


spool off
set termout on
prompt Extracting CONSTRAINTS...
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## CONSTRAINTS
prompt ########################################
Prompt ## Foreign Keys
Prompt ###############
prompt 

SELECT
    CASE
        WHEN dc.generated = 'USER NAME' THEN
            dbms_metadata.get_ddl('REF_CONSTRAINT', dc.constraint_name, dc.owner)
        WHEN dc.generated = 'GENERATED NAME' THEN
            replace(dbms_metadata.get_ddl('REF_CONSTRAINT', dc.constraint_name, dc.owner),'ADD FOREIGN KEY','ADD CONSTRAINT "'||substr(dc.table_name,1,10)||'_'||substr(dcc.COLUMN_NAME,1,10)||'_FKEY'||'" FOREIGN KEY')
        END ddl
FROM
    dba_constraints dc,
    dba_cons_columns dcc,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dc.owner = scm_tab.schema_name
    AND dc.constraint_type = 'R'
    AND dc.constraint_name = dcc.constraint_name
    AND dcc.owner = scm_tab.schema_name
    AND dcc.position = 1
    AND dc.STATUS = 'ENABLED'
    AND scm_tab.schema_validation = 'VALID'
    AND dc.constraint_name NOT LIKE 'BIN$%$_'
ORDER BY
    dc.constraint_name;

spool off
set termout on
prompt Extracting VIEWs..
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## VIEWS
prompt ########################################

SELECT
    dbms_metadata.get_ddl('VIEW', dba_obj.object_name, dba_obj.owner) ddl
FROM
    dba_objects dba_obj, 
    (SELECT 
        NAME, 
        MAX(LEVEL) lvl
    FROM
        (SELECT 
            * 
        FROM 
            dba_dependencies dba_dep,
            edb$tmp_mp_tbl11001101 scm_tab 
        WHERE 
            dba_dep.owner = scm_tab.schema_name 
            AND type = 'VIEW' ) 
        CONNECT BY NOCYCLE referenced_name = PRIOR name 
        GROUP BY 
            name 
        ORDER BY lvl) dba_dep,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_obj.owner = scm_tab.schema_name
    AND dba_obj.object_type = 'VIEW'
    AND dba_obj.object_name = dba_dep.name
    AND dba_obj.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID'
    AND NOT EXISTS 
        (SELECT 
            name 
        FROM 
            DBA_DEPENDENCIES 
        WHERE 
            owner = dba_obj.owner 
            AND type = 'VIEW' 
            AND referenced_type = 'TABLE' 
            AND EXISTS 
                (SELECT 
                    queue_table 
                FROM 
                    DBA_QUEUE_TABLES 
                WHERE 
                    queue_table = DBA_DEPENDENCIES.REFERENCED_NAME) 
            AND dba_obj.object_name = name)
ORDER BY dba_dep.lvl;


spool off
set termout on
prompt Extracting MATERIALIZED VIEWs...
set termout off


BEGIN
	EXECUTE IMMEDIATE 'CREATE global temporary TABLE edb$tmp_mp_mw11001101(owner varchar2(30),mview_name varchar2(30),query CLOB, build_mode varchar2(9)) ON COMMIT PRESERVE ROWS';
EXCEPTION
    WHEN others THEN
        NULL;
END;
/

DECLARE
    CURSOR c IS 
        SELECT
            CASE 
                WHEN (dba_mv.build_mode = 'PREBUILT') THEN
                    'IMMEDIATE'
                ELSE dba_mv.build_mode
            END build_mode,
            dba_mv.query,
            dba_mv.mview_name,
            dba_mv.owner
        FROM
            dba_mviews dba_mv, 
            (SELECT NAME, MAX(LEVEL) lvl FROM
            (SELECT * FROM dba_dependencies dba_dep,edb$tmp_mp_tbl11001101 scm_tab WHERE dba_dep.owner = scm_tab.schema_name AND type = 'MATERIALIZED VIEW' ) 
            CONNECT BY NOCYCLE referenced_name = PRIOR name GROUP BY name order by lvl) dba_dep,
            edb$tmp_mp_tbl11001101 scm_tab
        WHERE
            dba_mv.owner = scm_tab.schema_name
            AND dba_mv.mview_name = dba_dep.name
	    AND dba_mv.compile_state = 'VALID'
            AND scm_tab.schema_validation = 'VALID'
        ORDER BY dba_dep.lvl;
    var_query CLOB;
BEGIN
    FOR i IN c
    LOOP
        var_query := substr(i.query,0);
        INSERT INTO edb$tmp_mp_mw11001101 VALUES(i.owner,i.mview_name,var_query,i.build_mode);
    END LOOP;
    commit;
END;
/

spool &&v_filelocation append
prompt ########################################
prompt ## MATERIALIZED VIEWS
prompt ########################################


SELECT
    'CREATE MATERIALIZED VIEW "' || owner || '"."' || mview_name ||  '" BUILD ' || build_mode || ' REFRESH ON DEMAND AS ' || query || ';' ddl
FROM
    edb$tmp_mp_mw11001101;

spool off

BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE edb$tmp_mp_mw11001101';
   EXECUTE IMMEDIATE 'DROP TABLE edb$tmp_mp_mw11001101';
   COMMIT;
EXCEPTION
    WHEN others THEN
        NULL;
end;
/


set termout on
prompt Extracting TRIGGERs..
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## TRIGGERS
prompt ########################################

SELECT
    dbms_metadata.get_ddl('TRIGGER', object_name, dba_obj.owner) ddl
FROM
    dba_objects dba_obj,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_obj.owner = scm_tab.schema_name
    AND object_type = 'TRIGGER'
    AND dba_obj.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID'
    AND object_name NOT LIKE 'BIN$%$_'
ORDER BY
    object_name;



spool off
set termout on
prompt Extracting FUNCTIONS...
set termout off
spool &&v_filelocation append


prompt ########################################
prompt ## FUNCTIONS
prompt ########################################

SELECT
    dbms_metadata.get_ddl('FUNCTION', object_name, dba_obj.owner) ddl
FROM
    dba_objects dba_obj,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_obj.owner = scm_tab.schema_name
    AND object_type = 'FUNCTION'
    AND dba_obj.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID'
    AND NOT EXISTS 
    (SELECT
        * 
    FROM 
        all_source
    WHERE
        line = 1
        AND owner = scm_tab.schema_name
        AND type = dba_obj.object_type
        AND dba_obj.object_name = name
        AND regexp_like(text, '( wrapped$)|( wrapped )', 'cm'))
ORDER BY
    object_name;

spool off
set termout on
prompt Extracting PROCEDURES...
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## PROCEDURES
prompt ########################################

SELECT
    dbms_metadata.get_ddl('PROCEDURE', object_name, dba_obj.owner) ddl
FROM
    dba_objects dba_obj,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_obj.owner = scm_tab.schema_name
    AND object_type = 'PROCEDURE'
    AND dba_obj.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID'
    AND NOT EXISTS 
    (SELECT
        * 
    FROM 
        all_source
    WHERE
        line = 1
        AND owner = scm_tab.schema_name
        AND type = dba_obj.object_type
        AND dba_obj.object_name = name
        AND regexp_like(text, '( wrapped$)|( wrapped )', 'cm'))
ORDER BY
    object_name;

spool off
set termout on
prompt Extracting PACKAGE/PACKAGE BODY...
set termout off
spool &&v_filelocation append

prompt ########################################
prompt ## PACKAGE SPECIFICATION 
prompt ########################################

        
SELECT
    dbms_metadata.get_ddl('PACKAGE_SPEC', object_name, dba_obj.owner) ddl
FROM
    dba_objects dba_obj,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_obj.owner = scm_tab.schema_name
    AND object_type = 'PACKAGE'
    AND dba_obj.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID'
    AND NOT EXISTS 
    (SELECT
        * 
    FROM 
        all_source
    WHERE
        line = 1
        AND owner = scm_tab.schema_name
        AND type = dba_obj.object_type
        AND dba_obj.object_name = name
        AND regexp_like(text, '( wrapped$)|( wrapped )', 'cm'))
ORDER BY
    object_name;

prompt ########################################
prompt ## PACKAGE BODY
prompt ########################################

SELECT
    dbms_metadata.get_ddl('PACKAGE_BODY', object_name, dba_obj.owner) ddl
FROM
    dba_objects dba_obj,
    edb$tmp_mp_tbl11001101 scm_tab
WHERE
    dba_obj.owner = scm_tab.schema_name
    AND object_type = 'PACKAGE BODY'
    AND dba_obj.status = 'VALID'
    AND scm_tab.schema_validation = 'VALID'
    AND NOT EXISTS 
    (SELECT
        * 
    FROM 
        all_source
    WHERE
        line = 1
        AND owner = scm_tab.schema_name
        AND type = dba_obj.object_type
        AND dba_obj.object_name = name
        AND regexp_like(text, '( wrapped$)|( wrapped )', 'cm'))
ORDER BY
    object_name;


set termout on
prompt 


SELECT 
    '## Successfully Extracted Schema(s) : ' || SUBSTR (SYS_CONNECT_BY_PATH (schema_name , ', '), 2) ddl
FROM 
    (SELECT 
        schema_name , 
        ROW_NUMBER () OVER (ORDER BY schema_name ) s_name,
        COUNT (*) OVER () cnt
    FROM 
        edb$tmp_mp_tbl11001101 
    WHERE 
        schema_validation = 'VALID')
WHERE 
    s_name = cnt
START WITH 
    s_name = 1
CONNECT BY s_name = PRIOR s_name + 1;


SELECT 
    '## Schema(s) Not Found : ' || SUBSTR (SYS_CONNECT_BY_PATH (schema_name , ', '), 2) ddl
FROM 
    (SELECT 
        schema_name , 
        ROW_NUMBER () OVER (ORDER BY schema_name ) s_name,
        COUNT (*) OVER () cnt
    FROM 
        edb$tmp_mp_tbl11001101 
    WHERE 
        schema_validation = 'INVALID')
WHERE 
    s_name = cnt
START WITH 
    s_name = 1
CONNECT BY s_name = PRIOR s_name + 1;


SELECT 
    '## System Schema(s) Not Extracted : ' || SUBSTR (SYS_CONNECT_BY_PATH (schema_name , ', '), 2) ddl
FROM 
    (SELECT 
        schema_name , 
        ROW_NUMBER () OVER (ORDER BY schema_name ) s_name,
        COUNT (*) OVER () cnt
    FROM 
        edb$tmp_mp_tbl11001101 
    WHERE 
        schema_validation = 'SYSTEM')
WHERE 
    s_name = cnt
START WITH 
    s_name = 1
CONNECT BY s_name = PRIOR s_name + 1;


set termout off
spool off

set termout on
prompt
SELECT 
    'We have stored DDL(s) for Schema(s) ' || SUBSTR (SYS_CONNECT_BY_PATH (schema_name , ', '), 2) || ' to ' || '&&v_filelocation' || '.' ddl
FROM 
    (SELECT 
        schema_name , 
        ROW_NUMBER () OVER (ORDER BY schema_name ) s_name,
        COUNT (*) OVER () cnt
    FROM 
        edb$tmp_mp_tbl11001101 
    WHERE 
        schema_validation = 'VALID')
WHERE 
    s_name = cnt
START WITH 
    s_name = 1
CONNECT BY s_name = PRIOR s_name + 1;

SELECT 
    'Kindly note that we have removed $ symbol from the name of extracted file.' ddl
FROM
    edb$tmp_mp_tbl11001101 
WHERE 
    schema_validation = 'VALID'
    AND schema_name like '%$%'
    AND (select count(*) from edb$tmp_mp_tbl11001101) = 1;

prompt Upload this file to EDB Migration Portal to check compatibility against EDB Postgres Advanced Server.
prompt 
prompt NOTE : DDL Extractor does not extract objects having names like 'BIN$b54+4XlEYwPgUAB/AQBWwA==$0',
prompt If you want to extract these objects, you must change the name of the objects and re-run this extractor. 
prompt
set termout off

BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE edb$tmp_mp_tbl11001101';
   EXECUTE IMMEDIATE 'DROP TABLE edb$tmp_mp_tbl11001101';
   COMMIT;
EXCEPTION
    WHEN others THEN
        NULL;	
END;
/


exit
