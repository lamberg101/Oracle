Script Create tablespace Monthly :

1. OPCMC
   ** TRACKINGSTREAM_042021 (need min 120G)
   CREATE TABLESPACE TRACKINGSTREAM_042021 DATAFILE '+DATAC1' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
   alter tablespace TRACKINGSTREAM_042021 add datafile '+DATAC1' size 1G autoextend on next 300M maxsize 30G;
   alter tablespace TRACKINGSTREAM_042021 add datafile '+DATAC1' size 1G autoextend on next 300M maxsize 30G;
   alter tablespace TRACKINGSTREAM_042021 add datafile '+DATAC1' size 1G autoextend on next 300M maxsize 30G;
   ALTER USER CAMPAIGN_TRACKING QUOTA UNLIMITED ON TRACKINGSTREAM_042021;
   
   ** TRACKINGSTREAM_IDX_042021
   CREATE TABLESPACE TRACKINGSTREAM_IDX_042021 DATAFILE '+DATAC1' SIZE 100M AUTOEXTEND ON NEXT 100M MAXSIZE 5G;
   ALTER USER CAMPAIGN_TRACKING QUOTA UNLIMITED ON TRACKINGSTREAM_IDX_042021;
   
   ** DELIVERYTRACKING_042021 (need min 120G)
   CREATE TABLESPACE DELIVERYTRACKING_042021 DATAFILE '+DATAC1' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
   alter tablespace DELIVERYTRACKING_042021 add datafile '+DATAC1' size 1G autoextend on next 300M maxsize 30G;
   alter tablespace DELIVERYTRACKING_042021 add datafile '+DATAC1' size 1G autoextend on next 300M maxsize 30G;
   alter tablespace DELIVERYTRACKING_042021 add datafile '+DATAC1' size 1G autoextend on next 300M maxsize 30G;
   ALTER USER CAMPAIGN_TRACKING QUOTA UNLIMITED ON DELIVERYTRACKING_042021;
   
   ** DELIVERYTRACKING_IDX_042021
   CREATE TABLESPACE DELIVERYTRACKING_IDX_042021 DATAFILE '+DATAC1' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
   ALTER USER CAMPAIGN_TRACKING QUOTA UNLIMITED ON DELIVERYTRACKING_IDX_042021;

2. OPSELREP
   ** DT_RATEDATA_202104 (need min 90G)
   CREATE TABLESPACE DT_RATEDATA_202104 DATAFILE '+DATAC2' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
   alter tablespace DT_RATEDATA_202104 add datafile '+DATAC2' size 1G autoextend on next 300M maxsize 30G;
   alter tablespace DT_RATEDATA_202104 add datafile '+DATAC2' size 1G autoextend on next 300M maxsize 30G;
   ALTER USER UREP1 QUOTA UNLIMITED ON DT_RATEDATA_202104;
   ** IDX_RATEDATA_202104
   CREATE TABLESPACE IDX_RATEDATA_202104 DATAFILE '+DATAC2' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
   ALTER USER UREP1 QUOTA UNLIMITED ON IDX_RATEDATA_202104;

3. OPSMSICA19

   ** DT_RATEDATA_202104 (need min 90G)
CREATE TABLESPACE DT_RATEDATA_202104 DATAFILE '+DATAC5' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
alter tablespace DT_RATEDATA_202104 add datafile '+DATAC5' size 1G autoextend on next 300M maxsize 30G;
alter tablespace DT_RATEDATA_202104 add datafile '+DATAC5' size 1G autoextend on next 300M maxsize 30G;

ALTER USER ICACB_SMS1 QUOTA UNLIMITED ON DT_RATEDATA_202104;
ALTER USER ICACB_SMS2 QUOTA UNLIMITED ON DT_RATEDATA_202104;
ALTER USER ICACB_SMS3 QUOTA UNLIMITED ON DT_RATEDATA_202104;
ALTER USER ICACB_SMS4 QUOTA UNLIMITED ON DT_RATEDATA_202104;

** IDX_RATEDATA_202104
CREATE TABLESPACE IDX_RATEDATA_202104 DATAFILE '+DATAC5' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
ALTER USER ICACB_SMS1 QUOTA UNLIMITED ON IDX_RATEDATA_202104;
ALTER USER ICACB_SMS2 QUOTA UNLIMITED ON IDX_RATEDATA_202104;
ALTER USER ICACB_SMS3 QUOTA UNLIMITED ON IDX_RATEDATA_202104;
ALTER USER ICACB_SMS4 QUOTA UNLIMITED ON IDX_RATEDATA_202104;

4. OPHPOINT - (DONE!)
   ** TBS_PART_TBL_POIN_202104 (need min 100G)
CREATE TABLESPACE TBS_PART_TBL_POIN_202104 DATAFILE '+DATAIMC' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 25G;
alter tablespace TBS_PART_TBL_POIN_202104 add datafile '+DATAIMC' size 1G autoextend on next 300M maxsize 25G;
alter tablespace TBS_PART_TBL_POIN_202104 add datafile '+DATAIMC' size 1G autoextend on next 300M maxsize 25G;
alter tablespace TBS_PART_TBL_POIN_202104 add datafile '+DATAIMC' size 1G autoextend on next 300M maxsize 25G;
ALTER USER NEWTSPOIN QUOTA UNLIMITED ON TBS_PART_TBL_POIN_202104;