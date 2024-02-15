
Timeline:
Pre-check 22:36
Mulai uprade 02:11
Selesai upgrade 04:17
Proses recomplie 04:20-04:27









2. Convert logical standby db OPSCM


SQL> select FLASHBACK_ON from v$database;
SQL> alter database recover managed standby database cancel;
SQL> alter database flashback on;
SQL> alter database recover managed standby database using current logfile disconnect from session;




SQL> alter system set cluster_database=false scope=spfile sid='*';
$ srvctl stop database -d OPSCM19 
$ srvctl status database -d OPSCM19 
SQL> startup mount;

 instance nya hanya nyala 1 (node1)



shutdown immediate;

startup mount;



SQL> alter database recover managed standby database cancel;
SQL> create restore point pre_upgrade_stb guarantee flashback database;
SQL> alter database recover managed standby database disconnect;


SQL>
begin
dbms_logstdby.build;
end;
/

--cancel (stop mrp)
--kalau lama Check sessionya





CONVERT PHYSICAL STANDBY INTO LOGICAL STANDBY
On standby 
SQL> alter database recover managed standby database cancel;

SQL> shutdown immediate;

SQL> startup mount;

SQL> alter database recover to logical standby keep identity;
		> cancel proses/mrp pakai session baru) 
		(alter database recover managed standby database cancel;) --tidak perlu akktfifin mrp nya
		> kalu tidak bisa, jalankan build log miner di primary
		> jalankan lagi 
		(alter database recover to logical standby keep identity;)





SQL> select INST_ID,name, open_mode, database_role from gv$database;

SQL> alter database activate standby database; 
	➔ jika database role ngak berubah menjadi logical standby
	➔ Check role database 
	(select INST_ID,name, open_mode, database_role from gv$database;)
	➔ pastikan sudah logical standby, status mounted.

SQL> alter database open;

SQL> alter database start logical standby apply immediate;

SQL> select state from v$logstdby_state;

--------------------------------------------------------------------------------------------------------



alter system set log_archive_dest_state_2=DEFER scope=both sid='*';







SQL> alter database stop logical standby apply;

SQL> create restore point before_upgrade_lstb guarantee flashback database;

-additional

select dbms_java.longname('TEST') from dual; --test kalau gagal jalanin java_jit_enabled,, lalu Check lagi
alter system set java_jit_enabled=false;
select dbms_java.longname('TEST') from dual;--test lagi

--execute sys.dbms_registry.loaded('JAVAVM');
--execute sys.dbms_registry.valid('JAVAM');
--alter system set "_system_trig_enabled"=false scope=memory;
--create or replace java system;

SQL> shutdown immediate; --kalau sudah di copy pass file tidak perlu di upgrade



#primary
OPSCM =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = exapdb62b-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPSCM)
    )
  )

OPSCM1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = exa62pdb3-vip)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SID = OPSCM1)
    )
  )

OPSCM2 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = exa62pdb4-vip)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SID = OPSCM2)
    )
  )  


##standby
OPSCM19=
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = exapdb62b-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPSCM19)
    )
  )

OPSCM191 =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = exa62pdb3-vip)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPSCM19)
      (SID = OPSCM191)
      (UR=A)  )   )

OPSCM192 =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = exa62pdb4-vip)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPSCM19)
      (SID = OPSCM192)
      (UR=A)  )   )





Di node 1 :
$ cp /u01/app/oracle/product/11.2.0.4/dbhome_1/dbs/orapwOPSCM1 /u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/orapwOPSCM191
Di node 2 :
$ scp /u01/app/oracle/product/11.2.0.4/dbhome_1/dbs/orapwOPSCM1 oracle@exa62pdb4:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/orapwOPSCM192




/u01/app/oracle/product/19.0.0.0/dbhome_1/jdk/bin/java -jar /u01/app/oracle/product/19.0.0.0/dbhome_1/rdbms/admin/preupgrade.jar TERMINAL TEXT


Hasil dari ORACLE GENERATED FIXUP SCRIPT
SQL>@/u01/app/oracle/product/11.2.0.4/dbhome_1/cfgtoollogs/ODDGPOS/preupgrade/preupgrade_fixups.sql




$ srvctl stop database -d OPSCM19 
SQL > startup;  instance nya hanya nyala 1 (node1)
SQL> alter system set cluster_database=false scope=spfile sid='*';



Before upgrade:
Log into the database and execute the preupgrade fixups
@/u01/app/oracle/product/11.2.0.4/dbhome_1/cfgtoollogs/OPSCM19/preupgrade/preupgrade_fixups.sql



After the upgrade:
Log into the database and execute the postupgrade fixups
@/u01/app/oracle/product/11.2.0.4/dbhome_1/cfgtoollogs/OPSCM19/preupgrade/postupgrade_fixups.sql



$ vi /etc/oratab
OPSCM19:/u01/app/oracle/product/11.2.0.4/dbhome_1:N


7b before DBUA, change cluster_database = TRUE 
alter system set cluster_database=true scope=spfile sid='*';
--setelah di alter,restart db,shutdown

startup 
pake cluster

srvctl status database -d OPSCM19
srvctl start database -d OPSCM19
srvctl stop database -d OPSCM19


dbua
sys/OR4cl35y5#2015


/u01/app/oracle/cfgtoollogs/dbua/upgrade2021-07-02_01-43-31AM --upgrade pertama
/u01/app/oracle/cfgtoollogs/dbua/upgrade2021-07-02_02-11-08AM --upgrade pertama



------------------------------------------------------------------------

alter system set log_archive_dest_state_2=defer scope=both sid='*';
alter system set log_archive_dest_state_2=enable scope=both sid='*';


alter database start logical standby apply immediate;
