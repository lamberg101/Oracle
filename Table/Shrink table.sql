mas kadek, dikarenakan table nay sudah kena HWM  untuk reduce size nya mesti di shrink tablenya. dengan command berikut 
#####shrink table
alter table CMS_ALERTS.MON_EMSQUEUE enable row movement;
alter table CMS_ALERTS.MON_EMSQUEUE shrink space cascade;
alter table CMS_ALERTS.MON_EMSQUEUE disable row movement;
command shrink  table diatas dapat menyebabkan locking mas, di sarankan di jalankan saat offpeak


alter index "CC_MAIN"."SYS_C0012412" shrink space;
----------------------------------------------------------------------------------------------------------------------------------
