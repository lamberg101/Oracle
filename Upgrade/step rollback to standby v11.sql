======= STEP BALIKIN KE v.11 lagi OPSCM19 ===========

1.matiin db OPSCM19 v19 (profile v.19)
srvctl status database -d OPSCM19
srvctl stop database -d OPSCM19

2.start dan dibalikin ke physical standby ( profile v.19) nyalain satu node aja 
startup mount;
alter database convert to physical standby;
shutdown immediate;

3.remove service versi 19 (profile v.19)
srvctl remove database  -d OPSCM19 

4.add pake profile OPSCM v.11
srvctl add database -d OPSCM19 -o /u01/app/oracle/product/11.2.0.4/dbhome_1
srvctl add instance -d OPSCM19 -i OPSCM191 -n exa62pdb3-mgt
srvctl add instance -d OPSCM19 -i OPSCM192 -n exa62pdb4-mgt
srvctl modify database -d OPSCM19 -r physical_standby
srvctl modify database -d OPSCM19 -p '+DATAC2/opscm19/parameterfile/spfileopscm19.ora'

5.create pfile='/home/oracle/ssi/slam/OPSCM19/opscm19_14092021.txt' from spfile='+DATAC2/opscm19/parameterfile/spfileopscm19.ora'; -- apus parameter __unified_pga_pool_size

6. create spfile='+DATAC2/opscm19/parameterfile/spfileopscm19.ora' from pfile='/home/oracle/ssi/slam/OPSCM19/opscm19_14092021.txt';

7. srvctl start database -d OPSCM19 - mount
8 . nyalaiin mrp standby
9.enable dest 2 di primary