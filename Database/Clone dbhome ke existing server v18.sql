1. Crosscheck and create tar file of the existing  dbhome
$> cd /apps/oracle/product/12.1.0/
$> nohup tar -czvf bck_oracle_home_19.2.tar.gz ./dbhome_3 &

2. Copy to the target server and extract 
$ nohup tar -xvf bck_oracle_home_18.0.0_dbhome3.tar.gz &
$ chmod -R 777 dbhome_3 --if needed


3. create the profile 
$> vi .18_profile 
export ORACLE_HOME=/apps/oracle/product/18.0.0/dbhome_3
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib


4. run the clone command using the newly created profile 
$> /apps/oracle/product/18.0.0/dbhome_3/oui/bin/runInstaller -silent -clone ORACLE_BASE="/apps/oracle" ORACLE_HOME="/apps/oracle/product/18.0.0/dbhome_3" ORACLE_HOME_NAME="dbhome_3"


--Versi 18 (sesuaikan profilenya)
$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/clone/bin/clone.pl ORACLE_BASE="/apps/oracle" ORACLE_HOME="/apps/oracle/product/18.0.0/dbhome_3" -defaultHomeName

