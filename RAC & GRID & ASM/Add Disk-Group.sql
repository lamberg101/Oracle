1. Check STATUS

set linesize 300
set pagesize 200
col path for a45
select group_number, disk_number, name, os_mb,total_mb, free_mb, path, header_status, mode_status 
from V$ASM_DISK;
--where path like '/dev/mapper/GENDSK%' ---> disesuaikan disk nya
where header_status='CANDIDATE';

---------------------------------------------------------------------------

2. ADD DISK 
$ sett +ASM2 --atau masuk ke grid
SQL> ALTER DISKGROUP DISKGROUPNAME ADD DISK '/pathdisknya/xxxx' name namadisknya REBALANCE POWER 10;

example :
SQL> ALTER DISKGROUP GENDATA ADD DISK '/dev/mapper/GENDSK6' NAME GENDSK6 REBALANCE POWER 10;

---------------------------------------------------------------------------

3. CROSSCHECK
select group_number, disk_number, name, os_mb,total_mb, free_mb, path, header_status,mode_status 
from V$ASM_DISK 
where path like '/dev/mapper/GENDSK%';


---------------------------------------------------------------------------

4. Check Rebalance --masuk ke grid

$> sqlplus / as sysasm
SQL> set linesize 200
set pagesize 100
select * from gv$asm_operation;

---------------------------------------------------------------------------

5. Check SPACE ASM
SQL> sciprt Check asm.

