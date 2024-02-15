

--TABLE_NAME
INSERT INTO table_name
(column1, column2, ... column_n )
SELECT expression1, expression2, ... expression_n
FROM source_table
[WHERE conditions];

INSERT INTO contacts
SELECT *
FROM customers
WHERE state = 'Florida';

----------------------------------------------------------------------------------------------------------------------

--COUNT THE TABLE
SELECT /*+ PARALLEL 4 */ COUNT(*) FROM NFT_OMS_USER.SERVER_CACHE;


--INSERT
set timing on
insert /*+  PARALLEL(8) */ into NFT_OMS_USER.DATA_MODEL_RELATION select /*+ PARALLEL(12) */* from PRDP_OMS_USER.DATA_MODEL_RELATION;
commit;


----------------------------------------------------------------------------------------------------------------------


set time on;
set timing on;
insert into ESB_ILMUPED.C2P_PULL_CONF 
(
	BATCH_TYPE,
	BATCH_RUN_STATUS,
	LAST_BATCH_NUM,
	CREATED_BY,
	CREATED_DT,
	LAST_UPDATED_BY,
	LAST_UPDATED_DT
) select * from DOM.C2P_PULL_CONF;

commit;