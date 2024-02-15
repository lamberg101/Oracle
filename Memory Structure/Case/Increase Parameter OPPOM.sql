request: parameter dari db dev dan prod beda, dan harus di samakan.
parameter prod di samakan dengan di dev.

OPPOM2.__db_cache_size=2063597568
OPPOM1.__db_cache_size=2063597568
OPPOM2.__large_pool_size=100663296
OPPOM1.__large_pool_size=100663296
OPPOM2.__pga_aggregate_target=6442450944
OPPOM1.__pga_aggregate_target=6442450944
OPPOM2.__sga_target=7516192768
OPPOM1.__sga_target=7516192768
OPPOM1.__shared_io_pool_size=184549376
OPPOM2.__shared_io_pool_size=201326592
*.db_files=1024
*.open_cursors=1000
*.pga_aggregate_target=6442450944
*.processes=6000
*.sga_target=7516192768


STEPS

1. Create/Backup pfile
create pfile='/home/oracle/ssi/pfile_OPPOM_20190916_new.txt' from spfile;

2. Alter
alter system set "_db_cache_size"=2063597568 scope=spfile sid='*';
alter system set large_pool_size=100663296 scope=spfile sid='*';
alter system set pga_aggregate_target=6442450944 scope=spfile sid='*';
alter system set sga_target=7516192768 scope=spfile sid='*';
alter system set "_shared_io_pool_size"=201326592 sid='*' scope=spfile;
alter system set db_files=1024 scope=spfile sid='*';
alter system set open_cursors=1000 scope=both sid='*';

3. restart db
srvctl status database -d OPPOM
srvctl stop database -d OPPOM
srvctl start database -d OPPOM 
srvctl status database -d OPPOM

4. Check
show parameter db_cache_size
show parameter large_pool_size
show parameter pga_aggregate_target
show parameter sga_target
show parameter db_files
show parameter open_cursors
show parameter _shared_io;



