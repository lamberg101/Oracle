create pfile='/home/oracle/ssi/pfile_OPSCV_20190713_2.txt' from spfile;

alter system set pga_aggregate_limit=0 scope=spfile sid='*';
alter system set pga_aggregate_target=4G scope=spfile sid='*';


alter system set sga_max_size=8G scope=pfile sid='*';
alter system set sga_target=4G scope=pfile sid='*';

shutdown immediate;
startup;

startup pfile=/home/oracle/ssi/pfile_OPSCV_20190713.txt


PGA sebaiknya di set setengan dari SGA
karena di bagi 2 ke setiap instance
dan karena ada 2 instance jadi 14/2=7




1. start database
$ srvctl status database -d opscv
$ srvctl start instance -d OPSCV
$ srvctl stop instance -d OPSCV -i OPSCV2


2. Edit pfile

*.sga_max_size=8589934592
*.sga_target=4294967296



2. alter sga/pga
alter system set pga_aggregate_limit=0 scope=spfile sid='*';
alter system set pga_aggregate_target=2G scope=spfile sid='*';

alter system set sga_max_size=8G scope=spfile sid='*';
alter system set sga_target=4G scope=spfile sid='*';
srvctl stop database -d opscv
srvctl start database -d opscv



