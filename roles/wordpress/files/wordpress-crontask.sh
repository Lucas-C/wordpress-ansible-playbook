#!/bin/bash
set -o pipefail -o errexit -o nounset -o xtrace
cd $(dirname "${BASH_SOURCE[0]}")/www/$1
wp cron event run --due-now
# Update backup.status file:
STATUS_FILE=wp-content/updraft/backup.status
if grep -qF 'La sauvegarde a réussi' $(ls -t wp-content/updraft/log.*.txt | head -1); then
    date > $STATUS_FILE
else
    rm $STATUS_FILE
fi