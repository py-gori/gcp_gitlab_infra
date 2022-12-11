hostname=`uname -n`
user=`whoami`
login_time=`date +%Y%m%d%H%M%S`
logfile=/var/log/operation/"operation_log_"$hostname"_"$user"_"$login_time.log
p_proc=`ps -ef|grep $PPID|grep bash|awk '{print $8}'`
if [ "$p_proc" = -bash ]
then
    script -f -c "bash" -q $logfile
    exit
fi
