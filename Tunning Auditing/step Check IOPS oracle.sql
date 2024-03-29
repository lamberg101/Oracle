step Check IOPS oracle
====================

set lines 250 pages 50000
alter session set nls_date_format='dd-mm-yyyy hh24:mi';

-----------------------------------------------------------------------------------------------------------------------

col Phys_Read_Total_Bps for 999999999999
col Phys_Write_Total_Bps for 999999999999
col Redo_Bytes_per_sec for 999999999999
col Phys_Read_IOPS for 999999999999
col Phys_write_IOPS for 999999999999
col Phys_redo_IOPS for 999999999999
col OS_LOad for 999999999999
col DB_CPU_Usage_per_sec for 999999999999
col Host_CPU_util for 999999999999
col Network_bytes_per_sec for 999999999999
col Phys_IO_Tot_MBps for 999999999999
col Phys_IOPS_Tot for 999999999999

spool io_max_checkup.log

select min(begin_time), max(end_time),
sum(case metric_name when 'Physical Read Total Bytes Per Sec' then maxval end) Phys_Read_Tot_Bps,
sum(case metric_name when 'Physical Write Total Bytes Per Sec' then maxval end) Phys_Write_Tot_Bps,
sum(case metric_name when 'Redo Generated Per Sec' then maxval end) Redo_Bytes_per_sec,
sum(case metric_name when 'Physical Read Total IO Requests Per Sec' then maxval end) Phys_Read_IOPS,
sum(case metric_name when 'Physical Write Total IO Requests Per Sec' then maxval end) Phys_write_IOPS,
sum(case metric_name when 'Redo Writes Per Sec' then maxval end) Phys_redo_IOPS,
sum(case metric_name when 'Current OS Load' then maxval end) OS_LOad,
sum(case metric_name when 'CPU Usage Per Sec' then maxval end) DB_CPU_Usage_per_sec,
sum(case metric_name when 'Host CPU Utilization (%)' then maxval end) Host_CPU_util, --NOTE 100% = 1 loaded RAC node
sum(case metric_name when 'Network Traffic Volume Per Sec' then maxval end) Network_bytes_per_sec,
snap_id
from dba_hist_sysmetric_summary
group by snap_id
order by snap_id;

spool off

-----------------------------------------------------------------------------------------------------------------------

spool io_maxtot_summary.log

select min(begin_time), max(end_time),
sum(case metric_name when 'Physical Read Total Bytes Per Sec' then maxval end)/1024/1024 +
sum(case metric_name when 'Physical Write Total Bytes Per Sec' then maxval end)/1024/1024 +
sum(case metric_name when 'Redo Generated Per Sec' then maxval end)/1024/1024 Phys_IO_Tot_MBps,
sum(case metric_name when 'Physical Read Total IO Requests Per Sec' then maxval end) +
sum(case metric_name when 'Physical Write Total IO Requests Per Sec' then maxval end) +
sum(case metric_name when 'Redo Writes Per Sec' then maxval end) Phys_IOPS_Tot,
sum(case metric_name when 'Current OS Load' then maxval end) OS_LOad,
sum(case metric_name when 'CPU Usage Per Sec' then maxval end) DB_CPU_Usage_per_sec,
sum(case metric_name when 'Host CPU Utilization (%)' then maxval end) Host_CPU_util, --NOTE 100% = 1 loaded RAC node
sum(case metric_name when 'Network Traffic Volume Per Sec' then maxval end) Network_bytes_per_sec,
snap_id
from dba_hist_sysmetric_summary
group by snap_id
order by snap_id;

spool off

-----------------------------------------------------------------------------------------------------------------------

exit