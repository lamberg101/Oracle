1. Check lokasi spfile nya:

[oracle@cc011adm01vm01 ~]$ srvctl config database -d ODB2BOP
Database unique name: ODB2BOP
Database name: 
Oracle home: /u02/app/oracle/product/12.1.0/dbhome_8
Oracle user: oracle
Spfile: +DATAC1/ODB2BOP/spfileODB2BOP.ora ---disini
Password file: +DATAC1/ODB2BOP/PASSWORD/passwd
Domain: id1.ocm.s7065770.oraclecloudatcustomer.com
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools: 
Disk Groups: DATAC1
Mount point paths: 
Services: 
Type: RAC
Start concurrency: 
Stop concurrency: 
OSDBA group: dba
OSOPER group: racoper
Database instances: ODB2BOP1,ODB2BOP2
Configured nodes: cc011adm01vm01,cc011adm02vm01
Database is administrator managed

2. create pfile nya :

SQL> create pfile='/home/oracle/pfile_ODB2BOP_20210603.txt' from spfile='+DATAC1/ODB2BOP/spfileODB2BOP.ora';

3. ubah parameter di pfile nya:

ODB2BOP1.__sga_target=5368709120
ODB2BOP2.__sga_target=5368709120
*.sga_target=5368709120

menjadi 
ODB2BOP1.__sga_target=6768709120
ODB2BOP2.__sga_target=6768709120
*.sga_target=6768709120

4. create spfile from pfile yang sudah di ubah tadi

SQL> create spfile='+DATAC1/ODB2BOP/spfileODB2BOP.ora' from pfile='/home/oracle/pfile_ODB2BOP_20210603.txt';

5. startup database nya

$ srvctl start database -d ODB2BOP