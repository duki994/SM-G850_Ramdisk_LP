#!/sbin/busybox sh

cat << CTAG
{
    name:I/O,
    elements:[
    
	{ SPane:{
		title:"I/O scheduler choose",
        }},
	{ SOptionList:{
		title: "I/O sched",
		description:"Set desired I/O sched",
		default:deadline,
		action:"generic /sys/block/mmcblk0/queue/scheduler",
		values:[
		     noop,
		     deadline,
		     cfq,
		]
	}},
	{ SLiveLabel:{
                  title:"I/O sched",
                  description:"Current I/O sched.",
                  refresh:5000,
                  action:"cat /sys/block/mmcblk0/queue/scheduler"
        }},
	{ SSeekBar:{
		title:"Read ahead value",
		default:`cat /sys/block/mmcblk0/bdi/read_ahead_kb`,
		action:"generic /sys/block/mmcblk0/bdi/read_ahead_kb",
		unit:"kB", weight:256.0, min:0, step:1, max:10
	}},
    ]
}
CTAG