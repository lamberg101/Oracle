*.audit_file_dest='/u01/app/oracle/admin/OPCUGNEW/adump'
*.control_files='+DATAC2/OPCUGNEW/CONTROLFILE/OPCUGNEW_stby.ctl'
*.db_file_name_convert='+DATAC2/primary','+DATAC2/standby','+RECOC2/primary','+RECOC2/standby'
*.db_name='primary'
*.db_unique_name='standby'
*.db_recovery_file_dest='+RECOC2'
*.db_create_file_dest='+DATAC2'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=standbyXDB)'
*.fal_client='standby'
*.fal_server='primary'
*.log_archive_config='dg_config=(standby,primary)'
*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=standby'
*.log_archive_dest_2='SERVICE=primary_node1 ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=primary'
*.log_archive_dest_state_3='DEFER'
*.log_file_name_convert='+DATAC2/primary','+DATAC2/standby','+RECOC2/primary','+RECOC2/standby'


note!
next untuk craete ODG untuk v19.. passorapw nya di hapus ignorecase=Y