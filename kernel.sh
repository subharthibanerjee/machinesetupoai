#!/bin/bash
#kernel

echo "Running script on `date`"
Red=$'\e[1;31m'
Green=$'\e[1;32m'
Blue=$'\e[1;34m'
function echo_info() {
	echo -e "$Blue [INFO] \b"$1
}
function echo_sucess() {
	echo -e "$Green [SUCCESS] \b"$1
}

function echo_debug() {
	echo -e "$Red [DEBUG] \b"$1
}

echo_info "Updating the system"

sudo apt-get -y update

echo_info "Collecting general information regarding the system"

echo_info "Following information from https://open-cells.com/index.php/2017/08/22/all-in-one-openairinterface-august-22nd/"
# https://open-cells.com/index.php/2017/08/22/all-in-one-openairinterface-august-22nd/


if  [[ `lsb_release -rs` == "18.04" ]]; then
	echo_info "Installing low latency kernel for 18.04"
	sudo apt-get -y install subversion git i7z

	echo -n | openssl s_client -showcerts -connect gitlab.eurecom.fr:443 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | sudo tee -a /etc/ssl/certs/ca-certificates.crt

	
	
else
	echo_info "Installing low latency kernel for 14.04"
	apt-get -y install linux-image-3.19.0-61-lowlatency linux-headers-3.19.0-61-lowlatency
	apt-get -y install subversion git i7z cpufrequtils
	#add power options to grub, eliminating c and p states and the rest
	sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_pstate=disable processor.max_cstate=1 intel_idle.max_cstate=0 idle=poll"/g' /etc/default/grub
	update-grub
	#check power settings in cpufrequtils, adding line if necessary
	grep -q -F 'GOVERNOR="performance"' /etc/default/cpufrequtils
	if [ $? -ne 0 ]; then
	  echo 'GOVERNOR="performance"' >> /etc/default/cpufrequtils
	fi
	#update and restart
	update-rc.d ondemand disable
	/etc/init.d/cpufrequtils restart
	#run i7z to check if all cores are running at 100%, should be done after a restart of the cpu because the new kernel must be chosen from the "advanced options" page in the grub
	echo_debug "Please restart the computer and then choose advanced options > 3.19 kernel from the grub screen. Run sudo i7z to check if the power options are correct, cores must be running at 100%. "
fi


#necessary programs


