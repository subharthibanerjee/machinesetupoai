#!/bin/bash
# The script will setup the sytem for OAI-UE

dl_frequency=750000000 # band 13
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


if  [[ `lsb_release -rs` == "18.04" ]]; then
	echo_info "Installing USRP"

	sudo apt-get -y install libboost-all-dev libusb-1.0-0-dev python-mako doxygen python-docutils python-requests cmake build-essential
	git clone git://github.com/EttusResearch/uhd.git
	cd uhd; mkdir host/build; cd host/build
	cmake -DCMAKE_INSTALL_PREFIX=/usr ..
	make -j4
	sudo make install
	sudo ldconfig
	sudo /usr/lib/uhd/utils/uhd_images_downloader.py
	echo_success "`date`: Successfully installed USRP "

	

	echo_info "Installing patches"
	cd ~/Downloads
	wget open-cells.com/d5138782a8739209ec5760865b1e53b0/opencells-mods-20190621.tgz
	
	tar xf ~/Downloads/opencells-mods-20190621.tgz
	
	echo_succes "`date`: Installed patches"
	echo_info "Installing and checking out develop branch of openairinterface5g" 

	git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git
	cd openairinterface5g
	git checkout develop
	git checkout "17b9a9e917ce2a3a8c7004c7b9a221c350ddfe17"
	if [ $? -eq 0 ]; then
		echo_success "`date` checkout successful"
	else
		echo_debug "`date` failed checkout"
		exit
	fi

	cp ~/Downloads/opencells-mods/cmake_targets/tools/build_helper ~/openairnterface5g/cmake_targets/tools


	echo_info "copy complete"

	source oaienv
	echo_debug $PWD
	./cmake_targets/build_oai -I       # install SW packages from internet
	./cmake_targets/build_oai  -w USRP --eNB --UE --noS1 -x -c -C# compile eNB
else
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
fi








if 
sudo -E ./lte_noS1_build_oai/build/lte-uesoftmodem-nos1 -C $dl_frequency -r 25 \
 --ue-scan-carrier --ue-txgain 90 --ue-rxgain 115 --ue-max-power -5 -d \
 --phy-test
=======
sudo -E ./cmake_targets/lte_noS1_build_oai/build/lte-uesoftmodem-nos1 -d --phy-test -U 1 -C 750000000 -r 25 --ue-scan-carrier --ue-txgain 90 --ue-rxgain 115 --ue-max-power -5


