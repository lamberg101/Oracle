1. Jika butuh credential
username 	: backup_admin
password 	: Welcome123
save as 	: BACKUP_ADMIN@NAMA_DB -- contoh BACKUP_ADMIN@OPPOM


-----------------------------------------------------------------------------------------------------------------------

2. KALAU BELUM ADA USERNYA
select username, account_status from dba_users where username='BACKUP_ADMIN'; 

create user backup_admin identified by Welcome123;
--alter user BACKUP_ADMIN identified by Welcome123;

--Oracle 11g:
GRANT DBA, SYSDBA TO BACKUP_ADMIN; 

--Oracle 12c:
GRANT DBA, SYSDBA, SYSBACKUP TO BACKUP_ADMIN; 


-----------------------------------------------------------------------------------------------------------------------

3. KALAU CREDENTIAL DETAIL BELUM DI SET

Host Credentials
user	: oracle
pass	: pass hostname
	
#masuk ke rman 
rman target backup_admin catalog ravpc1@zdlra
rman target backup_admin catalog ravpc1@rabsdp
Welcome123
list incarnation of database;


-----------------------------------------------------------------------------------------------------------------------

5. AKSES LAGI. 
Availability > Backup and Recovery > Backup setting.
recovery appliance = zdlra
virtual catalog user = ravpc1
REAL-TIME REDO TRANSPORT = BIARKAN SAJA!!!

Sesuaikan credential > Apply

--Check settingan 
Masuk ke RMAN lalu show all


-----------------------------------------------------------------------------------------------------------------------

--ADD/REGISTER DB KE ZDLRA
rman target backup_admin/Welcome123 catalog ravpc1/Welcome123@rabsdp

RMAN> register database;


-----------------------------------------------------------------------------------------------------------------------

--KALAU TIDAK BISA TEST BACKUP
SBT_LIBRARY=/u01/app/oracle/product/12.1.0.2/dbhome_1/lib/libra.so, 
SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/12.1.0.2/dbhome_1/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')