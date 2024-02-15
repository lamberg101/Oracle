**Install HCVE (Health Check Validation Engine)

GOAL
This Note explains how to generate the HCVE Report in Text and Html Format with step by step Instructions.

STEPS
1. Open the below Note and click on the "Download HCVE/RDA".
RDA - Health Check / Validation Engine Guide (Doc ID 250262.1)

2.  Download the RDA files into your Local Server according to your Platform (By using Database OS User).
Note! atau download biasa, lalu masukan ke mountpoint/zfs
	-bash-4.1$ pwd
	/refresh/home/hcve
	-bash-4.1$ ls -ltr
	total 15540
	-rw-rw-r-- 1 oracle oracle 15909403 Nov 2 03:08 p21769913_81717912_Linux-x86-64.zip

3. Unzip the Downloaded File.
	-bash-4.1$ ls -ltr
	total 15548
	-rw-rw-r-- 1 oracle oracle 15909403 Nov 2 03:08 p21769913_81717912_Linux-x86-64.zip
	-r--r--r-- 1 oracle oracle 2885 Sep 8 19:24 readme.txt
	drwxr-xr-x 16 oracle oracle 4096 Nov 2 03:10 rda

4. Go to the 'rda' directory and run the Script as below.
-bash-4.1$ ./rda.sh -T hcve  ---> run this command > klik enter

--> list untk dimasukan (pilih 5, jika database nya Oracle Database 12c R1 (12.1.0) Preinstallation (Linux))
	Available Pre-Installation Rule Sets:
	1. Oracle Database 10g R1 (10.1.0) Preinstall (Linux)
	2. Oracle Database 10g R2 (10.2.0) Preinstall (Linux)
	3. Oracle Database 11g R1 (11.1) Preinstall (Linux)
	4. Oracle Database 11g R2 (11.2.0) Preinstall (Linux)
	5. Oracle Database 12c R1 (12.1.0) Preinstallation (Linux)
	6. Oracle Database 12c R2 (12.2.0) Preinstallation (Linux)
	7. Oracle Identity and Access Management PreInstall Check: Oracle Identity and Access Management 11g Release 2 (11.1.2) Linux
	8. Oracle JDeveloper PreInstall Check: Oracle JDeveloper 11g Release 2 (11.1.2.4) Linux
	9. Oracle JDeveloper PreInstall Check: Oracle JDeveloper 12c (12.1.3) Linux
	10. OAS PreInstall Check: Application Server 10g R2 (10.1.2) Linux
	11. OAS PreInstall Check: Application Server 10g R3 (10.1.3) Linux
	12. OFM PreInstall Check: Oracle Fusion Middleware 11g R1 (11.1.1) Linux
	13. OFM PreInstall Check: Oracle Fusion Middleware 12c (12.1.3) Linux
	14. Oracle Forms and Reports PreInstall Check: Oracle Forms and Reports 11g Release 2 (11.1.2) Linux
	15. Portal PreInstall Check: Oracle Portal Generic
	16. IDM PreInstall Check: Identity Management 10g (10.1.4) Linux
	17. BIEE PreInstall Check: Business Intelligence Enterprise Edition 11g (11.1.1) Generic
	18. EPM PreInstall Check: Enterprise Performance Management Server (11.1.2) Generic
	19. Oracle Enterprise Manager Cloud Control PreInstall Check: Oracle Enterprise Manager Cloud Control 12c Release 4 (12.1.0.4) Linux
	20. Oracle E-Business Suite Release 11i (11.5.10) Preinstall (Linux x86 and x86_64)
	21. Oracle E-Business Suite Release 12 (12.1.1) Preinstall (Linux x86 and x86_64)
	22. Oracle E-Business Suite Release 12 (12.2.0) Preinstall (Linux x86_64) Available Post-Installation Rule Sets:
	23. RAC 10G DB and OS Best Practices (Linux)
	24. Data Guard Postinstall (Generic)
	25. WLS PostInstall Check: WebLogic Server 11g (10.3.x) Generic
	26. WLS PostInstall Check: WebLogic Server 12c (12.x) Generic
	27. Portal PostInstall Check: Oracle Portal Generic
	28. OC4J PostInstall Check: Oracle Containers for J2EE 10g (10.1.x) Generic
	29. SOA PostInstall Check: Service-Oriented Architecture 11g and Later Generic
	30. OSB PostInstall Check: Service Bus 11g and Later Generic
	31. Oracle Forms 11g Post Installation (Generic)
	32. Oracle Enterprise Manager Agent 12c Post Installation (Generic)
	33. Oracle Management Server 12c Post Installation (Generic)
	34. Network Charging and Control Database Post Installation (Generic)


Contoh
--------
Enter the HCVE rule set number or 0 to cancel the test
Press Return to accept the default (0)
> 5                                                                                               
>>>Enter the Rules Sets according your Database Version from the above Menu.

Performing HCVE checks ...
Enter value for < Planned ORACLE_HOME location >
Press Return to accept the default
(/refresh/home/app/12.1.0.2/oracle/product/12.1.0.2/dbhome2) >>>Provide the Path or press 'Enter' for current Location.
>

Enter value for < JDK Home >
>                                                                                                 
>>>Press 'Enter' for the Default JDK Home.

Test "Oracle Database 12c R1 (12.1.0) Preinstallation (Linux)" executed at 02-Nov-2017 03:12:20

Test Results
~~~~~~~~~~~~

ID     NAME                 RESULT  VALUE
====== ==================== ======= ==========================================
A00100 OS Certified?        PASSED  Adequate
A01020 User in /etc/passwd? PASSED  userOK
A01040 Group in /etc/group? PASSED  GroupOK
A01050 Enter ORACLE_HOME    RECORD  /refresh/home/app/12.1.0.2/oracle/pro...
A01060 ORACLE_HOME Valid?   PASSED  OHexists
A01070 O_H Permissions OK?  PASSED  CorrectPerms
A01210 Enter JDK Home       RECORD
A01220 JDK Version          FAILED  JDK home is missing
A01410 oraInventory Permiss PASSED  oraInventoryOK
A01420 Other OUI Up?        PASSED  NoOtherOUI
A01430 Got Software Tools?  PASSED  ld_nm_ar_make_found
A01440 Other O_Hs in PATH?  FAILED  OratabEntryInPath
A02010 Umask Set to 022?    FAILED  UmaskNotOK
A02030 Limits Processes     PASSED  Adequate
A02040 Limits Stacksize     PASSED  Adequate
A02050 Limits Descriptors   PASSED  Adequate
A02100 LDLIBRARYPATH Unset? FAILED  IsSet
A02170 JAVA_HOME Unset?     PASSED  UnSet
A03100 RAM (in MB)          PASSED  7870
A02210 Kernel Parameters OK PASSED  KernelOK
A02300 Tainted Kernel?      PASSED  NotVerifiable
A03010 Temp Adequate?       PASSED  TempSpaceOK
A03020 Disk Space OK?       FAILED  NoSpace
A03050 Swap (in MB)         RECORD  2511
A03100 RAM (in MB)          PASSED  7870
A03150 SwapToRam OK?        FAILED  SwapLessThanRam
A03500 Network              PASSED  Connected
A03510 IP Address           RECORD  NotFound
A03530 Domain Name          RECORD  NotFound
A03540 /etc/hosts Format    PASSED  Adequate IPv4 entry
A03550 DNS Lookup           FAILED  Host not known
A03600 ip_local_port_range  PASSED  RangeOK
A04301 OL5 Server RPMs OK?  SKIPPED NotOL5
A04302 OL5 32-bit Client RP SKIPPED NotOL5
A04303 OL6 Server RPMs OK?  PASSED  OL6rpmsOK
A04304 OL6 32-bit Client RP FAILED  [libX11(i686)] not installed [libXau(...
A04305 OL7 Server RPMs OK?  SKIPPED NotOL7
A04311 RHEL5 Server RPMs OK SKIPPED NotRedHat
A04312 RHEL5 32-bit Client  SKIPPED NotRedHat
A04313 RHEL6 Server RPMs OK SKIPPED NotRedHat
A04314 RHEL6 32-bit Client  SKIPPED NotRedHat
A04315 RHEL7 Server RPMs OK SKIPPED NotRedHat
A04321 SLES11 Server RPMs O SKIPPED NotSuSE
A04322 SLES11 32-bit Client SKIPPED NotSuSE

----> jika muncul ini, maka sudah selesai. masuk ke :output/collect/DB_HCVE_A_DB12R1_lin_res.htm

5.The output files will be available in the Location <Current_Directory/output/collect/> as below in both TEXT and HTML format.
	-bash-4.1$ pwd
	/refresh/home/hcve/rda/output/collect
	-bash-4.1$ ls -ltr
	total 72
	-rw-r----- 1 oracle oracle 27236 Nov 2 03:12 DB_HCVE_A_DB12R1_lin_res.txt
	-rw-r----- 1 oracle oracle 40992 Nov 2 03:12 DB_HCVE_A_DB12R1_lin_res.htm

Note:  Use the below Command to run the HCVE report on Windows Platform and follow the Menu options.
rda.cmd -T hcve
RDA Non-Interactive Method
The RDA can be run directly using the Available Rules Set as below.
For Unix:
     rda.sh -T hcve:Adb12r1_lin
For Windows:
     rda.cmd -T hcve:Adb11r2_win
Note: Please note that there is no space here 'hcve:RulesSets'
Refer the below Note for the Available Rules Set for all the Available Products.
    RDA - Health Check / Validation Engine Guide (Doc ID 250262.1)
	

===================================================================================================================================================
LINK/LIST RDA - Health Check / Validation Engine Guide (Doc ID 250262.1)

Available 		Rule 				Sets
------------	----------------	----------------
APPS			Aebs11510_aix  		Oracle E-Business Suite Release 11i (11.5.10) Preinstall (AIX)
APPS			Aebs11510_hp  		Oracle E-Business Suite Release 11i (11.5.10) Preinstall (HP-UX)
APPS			Aebs11510_lin  		Oracle E-Business Suite Release 11i (11.5.10) Preinstall (Linux x86 and x86_64)
APPS			Aebs11510_sol  		Oracle E-Business Suite Release 11i (11.5.10) Preinstall (Solaris)
APPS			Aebs1211_aix  		Oracle E-Business Suite Release 12 (12.1.1) Preinstall (AIX)
APPS			Aebs1211_hp  		Oracle E-Business Suite Release 12 (12.1.1) Preinstall (HP-UX)
APPS			Aebs1211_lin  		Oracle E-Business Suite Release 12 (12.1.1) Preinstall (Linux x86 and x86_64)
APPS			Aebs1211_sol  		Oracle E-Business Suite Release 12 (12.1.1) Preinstall (Solaris)
APPS			Aebs122_aix  		Oracle E-Business Suite Release 12 (12.2.0) Preinstall (AIX)
APPS			Aebs122_hp  		Oracle E-Business Suite Release 12 (12.2.0) Preinstall (HP-UX)
APPS			Aebs122_lin  		Oracle E-Business Suite Release 12 (12.2.0) Preinstall (Linux x86_64)
APPS			Aebs122_sol  		Oracle E-Business Suite Release 12 (12.2.0) Preinstall (Solaris)
CGBU			Ancc001_sol  		Network Charging and Control Preinstallation (Solaris)
CGBU			Pncc44db_gen  		Network Charging and Control Database Post Installation (Generic)
CGBU			Pncc44os_sol  		Network Charging and Control 4.4 and later System Post Installation (Solaris)
EM				Aoem121_aix  		Oracle Enterprise Manager Cloud Control PreInstall Check: Oracle Enterprise Manager Cloud Control 12c Release 4 (12.1.0.4) AIX
EM				Aoem121_hp  		Oracle Enterprise Manager Cloud Control PreInstall Check: Oracle Enterprise Manager Cloud Control 12c Release 4 (12.1.0.4) HP-UX
EM				Aoem121_lin  		Oracle Enterprise Manager Cloud Control PreInstall Check: Oracle Enterprise Manager Cloud Control 12c Release 4 (12.1.0.4) Linux
EM				Aoem121_sol  		Oracle Enterprise Manager Cloud Control PreInstall Check: Oracle Enterprise Manager Cloud Control 12c Release 4 (12.1.0.4) Solaris
EM				Aoem121_win  		Oracle Enterprise Manager Cloud Control PreInstall Check: Oracle Enterprise Manager Cloud Control 12c Release 4 (12.1.0.4) Windows
EM				Pagt121_gen  		Oracle Enterprise Manager Agent 12c Post Installation (Generic)
EM				Poms121_gen  		Oracle Management Server 12c Post Installation (Generic)
DB				Adb10r1_aix  		Oracle Database 10g R1 (10.1.0) Preinstall (AIX)
DB				Adb10r1_hp  		Oracle Database 10g R1 (10.1.0) Preinstall (HP-UX)
DB				Adb10r1_lin  		Oracle Database 10g R1 (10.1.0) Preinstall (Linux)
DB				Adb10r1_mac  		Oracle Database 10g R1 (10.1.0) Preinstall (Mac OS X)
DB				Adb10r1_osf  		Oracle Database 10g R1 (10.1.0) Preinstall (DEC_OSF)
DB				Adb10r1_sol  		Oracle Database 10g R1 (10.1.0) Preinstall (Solaris)
DB				Adb10r2_aix  		Oracle Database 10g R2 (10.2.0) Preinstall (AIX)
DB				Adb10r2_hp  		Oracle Database 10g R2 (10.2.0) Preinstall (HP-UX)
DB				Adb10r2_lin  		Oracle Database 10g R2 (10.2.0) Preinstall (Linux)
DB				Adb10r2_sol  		Oracle Database 10g R2 (10.2.0) Preinstall (Solaris)
DB				Adb11r1_aix  		Oracle Database 11g R1 (11.1.0) Preinstall (AIX)
DB				Adb11r1_hp  		Oracle Database 11g R1 (11.1.0) Preinstall (HP-UX)
DB				Adb11r1_lin  		Oracle Database 11g R1 (11.1) Preinstall (Linux)
DB				Adb11r1_sol  		Oracle Database 11g R1 (11.1.0) Preinstall (Solaris)
DB				Adb11r2_aix  		Oracle Database 11g R2 (11.2.0) Preinstall (AIX)
DB				Adb11r2_hp  		Oracle Database 11g R2 (11.2.0) Preinstall (HP-UX)
DB				Adb11r2_lin  		Oracle Database 11g R2 (11.2.0) Preinstall (Linux)
DB				Adb11r2_sol  		Oracle Database 11g R2 (11.2.0) Preinstall (Solaris)
DB				Adb11r2_win  		Oracle Database 11g R2 (11.2.0) Preinstall (Windows)
DB				Adb12r1_aix  		Oracle Database 12c R1 (12.1.0) Preinstallation (AIX)
DB				Adb12r1_hp  		Oracle Database 12c R1 (12.1.0) Preinstallation (HP-UX)
DB				Adb12r1_lin  		Oracle Database 12c R1 (12.1.0) Preinstallation (Linux)
DB				Adb12r1_sol  		Oracle Database 12c R1 (12.1.0) Preinstallation (Solaris)
DB				Adb12r1_win  		Oracle Database 12c R1 (12.1.0) Preinstallation (Windows)
DB				Adb12r2_aix  		Oracle Database 12c R2 (12.2.0) Preinstallation (AIX)
DB				Adb12r2_hp  		Oracle Database 12c R2 (12.2.0) Preinstallation (HP-UX)
DB				Adb12r2_lin  		Oracle Database 12c R2 (12.2.0) Preinstallation (Linux)
DB				Adb12r2_sol  		Oracle Database 12c R2 (12.2.0) Preinstallation (Solaris)
DB				Adb12r2_win  		Oracle Database 12c R2 (12.2.0) Preinstallation (Windows)
DB				Adb18c_aix  		Oracle Database 18c Preinstallation (AIX)
DB				Adb18c_hp  			Oracle Database 18c Preinstallation (HP-UX)
DB				Adb18c_lin  		Oracle Database 18c Preinstallation (Linux)
DB				Adb18c_sol  		Oracle Database 18c Preinstallation (Solaris)
DB				Adb18c_win  		Oracle Database 18c Preinstallation (Windows)
DB				Adb19c_aix  		Oracle Database 19c Preinstallation (AIX)
DB				Adb19c_hp  			Oracle Database 19c Preinstallation (HP-UX)
DB				Adb19c_lin  		Oracle Database 19c Preinstallation (Linux)
DB				Adb19c_sol  		Oracle Database 19c Preinstallation (Solaris)
DB				Pdg_gen  			Data Guard Postinstall (Generic)
DB				Prac_lin  			RAC 10G DB and OS Best Practices (Linux)
OFM				Aiam1112_aix  		Oracle Identity and Access Management PreInstall Check: Oracle Identity and Access Management 11g Release 2 (11.1.2) AIX
OFM				Aiam1112_hp  		Oracle Identity and Access Management PreInstall Check: Oracle Identity and Access Management 11g Release 2 (11.1.2) HP-UX
OFM				Aiam1112_lin  		Oracle Identity and Access Management PreInstall Check: Oracle Identity and Access Management 11g Release 2 (11.1.2) Linux
OFM				Aiam1112_sol  		Oracle Identity and Access Management PreInstall Check: Oracle Identity and Access Management 11g Release 2 (11.1.2) Solaris
OFM				Aiam1112_win  		Oracle Identity and Access Management PreInstall Check: Oracle Identity and Access Management 11g Release 2 (11.1.2) Windows
OFM				Ajdev1112_lin  		Oracle JDeveloper PreInstall Check: Oracle JDeveloper 11g Release 2 (11.1.2.4) Linux
OFM				Ajdev1112_mac  		Oracle JDeveloper PreInstall Check: Oracle JDeveloper 11g Release 2 (11.1.2.4) Mac OS X
OFM				Ajdev1112_win  		Oracle JDeveloper PreInstall Check: Oracle JDeveloper 11g Release 2 (11.1.2.4) Windows
OFM				Ajdev1213_lin  		Oracle JDeveloper PreInstall Check: Oracle JDeveloper 12c (12.1.3) Linux
OFM				Ajdev1213_mac  		Oracle JDeveloper PreInstall Check: Oracle JDeveloper 12c (12.1.3) Mac OS X
OFM				Ajdev1213_win  		Oracle JDeveloper PreInstall Check: Oracle JDeveloper 12c (12.1.3) Windows
OFM				Aoas0904_aix  		OAS PreInstall Check: Application Server 10g R1 (9.0.4) AIX
OFM				Aoas0904_hp  		OAS PreInstall Check: Application Server 10g R1 (9.0.4) HP-UX
OFM				Aoas0904_lin  		OAS PreInstall Check: Application Server 10g R1 (9.0.4) Linux
OFM				Aoas0904_sol  		OAS PreInstall Check: Application Server 10g R1 (9.0.4) Solaris
OFM				Aoas1012_hp  		OAS PreInstall Check: Application Server 10g R2 (10.1.2) HP-UX
OFM				Aoas1012_lin  		OAS PreInstall Check: Application Server 10g R2 (10.1.2) Linux
OFM				Aoas1012_sol  		OAS PreInstall Check: Application Server 10g R2 (10.1.2) Solaris
OFM				Aoas1013_lin  		OAS PreInstall Check: Application Server 10g R3 (10.1.3) Linux
OFM				Aofm1111_aix  		OFM PreInstall Check: Oracle Fusion Middleware 11g R1 (11.1.1) AIX
OFM				Aofm1111_hp  		OFM PreInstall Check: Oracle Fusion Middleware 11g R1 (11.1.1) HP-UX
OFM				Aofm1111_lin  		OFM PreInstall Check: Oracle Fusion Middleware 11g R1 (11.1.1) Linux
OFM				Aofm1111_sol  		OFM PreInstall Check: Oracle Fusion Middleware 11g R1 (11.1.1) Solaris
OFM				Aofm1111_win  		OFM PreInstall Check: Oracle Fusion Middleware 11g R1 (11.1.1) Windows
OFM				Aofm1213_aix  		OFM PreInstall Check: Oracle Fusion Middleware 12c (12.1.3) AIX
OFM				Aofm1213_hp  		OFM PreInstall Check: Oracle Fusion Middleware 12c (12.1.3) HP-UX
OFM				Aofm1213_lin  		OFM PreInstall Check: Oracle Fusion Middleware 12c (12.1.3) Linux
OFM				Aofm1213_sol  		OFM PreInstall Check: Oracle Fusion Middleware 12c (12.1.3) Solaris
OFM				Aofm1213_win  		OFM PreInstall Check: Oracle Fusion Middleware 12c (12.1.3) Windows
OFM				Aofm12213_aix		OFM PreInstall Check: Oracle Fusion Middleware 12c (12.2.1.3) AIX
OFM				Aofm12213_hp		OFM PreInstall Check: Oracle Fusion Middleware 12c (12.2.1.3) HP-UX
OFM				Aofm12213_lin		OFM PreInstall Check: Oracle Fusion Middleware 12c (12.2.1.3) Linux
OFM				Aofm12213_sol		OFM PreInstall Check: Oracle Fusion Middleware 12c (12.2.1.3) Solaris
OFM				Aofm12213_win		OFM PreInstall Check: Oracle Fusion Middleware 12c (12.2.1.3) Windows
OFM				Aofr1112_aix  		Oracle Forms and Reports PreInstall Check: Oracle Forms and Reports 11g Release 2 (11.1.2) AIX
OFM				Aofr1112_hp  		Oracle Forms and Reports PreInstall Check: Oracle Forms and Reports 11g Release 2 (11.1.2) HP-UX
OFM				Aofr1112_lin  		Oracle Forms and Reports PreInstall Check: Oracle Forms and Reports 11g Release 2 (11.1.2) Linux
OFM				Aofr1112_sol  		Oracle Forms and Reports PreInstall Check: Oracle Forms and Reports 11g Release 2 (11.1.2) Solaris
OFM				Aofr1112_win  		Oracle Forms and Reports PreInstall Check: Oracle Forms and Reports 11g Release 2 (11.1.2) Windows
OFM				Aoim1014_aix  		IDM PreInstall Check: Identity Management 10g (10.1.4) AIX
OFM				Aoim1014_hp  		IDM PreInstall Check: Identity Management 10g (10.1.4) HP-UX
OFM				Aoim1014_lin  		IDM PreInstall Check: Identity Management 10g (10.1.4) Linux
OFM				Aoim1014_sol  		IDM PreInstall Check: Identity Management 10g (10.1.4) Solaris
OFM				Apda_gen  			Portal PreInstall Check: Oracle Portal Generic
OFM				Pfrm11_gen  		Oracle Forms 11g Post Installation (Generic)
OFM				Poc4j_gen  			OC4J PostInstall Check: Oracle Containers for J2EE 10g (10.1.x) Generic
OFM				Posb111_gen  		OSB PostInstall Check: Service Bus 11g and Later Generic
OFM				Ppda_gen  			Portal PostInstall Check: Oracle Portal Generic
OFM				Psoa11_gen  		SOA PostInstall Check: Service-Oriented Architecture 11g and Later Generic
OFM				Pwls10_gen  		WLS PostInstall Check: WebLogic Server 11g (10.3.x) Generic
OFM				Pwls12_gen  		WLS PostInstall Check: WebLogic Server 12c (12.x) Generic
BI				Abi1111_gen  		BIEE PreInstall Check: Business Intelligence Enterprise Edition 11g (11.1.1) Generic
BI				Aepm1112c_win  		EPM PreInstall Check: Enterprise Performance Management Client (11.1.2) Windows
BI				Aepm1112s_gen  		EPM PreInstall Check: Enterprise Performance Management Server (11.1.2) Generic 