create and insert simple table.

1. Create 
create table test ( x int, y char(50) );
create table sys.test ( x int, y char(50) );


2. Insert
set timing on

begin
for i in 1 . . 60000
loop 
insert into test values ( i, 'x' );
end loop;
commit;
end;
/


2. Insert

set timing on
insert into test values (1, 'Y');

3. Select
select * from test where y ='Y';