nohup /apps/oracle/product/11.2/client_1/bin/expdp 
muhamad_d_rf_x/########@exaimcpdb-scan.telkomsel.co.id:1521/OPDGPOS19 
directory=/ngrs/image/onboarding 
dumpfile=RECHARGE_REQUEST_OLD.dmp 
logfile=/ngrs/image/onboarding/recharge_request_old.log 
tables=DGPOS.RECHARGE_REQUEST_OLD &




nohup /apps/oracle/product/11.2/client_1/bin/expdp muhamad_d_rf_x/########@exaimcpdb01-vip.telkomsel.co.id:1521/OPDGPOS191 directory=TEMP_DGPOS  
dumpfile=RECHARGE_REQUEST_OLD.dmp 
logfile=recharge_request_old.log tables=DGPOS.RECHARGE_REQUEST_OLD &


ALTER USER muhamad_d_rf_x IDENTIFIED BY JUN#2021;