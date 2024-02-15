--NORMAL
srvctl status database -d OPCMC
srvctl stop database -d OPCMC
srvctl start database -d OPCMC

--MOUNT
ampe mount aja
srvctl start database -db OPDGPOSTBS -startoption mount

--INSTANCE: 
srvctl status database -d ODBIC
srvctl status instance -d ODCUST -i ODCUST2
srvctl start instance -d OPNBPBSD -i OPNBPBSD1 -o mount
srvctl stop instance -d ODCUST -i ODCUST2


--IMMADIATE
srvctl stop instance -d OPIDM -i OPIDM1 -o immediate
srvctl start instance -d OPIDM -i OPIDM1
srvctl status database -d OPIDM


--START MOUNT
srvctl status database -d OPNBPBSD
srvctl stop database -d OPNBPBSD -o immediate
srvctl start database -d OPNBPBSD -o mount


--STOP ABORT
srvctl status database -d OPRMD9IT
srvctl stop database -d OPRMD9IT -stopoption abourt -force
srvctl start database -d OPRMD9IT


srvctl stop instance -d oprfsevbsd -i oprfsevbsd2 -o immediate
srvctl start instance -d oprfsevbsd -i oprfsevbsd2 -o "READ ONLY"

col type format a20;
select INST_ID,to_char(start_time,'dd-mon-yyyy HH:MI:SS') start_time, type, item, units, sofar, total, to_char(timestamp,'dd-mon-yyyy HH:MI:SS') timestamp  
from gv$recovery_progress;

incase not solve
srvctl stop database -d oprfsevbsd 
srvctl start database -d oprfsevbsd -o "READ ONLY"


----------------------------------------------------------------------------------------------------------------

--SHUTDOWN
SHUTDOWN IMMEDIATE;
SHUTDOWN  TRANSACTIONAL;
SHUTDOWN ABORT;


--STARTUP
STARTUP;
STARTUP OPEN;
STARTUP MOUNT;

--BERTAHAP
STARTUP NOMOUNT;
ALTER DATABASE MOUNT;
ALTER DATABASE OPEN;


--OPEN DATABASE MANUAL.
select status from v$instance;
alter database mount;
alter database open;


----------------------------------------------------------------------------------------------------------------

kalau db on sendiri
masuk profile grid/asm
crsctl stat res -t
Check resource nya kalau ada ora (ora.tkcrm01.db) pake ora
crsctl modify resource tkcrm01.db -attr AUTO_START=never
