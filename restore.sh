#!/bin/bash

source backup.conf

if [ $# -lt 3 ]; then echo "Usage format $0 <date> <file> <restore-to>"; exit; fi

duplicity \
    --encrypt-key=${GPG_KEY} \
    --sign-key=${GPG_KEY} \
    --file-to-restore $2 \
    --restore-time $1 \
    ${DEST} $3

# Reset the ENV variables. Don't need them sitting around
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY