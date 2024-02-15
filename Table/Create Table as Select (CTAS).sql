

--EXAMPLE FROM CHATGTP (need testing)
CREATE TABLE new_table 
TABLESPACE tablespace_name 
PARALLEL
NOLOGGING 
AS
SELECT * 
FROM existing_table;


--CREATE TABLE AS SELECT (CTAS) --need testing
create table DATA_MODEL_NEW as (select * from SIT11_OMS_USER.DATA_MODEL);


------------------------------------------------------------------------------------------------------------


--Simple CTAS statement: 
SQL> CREATE TABLE emp2 AS SELECT * FROM emp;


--Specifying a tablespace: 
SQL> CREATE TABLE emp3 TABLESPACE users AS SELECT * FROM emp;


--Parallel CTAS with nologging for faster performance: 
SQL> CREATE TABLE emp4 NOLOGGING PARALLEL 4 AS SELECT * FROM emp;


--Normal CTAS, but also define a primary key on the target table: 
SQL> CREATE TABLE emp5 (empid PRIMARY KEY) AS SELECT empid FROM emp;

------------------------------------------------------------------------------------------------------------

--CREATE INDEX
CREATE UNIQUE INDEX "UAT11_OMS_USER"."SYS_IL0000105810C00004$$" ON "UAT11_OMS_USER"."SERVER_CACHE_NEW" (
  PCTFREE 10 
  INITRANS 2 
  MAXTRANS 255
  STORAGE(
  INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 
  FREELISTS 1 
  FREELIST GROUPS 1
  BUFFER_POOL DEFAULT 
  FLASH_CACHE DEFAULT 
  CELL_FLASH_CACHE DEFAULT 
  )
  TABLESPACE "FOM_OMS_UAT11"
  PARALLEL (DEGREE 0 INSTANCES 0);