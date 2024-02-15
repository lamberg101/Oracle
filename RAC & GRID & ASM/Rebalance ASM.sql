#Check PROCESS REBALANCE/ASM_OPERATION
----------------------------
sett +ASM2 --> ganti ke profile asm
. .grid_profile 

Set linesize 200
Set pagesize 100
sqlplus / as sysasm

select * from gv$asm_operation;

---------------------------------------------------------------------------------------------------------

--STOP REBALANCE PROCESS

$ . .grid_profile
$ sqlplus '/ as sysasm'
SQL>
set linesize 200
set pages 99
select * from gv$asm_operation;


SQL> alter diskgroup datac4 rebalance power 0;

---------------------------------------------------------------------------------------------------------

--Check PROGRESS REBALCANCE
select group_number, pass, state, power, (sofar/est_work)*100, est_rate, est_minutes 
from gv$asm_operation 
where state='RUN';


