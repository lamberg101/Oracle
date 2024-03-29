#!/bin/sh
# $Header: hot_database_backup.sh,v 1.2 2002/08/06 23:51:42 $
#
#bcpyrght
#***************************************************************************
#* $VRTScprght: Copyright 1993 - 2008 Symantec Corporation, All Rights Reserved $ *
#***************************************************************************
#ecpyrght
#
# ---------------------------------------------------------------------------
#                       hot_database_backup.sh
# ---------------------------------------------------------------------------
#  This script uses Recovery Manager to take a hot (inconsistent) database
#  backup. A hot backup is inconsistent because portions of the database are
#  being modified and written to the disk while the backup is progressing.
#  You must run your database in ARCHIVELOG mode to make hot backups. It is
#  assumed that this script will be executed by user root. In order for RMAN
#  to work properly we switch user (su -) to the oracle dba account before
#  execution. If this script runs under a user account that has Oracle dba
#  privilege, it will be executed using this user's account.
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Determine the user which is executing this script.
# ---------------------------------------------------------------------------

CUSER=`id |cut -d"(" -f2 | cut -d ")" -f1`

# ---------------------------------------------------------------------------
# Put output in <this file name>.out. Change as desired.
# Note: output directory requires write permission.
# ---------------------------------------------------------------------------

DATE=`date +"%Y%m%d_%H"`
RMAN_LOG_FILE=${0}.out.${DATE}
#RMAN_LOG_FILE=${0}.out

# ---------------------------------------------------------------------------
# You may want to delete the output file so that backup information does
# not accumulate.  If not, delete the following lines.
# ---------------------------------------------------------------------------

if [ -f "$RMAN_LOG_FILE" ]
then
        rm -f "$RMAN_LOG_FILE"
fi

# -----------------------------------------------------------------
# Initialize the log file.
# -----------------------------------------------------------------

echo >> $RMAN_LOG_FILE
chmod 666 $RMAN_LOG_FILE

# ---------------------------------------------------------------------------
# Log the start of this script.
# ---------------------------------------------------------------------------

echo Script $0 >> $RMAN_LOG_FILE
echo ==== started on `date` ==== >> $RMAN_LOG_FILE
echo >> $RMAN_LOG_FILE

# ---------------------------------------------------------------------------
# Replace /db/oracle/product/ora81, below, with the Oracle home path.
# ---------------------------------------------------------------------------

ORACLE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1
export ORACLE_HOME

# ---------------------------------------------------------------------------
# Replace ora81, below, with the Oracle SID of the target database.
# ---------------------------------------------------------------------------

ORACLE_SID=OPREPORT2
export ORACLE_SID

# ---------------------------------------------------------------------------
# Replace ora81, below, with the Oracle DBA user id (account).
# ---------------------------------------------------------------------------

ORACLE_USER=oracle

# ---------------------------------------------------------------------------
# Set the target connect string.
# Replace "sys/manager", below, with the target connect string.
# ---------------------------------------------------------------------------

TARGET_CONNECT_STR=/

# ---------------------------------------------------------------------------
# Set the Oracle Recovery Manager name.
# ---------------------------------------------------------------------------

RMAN=$ORACLE_HOME/bin/rman

# ---------------------------------------------------------------------------
# Print out the value of the variables set by this script.
# ---------------------------------------------------------------------------

echo >> $RMAN_LOG_FILE
echo   "RMAN: $RMAN" >> $RMAN_LOG_FILE
echo   "ORACLE_SID: $ORACLE_SID" >> $RMAN_LOG_FILE
echo   "ORACLE_USER: $ORACLE_USER" >> $RMAN_LOG_FILE
echo   "ORACLE_HOME: $ORACLE_HOME" >> $RMAN_LOG_FILE

# ---------------------------------------------------------------------------
# Print out the value of the variables set by bphdb.
# ---------------------------------------------------------------------------

echo  >> $RMAN_LOG_FILE
echo   "NB_ORA_FULL: $NB_ORA_FULL" >> $RMAN_LOG_FILE
echo   "NB_ORA_INCR: $NB_ORA_INCR" >> $RMAN_LOG_FILE
echo   "NB_ORA_CINC: $NB_ORA_CINC" >> $RMAN_LOG_FILE
echo   "NB_ORA_SERV: $NB_ORA_SERV" >> $RMAN_LOG_FILE
echo   "NB_ORA_POLICY: $NB_ORA_POLICY" >> $RMAN_LOG_FILE

# ---------------------------------------------------------------------------
# NOTE: This script assumes that the database is properly opened. If desired,
# this would be the place to verify that.
# ---------------------------------------------------------------------------

echo >> $RMAN_LOG_FILE
# ---------------------------------------------------------------------------
# If this script is executed from a NetBackup schedule, NetBackup
# sets an NB_ORA environment variable based on the schedule type.
# The NB_ORA variable is then used to dynamically set BACKUP_TYPE
# For example, when:
#     schedule type is                BACKUP_TYPE is
#     ----------------                --------------
# Automatic Full                     INCREMENTAL LEVEL=0
# Automatic Differential Incremental INCREMENTAL LEVEL=1
# Automatic Cumulative Incremental   INCREMENTAL LEVEL=1 CUMULATIVE
#
# For user initiated backups, BACKUP_TYPE defaults to incremental
# level 0 (full).  To change the default for a user initiated
# backup to incremental or incremental cumulative, uncomment
# one of the following two lines.
# BACKUP_TYPE="INCREMENTAL LEVEL=1"
# BACKUP_TYPE="INCREMENTAL LEVEL=1 CUMULATIVE"
#
# Note that we use incremental level 0 to specify full backups.
# That is because, although they are identical in content, only
# the incremental level 0 backup can have incremental backups of
# level > 0 applied to it.
# ---------------------------------------------------------------------------

if [ "$NB_ORA_FULL" = "1" ]
then
        echo "Full backup requested" >> $RMAN_LOG_FILE
        BACKUP_TYPE="INCREMENTAL LEVEL=0"

elif [ "$NB_ORA_INCR" = "1" ]
then
        echo "Differential incremental backup requested" >> $RMAN_LOG_FILE
        BACKUP_TYPE="INCREMENTAL LEVEL=1"

elif [ "$NB_ORA_CINC" = "1" ]
then
        echo "Cumulative incremental backup requested" >> $RMAN_LOG_FILE
        BACKUP_TYPE="INCREMENTAL LEVEL=1 CUMULATIVE"

elif [ "$BACKUP_TYPE" = "" ]
then
        echo "Default - Full backup requested" >> $RMAN_LOG_FILE
        BACKUP_TYPE="INCREMENTAL LEVEL=0"
fi


# ---------------------------------------------------------------------------
# Call Recovery Manager to initiate the backup. This example does not use a
# Recovery Catalog. If you choose to use one, replace the option 'nocatalog'
# from the rman command line below with the
# 'rcvcat <userid>/<passwd>@<tns alias>' statement.
#
# Note: Any environment variables needed at run time by RMAN
#       must be set and exported within the switch user (su) command.
# ---------------------------------------------------------------------------
#  Backs up the whole database.  This backup is part of the incremental
#  strategy (this means it can have incremental backups of levels > 0
#  applied to it).
#
#  We do not need to explicitly request the control file to be included
#  in this backup, as it is automatically included each time file 1 of
#  the system tablespace is backed up (the inference: as it is a whole
#  database backup, file 1 of the system tablespace will be backed up,
#  hence the controlfile will also be included automatically).
#
#  Typically, a level 0 backup would be done at least once a week.
#
#  The scenario assumes:
#     o you are backing your database up to two tape drives
#     o you want each backup set to include a maximum of 5 files
#     o you wish to include offline datafiles, and read-only tablespaces,
#       in the backup
#     o you want the backup to continue if any files are inaccessible.
#     o you are not using a Recovery Catalog
#     o you are explicitly backing up the control file.  Since you are
#       specifying nocatalog, the controlfile backup that occurs
#       automatically as the result of backing up the system file is
#       not sufficient; it will not contain records for the backup that
#       is currently in progress.
#     o you want to archive the current log, back up all the
#       archive logs using two channels, putting a maximum of 20 logs
#       in a backup set, and deleting them once the backup is complete.
#
#  Note that the format string is constructed to guarantee uniqueness and
#  to enhance NetBackup for Oracle backup and restore performance.
#
#
#  NOTE WHEN USING TNS ALIAS: When connecting to a database
#  using a TNS alias, you must use a send command or a parms operand to
#  specify environment variables.  In other words, when accessing a database
#  through a listener, the environment variables set at the system level are not
#  visible when RMAN is running.  For more information on the environment
#  variables, please refer to the NetBackup for Oracle Admin. Guide.
#
# ---------------------------------------------------------------------------

CMD_STR="
ORACLE_HOME=$ORACLE_HOME
export ORACLE_HOME
ORACLE_SID=$ORACLE_SID
export ORACLE_SID
$RMAN target $TARGET_CONNECT_STR nocatalog msglog $RMAN_LOG_FILE append << EOF
run {
   allocate channel ch00 type 'SBT_TAPE' PARMS 'ENV=(NB_ORA_POLICY=TBS_OPREPORT_exa62b_db)';
   allocate channel ch01 type 'SBT_TAPE' PARMS 'ENV=(NB_ORA_POLICY=TBS_OPREPORT_exa62b_db)';
   backup
     $backup_type
     # skip inaccessible
     tag hot_db_bk_level0
     # recommended format
     format 'bk_%s_%p_%t' database;
     sql 'alter system archive log current';
   release channel ch00;
   release channel ch01;

# backup all archive logs
   allocate channel ch00 type 'SBT_TAPE' PARMS 'ENV=(NB_ORA_POLICY=TBS_OPREPORT_exa62b_db)';
   allocate channel ch01 type 'SBT_TAPE' PARMS 'ENV=(NB_ORA_POLICY=TBS_OPREPORT_exa62b_db)';
   backup
     format 'al_%s_%p_%t'
     archivelog all delete input;
     # archivelog all ;
     # archivelog all delete input;
   release channel ch00;
   release channel ch01;
#
# Note: During the process of backing up the database, RMAN also backs up the
# control file.  This version of the control file does not contain the
# information about the current backup because "nocatalog" has been specified.
# To include the information about the current backup, the control file should
# be backed up as the last step of the RMAN section.  This step would not be
# necessary if we were using a recovery catalog.
#
   allocate channel ch00 type 'SBT_TAPE'PARMS 'ENV=(NB_ORA_POLICY=TBS_OPREPORT_exa62b_db)';
   backup
     # recommended format
     format 'cntrl_OPREPORT_%s_%p_%t'
     current controlfile;
   release channel ch00;
}
EOF
"
# Initiate the command string

if [ "$CUSER" = "root" ]
then
    su - $ORACLE_USER -c "$CMD_STR" >> $RMAN_LOG_FILE
    RSTAT=$?
else
    /usr/bin/sh -c "$CMD_STR" >> $RMAN_LOG_FILE
    RSTAT=$?
fi

# ---------------------------------------------------------------------------
# Log the completion of this script.
# ---------------------------------------------------------------------------

if [ "$RSTAT" = "0" ]
then
    LOGMSG="ended successfully"
else
    LOGMSG="ended in error"
fi

echo >> $RMAN_LOG_FILE
echo Script $0 >> $RMAN_LOG_FILE
echo ==== $LOGMSG on `date` ==== >> $RMAN_LOG_FILE
echo >> $RMAN_LOG_FILE
mv $RMAN_LOG_FILE /usr/openv/netbackup/prod_rman_scripts/out/

exit $RSTAT

