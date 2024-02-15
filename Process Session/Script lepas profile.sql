siapin untuk script ngelepas profile nya dulu
disable the SQL Profiles

BEGIN
DBMS_SQLTUNE.ALTER_SQL_PROFILE(
name => 'SYS_SQLPROF_789tfag56hjli0004',
attribute_name => 'STATUS',
value => 'DISABLED');
END;
/

Drop the SQL Profile

exec dbms_sqltune.drop_sql_profile('SYS_SQLPROF_9824ryfg6f7d78653');

