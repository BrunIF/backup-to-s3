#!/bin/bash

source backup.conf

if [ $# -lt 3 ]; then echo "Usage format $0 <date> <file> <restore-to>"; exit; fi

export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

mkdir -p /root/backup/tmp

duplicity \
    --no-encryption \
    --archive-dir /root/backup/duplicity \
    --tempdir /root/backup/tmp \
    --file-to-restore $2 \
    --restore-time $1 \
    ${DEST} $3

# Reset the ENV variables. Don't need them sitting around
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
