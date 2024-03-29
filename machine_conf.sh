#!/bin/bash

clear
echo "Running script on `date`"
Red=$'\e[1;31m'
Green=$'\e[1;32m'
Blue=$'\e[1;34m'
Default=$'\e[0m'

function echo_default() {
	echo -e "$Default \b"$1
}
function echo_info() {
	echo -e "$Blue \b"$1
	echo_default
}
function echo_sucess() {
	echo -e "$Green \b"$1
	echo_default
}

function echo_debug() {
	echo -e "$Red \b"$1
	echo_default
}


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

echo "======================================"
echo_info "Please read carefully from here"

read -p "Do you want to run CSET optimization? " choice
case "$choice" in
y|Y )	echo_debug "processing CSET request"
	echo_default "..."	
	cset shield --force --kthread on -c 1-3
	for f in /sys/devices/system/cpu/cpu[0-9]* ; do
		echo_info "running on $f"
		echo "Performance" > $f/cpufreq/scaling_governor
	done
	echo_info "Performance optimization done";;

n|N ) 	echo_info "not setting CSET";;
* ) 	echo_debug "Invalid option";;
esac 
echo




read -p "Do you want to run with CSET shield? " choice
case "$choice" in
y|Y )   echo_debug "processing CSET request"
	sudo cset shield ~/openairinterface5g/cmake_targets/lte_noS1_build_oai/build/lte-uesoftmodem-nos1;;
n|N ) 	echo_info "not setting CSET";;
* ) 	echo_debug "Invalid option";;
esac
echo



echo_info "exiting shell ......."
