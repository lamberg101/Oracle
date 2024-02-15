sqlplus "/ AS SYSDBA"

@$ORACLE_HOME/rdbms/admin/utlrp.sql


select owner, object_type, count(*) total 
from dba_objects 
--where owner='FCC114' 
where status ='INVALID' 
group by owner, object_type 
order by 1,3;


set pages 9999
select 'ALTER PACKAGE "' ||owner||'"."'||object_name|| '" compile;' script from dba_objects 
where owner='FCC114' and object_type='PACKAGE' and status = 'INVALID';

set pages 9999
select 'ALTER TRIGGER "' ||owner||'"."'||object_name|| '" compile;' script from dba_objects 
where owner='FCC114' and object_type='TRIGGER' and status = 'INVALID';


set pages 9999
select 'ALTER SYNONYM "' ||owner||'"."'||object_name|| '" compile;' script from dba_objects 
where owner='FCC114' and object_type='SYNONYM' and status = 'INVALID';

--PACKAGE BODY
set pages 9999
select 'ALTER PACKAGE "' ||owner||'"."'||object_name|| '" compile BODY;' script from dba_objects 
where owner='FCC114' and object_type='PACKAGE BODY' and status = 'INVALID';


set pages 9999
select 'ALTER FUNCTION "' ||owner||'"."'||object_name|| '" compile;' script from dba_objects 
where owner='FCC114' and object_type='FUNCTION' and status = 'INVALID';

set pages 9999
select 'ALTER PROCEDURE "' ||owner||'"."'||object_name|| '" compile;' script from dba_objects 
where owner='FCC114' and object_type='PROCEDURE' and status = 'INVALID';


ALTER PROCEDURE hr.remove_emp COMPILE;


--ALTER PACKAGE hr.emp_mgmt COMPILE BODY;
--ALTER SYNONYM offices COMPILE;

