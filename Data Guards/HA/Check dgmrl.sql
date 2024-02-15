--check configuration:
dgmgrl sys/OR4cl35y5#2015 
show configuration; 


---------------------------------------------------------------------------------------------------
--check pas status lagging
set lines 200;
select name,value,time_computed 
from v$dataguard_stats;


---------------------------------------------------------------------------------------------------
--check failover configuration
dgmgrl sys/OR4cl35y5#2015 
show fast_start failover
