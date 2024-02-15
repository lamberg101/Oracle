1. EXPORT (on Primary)
--nohup expdp \"/ as sysdba\"  
directory=DATADUMP tables=TELKOMSEL.TRACE_LOG_TRANSACTION dumpfile=TRACE_LOG_TRANSACTION_082021_%U.dmp logfile=TRACE_LOG_TRANSACTION_082021.log flashback_scn=disesuaikan parallel=4 EXCLUDE=INDEX &


2. DROP TABLE (ON STANDBY OPSCM19 !!!)
SQL> DROP TABLE TELKOMSEL.TRACE_LOG_TRANSACTION; 


3. IMPORT (ON STANDBY OPSCM19 !!!!)
--nohup impdp \"/ as sysdba\"  
directory=STANDBY_DUMP dumpfile=TRACE_LOG_TRANSACTION_082021_%U.dmp logfile=IMP_TRACE_LOG_TRANSACTION_082021.log cluster=N  parallel=4  & 


4.CREATE INDEX (ON STANDBY OPSCM19 !!!!)
SQL>
CREATE INDEX "TELKOMSEL"."TRACE_LOG_TRANSACTION_NDX1" 
ON "TELKOMSEL"."TRACE_LOG_TRANSACTION" ("CREATED_PERIODE", "TRANSACTION_TYPE", "TRANSACTION_REFF_ID")
TABLESPACE "DATA2" PARALLEL (degree 8) nologging;

SQL>
ALTER INDEX TELKOMSEL.TRACE_LOG_TRANSACTION_NDX1 noparallel logging;

----------------------------------------------------------------------------------------------------------------------------------
