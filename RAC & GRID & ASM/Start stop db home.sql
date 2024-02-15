Before rolling :

1. Stop service HA of haopiris, haopppesag, DOMODD in node 1

profile db
oracle> srvctl status service -d OPIRIS -s haopiris
oracle> srvctl stop service -d OPIRIS -s haopiris -i OPIRIS1

profile db
oracle> srvctl status service -d OPPPESAG -s haopppesag 
oracle> srvctl stop service -d OPPPESAG -s haopppesag -i OPPPESAG1

profile db
oracle> srvctl status service -d OPRFSODBSD -s DOMODD
oracle> srvctl stop service -d OPRFSODBSD -s DOMODD -i OPRFSODBSD1


2. relocate service DOMODDBATCH to node 2
oracle> srvctl relocate service -d OPRFSODBSD -s DOMODDBATCH -oldinst OPRFSODBSD1 -newinst OPRFSODBSD2 (done)

3. Stop all db instances EXA82BSD Node 1
oracle> mkdir /home/oracle/state20220419

oracle> . .OPRFSODBSD_profile
oracle> srvctl stop home -oraclehome /u01/app/oracle/product/12.1.0.2/dbhome_1 -statefile /home/oracle/state20220419/s121.txt -node exa82absdpdbadm01 -stopoption IMMEDIATE

oracle> . .OPPOINBSD_profile
oracle> srvctl stop home -oraclehome /u01/app/oracle/product/19.0.0.0/dbhome_1 -statefile /home/oracle/state20220419/s19.txt -node exa82absdpdbadm01 -stopoption IMMEDIATE


========================================================================================================================================

After rolling :

1. Start all db instances EXA82BSD Node 1

oracle> . .OPRFSODBSD_profile
oracle> srvctl start home -oraclehome /u01/app/oracle/product/12.1.0.2/dbhome_1 -statefile /home/oracle/state20220419/s121.txt -node exa82absdpdbadm01 

oracle> . .OPPOINBSD_profile
oracle> srvctl start home -oraclehome /u01/app/oracle/product/19.0.0.0/dbhome_1 -statefile /home/oracle/state20220419/s19.txt -node exa82absdpdbadm01  

2.  Relocate back service batch to node 1 
oracle> . .OPRFSODBSD_profile
oracle> srvctl relocate service -d OPRFSODBSD


========================================================================================================================================

oracle> . .OPRFSODBSD_profile
oracle> srvctl start home -oraclehome /u01/app/oracle/product/12.1.0.2/dbhome_1 -statefile /home/oracle/state20220419/s121.txt -node exa82absdpdbadm02 

oracle> . .OPPOINBSD_profile
oracle> srvctl start home -oraclehome /u01/app/oracle/product/19.0.0.0/dbhome_1 -statefile /home/oracle/state20220419/s19.txt -node exa82absdpdbadm02




set pages 999
set lines 999
select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' IMMEDIATE;' 
from gv$session 
where username in ('DOM_USER','DOM')
and last_call_et > (60*15) 
and status = 'INACTIVE' 
order by inst_id;


