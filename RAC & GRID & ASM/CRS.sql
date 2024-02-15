--before restart

$ ps -ef |grep pmon
$ . .grid_profile
$ crsctl stat res -t
$ ps -ef |grep inherit
$ . .grid_profile
$ asmcmd
ASMCMD> lsdg

----------------------------------------------------------------------

--STOP/DISSABLE CRS

login ke root  
$ cd /u01/app/19.0.0.0/grid/bin/

start cluster
$ ./crsctl check crs
$ ./crsctl stop crs
$ ./crsctl status crs
$ ./crsctl disable crs

--START CLUSTER SEKALIAN KEDUA NODE
$> ./crsctl check cluster -all
$> ./crsctl start cluster -all
$> ./crsctl check cluster -all

start listener
$> lsnrctl status
$> lsnrctl start

--restart server oleh tim mosigma

----------------------------------------------------------------------

--after aktivity,pengeCheckan status db,crs,listener, dan asm
$ ps -ef |grep pmon
$ . .grid_profile
$ crsctl stat res -t
$ ps -ef |grep inherit
$ . .gridprofile
$ ASMCMD
ASMCMD> lsdg

----------------------------------------------------------------------

--STEP KE EMPAT
heatlh check

----------------------------------------------------------------------


EXAMPLE
--disable crs exa62tbs node 1
1. login ke root  
2. masuk ke dir 		: /u01/app/19.0.0.0/grid/bin
3. ketikkan 			: ./crsctl check crs
4. lalu matikkan dengan : ./crsctl stop crs 
--4. lalu matikkan dengan : ./crsctl stop cluster -all --ini untuk 2 node saja
--4. lalu matikkan dengan : ./crsctl check cluster -all --ini untuk 2 node saja
5. ketikkan 			: ./crsctl check crs
6. Disable crs 			: ./crsctl disable crs

--enable crs exa62tbs node 1
1. login ke root  
2. masuk ke dir 		: /u01/app/19.0.0.0/grid/bin
3. ketikkan 			: ./crsctl check crs
4. enable  crs 			: ./crsctl enable crs
5. lalu start dengan 	: ./crsctl start crs
6. ketikkan 			: ./crsctl check crs
