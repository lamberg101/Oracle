source 
OPTXNTBS
txntbspdb2
10.58.6.137

target
OPTXNTBS
txnsolopdb1
10.75.10.7

------------------------------------------------------------------------------------------------------------------------
1. copy dari primary ke standby

dari team apps

2. Check sequence di standby
select process, status, thread#, sequence, block# from v$manage_standby where process='MRP' or PROCESS='RFS';

Note! 
- Sequences terakhir di 162439, dan itu akan generate terus
- jadi kalau pas copy file di asm nya ada yg sequence thread_1_seq_1625*
- langsung copy lagi dan tinggal register sesuai path nya yang di standby

3. restore archived_log 


list backup of archivelog from logseq 69660 until logseq 69760;

RUN {
set archivelog destination to '/backup/arc_restore'; 
restore archivelog from logseq 69660 until logseq 69760; 
}

set archivelog destination to '/backup/arc_restore'; 
restore archivelog from logseq 69680 until logseq 69685;


run {
allocate channel ch00 device type 'sbt_tape';
send 'NB_ORA_SERV=tbsnbuvpapp1.telkomsel.co.id, NB_ORA_CLIENT=txntbspdb2';
restore archivelog from logseq 69680 until logseq 69685 from 'al_2135_1_1046227819';
}




3. ***REGISTER ARCHIVE MANUAL****
masuk ke db standby
cd /zfssa/testet/backup9/opuimtbs/temp_archive/
chmod 777 1_7*


sqlplus / as sysdba
******
alter database register or replace logfile '/ora_arch/1_71655_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71656_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71657_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71658_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71659_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71660_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71661_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71662_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71663_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71664_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71665_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71666_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71667_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71668_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71669_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71670_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71671_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71672_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71673_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71674_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71675_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71676_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71677_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71678_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71679_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71680_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71681_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71682_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71683_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71684_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71685_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71686_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71687_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71688_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71689_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71690_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71691_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71692_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71693_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71694_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71695_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71696_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71697_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71698_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71699_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71700_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71701_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71702_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71703_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71704_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71705_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71706_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71707_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71708_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71709_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71710_1014490159.dbf';
alter database register or replace logfile '/ora_arch/1_71711_1014490159.dbf';
-rw-r----- 1 oracle oinstall 1.4G Jul 25 02:33 1_71712_1014490159.dbf
-rw-r----- 1 oracle oinstall 1.4G Jul 25 02:48 1_71713_1014490159.dbf
-rw-r----- 1 oracle oinstall 152M Jul 25 02:50 1_71714_1014490159.dbf
-rw-r----- 1 oracle oinstall 1.4G Jul 25 03:05 1_71715_1014490159.dbf
-rw-r----- 1 oracle oinstall 1.4G Jul 25 03:20 1_71716_1014490159.dbf
-rw-r----- 1 oracle oinstall 1.3G Jul 25 03:35 1_71717_1014490159.dbf
-rw-r----- 1 oracle oinstall 1.4G Jul 25 03:50 1_71718_1014490159.dbf
-rw-r----- 1 oracle oinstall 1.5G Jul 25 04:05 1_71719_1014490159.dbf
-rw-r----- 1 oracle oinstall 1.6G Jul 25 04:20 1_71720_1014490159.dbf
-rw-r----- 1 oracle oinstall 1.6G Jul 25 04:35 1_71721_1014490159.dbf
-rw-r----- 1 oracle oinstall 1.6G Jul 25 04:50 1_71722_1014490159.dbf
-rw-r----- 1 oracle oinstall 1.8G Jul 25 05:05 1_71723_1014490159.dbf
-rw-r----- 1 oracle oinstall 2.2G Jul 25 05:20 1_71724_1014490159.dbf
-rw-r----- 1 oracle oinstall 2.7G Jul 25 05:35 1_71725_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 05:48 1_71726_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 05:59 1_71727_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 06:09 1_71728_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 06:17 1_71729_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 06:24 1_71730_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 06:31 1_71731_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 06:37 1_71732_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 06:43 1_71733_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 06:49 1_71734_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 06:54 1_71735_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 06:59 1_71736_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:04 1_71737_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:08 1_71738_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:12 1_71739_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:17 1_71740_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:21 1_71741_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:25 1_71742_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:28 1_71743_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:32 1_71744_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:36 1_71745_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:39 1_71746_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:43 1_71747_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:46 1_71748_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:50 1_71749_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:53 1_71750_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:56 1_71751_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 07:59 1_71752_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:02 1_71753_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:06 1_71754_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:09 1_71755_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:12 1_71756_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:14 1_71757_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:18 1_71758_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:20 1_71759_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:23 1_71760_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:26 1_71761_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:29 1_71762_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:32 1_71763_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:35 1_71764_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:38 1_71765_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:41 1_71766_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:43 1_71767_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:46 1_71768_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:49 1_71769_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:52 1_71770_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:54 1_71771_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 08:57 1_71772_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:00 1_71773_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:02 1_71774_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:05 1_71775_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:08 1_71776_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:11 1_71777_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:13 1_71778_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:16 1_71779_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:18 1_71780_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:21 1_71781_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:24 1_71782_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:26 1_71783_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:29 1_71784_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:31 1_71785_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:34 1_71786_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:36 1_71787_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:39 1_71788_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:41 1_71789_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:44 1_71790_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:46 1_71791_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:49 1_71792_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:51 1_71793_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:54 1_71794_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:57 1_71795_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 09:59 1_71796_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:02 1_71797_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:04 1_71798_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:07 1_71799_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:09 1_71800_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:12 1_71801_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:14 1_71802_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:17 1_71803_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:19 1_71804_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:22 1_71805_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:25 1_71806_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:27 1_71807_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:29 1_71808_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:32 1_71809_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:34 1_71810_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:37 1_71811_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:39 1_71812_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:42 1_71813_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:44 1_71814_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:47 1_71815_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:49 1_71816_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:52 1_71817_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:54 1_71818_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:57 1_71819_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 10:59 1_71820_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:02 1_71821_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:04 1_71822_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:07 1_71823_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:09 1_71824_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:12 1_71825_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:14 1_71826_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:17 1_71827_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:19 1_71828_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:22 1_71829_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:24 1_71830_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:27 1_71831_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:30 1_71832_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:32 1_71833_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:35 1_71834_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:38 1_71835_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:40 1_71836_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:43 1_71837_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:46 1_71838_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:49 1_71839_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:52 1_71840_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:54 1_71841_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 11:57 1_71842_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:00 1_71843_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:03 1_71844_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:06 1_71845_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:08 1_71846_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:11 1_71847_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:14 1_71848_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:17 1_71849_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:20 1_71850_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:23 1_71851_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:26 1_71852_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:29 1_71853_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:32 1_71854_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:35 1_71855_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:38 1_71856_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:41 1_71857_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:44 1_71858_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:47 1_71859_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:50 1_71860_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:53 1_71861_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:56 1_71862_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 12:59 1_71863_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:02 1_71864_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:05 1_71865_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:09 1_71866_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:12 1_71867_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:15 1_71868_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:18 1_71869_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:21 1_71870_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:23 1_71871_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:26 1_71872_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:29 1_71873_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:32 1_71874_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:35 1_71875_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:38 1_71876_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:41 1_71877_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:44 1_71878_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:47 1_71879_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:50 1_71880_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:54 1_71881_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 13:57 1_71882_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 14:00 1_71883_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 14:03 1_71884_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 14:06 1_71885_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 14:09 1_71886_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 14:12 1_71887_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 14:15 1_71888_1014490159.dbf
-rw-r----- 1 oracle oinstall 3.0G Jul 25 14:18 1_71889_1014490159.dbf



--dan seterunsya, di sesuakian dengan gap nya





ngeCheck nya nanti kalau sudah register manual yah kaka :

#Check thread 1
select max(sequence#), thread#, applied from v$archived_log group by thread#,applied;

#Check thread 2
select min(sequence#), thread#, applied from v$archived_log group by thread#,applied;

#Check
SELECT PROCESS, STATUS, THREAD#, SEQUENCE#, BLOCK#, BLOCKS FROM V$MANAGED_STANDBY;