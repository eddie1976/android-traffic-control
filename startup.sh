#!/system/bin/sh

#touch /sdcard/test_verify
rm /data/crontab/crontab.log
crond -b -l0 -d0 -L /data/crontab/crontab.log -c /data/crontab
sleep 120 && /system/bin/tc.sh start
