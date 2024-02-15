
--Check DBA_SYNONYMS
set linesize 200
set pagesize 200
col owner for a32
col table_owner for a32
col synonym_name for a32
col table_name for a32
select owner,table_owner,synonym_name,table_name 
from DBA_SYNONYMS 
where synonym_name = 'MAP_HISTORY';


---------------------------------------------------------------------------------------------------------------------------------------------------------

--Check ALL_SYNONYMS
select owner, synonym_name, table_name, table_owner 
from ALL_SYNONYMS
where table_name = 'table_name';


---------------------------------------------------------------------------------------------------------------------------------------------------------

--CREATE SYNONYM
CREATE [or replace] [public] SYNONYM [schema.] SYNONYM_NAME FOR [schema.] OBJECT_NAME [@dblink];
CREATE SYNONYM <synonym> FOR <object>;
CREATE PUBLIC SYNONYM <synonym> FOR <object>;

--contoh:
CREATE SYNONYM QUOTA_PER_SUBS FOR activeoffer.QUOTA_PER_SUBS;
CREATE PUBLIC SYNONYM QUOTA_PER_SUBS FOR activeoffer.QUOTA_PER_SUBS;

--replace (if it already exist)
CREATE OR REPLACE PUBLIC SYNONYM suppliers FOR app.suppliers;

---------------------------------------------------------------------------------------------------------------------------------------------------------

--DROP SYNONYM
DROP [public] SYNONYM [schema.] SYNONYM_NAME [force];

--contoh
DROP SYNONYM SUPPLIERS;

---------------------------------------------------------------------------------------------------------------------------------------------------------





