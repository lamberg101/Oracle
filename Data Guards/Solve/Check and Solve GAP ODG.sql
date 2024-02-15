Untuk solving GAP ODG, dengan catatan :
1. Perbedaan gap yang jauh dikarenakan ada archive yang sudah ga ada di primary, namun masih ada backup archive di primary
2. Tidak ada valid error(exp: error password, error tns, dll)


====MOP Checking GAP ODG====
1. Check apakah ada dest error di primary :
	SQL> select inst_id, dest_id, error from gv$archive_dest_status where dest_id in (1,2,3);
	RESULT|  	 INST_ID    DEST_ID	  ERROR
				---------- ---------- -----------------------------------------------------------------
					1	    1
					1	    2
					1	    3
					2	    1
					2	    2
					2	    3
	**** Yang perlu diperhatikan, pastikan dest yang dituju yakni untuk ODG nya dan jika ada error coba berikut :
	     1. Matikan MRP di standby nya
		 2. Defer state dest di primary yang mengarah ke ODG
		 3. Lakukan switch logfile manual sebanyak 3x, di node 1 dan node 2
		 4. Nyalakan MRP di standby nya
		 5. Enable state dest di primary yang mengarah ke ODG
	
2. Jika step no 1 masih aman, lakukan pengeCheckan lebih lanjut di standby untuk memvalidasi apakah ada archive yang belum ter applied sudah tidak ada di primary
	2.a. Check Proses MRP APPLYING_LOG apakah ada status N/A dengan sequence# tersebut dimana BLOCK nya tidak bertambah, jika iya ini menandakan ada archive yang tidak bisa terkirim
	SQL> select inst_id,process,status,client_process,thread#,sequence#,block#,blocks from gv$managed_standby where status='APPLYING_LOG';
	RESULT|    INST_ID 		PROCESS   STATUS	  CLIENT_P   THREAD#  SEQUENCE#   BLOCK#	BLOCKS
			   ---------- ---------	 ------------ -------- ---------- ---------- --------- ----------
			    1 M				RP0  APPLYING_LOG 	N/A		    1	  	205648    3674906    3674938
	**** Yang perlu diperhatikan, lakukan ini dengan jeda 1-5 menit, dan lihat BLOCK# dan BLOCKS nya

3. Selanjutnya adalah mencari archive yang perlu di restore berdasarkan sequence yang tidak ter-applied pada standby
	3.a. Check batas bawah sequence yang belum terapplied dan tidak ada archive yang tergenerated
	SQL> select dest_id, thread#, sequence#, first_time, next_time, blocks, standby_dest, archived, registrar, applied, deleted, status, fal 
		 from gv$archived_log where thread#=2 and applied='NO' and FAL='YES' and DELETED='NO' order by first_change# asc;
	RESULT|   DEST_ID    THREAD#     SEQUENCE# 	FIRST_TIM NEXT_TIME	BLOCKS  STA ARC REGISTR  APPLIED   DEL  S FAL
			  ---------- ----------  ---------- --------- --------- ------  --- --- -------  ------- -----  - ---
			   2	      2	 		 116546 	07-OCT-20 07-OCT-20	 691236 NO  YES RFS		 NO	  		NO  A YES
			   2	      2	 		 116546 	07-OCT-20 07-OCT-20	 691236 NO  YES RFS		 NO	  		NO  A YES
			   2	      2	 		 116547 	07-OCT-20 07-OCT-20	1087042 NO  YES RFS		 NO	  		NO  A YES
			   2	      2	 		 116547 	07-OCT-20 07-OCT-20	1087042 NO  YES RFS		 NO	  		NO  A YES
			   2	      2	 		 116548 	07-OCT-20 07-OCT-20	3684635 NO  YES RFS		 NO	  		NO  A YES
			   2	      2	 		 116548 	07-OCT-20 07-OCT-20	3684635 NO  YES RFS		 NO	  		NO  A YES
			   2	      2	 		 116549 	07-OCT-20 07-OCT-20	2856882 NO  YES RFS		 NO	  		NO  A YES
	**** Yang perlu diperhatikan, SEQUENCE# yang paling atas adalah archivelog dengan sequence yang kemungkinan besar sudah terhapus di primary yakni 116456 di thread 2
	**** Lakukan juga untuk thread#=1 pada query
	
	3.b Check batas atas sequence yang belum terapplied dan tidak ada archive yang tergenerated
	SQL> select dest_id, thread#, sequence#, first_time, next_time, blocks, standby_dest, archived, registrar, applied, deleted, status, fal 
	from gv$archived_log where thread#=2 and applied='NO' and FAL='NO' and DELETED='NO' order by first_change# asc;
	RESULT|   DEST_ID    THREAD#     SEQUENCE# 	FIRST_TIM NEXT_TIME	BLOCKS  STA ARC REGISTR  APPLIED   DEL  S FAL
			  ---------- ----------  ---------- --------- --------- ------  --- --- -------  ------- -----  - ---
			   1	      2	  		 117118     10-OCT-20 10-OCT-20	3680182 NO  YES RFS      NO	        NO  A NO
			   1	      2	  		 117118     10-OCT-20 10-OCT-20	3680182 NO  YES RFS      NO	        NO  A NO
			   1	      2	  		 117119     10-OCT-20 10-OCT-20	3701253 NO  YES RFS      NO	        NO  A NO
			   1	      2	  		 117119     10-OCT-20 10-OCT-20	3701253 NO  YES RFS      NO	        NO  A NO
			   1	      2	  		 117120     10-OCT-20 10-OCT-20	3723240 NO  YES RFS      NO	        NO  A NO
			   1	      2	  		 117120     10-OCT-20 10-OCT-20	3723240 NO  YES RFS      NO	        NO  A NO
			   1	      2	  		 117121     10-OCT-20 10-OCT-20	3686231 NO  YES RFS      NO	        NO  A NO
	**** Yang perlu diperhatikan, SEQUENCE#-1 yang paling atas adalah archivelog dengan sequence yang kemungkinan besar sudah terhapus di primary yakni 117117 di thread 2
	**** Lakukan juga untuk thread#=1 pada query

	3.c Lakukan pengeCheckan crosscheck archivelog secara manual di primaru dengan sequence tadi di RMAN
	RMAN> CROSSCHECK ARCHIVELOG FROM SEQUENCE 116456 until SEQUENCE 117117 thread 2;
	RESULT| released channel: ORA_DISK_1
			allocated channel: ORA_DISK_1
			channel ORA_DISK_1: SID=46 instance=OPUIMTBS1 device type=DISK
			validation succeeded for archived log
			archived log file name=+RECOC2/OPUIMTBS/ARCHIVELOG/2020_10_11/thread_2_seq_116456.95672.1053480227 RECID=580021 STAMP=1053480300
			validation succeeded for archived log
			archived log file name=+RECOC2/OPUIMTBS/ARCHIVELOG/2020_10_11/thread_2_seq_116457.135010.1053480261 RECID=580022 STAMP=1053480333
			validation succeeded for archived log
			archived log file name=+RECOC2/OPUIMTBS/ARCHIVELOG/2020_10_11/thread_2_seq_116458.112140.1053480287 RECID=580028 STAMP=1053480360
			validation succeeded for archived log
			archived log file name=+RECOC2/OPUIMTBS/ARCHIVELOG/2020_10_11/thread_2_seq_116459.23071.1053480287 RECID=580029 STAMP=1053480361
			validation succeeded for archived log
			archived log file name=+RECOC2/OPUIMTBS/ARCHIVELOG/2020_10_11/thread_2_seq_117117.6153.1053480301 RECID=580031 STAMP=1053480377
			Crosschecked 5 objects
	RMAN> exit
    **** Yang perlu diperhatikan, seharusnya jika archive masih ada maka tercatat 662 objects, tapi hanya ada 5 ini artinya bahwa banyak archive sudah tidak ada di primary
	**** Ambil nilai sequence yang tidak tercatat tersebut yakni 116460 dan 117116
	**** Lakukan juga untuk thread# 1 sesuai sequence yang mau di restore

4. Selanjutnya adalah me-restore archive only sesuai sequence yang missing baik pada thread 1 dan thread 2
   **** Pastikan MRP di standby mati di standby
   **** Pastikan set DEFER state yang mengarah ke standby di Primary

   RMAN> restore archivelog from sequence 116460 until sequence 117116 thread 2;
   
   **** Yang perlu diperhatikan, jalankan di nohup atau lakukan hal ini dengan OEM
   **** Lakukan juga untuk thread# 1 sesuai sequence yang mau di restore
   **** Check selalu FRA nya jangan sampai penuh baik di PRIMARY dan STANDBY
   
5. Finishing, selanjutkan jika sudah selesai restore kembali nyalakan MRP di standby dan set ENABLE state yang mengarah ke standby di Primary, dan monitoring apply gap
   **** Check selalu FRA nya jangan sampai penuh baik di PRIMARY dan STANDBY
	
	