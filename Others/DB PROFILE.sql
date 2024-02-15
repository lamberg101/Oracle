1. Contoh profile OBIEE

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.3/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$PATH
export ORACLE_SID=OBIEE1
alias sq="sqlplus '/ as sysdba'"
alias oh='cd $ORACLE_HOME'
alias Checklog='tail -100f /u01/app/oracle/diag/rdbms/obiee/OBIEE1/trace/al*log'


---------------------------------------------------------------------------------------

2. contoh profile client.

ORACLE_HOSTNAME=cugsmepapp1; export ORACLE_HOSTNAME
ORACLE_HOME=/apps/oracle/product/11.2/client1; export ORACLE_HOME
PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH