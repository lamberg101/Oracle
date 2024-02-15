***HOW TO REPLACE REDOLOG***

1. Check current size

select group#,THREAD#,bytes/1024/1024 "Size in MB" from v$log;

   GROUP#    THREAD# Size in MB
---------- ---------- ----------
         1          1         1024
         2          1         1024
         3          2         1024
         4          2         1024
         

--------------------------------------------------------------------------------------------------------------------------------

2. drop current size

Cari cara drops


--------------------------------------------------------------------------------------------------------------------------------


3. Check logfile

set linesize 900
col MEMBER format a80
SELECT * FROM V$LOGFILE;  
note: sudah di drop untuk group 1 sampai dengan 4)

    GROUP# STATUS  TYPE    MEMBER                                                                           IS_
---------- ------- ------- -------------------------------------------------------------------------------- ---
         5         STANDBY +DATAC5/opuxptbs/onlinelog/group_5.2307.971583675                                NO
         5         STANDBY +RECOC5/opuxptbs/onlinelog/group_5.1711.971583677                                YES
         6         STANDBY +DATAC5/opuxptbs/onlinelog/group_6.2308.971583677                                NO
         6         STANDBY +RECOC5/opuxptbs/onlinelog/group_6.1712.971583677                                YES
         7         STANDBY +DATAC5/opuxptbs/onlinelog/group_7.2309.971583679                                NO
         7         STANDBY +RECOC5/opuxptbs/onlinelog/group_7.1713.971583679                                YES
         8         STANDBY +DATAC5/opuxptbs/onlinelog/group_8.2310.971583679                                NO
         8         STANDBY +RECOC5/opuxptbs/onlinelog/group_8.1714.971583681                                YES
         9         STANDBY +DATAC5/opuxptbs/onlinelog/group_9.2311.971583681                                NO
         9         STANDBY +RECOC5/opuxptbs/onlinelog/group_9.1715.971583681                                YES
        10         STANDBY +DATAC5/opuxptbs/onlinelog/group_10.2312.971583681                               NO

    GROUP# STATUS  TYPE    MEMBER                                                                           IS_
---------- ------- ------- -------------------------------------------------------------------------------- ---
        10         STANDBY +RECOC5/opuxptbs/onlinelog/group_10.1716.971583683                               YES
        
--add redo log
ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 11 ('+RECOC5','+DATAC5' ) SIZE 2048m;
ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 12 ('+RECOC5','+DATAC5' ) SIZE 2048m;
ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 13 ('+RECOC5','+DATAC5' ) SIZE 2048m;
ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 14 ('+RECOC5','+DATAC5' ) SIZE 2048m;

ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 15 ('+RECOC5','+DATAC5' ) SIZE 2048m;
ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 16 ('+RECOC5','+DATAC5' ) SIZE 2048m;
ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 17 ('+RECOC5','+DATAC5' ) SIZE 2048m;
ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 18 ('+RECOC5','+DATAC5' ) SIZE 2048m;

--set linesize 900
col MEMBER format a80
SELECT * FROM V$LOGFILE;
    GROUP# STATUS  TYPE    MEMBER                                                                           IS_
---------- ------- ------- -------------------------------------------------------------------------------- ---
         5         STANDBY +DATAC5/opuxptbs/onlinelog/group_5.2307.971583675                                NO
         5         STANDBY +RECOC5/opuxptbs/onlinelog/group_5.1711.971583677                                YES
         6         STANDBY +DATAC5/opuxptbs/onlinelog/group_6.2308.971583677                                NO
         6         STANDBY +RECOC5/opuxptbs/onlinelog/group_6.1712.971583677                                YES
         7         STANDBY +DATAC5/opuxptbs/onlinelog/group_7.2309.971583679                                NO
         7         STANDBY +RECOC5/opuxptbs/onlinelog/group_7.1713.971583679                                YES
         8         STANDBY +DATAC5/opuxptbs/onlinelog/group_8.2310.971583679                                NO
         8         STANDBY +RECOC5/opuxptbs/onlinelog/group_8.1714.971583681                                YES
         9         STANDBY +DATAC5/opuxptbs/onlinelog/group_9.2311.971583681                                NO
         9         STANDBY +RECOC5/opuxptbs/onlinelog/group_9.1715.971583681                                YES
        10         STANDBY +DATAC5/opuxptbs/onlinelog/group_10.2312.971583681                               NO
		10         STANDBY +RECOC5/opuxptbs/onlinelog/group_10.1716.971583683                               YES
        11         ONLINE  +RECOC5/opuxptbs/onlinelog/group_11.47276.982837873                              NO
        11         ONLINE  +DATAC5/opuxptbs/onlinelog/group_11.6345.982837873                               NO
        12         ONLINE  +RECOC5/opuxptbs/onlinelog/group_12.47253.982837883                              NO
        12         ONLINE  +DATAC5/opuxptbs/onlinelog/group_12.6346.982837883                               NO
        13         ONLINE  +RECOC5/opuxptbs/onlinelog/group_13.47248.982837893                              NO
        13         ONLINE  +DATAC5/opuxptbs/onlinelog/group_13.6347.982837895                               NO
        14         ONLINE  +RECOC5/opuxptbs/onlinelog/group_14.17929.982837905                              NO
        14         ONLINE  +DATAC5/opuxptbs/onlinelog/group_14.6348.982837905                               NO
        15         ONLINE  +RECOC5/opuxptbs/onlinelog/group_15.46480.982837923                              NO
        15         ONLINE  +DATAC5/opuxptbs/onlinelog/group_15.6349.982837925                               NO
        16         ONLINE  +RECOC5/opuxptbs/onlinelog/group_16.46507.982837931                              NO
        16         ONLINE  +DATAC5/opuxptbs/onlinelog/group_16.6350.982837931                               NO
        17         ONLINE  +RECOC5/opuxptbs/onlinelog/group_17.46515.982837941                              NO
        17         ONLINE  +DATAC5/opuxptbs/onlinelog/group_17.6351.982837941                               NO
        18         ONLINE  +RECOC5/opuxptbs/onlinelog/group_18.6160.982837955                               NO
        18         ONLINE  +DATAC5/opuxptbs/onlinelog/group_18.6352.982837957                               NO
28 rows selected.




-----------
check status sekarang
SQL> select group#,THREAD#,bytes/1024/1024 "Size in MB" from v$log;

    GROUP#    THREAD# Size in MB
---------- ---------- ----------
         1          1       1024
         2          1       1024
         3          2       1024
         4          2       1024
        11          1       2048
        12          1       2048
        13          1       2048
        14          1       2048
        15          2       2048
        16          2       2048
        17          2       2048

    GROUP#    THREAD# Size in MB
---------- ---------- ----------
        18          2       2048

---------------------------------
 dan sekarang di drop untuk group 1 sampai dengan 4
 dimulai dengan yang inactive yaitu dengan no 4
 
    GROUP#    THREAD#    MEMBERS STATUS
---------- ---------- ---------- ----------------
         1          1          2 ACTIVE
         2          1          2 ACTIVE
         3          2          2 ACTIVE
         4          2          2 INACTIVE
        11          1          2 CURRENT
        12          1          2 UNUSED
        13          1          2 UNUSED
        14          1          2 UNUSED
        15          2          2 CURRENT
        16          2          2 UNUSED
        17          2          2 UNUSED
        18          2          2 UNUSED
        
------------
Alter database drop logfile group 4;

lalu check kembali group yg statusnya inactive 
dan seterusnya:
Alter database drop logfile group 1;
Alter database drop logfile group 2;
Alter database drop logfile group 3;




================


Lamberg Nicholas, [03.10.19 19:42]
[Forwarded from Slamet Riyadi]
resize/add redolog :
------------
alter database add logfile thread 1 group 9 ('+DATAC4','+RECOC4') size 500M,group 10 ('+DATAC4','+RECOC4') size 500M,group 11 ('+DATAC4','+RECOC4') size 500M,group 12 ('+DATAC4','+RECOC4') size 500M,group 13 ('+DATAC4','+RECOC4') size 500M;
alter database add logfile thread 2 group 14 ('+DATAC4','+RECOC4') size 500M,group 15 ('+DATAC4','+RECOC4') size 500M,group 16 ('+DATAC4','+RECOC4') size 500M,group 17 ('+DATAC4','+RECOC4') size 500M,group 19 ('+DATAC4','+RECOC4') size 500M;

pertama-tama Check status redolog nya kalo sudah inactive boleh langsung di drop, tapi kalo belum inactive lakuin langkah-langkah berikut:

SQL> select group#,thread#,sequence#,bytes/1024/1024/1024 GB,archived,status from v$log;

SQL> alter system checkpoint global; ==>> untuk mengubah status redolog nya atau di swicth
SQL> alter system switch logfile;

alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;
alter database drop logfile group 4;
 
        

 