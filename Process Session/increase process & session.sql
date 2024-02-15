1. contoh error:

ORA-12516: TNS:listener could not find available handler with matching protocol stack
ORA-00020: maximum number of processes (%s) exceeded


2. command

SQL> alter system set processes = 150 scope = spfile;
SQL> alter system set sessions = 300 scope = spfile;
SQL> alter system set transactions = 330 scope = spfile;  
SQL> shutdown immediate;
SQL> startup;


3. cross check

select name, value  
from v$parameter  
where name in ('processes', 'sessions', 'transactions');  