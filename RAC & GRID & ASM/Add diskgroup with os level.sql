Pre-reg
- Disk sudah ditambahkan oleh MOVM
- Disk harus terbaca both node dan naming nya sama

1. Check disk di kedua node
root$> lsblk 

--hasilnya?

2. Config OS level 
$> cd etc/udev/rules.d/
$> config file 10-oracle-asmdev.rules

Config parameter sesuaikan di bawah untuk xvdi* 
di ambil dari disk partisi yang sudah di buatkan oleh sysadmin untuk dir /dev/asm_data* 
di buat seacara urutan tidak boleh sama karena untuk memudahkan proses config diskgroup asm nya 

KERNEL=="xvdd1", ENV{DEVTYPE}=="partition", RUN+="/bin/sh -c 'mknod /dev/asm_ocr1 b $major $minor; chown oracle:asmadmin /dev/asm_ocr1; chmod 0660 /dev/asm_ocr1'"
KERNEL=="xvde1", ENV{DEVTYPE}=="partition", RUN+="/bin/sh -c 'mknod /dev/asm_ocr2 b $major $minor; chown oracle:asmadmin /dev/asm_ocr2; chmod 0660 /dev/asm_ocr2'"
KERNEL=="xvdf1", ENV{DEVTYPE}=="partition", RUN+="/bin/sh -c 'mknod /dev/asm_ocr3 b $major $minor; chown oracle:asmadmin /dev/asm_ocr3; chmod 0660 /dev/asm_ocr3'"
KERNEL=="xvdg1", ENV{DEVTYPE}=="partition", RUN+="/bin/sh -c 'mknod /dev/asm_data b $major $minor; chown oracle:asmadmin /dev/asm_data; chmod 0660 /dev/asm_data'"
KERNEL=="xvdh1", ENV{DEVTYPE}=="partition", RUN+="/bin/sh -c 'mknod /dev/asm_mgmt b $major $minor; chown oracle:asmadmin /dev/asm_mgmt; chmod 0660 /dev/asm_mgmt'"
KERNEL=="xvdi1", ENV{DEVTYPE}=="partition", RUN+="/bin/sh -c 'mknod /dev/asm_data2 b $major $minor; chown oracle:asmadmin /dev/asm_data2; chmod 0660 /dev/asm_data2'"
KERNEL=="xvdj1", ENV{DEVTYPE}=="partition", RUN+="/bin/sh -c 'mknod /dev/asm_data3 b $major $minor; chown oracle:asmadmin /dev/asm_data3; chmod 0660 /dev/asm_data3'"
KERNEL=="xvdk1", ENV{DEVTYPE}=="partition", RUN+="/bin/sh -c 'mknod /dev/asm_data4 b $major $minor; chown oracle:asmadmin /dev/asm_data4; chmod 0660 /dev/asm_data4'"
KERNEL=="xvdl1", ENV{DEVTYPE}=="partition", RUN+="/bin/sh -c 'mknod /dev/asm_data5 b $major $minor; chown oracle:asmadmin /dev/asm_data5; chmod 0660 /dev/asm_data5'"
KERNEL=="xvdm1", ENV{DEVTYPE}=="partition", RUN+="/bin/sh -c 'mknod /dev/asm_data6 b $major $minor; chown oracle:asmadmin /dev/asm_data6; chmod 0660 /dev/asm_data6'"


Setelah di config pada parameter tersebut di lanjutkan untuk proses reload config nya pada both node.
$> udevadm control --reload-rules ; udevadm trigger

setelah proses reload selesai make sure parameter yang sudah di config muncul dan pastikan sudah muncul di node 1 dan node 2

di dir rules.d/
$> ls -l /dev/asm*

--detail liat di file doc


3. cek disk
--Setelah di pastikan aman lanjut check di sisi asm nya , pastikan status nya candidate 

set linesize 300
set pagesize 200
col path for a45
select group_number, disk_number, name, os_mb,total_mb, free_mb, path, header_status, mode_status 
from V$ASM_DISK;
--where path like '/dev/mapper/GENDSK%' ---> disesuaikan disk nya
where header_status='CANDIDATE';

4. Proses add disk
Setelah sudah terdaftar lanjut untuk proses add disk nya ke asm dengan command di bawah di sesuaikan dengan path yang sudah di sesuaikan sebelum nya.
SQL> alter diskgroup DATA add disk '/dev/asm_data2' rebalance power 10;
SQL> alter diskgroup DATA add disk '/dev/asm_data3' rebalance power 10;
SQL> alter diskgroup DATA add disk '/dev/asm_data4' rebalance power 10;
SQL> alter diskgroup DATA add disk '/dev/asm_data5' rebalance power 10;
SQL> alter diskgroup DATA add disk '/dev/asm_data6' rebalance power 10;
