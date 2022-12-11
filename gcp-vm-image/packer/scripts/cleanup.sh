#!/bin/bash -eux
/usr/bin/yum -y clean all
/bin/rm -rf /tmp/*
/bin/rm -rf /var/tmp/*
sync
