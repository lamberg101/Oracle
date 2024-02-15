check service db

$> srvctl status service -d ODBIC

--------------------------------------------------------------------------------

SQL> 
SELECT name, network_name
FROM v$active_services
ORDER BY 1;



--CEK SERVICE
select con_id, name from cdb_services order by con_id, name;