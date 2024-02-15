set colsep '|'
COL roles FOR a90
COL table_name FOR a30
col privilege for a30
col owner for a30
col grantee for a30
col COLUMN_NAME for a30
set lin 200 trims on pages 0 emb on hea on newp none
  SELECT *
    FROM (    SELECT CONNECT_BY_ROOT grantee grantee,
                     privilege,
                     REPLACE (
                        REGEXP_REPLACE (SYS_CONNECT_BY_PATH (granteE, '/'),
                                        '^/[^/]*'),
                        '/',
                        ' --> ')
                        ROLES,
                     owner,
                     table_name,
                     column_name
                FROM (SELECT PRIVILEGE,
                             GRANTEE,
                             OWNER,
                             TABLE_NAME,
                             NULL column_name
                        FROM DBA_TAB_PRIVS
                       WHERE owner NOT IN
                                ('SYS',
                                 'SYSTEM',
                                 'WMSYS',
                                 'SYSMAN',
                                 'MDSYS',
                                 'ORDSYS',
                                 'XDB',
                                 'WKSYS',
                                 'EXFSYS',
                                 'OLAPSYS',
                                 'DBSNMP',
                                 'DMSYS',
                                 'CTXSYS',
                                 'WK_TEST',
                                 'ORDPLUGINS',
                                 'OUTLN',
                                 'ORACLE_OCM',
                                 'APPQOSSYS')
						UNION 
                      SELECT PRIVILEGE,
                             GRANTEE,
                             OWNER,
                             TABLE_NAME,
                             column_name
                        FROM DBA_COL_PRIVS
                       WHERE owner NOT IN
                                ('SYS',
                                 'SYSTEM',
                                 'WMSYS',
                                 'SYSMAN',
                                 'MDSYS',
                                 'ORDSYS',
                                 'XDB',
                                 'WKSYS',
                                 'EXFSYS',
                                 'OLAPSYS',
                                 'DBSNMP',
                                 'DMSYS',
                                 'CTXSYS',
                                 'WK_TEST',
                                 'ORDPLUGINS',
                                 'OUTLN',
                                 'ORACLE_OCM',
                                 'APPQOSSYS')
                      UNION 
                      SELECT GRANTED_ROLE,
                             GRANTEE,
                             NULL,
                             NULL,
                             NULL
                        FROM DBA_ROLE_PRIVS
                       WHERE GRANTEE NOT IN
                                ('SYS',
                                 'SYSTEM',
                                 'WMSYS',
                                 'SYSMAN',
                                 'MDSYS',
                                 'ORDSYS',
                                 'XDB',
                                 'WKSYS',
                                 'EXFSYS',
                                 'OLAPSYS',
                                 'DBSNMP',
                                 'DMSYS',
                                 'CTXSYS',
                                 'WK_TEST',
                                 'ORDPLUGINS',
                                 'OUTLN',
                                 'ORACLE_OCM',
                                 'APPQOSSYS')) T
          START WITH grantee IN (SELECT username FROM dba_users)
          CONNECT BY PRIOR PRIVILEGE = GRANTEE)
   WHERE table_name IS NOT NULL AND grantee != OWNER
ORDER BY grantee,
         owner,
         table_name,
         column_name,
         privilege;
		 



Set markup csv on delimiter |

set colsep '|'
col OWNER for a20
col GRANTEE for a20
col COLUMN_NAME for a20
COL roles FOR a120
COL table_name FOR a30
col privilege for a20
set lin 500 trims on pages 0 emb on hea on newp none
  SELECT *
    FROM (    SELECT CONNECT_BY_ROOT grantee grantee,
                     privilege,
					REPLACE (
                        REGEXP_REPLACE (SYS_CONNECT_BY_PATH (granteE, '/'),
                        '^/[^/]*'),
                        '/',
                        ' --> ')
                        ROLES,
						owner,
						table_name,
						column_name
                FROM (SELECT PRIVILEGE,
                             GRANTEE,
                             OWNER,
                             TABLE_NAME,
                        NULL column_name
                        FROM DBA_TAB_PRIVS
                       WHERE owner NOT IN
                      -- WHERE owner IN
                                ('SYS')
                       --         ('SIEBEL')
                      UNION 
                      SELECT PRIVILEGE,
                             GRANTEE,
							OWNER,
                             TABLE_NAME,
                             column_name
                        FROM DBA_COL_PRIVS
                       WHERE owner NOT IN
                       --WHERE owner IN
                               ('SYS')
                              --  ('SIEBEL')
						UNION 
						SELECT GRANTED_ROLE,
                             GRANTEE,
                             NULL,
                             NULL,
                             NULL
                        FROM DBA_ROLE_PRIVS
							WHERE GRANTEE NOT IN
							--WHERE GRANTEE IN
                                ('SYS')) T
                                --('SIEBEL')) T
          START WITH grantee IN (SELECT username FROM dba_users)
          CONNECT BY PRIOR PRIVILEGE = GRANTEE)
   WHERE table_name IS NOT NULL AND grantee != OWNER
ORDER BY grantee,
         owner,
         table_name,
         column_name,
         privilege;