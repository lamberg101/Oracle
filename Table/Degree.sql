--TABLE
select table_name, degree 
from dba_tables 
where table_name in ('PURCHASE_HISTORY','PURCHASE_HISTORY_SPEC');


--INDEX
select index_Name, degree 
from dba_indexes 
where index_name in ('IDX_PK_PURCHASE_HISTORY','IDX_PK_PURCHASE_HISTORY_SPEC');