--COLLECT AWR
140477
@$ORACLE_HOME/rdbms/admin/awrrpt.sql
@?/rdbms/admin/awrrpt.sql


--GENERATE ADDM 
@$ORACLE_HOME/rdbms/admin/addmrpt
@?/rdbms/admin/addmrpt.sql

--hash_plan/explain plan
@?/rdbms/admin/sqltrpt.sql

--GENERATE ASH 
@$ORACLE_HOME/rdbms/admin/ashrpt.sql
@?/rdbms/admin/ashrpt.sql



							 
-----------------------------------------------------------------------------------------------------------------------------------------------

--Via OEM

1.	ASH Report (analytics or active session history) 
	- Run ASH Report dibawah grafik Top Activity.
	- Sesuaikan
	- Generate report
	- setelah itu klik save file.
 

2.	AWR Report (automatic workload repository) 
	- Performance
	- AWR > AWR Report.
	- Sesuaikan
	- Generate report
	- Save file.
 
 
3.	ADDM Report (automatic database diagnostic monitor) 
	- Performance > Adviors Home
	- Pilih ADDM
	- Sesuaikan start dan end time > Ok
	- View report
	- save file.
 
