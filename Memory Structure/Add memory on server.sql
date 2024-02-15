add memroy

1. Matiin database nya
lewat cluster

2. Stop listener nya
dari lsnrctl

2. Matiin clusternya (user root)
/u01/app/12.1.0/grid/bin/crsctl stop cluster -all

setelah add memory dari movm

1. Cluster akan auoto restart
--kalau tidak jalankan query berikut
/u01/app/12.1.0/grid/bin/crsctl start cluster -all


