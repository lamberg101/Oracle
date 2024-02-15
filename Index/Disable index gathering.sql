
--PRE-CHECK 
Cross-check parameter and Health check Database.

--MAIN ACTION
Change parameter 
alter system set "_optimizer_gather_stats_on_load_index"=FALSE scope=spfile sid='*' ;

--------------------------------------------------------------------------------------------------------

INSTANCE 1

--CHECK STATUS
srvctl status database -d OPDGPOS19

--STOP DATABASE
srvctl stop instance -d OPDGPOS19 -i OPDGPOS191 -o immediate

--START DATABASE
srvctl start instance -d OPDGPOS19 -i OPDGPOS191
srvctl status database -d OPTOIPIMC

--------------------------------------------------------------------------------------------------------

INSATANCE 2

--CHECK STATUS DATABASE
srvctl status database -d OPDGPOS19

--STOP DATABASE
srvctl stop instance -d OPDGPOS19 -i OPDGPOS192 -o immediate

--START DATABASE
srvctl start instance -d OPDGPOS19 -i OPDGPOS192
srvctl status database -d OPDGPOS19

--------------------------------------------------------------------------------------------------------

--CROSS-CHECK 
Cross-check parameter and Health check Database.
