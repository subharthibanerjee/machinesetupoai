#! /bin/sh

echo 'setting real-time performance measure'
for cpu in /sys/devices/system/cpu/cpu[0-9]* ; do
	echo -n "siblings for virtual core:  ${cpu##*/} "
	cat $cpu/topology/thread_siblings_list
done

echo 'improving hardware interruptions latency'
echo 'Move out all the movable IRQ signals to the core 0'


for f in /proc/irq/[0-9]* ; do echo '0' > $f/smp_affinity_list; done

echo 'Move all the IRQ signals to the same core as the I/Q manager'
echo '3' > /proc/irq/30/smp_affinity_list
