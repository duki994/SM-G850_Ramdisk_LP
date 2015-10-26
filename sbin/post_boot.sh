#!/system/bin/sh
# duki994 - post_boot script for setting values after boot;

#### UKSM tuning #####
# 500 ms scanning
echo "500" > /sys/kernel/mm/uksm/sleep_millisecs
# medium cpu gov
echo "medium" > /sys/kernel/mm/uksm/cpu_governor
########################


### Set I/O deadline ###
echo "deadline" > /sys/block/mmcblk0/queue/scheduler;
echo "1024" > /sys/block/mmcblk0/bdi/read_ahead_kb
echo "2" >  /sys/block/mmcblk0/queue/nomerges;