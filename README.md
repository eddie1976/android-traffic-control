# android-traffic-control
The purpose of this project is to implement Traffic Control (tc) in Android.

Make Your Kids' YouTube Running Slow on Their Mobiles

My 12-year-old girl is going to junior high school soon. I am thinking to give her 1GB mobile data plan (within 60 days). However, after talking to those parents of her classmates recently, I found that teenagers in her age like to spend hours on watching YouTube videos. As a result, 1GB quota is not enough. And I need to work out a solution to prevent her from spending too much time on videos.

After google, I realized that I am not alone because there are lots of parents over the world facing the same problem. What they did are implementing Traffic Control on their home routers or running some scripts on phones to block YouTube services. As for me, I want to implement Traffic Control on my girl's mobile to limit both download/upload bandwidth.

Because my girl uses Google Nexus 5 with LineageOS 14.1, I will use it to explain what I did to make her YouTube running slow. I believe that these steps also work in most Android phones.

1. Hack Nexus 5 with Su and TWRP to get root access.

2. Add init.d support to Android for custom startup scripts.
	
	2.1 Copy init_d.rc to /system/etc/init
	
		service init_d /system/bin/sh /system/bin/sysinit
			user root
			group root
			disabled
			oneshot
			seclabel u:r:sudaemon:s0

		on property:sys.boot_completed=1 && property:sys.logbootcomplete=1
			start init_d
	
	2.2 Copy startup.sh to /system/etc/init.d
	
		#!/system/bin/sh

		#touch /sdcard/test_verify
		rm /data/crontab/crontab.log
		crond -b -l0 -d0 -L /data/crontab/crontab.log -c /data/crontab
		sleep 120 && /system/bin/tc.sh start

3. Install BusyBox App for additional Linux utilities.

	3.1 What we need are "crond" and "awk".
	
	Apps on Google Play: https://play.google.com/store/apps/details?id=stericson.busybox

4. Install Traffic Control script and run it in cron job.

	4.1 Copy passwd to /system/etc (for crond)
	
		root:x:0:0:root:/data:/system/bin/sh

	4.2 Copy root to /data/crontab (for crond)
	
		0 * * * * /system/bin/tc.sh stop
		1 * * * * /system/bin/tc.sh start

	4.3 Copy tc.sh /system/bin
	
	Source code of tc.sh: https://android.stackexchange.com/questions/33661/limit-the-internet-bandwidth-of-android-device
	
	4.3.2 I tried "BradyBound" (iptables solutions). It didn't work with YouTube.
	
	4.4 Modify tc.sh (rate and ceil of Download/Upload, Interface)
	
		# The network interface we're planning on limiting bandwidth.
		IF=wlan0

		# Download limit (in mega bits)
		DNLD=4kbps

		# Upload limit (in mega bits)
		UPLD=4kbps

		# rate is min bandwidth and ceil is max
		$TC class add dev $IF parent 1: classid 1:1 htb rate $DNLD ceil 5kbps
		$TC class add dev $IF parent 1: classid 1:2 htb rate $UPLD ceil 5kbps

Feel free to change script path accroding to your need.

PM me if you are also interested about this side project (help teenagers and their parents).

https://www.linkedin.com/in/eddiec9968/
