
col "Average of % Growth JAN 19" JUSTIFY LEFT FORMAT 99,990.00
col GROW_SIZE JUSTIFY LEFT FORMAT 999,990.000
col Average_PCT_GROW JUSTIFY LEFT FORMAT 999,990.00
col "Projection % growth DB 3 Mth" JUSTIFY LEFT FORMAT 999,990.00
col "Projection % Util (3 Months)" JUSTIFY LEFT FORMAT 999,990.00
col PCT_GROW JUSTIFY LEFT FORMAT 999,990.000
col GROW_SIZE JUSTIFY LEFT FORMAT 999,990.000
col "% Utilization" JUSTIFY LEFT FORMAT 999,990.00
col PCT_GR_AC_SZ JUSTIFY LEFT FORMAT 999,990.000
col GROW_ACT_SIZE JUSTIFY LEFT FORMAT 999,990.000
set head off
select J.dbname, avg(J.PCT_GROW) as "Average of % Growth JAN 19" ,avg(J.PCT_GROW)*3 as "Projection % growth DB 3 Mth" , 
Avg(J.UTILIZATION) as "% Utilization" , (avg(J.PCT_GROW)*3)+(Avg(J.UTILIZATION)) as "Projection % Util (3 Months)"
from (select H.dbname, H.dbsize,  to_char(H.getdate,'DD-MM-YYYY') "Date", H.undosz, H.actsz, H.dtfsz, 
G.SIZE_NEXT_DAY-H.dbsize as GROW_SIZE, ((G.SIZE_NEXT_DAY-H.dbsize)/H.dbsize)*100 as "PCT_GROW",
(H.dbsize/H.dtfsz)*100 as "UTILIZATION",G.actsz-H.actsz as GROW_ACT_SIZE , ((G.actsz-H.actsz)/H.actsz)*100 as PCT_GR_AC_SZ from 
(select b.dbname, c.getdate, c.dayplus1, b.dbsize as SIZE_NEXT_DAY, b.actsz from db_grow b, 
(select a.dbname , a.getdate,a.actsz, to_char(a.getdate,'DD')+1 as dayplus1   from db_grow a where to_char(getdate,'MMYYYY')='112018' 
order by dayplus1 ) C
where to_char(b.getdate,'DD')=c.dayplus1
and to_char(b.getdate,'MMYYYY')='102019'
and b.dbname=c.dbname) G, db_grow H
where H.getdate=G.getdate
and H.dbname=G.dbname
order by H.dbname, H.getdate ) J
group BY J.dbname
order by 1;




