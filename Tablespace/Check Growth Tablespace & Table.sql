
--Check GROWTH TABLESPACE
SELECT part.tsname tablespace_name,
       Max(part.used_size) "Current Size (MB)",  /* Current size of tablespace */
       Round(Avg(inc_used_size), 2) "Growth Per Day(MB)" /* Growth of tablespace per day */
 FROM 
 (SELECT sub.days,
         sub.tsname,
         used_size,
         used_size - Lag (used_size, 1)
          over (PARTITION BY sub.tsname ORDER BY sub.tsname, sub.days) inc_used_size /* getting delta increase using analytic function */
       FROM  
       (SELECT TO_CHAR(hsp.begin_interval_time,'MM-DD-YYYY') days,
        hs.tsname,
        MAX((hu.tablespace_usedsize* dt.block_size )/(1024*1024)) used_size
      from
        dba_hist_tbspc_space_usage hu, /* historical tablespace usage statistics */
        dba_hist_tablespace_stat hs , /* tablespace information from the control file */
        dba_hist_snapshot hsp, /* information about the snapshots in the Workload Repository */
        dba_tablespaces dt
      where
        hu.snap_id = hsp.snap_id
        and hu.TABLESPACE_ID = hs.ts#
        and hs.tsname = dt.tablespace_name
        and dt.tablespace_name='USERS'
        AND hsp.begin_interval_time > SYSDATE - 7 /* gathering info about last 14 days */
      GROUP  BY To_char(hsp.begin_interval_time, 'MM-DD-YYYY'),
        hs.tsname
      order by  hs.tsname,days) sub) part
GROUP  BY part.tsname
ORDER  BY part.tsname; 




--Check GROWTH TABLE
col Growth (MB) for a20
col object_type for a20
col segment_name for a20
col tablespace_name for a20
SELECT ds.tablespace_name, ds.segment_name, dobj.object_type, ROUND(SUM(dhss.space_used_delta) / 1024 / 1024 ,2) "Growth (MB)"
FROM dba_hist_snapshot snpshot, dba_hist_seg_stat dhss, dba_objects dobj, dba_segments ds
WHERE begin_interval_time > TRUNC(SYSDATE)-360
AND snpshot.snap_id = dhss.snap_id
AND dobj.object_id = dhss.obj#
AND dobj.owner = ds.owner
AND dobj.object_name = ds.segment_name
AND ds.owner ='&owner' 
AND ds.SEGMENT_NAME IN ('&table_name') 
AND dobj.object_type='TABLE'
GROUP BY ds.tablespace_name,ds.segment_name,dobj.object_type
ORDER BY 3 ASC


================================================================================================================

set serverout on
set verify off
set lines 200
set pages 2000
DECLARE
v_ts_id number;
v_ts_name varchar2(200) := UPPER('&Tablespace_Name');
v_ts_block_size number;
v_begin_snap_id number;
v_end_snap_id number;
v_begin_snap_date date;
v_end_snap_date date;
v_numdays number;
v_ts_begin_size number;
v_ts_end_size number;
v_ts_growth number;
v_ts_begin_allocated_space number;
v_ts_end_allocated_space number;
BEGIN
SELECT ts# into v_ts_id FROM v$tablespace where name = v_ts_name;
SELECT block_size into v_ts_block_size FROM dba_tablespaces where tablespace_name = v_ts_name;
SELECT min(snap_id), max(snap_id), min(trunc(to_date(rtime,'MM/DD/YYYY HH24:MI:SS'))), max(trunc(to_date(rtime,'MM/DD/YYYY HH24:MI:SS')))
into v_begin_snap_id,v_end_snap_id, v_begin_snap_date, v_end_snap_date from dba_hist_tbspc_space_usage where tablespace_id=v_ts_id;
v_numdays := v_end_snap_date - v_begin_snap_date;

SELECT round(max(tablespace_size)*v_ts_block_size/1024/1024,2) into v_ts_begin_allocated_space from dba_hist_tbspc_space_usage where tablespace_id=v_ts_id and snap_id= v_begin_snap_id;
SELECT round(max(tablespace_size)*v_ts_block_size/1024/1024,2) into v_ts_end_allocated_space from dba_hist_tbspc_space_usage where tablespace_id=v_ts_id and snap_id = v_end_snap_id;
SELECT round(max(tablespace_usedsize)*v_ts_block_size/1024/1024,2) into v_ts_begin_size from dba_hist_tbspc_space_usage where tablespace_id=v_ts_id and snap_id = v_begin_snap_id;
SELECT round(max(tablespace_usedsize)*v_ts_block_size/1024/1024,2) into v_ts_end_size from dba_hist_tbspc_space_usage where tablespace_id=v_ts_id and snap_id = v_end_snap_id; 
v_ts_growth := v_ts_end_size - v_ts_begin_size;
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE('Tablespace Block Size: '||v_ts_block_size);
DBMS_OUTPUT.PUT_LINE('---------------------------');
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE('Summary');
DBMS_OUTPUT.PUT_LINE('========');
DBMS_OUTPUT.PUT_LINE('1) Allocated Space: '||v_ts_end_allocated_space||' MB'||' ('||round(v_ts_end_allocated_space/1024,2)||' GB)');
DBMS_OUTPUT.PUT_LINE('2) Used Space: '||v_ts_end_size||' MB'||' ('||round(v_ts_end_size/1024,2)||' GB)');
DBMS_OUTPUT.PUT_LINE('3) Used Space Percentage: '||round(v_ts_end_size/v_ts_end_allocated_space*100,2)||' %');
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE('History');
DBMS_OUTPUT.PUT_LINE('========');
DBMS_OUTPUT.PUT_LINE('1) Allocated Space on '||v_begin_snap_date||': '||v_ts_begin_allocated_space||' MB'||' ('||round(v_ts_begin_allocated_space/1024,2)||' GB)');
DBMS_OUTPUT.PUT_LINE('2) Current Allocated Space on '||v_end_snap_date||': '||v_ts_end_allocated_space||' MB'||' ('||round(v_ts_end_allocated_space/1024,2)||' GB)');
DBMS_OUTPUT.PUT_LINE('3) Used Space on '||v_begin_snap_date||': '||v_ts_begin_size||' MB'||' ('||round(v_ts_begin_size/1024,2)||' GB)' );
DBMS_OUTPUT.PUT_LINE('4) Current Used Space on '||v_end_snap_date||': '||v_ts_end_size||' MB'||' ('||round(v_ts_end_size/1024,2)||' GB)' );
DBMS_OUTPUT.PUT_LINE('5) Total growth during last '||v_numdays||' days between '||v_begin_snap_date||' and '||v_end_snap_date||': '||v_ts_growth||' MB'||' ('||round

(v_ts_growth/1024,2)||' GB)');
IF (v_ts_growth <= 0 OR v_numdays <= 0) THEN
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE('No data growth was found for this Tablespace');
ELSE
DBMS_OUTPUT.PUT_LINE('6) Per day growth during last '||v_numdays||' days: '||round(v_ts_growth/v_numdays,2)||' MB'||' ('||round((v_ts_growth/v_numdays)/1024,2)||'GB)');
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE('Expected Growth');
DBMS_OUTPUT.PUT_LINE('===============');
DBMS_OUTPUT.PUT_LINE('1) Expected growth for next 30 days: '|| round((v_ts_growth/v_numdays)*30,2)||' MB'||' ('||round(((v_ts_growth/v_numdays)*30)/1024,2)||' GB)');
DBMS_OUTPUT.PUT_LINE('2) Expected growth for next 60 days: '|| round((v_ts_growth/v_numdays)*60,2)||' MB'||' ('||round(((v_ts_growth/v_numdays)*60)/1024,2)||' GB)');
DBMS_OUTPUT.PUT_LINE('3) Expected growth for next 90 days: '|| round((v_ts_growth/v_numdays)*90,2)||' MB'||' ('||round(((v_ts_growth/v_numdays)*90)/1024,2)||' GB)');
DBMS_OUTPUT.PUT_LINE('If no data is displayed for this tablepace, it means AWR does not have any data for this tablespace');
END IF;

EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE('Tablespace usage information not found in AWR');

END;
/


====================================================================================================================================



SELECT part.tsname tablespace_name,
       Max(part.used_size) "Current Size (MB)",  /* Current size of tablespace */
       Round(Avg(inc_used_size), 2) "Growth Per Day(MB)" /* Growth of tablespace per day */
 FROM 
 (SELECT sub.days,
         sub.tsname,
         used_size,
         used_size - Lag (used_size, 1)
          over (PARTITION BY sub.tsname ORDER BY sub.tsname, sub.days) inc_used_size /* getting delta increase using analytic function */
       FROM  
       (SELECT TO_CHAR(hsp.begin_interval_time,'MM-DD-YYYY') days,
        hs.tsname,
        MAX((hu.tablespace_usedsize* dt.block_size )/(1024*1024)) used_size
      from
        dba_hist_tbspc_space_usage hu, /* historical tablespace usage statistics */
        dba_hist_tablespace_stat hs , /* tablespace information from the control file */
        dba_hist_snapshot hsp, /* information about the snapshots in the Workload Repository */
        dba_tablespaces dt
      where
        hu.snap_id = hsp.snap_id
        and hu.TABLESPACE_ID = hs.ts#
        and hs.tsname = 'USERS'
        AND hsp.begin_interval_time > SYSDATE - 7 /* gathering info about last 30 days */
      GROUP  BY To_char(hsp.begin_interval_time, 'MM-DD-YYYY'),
        hs.tsname
      order by  hs.tsname,days) sub) part
GROUP  BY part.tsname
ORDER  BY part.tsname; 