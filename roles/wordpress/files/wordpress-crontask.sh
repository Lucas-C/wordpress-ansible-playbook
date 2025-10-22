#!/bin/bash
set -o pipefail -o errexit -o nounset -o xtrace
cd $(dirname "${BASH_SOURCE[0]}")/www/$1
wp cron event run --due-now
# Update backup.status file:
STATUS_FILE=wp-content/updraft/backup.status
if grep -Eq 'La sauvegarde a réussi|The backup succeeded and is now complete' $(ls -t wp-content/updraft/log.*.txt | head -1); then
    date > $STATUS_FILE
else
    rm -f $STATUS_FILE
fi