EXECUTE SQL TUNE
=============================================
1. 1wvc9fafab8sx (sql id)
execute dbms_sqltune.accept_sql_profile(task_name => 'TASK_199036',task_owner => 'SYS', replace => TRUE);


2. f8yxwp68nna4p (sql id)
execute dbms_sqltune.accept_sql_profile(task_name => 'TASK_199022',task_owner => 'SYS', replace => TRUE, profile_type =>DBMS_SQLTUNE.PX_PROFILE); 

tunning advisor khusus per sql_id
- top activity 
- diatas top sql ada sql tuning advisor
- select top sql, lalu klik go
- lalu submit
- hasilnya bisa di lihat di plan > lalu buka table 
- klik di link new explain plan / compare explain plan



