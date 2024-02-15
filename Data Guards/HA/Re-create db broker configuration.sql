Re-create db broker configuration

DGMGRL> disable fast_start failover 
DGMGRL> stop observer
DGMGRL> disable configuration;
DGMGRL> remove configuration;
DGMGRL> create configuration domeven as primary database is oprfsev CONNECT IDENTIFIER IS oprfsev
DGMGRL> ADD DATABASE oprfsevbsd  AS CONNECT IDENTIFIER IS oprfsevbsd MAINTAINED AS PHYSICAL;
DGMGRL> enable configuration;
DGMGRL> show configuration
DGMGRL> edit configuration set property faststartfailoverlaglimit=45;
DGMGRL> edit configuration set property FastStartFailoverThreshold=95;
DGMGRL> edit configuration set property ObserverReconnect=30;

START OBSERVER 
$> nohup /apps/oracle/product/12.1.0.2/db1/bin/dgmgrl -logfile /apps/dataguard/log/OPRFSEV2.log sys/OR4cl35y5#2015@OPRFSEV "start observer file='/apps/dataguard/OPRFSEV2.fsfo'" &
