--Check INDOUBT
select count(*) from dba_2pc_pending where state='prepared';


kalau ada e-mail indoubt.

select 'COMMIT FORCE '''||local_tran_id||''';' commit_command,'EXECUTE DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('''||local_tran_id||''');' purge_command 
from dba_2pc_pending WHERE state='prepared';

