Transaction/Query Per Secon --http://www.dba-oracle.com/m_transactions_per_second.htm

perdb atau per server mas?
bisa dicari angka max nya ya? dalam Db itu selama satu hari
Kalau tps biasanya mah apps yang ngitung
Average per hari kali mas?
Atau per jam
Di group by dateformat


WITH hist_snaps
     AS (SELECT instance_number,
                snap_id,
                round(begin_interval_time,'MI') datetime,
                  (  begin_interval_time
                   + 0
                   - LAG (
                        begin_interval_time + 0)
                     OVER (PARTITION BY dbid, instance_number
                           ORDER BY snap_id))
                * 86400      -- seconds per day
                   diff_time -- calculate difference in time from
                             -- previous snapshot
                   FROM dba_hist_snapshot),
     hist_stats      AS (SELECT dbid,
                instance_number,
                snap_id,
                stat_name,
                  VALUE
                - LAG (
                     VALUE)
                  OVER (PARTITION BY dbid,instance_number,stat_name
                        ORDER BY snap_id)
                  delta_value -- difference in value from previous
                              -- snapshot for each stat_name
           FROM dba_hist_sysstat
          WHERE stat_name IN ('user commits', 'user rollbacks'))
  SELECT datetime,
         ROUND (SUM (delta_value) / 3600, 2) "Transactions/Second"
     FROM hist_snaps sn, hist_stats st
   WHERE     st.instance_number = sn.instance_number
         AND st.snap_id = sn.snap_id
         AND diff_time IS NOT NULL
GROUP BY datetime
ORDER BY 1 desc;


Usual Results (contoh di prod)
==============================================
DATETIME  Transactions/Second
--------- -------------------
28-AUG-19		  .58
28-AUG-19		 1.03
28-AUG-19		 1.24
28-AUG-19		  .98
28-AUG-19		  .75
28-AUG-19		  .45
28-AUG-19		  .48
28-AUG-19		  .47
28-AUG-19		  .47
28-AUG-19		  .46
28-AUG-19		  .46

3410 rows selected.


















