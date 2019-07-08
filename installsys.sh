#!/bin/bash
# The script will setup the sytem for OAI-UE

echo "Running script on `date`"
Red=$'\e[1;31m'
Green=$'\e[1;32m'
Blue=$'\e[1;34m'

echo "$Red`date`: start installing USRP and libboost"

sudo apt-get -y install libboost-all-dev
sudo add-apt-repository ppa:ettusresearch/uhd
sudo apt-get update
sudo apt-get -y install libuhd-dev libuhd003 uhd-host


echo -e "$Green \binstallation complete for USRP and libboost"

mkdir -p ~/openairinterface5g

OPENAIRHOME=~/openairinterface5g
cd $HOME
echo "$Green`date`:git cloning https://gitlab.eurecom.fr/oai/openairinterface5g"
git clone https://gitlab.eurecom.fr/oai/openairinterface5g

echo "cloning complete"

cd $OPENAIRHOME/cmake_targets/
echo -e "$Blue \bcurrent directory $PWD"
echo "`date`: Installing dependencies"

./build_oai -I

echo "$Green `date`:Installation complete"

./build_oai --UE --noS1 -c -w USRP -x

cd $OPENAIRHOME
source oaienv
echo "$Blue`date`:sourced OAIENV"

source ./targets/bin/init_nas_nos1 UE

echo "`date`:nashmesh complete"



cd $OPENAIRHOME/cmake_targets

sudo /usr/lib/uhd/utils/uhd_images_downloader.py
sudo -E ./lte_noS1_build_oai/build/lte-uesoftmodem-nos1  -U 1 -C 2660000000 -r 25 --ue-scan-carrier --ue-txgain 90 --ue-rxgain 115 -d >&1 | tee UE.log

