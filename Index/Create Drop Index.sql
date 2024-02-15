

--CREATE INDEX
CREATE INDEX TR_USER.TRACK_LOGIN_IX2 ON TR_USER.TRACK_LOGIN (MSISDN, CHANNEL) TABLESPACE DATA LOCAL PARALLEL (degree 16);

--DROP INDEX
DROP INDEX TR_USER.TRACK_LOGIN_IX2;


-------------------------------------------------------------------------------------------------------------------

--CONTOH CREATE INDEX OPCMC
set timing on
ALTER SESSION SET CURRENT_SCHEMA=CAMPAIGN_TRACKING;
CREATE INDEX camp_status_idx ON CMS_CAMPAIGNS_V4 (camp_status)
LOGGING
TABLESPACE CAMPAIGN_TRACKING
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;
exit;


-------------------------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------------------------

--DROP INDEX
SQL> DROP INDEX NAMA_INDEX;          --> kalau masuk pakai usernya
SQL> DROP INDEX SCHEMA.INDEX_NAME;   ---> pakai ini kalau masuk pakai sys







