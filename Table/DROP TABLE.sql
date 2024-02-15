#DROP TABLE
-----------
DROP TABLE TABLE_NAME;
DROP TABLE SCHEMA.TABLE_NAME;
DROP TABLE ICACBSMS1.T_RATEDDATASMSIW201703 PURGE;



#CASCADE
--------
DROP TABLE TABLE_NAME CASCADE CONSTRAINTS;

Note!
Deletes all foreign keys that reference the table to be dropped, then drops the table.



#PURGE
------
DROP TABLE TABLE_NAME PURGE;

Note!
The drop table command moves a table into the recycle bin unless purge was also specified.




