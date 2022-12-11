#!/bin/sh

BKDIR=/var/opt/gitlab/backups
DATE=$(date "+%s_%Y_%m_%d")
PID=$$
LOG_FILE=/var/log/middle/gitlab_backup.log

# Get GitLab Config
tar cfz ${BKDIR}/${DATE}_etc_gitlab.tar.gz -C /etc gitlab
# Upload Google Storage
gsutil cp ${BKDIR}/${DATE}_etc_gitlab.tar.gz gs://prd-gcs-gitlab-conf-bk/

# Get GitLab Backup
/opt/gitlab/bin/gitlab-rake gitlab:backup:create SKIP=db

# Delete
find $BKDIR -mtime +2 | xargs rm -rf

DATE=$(date "+%s_%Y_%m_%d")
echo "${DATE} [${PID}] [INFO]: gitlab backup complete" >> ${LOG_FILE}