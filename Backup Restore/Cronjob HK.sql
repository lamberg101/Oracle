Note!
--di sesuaikan zdlra tbs-zdrla bsd

$> vi hk_OPPOMTBS_lv1.sh  --zdlra tbs
------------------------------------
export ORACLE_SID=OPPOMTBS1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman target backup_admin/Welcome123 catalog ravpc1/Welcome123@zdlra trace=/home/oracle/script/backup/log/OPPOMTBS.log << EOF
run{  
--backup incremental level 1 cumulative device type sbt filesperset = 1 tag '%TAG' section size 64 G database plus archivelog not backed up filesperset = 32;
DELETE noprompt archivelog until time '(sysdate - 1)' backed up 1 times to device type SBT_TAPE;
}
exit
EOF

------------------------------------------------------------------------------------------------------------------------------------

$> vi hk_OPHUMBSD_lv1.sh ---zdlra bsd
------------------------------------
export ORACLE_SID=OPRFSODNEW1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman target backup_admin/Welcome123 catalog ravpc1/Welcome123@zdlrabsda-scan:1521/rabsdp:dedicated trace=/home/oracle/script/backup/log/OPRFSODNEW_incr.log << EOF
run{  
DELETE noprompt archivelog until time '(sysdate - 1)' backed up 1 times to device type SBT_TAPE;
}
crosscheck archivelog all;
exit
EOF


------------------------------------------------------------------------------------------------------------------------------------

--CRONJOB HK
0 2 * * * /home/oracle/script/backup/backup_oppomtbs_lv1.sh > /dev/null 2>&1 >> /home/oracle/script/backup/log/OPPOMTBS.log





