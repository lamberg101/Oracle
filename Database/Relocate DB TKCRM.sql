Relocate DB di server crm


di crmbsdcrmpdb1:
1. Check session nya masih rame apa engga
2. Kalo masih rame shutdown abort aja, terus startup normal, shutdown immediate, startup lagi
3. Pake sett +ASM1
4. command berikut:  crsctl relocate resource tkoms01.db ; date;

tunggu selesai~ kalau sudah
5. Restart listener di crmbsdcrmpdb2



di crmbsdcrmpdb2
-----------------
sett TKCRM01
sqlplus / as sysdba
SQL> shutdown immediate;
sett +ASM2
crsctl relocate resource tkcrm01.db

di crmbsdcrmpdb1
---------------- 
sett TKCRM01
sqlplus / as sysdba
SQL> startup;