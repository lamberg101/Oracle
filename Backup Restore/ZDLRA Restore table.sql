1. create table 
SQL> create table SIEBEL_HISTORY.TEST_RESTORE ( x int, y char(50) );

2. insert 
SQL> begin
for i in 1 .. 1000000000
loop
insert into SIEBEL_HISTORY.TEST_RESTORE values ( i, 'x' );
end loop;
commit;
end;
/

3. drop table dummy
SQL> select /*+ PARALLEL (10) */  count(*) from SIEBEL_HISTORY.TEST_RESTORE;
SQL> drop table SIEBEL_HISTORY.TEST_RESTORE PURGE;
SQL> select /*+ PARALLEL (10) */  count(*) from SIEBEL_HISTORY.TEST_RESTORE; --select lagi make sure table nya sudah tak ada.


======================

4. restore table dummy from zdlra ---mulai dari sini

RMAN> recover SIEBEL_HISTORY.TEST_RESTORE
until time "to_date('03/19/2020 16:00:00','mm/dd/yyyy hh24:mi:ss')"
auxiliary destination '/u01/app/oracle/aux';

-----atau jalankan nohup
$> nohup sh restore_table.sh > restore_tbl.log &

echo '======================================='
export ORACLE_SID=OPCRMBE1 ---sesuaikan
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1 ---sesuaikan
export PATH=$ORACLE_HOME/bin:$PATH ---sesuaikan

$ORACLE_HOME/bin/rman target / trace=/home/oracle/script/aux/restore_new.log << EOF
run
{
recover SIEBEL_HISTORY.TEST_RESTORE
until time "to_date('03/19/2020 16:00:00','mm/dd/yyyy hh24:mi:ss')"
auxiliary destination '+DATAC2';
}
exit
EOF


5. validasi table
SQL> select /*+ PARALLEL (10) */  count(*) from SIEBEL_HISTORY.TEST_RESTORE;

Note!
Pake set time on

tail -200f /u01/app/oracle/diag/rdbms/evsf_pitr_opcrmbe/evsF/trace/alert_evsF.log
tail -100f /u01/app/oracle/aux/restore_table_new.log


tail -200f /u01/app/oracle/aux/restore_table_new.log
tail -200f /u01/app/oracle/diag/rdbms/cndd_pitr_opcrmbe/CndD/trace/alert_CndD.log



