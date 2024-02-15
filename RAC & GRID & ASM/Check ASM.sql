password asmsnmp exa62A, 62B, TBS, IMC, BSD = welcome1
cara reset password asmsnmp
$ . .grid_profile
$ asmcmd -p
ASMCMD [+] > lspwusr
        Username sysdba sysoper sysasm 
             SYS   TRUE    TRUE   TRUE 
         ASMSNMP   TRUE   FALSE  FALSE 
CRSUSER__ASM_001   TRUE   FALSE   TRUE 

*** pastikan ada user ASMSNMP dgn sysdba "TRUE"
ASMCMD [+] > orapwusr --modify ASMSNMP
Enter password:


--------------------------------------------------------------------------------------------------------------------

--Check STATUS ASM:
set linesize 300 
set pagesize 200 
col path for a60 
select group_number,d isk_number, name, os_mb,total_mb, free_mb, path, header_status, mode_status 
from v$asm_disk;
          
--------------------------------------------------------------------------------------------------------------------


--Check ASM
set linesize  1000
set pagesize  9999
set trimspool on
set verify    off
column disk_group_name        format a10           head 'Disk Group Name'
column total_mb               format 999,999,999   head 'File Size (MB)'
column used_mb                format 999,999,999   head 'Used Size (MB)'
column pct_used               format 999.99        head 'Pct. Used'
column pct_free               format 999.99        head 'Pct. Free'
SELECT 
	b.group_number disk_group_number,
	b.name  disk_file_name, 
	b.total_mb  total_mb, 
	b.free_mb free_mb,
	(b.total_mb - b.free_mb) used_mb,decode(b.total_mb,0,0,(ROUND((1- (b.free_mb / b.total_mb))*100, 2))) 
	pct_used, (100- decode(b.total_mb,0,0,(ROUND((1- (b.free_mb / b.total_mb))*100, 2)))) pct_free 
FROM v$asm_diskgroup b 
ORDER BY b.group_number;


--------------------------------------------------------------------------------------------------------------------

--Check DISK GROUP OFFLINE/OFFILE
set linesize 300 
set pagesize 200 
col path for a60 
select group_number, disk_number, name, os_mb,total_mb, free_mb, path, header_status,mode_status 
from v$asm_disk
where mode_status ='OFFLINE';

--------------------------------------------------------------------------------------------------------------------

--Check SIZE ASM
set linesize  145
set pagesize  9999
set verify    off
column group_name             format a20           head 'Disk Group|Name'
column sector_size            format 99,999        head 'Sector|Size'
column block_size             format 99,999        head 'Block|Size'
column allocation_unit_size   format 999,999,999   head 'Allocation|Unit Size'
column state                  format a11           head 'State'
column type                   format a6            head 'Type'
column total_mb               format 999,999,999   head 'Total Size (MB)'
column used_mb                format 999,999,999   head 'Used Size (MB)'
column pct_used               format 999.99        head 'Pct. Used'
break on report on disk_group_name skip 1
compute sum label "Grand Total: " of total_mb used_mb on report
SELECT
    name                                     group_name
  , sector_size                              sector_size
  , block_size                               block_size
  , allocation_unit_size                     allocation_unit_size
  , state                                    state
  , type                                     type
  , total_mb                                 total_mb
  , (total_mb - free_mb)                     used_mb
  , ROUND((1- (free_mb / total_mb))*100, 2)  pct_used
FROM
    v$asm_diskgroup
ORDER BY
    name
/