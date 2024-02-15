Note!
- Check size dump nya dan pastikan space (tbs) nya cukup
- process backup, monitoring fra, space tbs nya dan logops

1. create tbs opverona VERONATSEL_TBS 140G

SQL> CREATE TABLESPACE VERONATSEL_TBS DATAFILE '+DATAIMC' size 100M autoextend on next 512M maxsize 30G;

alter 3x.
SQL> alter tablespace VERONATSEL_TBS add datafile '+DATAIMC' size 100M autoextend on next 512M maxsize 30G;


3. reset pass & assign kuota ke tablespace VERONATSEL_TBS

SQL> alter USER VERONA_OASIS identified by oasis_verona#2020 account unlock;
SQL> ALTER USER VERONA_OASIS QUOTA UNLIMITED ON VERONATSEL_TBS;


2. remap schema
$ nohup impdp \"/ as sysdba\" directory=DATA_PUMP_DIR dumpfile=TSEL_VERONA_DUMP_01022020.dmp logfile=IMPRT_TSEL_VERONA.log REMAP_TABLESPACE=USERS:VERONATSEL_TBS, DATA:VERONATSEL_TBS REMAP_SCHEMA=TSEL_VERONA:VERONA_OASIS &
