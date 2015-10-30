#!/sbin/busybox sh
# duki994 postboot script

BB=/sbin/busybox


MOUNT_RW() 
{

	if [ "$($BB mount | $BB grep rootfs | $BB cut -c 26-27 | $BB grep -c ro)" -eq "1" ]; then
		$BB mount -o remount,rw /;
	fi;

	if [ "$($BB mount | $BB grep system | $BB grep -c ro)" -eq "1" ]; then
		$BB mount -o remount,rw /system;
	fi;

}
MOUNT_RW;

PERMISSION_FIX()
{
	$BB chown -R root:root /tmp;
	$BB chown -R root:root /res;
	$BB chown -R root:root /sbin;
	$BB chown -R root:root /lib;
	$BB chmod -R 777 /tmp/; # for annoying tmp-mksh errors
	$BB chmod -R 775 /res/;	# for Synapse
	$BB chmod -R 06755 /sbin/ext/;
	$BB chmod 06755 /sbin/busybox;
	$BB chmod 06755 /system/xbin/busybox;
}
PERMISSION_FIX;

# create init.d folder
if [ ! -d /system/etc/init.d ]; then
	mkdir -p /system/etc/init.d/
	$BB chmod -R 755 /system/etc/init.d/;
fi;

#chmod everything in res dir
MOUNT_RW;
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

# Start any init.d scripts that may be present in the rom or added by the user
MOUNT_RW;
$BB chmod -R 755 /system/etc/init.d/;

# Start uci
MOUNT_RW;
$BB sh /res/synapse uci;
