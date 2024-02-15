1. Ambil dulu object_name gunakan query berikut.

berikut sql untuk statistic:

set linesize 400
set pagesize 200
select * from (
SELECT  vss.owner,
        vss.object_name,
        SUM(CASE statistic_name WHEN 'logical reads' THEN value ELSE 0 END
            + CASE statistic_name WHEN 'physical reads' THEN value ELSE 0 END) AS reads ,
        SUM(CASE statistic_name WHEN 'logical reads' THEN value ELSE 0 END) AS logical_reads ,
        SUM(CASE statistic_name WHEN 'physical reads' THEN value ELSE 0 END) AS physical_reads ,
        SUM(CASE statistic_name WHEN 'segment scans' THEN value ELSE 0 END) AS segment_scans ,
        SUM(CASE statistic_name WHEN 'physical writes' THEN value ELSE 0 END) AS writes
FROM    v$segment_statistics vss
WHERE   vss.owner NOT IN ('SYS', 'SYSTEM')
GROUP BY vss.owner,
        vss.object_name ,
        vss.object_type ,
        vss.subobject_name ,
        vss.tablespace_name
ORDER BY reads DESC) where rownum <= 20;


================================================================================================================================================

5. DBA FUTURE USAGE <di home server ada namanya getfeature.sql>

select NAME,DETECTED_USAGES,CURRENTLY_USED,LAST_USAGE_DATE from dba_feature_usage_statistics;

>Pake query yg diatas terlalu banyak, jadi pilih beberapa saja, seperti quer dibawah.


set linesize 200
set pagesize 200
select (select name from v$database)||'|'||NAME||'|'||DETECTED_USAGES||'|'||CURRENTLY_USED||'|'||LAST_USAGE_DATE 
from dba_feature_usage_statistics
where version=(select version from v$instance) and (name) in 
('Real Application Clusters (RAC)','Automatic Memory Tuning',
'Partitioning (system)','Spatial','In-Memory Column Store','GoldenGate',
'Audit Options','Information Lifecycle Management','Active Data Guard - Real-Time Query on Physical Standby',
'Advanced Index Compression','Real Application Security','Label Security','OLAP - Analytic Workspaces',
'Server Flash Cache','EM Cloud Control') order by 1;




