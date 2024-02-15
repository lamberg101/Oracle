--Check MAA
1. Total session (include dom even primary/standby)

2. Load all db

3. CPU & Memory & swap
exa62bsdpdb1-mgt.telkomsel.co.id
exa62bsdpdb2-mgt.telkomsel.co.id
exa62pdb3-mgt.telkomsel.co.id
exa62pdb4-mgt.telkomsel.co.id

4. Response time listener
LISTENER_exa62pdb3-mgt.telkomsel.co.id	
LISTENER_exa62pdb4-mgt.telkomsel.co.id	

5. status crs
. .grid
crsctl check crs

6. status asm
asmcmd lsdg


sqlplus / as sysasm
SQL>
set linesize 200
set pages 99
select * from gv$asm_operation;


