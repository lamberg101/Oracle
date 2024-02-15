export ORACLE_SID=OPPOMTBS1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman target backup_admin/Welcome123 catalog ravpc1/Welcome123@zdlra trace=/home/oracle/script/backup/log/OPPOMTBS.log << EOF
run{  
backup incremental level 1 cumulative device type sbt filesperset = 1 tag '%TAG' section size 64 G database plus archivelog not backed up filesperset = 32;
}
exit
EOF
