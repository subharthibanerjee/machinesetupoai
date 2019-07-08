#!/bin/bash
#kernel
apt-get -y update
apt-get -y install linux-image-3.19.0-61-lowlatency linux-headers-3.19.0-61-lowlatency
#necessary programs
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
echo "Please restart the computer and then choose advanced options > 3.19 kernel from the grub screen. Run sudo i7z to check if the power options are correct, cores must be running at 100%. "

