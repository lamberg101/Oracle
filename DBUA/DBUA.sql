ssh -o ServerAliveInterval=30 10.49.132.94 -l oracle




Using DBCA to drop the database
$ export DISPLAY=10.2.230.111:1.0
$ dbca


khusus di exa82bsd-MAA pake moba extern

ssh -X oracle@10.49.132.94 (X uppercase)



create dulu profile untuk database baru
export ORACLE_SID=OPCUSTOR2
export ORACLE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
