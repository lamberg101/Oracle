1. Check session and status before on database OPRFSODNEW exa62bsdpdb1
 
2. Backup Spfile ON database OPRFSODNEW

create pfile='/home/oracle/ssi/OPRFSODNEW/pfile_OPRFSODNEW_08112020.txt' from spfile;


3. Increase SGA on database OPRFSODNEW

alter system set sga_target=16G scope=spfile sid='*';
alter system set sga_max_size=16G scope=spfile sid='*';


4. Rolling Restart database OPRFSODNEW on (exa62bsdpdb1 and exa62bsdpdb2)

#NODE 1
srvctl status database -d OPRFSODNEW
srvctl stop instance -d OPRFSODNEW -i OPRFSODNEW1
srvctl start instance -d OPRFSODNEW -i OPRFSODNEW1


Check session --pastikan sudah masuk ke node 	


#NODE 2
srvctl status database -d OPRFSODNEW
srvctl stop instance -d OPRFSODNEW -i OPRFSODNEW2
srvctl start instance -d OPRFSODNEW -i OPRFSODNEW2


5. Sanity check by apps team and dba




Increase SGA OPDGPOS
1. Backup spfile.
create pfile='/home/oracle/ssi/pfile_OPDGPOS_22102019.txt' from spfile;

2. resize SGA & PGA
alter system set sga_max_size=10G scope=spfile sid='*';
alter system set sga_target=7G scope=spfile sid='*';
alter system set pga_aggregate_target=4G scope=spfile sid='*';

2. Restart Database
srvctl status database -d OPDGPOS
srvctl stop database -d OPDGPOS -o immediate
srvctl start database -d OPDGPOS
srvctl status database -d OPDGPOS



