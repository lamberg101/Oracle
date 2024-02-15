*** matikan db ***
srvctl status database -d OPSCM
srvctl stop database -d OPSCM

*** duplicat control file ***
rman target /
RMAN> startup nomount;
RMAN> restore controlfile to '+DATAC2' from '+DATAC2/opscm/controlfile/current.17809.958231563';
RMAN> restore controlfile to '+RECOC2' from '+DATAC2/opscm/controlfile/current.17809.958231563';

*** Check naming controlfile yang di restore ***
Check : SQL> select name from v$controlfile;
atau
Check : asmcmd
        asmcmd> cd +DATAC2/opscm/controlfile/
    asmcmd> ls
    asmcmd> cd +RECOC2/opscm/controlfile/
    asmcmd> ls
    
SQL> alter system set control_files='++DATAC2/opscm/controlfile/XXXXXX','+RECOC2/opscm/controlfile/XXXXXX' sid='*' scope=spfile;

SQL> shutdown immediate;

*** Start database ***
srvctl status database -d OPSCM 
srvctl start database -d OPSCM