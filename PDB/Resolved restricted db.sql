kalau dari apps restrict:

select INST_ID, logins from gv$instance;
alter system disable restricted session;
select inst_id,logins from gv$instance;

--INSTANCE: 
srvctl status database -d ODCUST
srvctl status instance -d ODCUST -i ODCUST2
srvctl stop instance -d ODCUST -i ODCUST2
srvctl start instance -d ODCUST -i ODCUST2


select INST_ID,NAME,OPEN_MODE,RESTRICTED from gv$pdbs order by 1,2;


select logins from v$instance;
alter system disable restricted session;
select logins from v$instance;


masuk pdb nya 
show pdbs;
ALTER SESSION SET CONTAINER=DBNAME;


-- Check dan solve accordingily, --usually run datapatch