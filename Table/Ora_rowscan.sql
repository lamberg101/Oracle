Jika table tidak punya timestamp tapi mau diCheck kapan di insert.
Check nya dari ora_rowscn (perkiraan commit) 

https://docs.oracle.com/cd/B19306_01/server.102/b14200/pseudocolumns007.htm

select ORA_ROWSCN , x from tt1 where x=86 and rownum=1;

ORA_ROWSCN          X
---------- ----------
   9877923         86

SQL> select scn_to_timestamp(9877923) as timestamp from dual;

TIMESTAMP
---------------------------------------------------------------------------
02-NOV-21 04.05.50.000000000 PM