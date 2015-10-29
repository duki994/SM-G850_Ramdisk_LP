# duki994 - post_boot script for setting values after boot;
#!/system/bin/sh
BB=/res/busybox/

### mount system and rootfs as rw
$BB mount -t rootfs -o remount,rw
$BB mount -o remount,rw /system

#chmod everything in res dir
$BB chmod -R 777 /res/*

#### UKSM tuning #####
# 500 ms scanning
$BB echo "500" > /sys/kernel/mm/uksm/sleep_millisecs
# medium cpu gov
echo "medium" > /sys/kernel/mm/uksm/cpu_governor
########################


### Set I/O deadline ###
$BB echo "deadline" > /sys/block/mmcblk0/queue/scheduler
$BB echo "1024" > /sys/block/mmcblk0/bdi/read_ahead_kb
$BB echo "2" >  /sys/block/mmcblk0/queue/nomerges
