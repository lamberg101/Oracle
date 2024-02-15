Contoh.
1. Drop table partitionnya dulu
2. Drop tablespace.
3. Jalankan 1 per 1

--drop partition
alter table PROD_OSB_CRMLOG.MESSAGE_LOGS drop partition PT_MESSAGE_LOG_042019;
alter table PROD_OSB_CRMLOG.MESSAGE_LOGS drop partition PT_MESSAGE_LOG_052019;

--drop tablespace
drop tablespace PRT_LOG_042019 INCLUDING CONTENTS AND DATAFILES;
drop tablespace PRT_LOG_052019 INCLUDING CONTENTS AND DATAFILES

DROP TABLE PARTITION
SQL> ALTER TABLE PROD_OSB_CRMLOG.MESSAGE_LOGS DROP PARTITION PT_MESSAGE_LOG_032018;

DROP TABLESPACE
SQL> drop tablespace IDX_PRT_LOG_022018 INCLUDING CONTENTS AND DATAFILES;


---------------------

DROP
	$ drop tablespace TBS_MKIOS_201312_EXA_C INCLUDING CONTENTS AND DATAFILES;
	$ ALTER TABLE PROD_OSB_CRMLOG.MESSAGE_LOGS_OLD31012018 DROP PARTITION PT_MESSAGE_LOG_112018;
	
	
SQL>
ALTER SESSION SET ddl_lock_timeout=300;

SQL>
ALTER TABLE CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM SET INTERVAL ();

SQL>
ALTER TABLE CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM ADD PARTITION VALUES LESS THAN (TIMESTAMP' 2020-12-02 00:00:00') LOGGING NOCOMPRESS TABLESPACE TRACKINGSTREAM_122020;
ALTER TABLE CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM ADD PARTITION VALUES LESS THAN (TIMESTAMP' 2020-12-03 00:00:00') LOGGING NOCOMPRESS TABLESPACE TRACKINGSTREAM_122020;
ALTER TABLE CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM ADD PARTITION VALUES LESS THAN (TIMESTAMP' 2020-12-04 00:00:00') LOGGING NOCOMPRESS TABLESPACE TRACKINGSTREAM_122020;

SQL>
ALTER TABLE CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM SET INTERVAL (NUMTODSINTERVAL(1, 'DAY'));









