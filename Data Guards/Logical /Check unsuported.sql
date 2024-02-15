--chek unsupoter standby
select count(*) from dba_logstanby_unsupported;


--Check sebelum upgrade (kalau no row/berrti all support/bisa pakai logical)
select count(*) from dba_logstdby_unsupported;