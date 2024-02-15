script export:
nohup expdp system/oracle@ODDPOS directory=EXPDP_ODDPOS12 dumpfile=EXPDP_ODDPOS12C_20082021_%U.dmp logfile=expdp_ODDPOS12C_20082021.log schemas=APPS,APPS_PRM,COMMET,DGPOS_DEV,DIAMOND,DMS,OTDGPOS,WEBDEALER EXCLUDE=STATISTICS parallel=8 filesize=30G &
. ODDPOSC.env
expdp system@ODDPOS attach=SYS_EXPORT_SCHEMA_02

script import:
nohup impdp system/oracle@ODDGPOS directory=IMPDP_ODDPOS19 dumpfile=EXPDP_ODDPOS12C_20082021_%U.dmp logfile=impdp_ODDPOS12C_20082021.log cluster=N parallel=8 &



==================================================================================================================

ODPOM

#Check DIRECTORY
set lines 300
col owner for a20
col directory_name for a30
col directory_path for a70
select owner, directory_name, directory_path 
from dba_directories 
where directory_name='DUMP_NFS';

met pagi tim DBA boleh mintol import table PRO_PAYLOAD_V3 ke user POMAPP db ODPOMC
  source file : exdmp_PRO_PAYLOAD_V3_20210506_*.dmp
 
--USING NOHUP




---------------------------------------------------------------------------------------------------
--USING PARFILE
vi  impdp_exdmp_PRO_PAYLOAD_V3_20211204_010523.par 

directory=DUMP_NFS 
dumpfile=exdmp_PRO_PAYLOAD_V3_20211204_010523.dmp 
query="WHERE EVENT_ID in ('862715434','862715435','862715422','862716292','862716150')" 
logfile=impdp_exdmp_PRO_PAYLOAD_V3_20211204_010523.log 
remap_schema=proapp:POMAPP 
remap_tablespace=DATAL03:DATAL01,IXL01:DATAL01 
CONTENT=DATA_ONLY

nohup impdp system/oracle@ODPOM parfile=impdp_exdmp_PRO_PAYLOAD_V3_20211204_010523.par &

---------------------------------------------------------------------------------------------------
--USING NOHUP
nohup impdp system/oracle@ODPOM 
directory=DUMP_NFS 
dumpfile=exdmp_PRO_PAYLOAD_V3_20211117_010524.dmp 
--query=\"WHERE EVENT_ID =\'859043564\'\" 
logfile=impdp_exdmp_PRO_PAYLOAD_V3_20211117_010524.log 
remap_schema=proapp:POMAPP 
remap_tablespace=DATAL03:DATAL01,IXL01:DATAL01 
CONTENT=DATA_ONLY &
