Dede Sulaeman, [19.04.20 10:39]
restore archivelog from logseq=32680 until logseq=32686 thread =1 from tag 'TAG20200419T030746';

Fatur Rohman, [19.04.20 10:39]
export ORACLE_SID=OPCIS1
$ORACLE_HOME=/u01/app/oracle/product/11.2.0.4/dbhome_1
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.4/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH
$ORACLE_HOME/bin/rman target/ trace=/home/oracle/restore_3680_new.log << EOF
run {
allocate channel ch00 device type 'sbt_tape';
send 'NB_ORA_SERV=tbsnbuvpapp1.telkomsel.co.id, NB_ORA_CLIENT=exa62pdb3-vip.telkomsel.co.id';
restore archivelog from logseq=32680 until logseq=32686 thread =1 from tag 'TAG20200419T030746';
}
exit
EOF


cari di chattt