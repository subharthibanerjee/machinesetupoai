#!/bin/bash
# The script will setup the sytem for OAI-UE

echo "Running script on `date`"
Red=$'\e[1;31m'
Green=$'\e[1;32m'
Blue=$'\e[1;34m'

function echo_info() {
	echo -e "$Blue \b"$1
}
function echo_sucess() {
	echo -e "$Green \b"$1
}

function echo_debug() {
	echo -e "$Red \b"$1
}
echo_debug "`date`: start installing USRP and libboost"

sudo apt-get -y install libboost-all-dev
sudo add-apt-repository ppa:ettusresearch/uhd
sudo apt-get update
sudo apt-get -y install libuhd-dev libuhd003 uhd-host


echo_success "installation complete for USRP and libboost"

mkdir -p ~/openairinterface5g

OPENAIRHOME=~/openairinterface5g
cd $HOME
echo_info "`date`:git cloning https://gitlab.eurecom.fr/oai/openairinterface5g"
git clone https://gitlab.eurecom.fr/oai/openairinterface5g

echo_success "cloning complete"

cd $OPENAIRHOME/cmake_targets/
echo_info "current directory $PWD"
echo_info "`date`: Installing dependencies"

./build_oai -I

echo_success "`date`:Installation complete"

./build_oai --UE --noS1 -c -w USRP -x

cd $OPENAIRHOME
source oaienv
echo_info "`date`:sourced OAIENV"

source ./targets/bin/init_nas_nos1 UE

echo_success "`date`:nashmesh complete"



cd $OPENAIRHOME/cmake_targets

sudo /usr/lib/uhd/utils/uhd_images_downloader.py

echo_info "downloaded installer"
sudo -E ./cmake_targets/lte_noS1_build_oai/build/lte-uesoftmodem-nos1 -d --phy-test -U 1 -C 750000000 -r 25 --ue-scan-carrier --ue-txgain 90 --ue-rxgain 115 --ue-max-power -5

