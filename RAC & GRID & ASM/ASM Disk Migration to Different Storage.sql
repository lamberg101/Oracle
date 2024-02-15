
ASM Disk Migration to Different Storage
'This is a zero downtime activity'

Below are the 3 disks allocated on both RAC nodes which are further allocated to CRS, DATA and FRA diskgroups

 Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1         915     7349706   83  Linux
/dev/sdb2             916        1830     7349737+  83  Linux
/dev/sdb3            1831        2610     6265350   83  Linux


--Below are the diskgroup details

DISKGROUP  DISKNAME       TOTAL_MB    USED_MB    FREE_MB PATH                           HEADER_STATU
---------- ------------ ---------- ---------- ---------- ------------------------------ ------------
CRS        CRS_0000           7177        396       6781 /dev/oracleasm/disks/CRS1      MEMBER
DATA       DATA_0000          7177       2009       5168 /dev/oracleasm/disks/DATA1     MEMBER
FRA        FRA_0000           6118        366       5752 /dev/oracleasm/disks/FRA1      MEMBER


We are going to replace the DATA1 disk under DATA diskgroup with DATA2 disk. This new disk we have allocated via a new storage. 

--Let us first create the ASM disk

[root@oraracn1 ~]# oracleasm createdisk DATA2 /dev/sdc1
Writing disk header: done
Instantiating disk: done

--Connect to ASM via sqlplus and add the new diskstring. 
-In our example, the new disk location is same as old disks, so no need to add. 
-In case you have different disk path, add it to ASM_DISKSTRING parameter. Keep both old and new paths.

$> sqlplus / as sysasm
SQL> alter system set asm_disktring = '/dev/oracleasm/disks/*' , '/dev/new_loc/*';
SQL> select path from v$asm_disk;

--Check the ASM disks details via below query. The new disk status must be PROVISIONED

SQL>
set pages 40000 lines 120
col PATH for a30
select DISK_NUMBER,MOUNT_STATUS,HEADER_STATUS,MODE_STATUS,STATE,
PATH FROM V$ASM_DISK;

DISK_NUMBER MOUNT_S HEADER_STATU MODE_ST STATE    PATH
----------- ------- ------------ ------- -------- ------------------------------
          0 CLOSED  PROVISIONED  ONLINE  NORMAL   /dev/oracleasm/disks/DATA2
          0 CACHED  MEMBER       ONLINE  NORMAL   /dev/oracleasm/disks/FRA1
          0 CACHED  MEMBER       ONLINE  NORMAL   /dev/oracleasm/disks/DATA1
          0 CACHED  MEMBER       ONLINE  NORMAL   /dev/oracleasm/disks/CRS1


--We will now add DATA2 to DATA diskgroup and later remove DATA1 disk
SQL> alter diskgroup DATA add disk '/dev/oracleasm/disks/DATA2';
OR
SQL> alter diskgroup DATA add disk '/dev/oracleasm/disks/DATA2' rebalance power 20;
Diskgroup altered.


--Wait for re-balance operation to complete
SQL> Select operation, state, est_work, est_minutes from v$asm_operation; 

OPERA STAT   EST_WORK EST_MINUTES
----- ---- ---------- -----------
REBAL RUN        1175           0


--Once re-balance operation is completed, check the disk details
SQL>
set lines 999;
col diskgroup for a10
col diskname for a12
col path for a30
select a.name DiskGroup,b.name DiskName, b.total_mb, (b.total_mb-b.free_mb) Used_MB, b.free_mb,b.path, b.header_status
from v$asm_disk b, v$asm_diskgroup a 
where a.group_number (+) =b.group_number 
order by b.group_number,b.name;

DISKGROUP  DISKNAME       TOTAL_MB    USED_MB    FREE_MB PATH                           HEADER_STATU
---------- ------------ ---------- ---------- ---------- ------------------------------ ------------
CRS        CRS_0000           7177        396       6781 /dev/oracleasm/disks/CRS1      MEMBER
DATA       DATA_0000          7177        838       6339 /dev/oracleasm/disks/DATA1     MEMBER
DATA       DATA_0001         10236       1183       9053 /dev/oracleasm/disks/DATA2     MEMBER
FRA        FRA_0000           6118        366       5752 /dev/oracleasm/disks/FRA1      MEMBER


--Observe that both DATA1 and DATA2 are now part of DATA diskgroup. Now we can remove the old disk DATA1 from the diskgroup
SQL> alter diskgroup DATA drop disk 'DATA_0000'; 

Diskgroup altered.
Wait for re-balance operation to complete
SQL> Select operation, state, est_work, est_minutes from v$asm_operation; 

OPERA STAT   EST_WORK EST_MINUTES
----- ---- ---------- -----------
REBAL RUN         836           0


--Once re-balance operation is completed, check the disk details via below query and you must see DATA1 disk marked as FORMER
SQL>
set lines 999;
col diskgroup for a10
col diskname for a12
col path for a30
select a.name DiskGroup,b.name DiskName, b.total_mb, (b.total_mb-b.free_mb) Used_MB, b.free_mb,b.path, b.header_status
from v$asm_disk b, v$asm_diskgroup a 
where a.group_number (+) =b.group_number 
order by b.group_number,b.name;

DISKGROUP  DISKNAME       TOTAL_MB    USED_MB    FREE_MB PATH                           HEADER_STATU
---------- ------------ ---------- ---------- ---------- ------------------------------ ------------
                                 0          0          0 /dev/oracleasm/disks/DATA1     FORMER
CRS        CRS_0000           7177        396       6781 /dev/oracleasm/disks/CRS1      MEMBER
DATA       DATA_0001         10236       1183       9053 /dev/oracleasm/disks/DATA2     MEMBER
FRA        FRA_0000           6118        366       5752 /dev/oracleasm/disks/FRA1      MEMBER


--You can later choose to complete drop DATA1 disk via below command and ask storage team to reclaim the mount points
[root@oraracn1 ~]# oracleasm deletedisk DATA1 /dev/sdb1

You can also achieve above via ASMCA but make sure you monitor re-balancing manually!