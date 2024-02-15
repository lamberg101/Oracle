set linesize 300
col logon for a20
col machine for a40
SELECT DECODE(TRUNC(SYSDATE - LOGON_TIME), 0, NULL, TRUNC(SYSDATE - LOGON_TIME) || ' Days' || ' + ') || 
TO_CHAR(TO_DATE(TRUNC(MOD(SYSDATE-LOGON_TIME,1) * 86400), 'SSSSS'), 'HH24:MI:SS') LOGON, 
SID, gv$session.SERIAL#, gv$process.SPID , ROUND(gv$process.pga_used_mem/(1024*1024), 2) PGA_MB_USED, 
gv$session.USERNAME, STATUS, OSUSER, MACHINE
gv$session.PROGRAM, MODULE 
FROM gv$session, gv$process 
WHERE gv$session.paddr = gv$process.addr
and gv$session.username is not null 
--and status = 'ACTIVE' 
--and v$session.sid = 97
--and gv$session.username in ('PRDP12_OMS_USER','PRDP_OMS_USER','PREPRDP_OMS_USER')
--and v$process.spid = 24301
ORDER BY pga_used_mem DESC;


LOGON			    	SID    	SERIAL# 	SPID		PGA_MB_USED USERNAME	STATUS		OSUSER		MACHINE
-------------------- ---------- ---------- -----------	----------- ----------- ----------	-----------	-------- 
01:48:08		   		3336    21451 		95830		1.4 		APPLSYSPUB	INACTIVE 	apps		ebspapp1
02:38:56		   		1730    39749 		340750		1.4 		APPLSYSPUB	INACTIVE 	apps		ebspapp1
08:55:29		    	966     36179 		19386		1.4 		APPLSYSPUB	INACTIVE 	apps		ebspapp1
6 Days + 03:17:45	   	2047    61661 		263505		1.24 		IPM			INACTIVE 	oracle		ipmpapp2
73 Days + 16:07:22	   	2145    54669 		234313		1.24 		DBSNMP		INACTIVE 	oracle		exapdb01-mgt.telkomsel.co.id
51 Days + 18:16:12	    792     38173 		107823		1.24 		DBSNMP		INACTIVE 	oracle		exapdb01-mgt.telkomsel.co.id
6 Days + 03:07:53	   	2984    12963 		66397		1.24 		IPM			INACTIVE 	oracle		ipmpapp2-rep
73 Days + 16:07:20	   	2998    42921 		94750		1.23 		DBSNMP		INACTIVE 	oracle		exapdb02-mgt.telkomsel.co.id
08:43:40		    	294     58949 		30350		.97 		DBSNMP		ACTIVE		oracle		exapdb02-mgt.telkomsel.co.id
2 Days + 15:09:49	   	3667    41705 		199508		.97 		SYS			ACTIVE		oracle		exapdb01-mgt.telkomsel.co.id
5 Days + 01:34:08	   	1476    52191 		41345		.95 		APPS		INACTIVE 	apps		ebspapp1
5 Days + 01:34:08	   	1131    55325 		41331		.95 		APPS		INACTIVE 	apps		ebspapp1
5 Days + 01:34:10	    187     15457 		41323		.95 		APPS		INACTIVE 	apps		ebspapp1
00:00:04		   		3592    58601 		17733		.95 		APPS		INACTIVE 	apps		ebspapp1
5 Days + 01:34:12	   	3147    52711 		41264		.95 		APPS		INACTIVE 	apps		ebspapp1
3 Days + 21:14:01	   	2812    13173 		96979		.95 		APPS		INACTIVE 	apps		ebspapp1