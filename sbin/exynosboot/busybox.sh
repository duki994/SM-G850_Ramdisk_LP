#!/sbin/busybox sh

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

CLEAN_BUSYBOX()
{
	for f in *; do
		case "$($BB readlink "$f")" in *usybox*)
			$BB rm "$f"
		;;
		esac
	done;
}

# Cleanup the old busybox symlinks
cd /system/xbin/;
CLEAN_BUSYBOX;

# If busybox was installed in /bin
cd /system/bin/;
CLEAN_BUSYBOX;

cd /;

# Install busybox to ROM and set correct permissions
$BB cp /sbin/busybox /system/xbin/;

/system/xbin/busybox --install -s /system/xbin/

chmod 06755 /system/xbin/busybox;
if [ -e /system/xbin/su ]; then
	$BB chmod 06755 /system/xbin/su;
fi;
if [ -e /system/xbin/daemonsu ]; then
	$BB chmod 06755 /system/xbin/daemonsu;
	/system/xbin/daemonsu --auto-daemon &
fi;

# execute my postboot script
$BB sh /sbin/exynosboot/postboot.sh;

