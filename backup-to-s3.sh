#!/bin/bash

cd /root/backup

source backup.conf

# Backup databases 
mkdir -p $DATABASEDIR

if [[ -z "$DATABASENAME" ]]
then
    DATABASENAME=$(echo "show databases" | mysql -Bs | grep -Ev "^(mysql|performance_schema|information_schema|sys|forge)$")
    DATABASENAME=(${DATABASENAME// / })
fi

for i in "${DATABASENAME[@]}"
do
    mysqldump -u$DATABASEUSER -p$DATABASEPASSWORD ${i} > ${DATABASEDIR}${i}.sql
done

# Set up some variables for logging
HOST=`hostname`
DATE=`date +%Y-%m-%d`

# Clear the old daily log file
cat /dev/null > ${DAILYLOGFILE}

# Trace function for logging, don't change this
trace () {
        stamp=`date +%Y-%m-%d_%H:%M:%S`
        echo "$stamp: $*" >> ${DAILYLOGFILE}
}

# Export some ENV variables so you don't have to type anything
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

FULL=
if [ $(date +%d) -eq 1 ]; then
        FULL=full
fi;

trace "Backup for local filesystem started"

trace "... removing old backups"

duplicity remove-older-than ${OLDER_THAN} ${DEST} >> ${DAILYLOGFILE} 2>&1

trace "... backing up filesystem"

mkdir -p $TEMPDIR

duplicity \
    ${FULL} \
    --no-encryption \
    --archive-dir $ARCHIVEDIR \
    --tempdir $TEMPDIR \
    --volsize=250 \
    ${SOURCE} ${DEST} >> ${DAILYLOGFILE} 2>&1

trace "Backup for local filesystem complete"
trace "------------------------------------"

# Send the daily log file by email
cat "$DAILYLOGFILE" | mail -s "Backup Log for $HOST - $DATE" $MAILADDR

# Append the daily log file to the main log file
cat "$DAILYLOGFILE" >> $LOGFILE

# Reset the ENV variables. Don't need them sitting around
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
