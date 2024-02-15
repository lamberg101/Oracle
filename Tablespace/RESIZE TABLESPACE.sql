1. check file name 

Select status, file_name, tablespace_name,autoextensible 
From dba_data_files 
Where tablespace_name in ('T_RATEDDATA_201709','IDX_RATEDATA_201909','IDX_RATEDATA_201908');


--------------------------------------------------------------------------------------------------------------------

2. setelah list file name kelaur, sesuaikan dengn comman dibawah.

ALTER DATABASE DATAFILE '+DATAC5/opicavctbs/datafile/dt_ratedata_201904.22262.1009630901'RESIZE 1G; 
ALTER DATABASE DATAFILE '+DATAC5/opicavctbs/datafile/idx_ratedata_201904.22266.1009630905'RESIZE 1G; 
ALTER DATABASE DATAFILE '+DATAC5/opicavctbs/datafile/dt_ratedata_201905.22270.1009630911'RESIZE 1G; 
ALTER DATABASE DATAFILE '+DATAC5/opicavctbs/datafile/idx_ratedata_201905.22278.1009630919'RESIZE 1G; 
ALTER DATABASE DATAFILE '+DATAC5/opicavctbs/datafile/dt_ratedata_201906.22283.1009630925'RESIZE 1G; 


=======================================================================================================================


note!
1. 	Pengurangan size (resize) tidak bisa dilakukan pada block di bawah high water mark. 
	High water mark adalah posisi block tertinggi yang pernah dipakai untuk extent. 
2. 	Eksekusi akan error kalau resize dilakukan di bawah High water mark: 
	ORA-03297: file contains used data beyond requested RESIZE value
3. 	Best practice-nya, kalau misalkan size datafile 4G, dan kita ingin menurunkan size-nya, 
	lakukan secara gradual (diturunkan 100M – 100M) untuk menemukan size(high water mark) yang sesuai.

4. Menghapus temp file.
	Untuk alasan keamanan, datafile tidak bisa dihapus (milik tablespace PERMANENT dan UNDO)
	Sedangkan temp file bisa dihapus karena file ini tidak berisi data. Dengan catatan, paling tidak sisakan 1 tempfile.
	SQL> alter database tempfile '/oradata/oracle/ts/temp02.dbf2' drop;



