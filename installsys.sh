#!/bin/bash

echo 'installing USRP and libboost'

sudo apt-get -y install libboost-all-dev
sudo add-apt-repository ppa:ettusresearch/uhd
sudo apt-get update
sudo apt-get -y install libuhd-dev libuhd003 uhd-host


echo "installation complete for USRP and libboost"

mkdir -p ~/openairinterface5g

OPENAIRHOME=~/openairinterface5g
echo "git cloning https://gitlab.eurecom.fr/oai/openairinterface5g"
git clone https://gitlab.eurecom.fr/oai/openairinterface5g

echo "cloning complete"

cd $OPENAIRHOME/cmake_targets/
echo $PWD
echo "Installing dependencies"

./build_oai -I

echo 'Installation complete'

./build_oai -c -w USRP -x

cd $OPENAIRHOME
source oaienv
echo "sourced OAIENV"

source ./targets/bin/init_nas_nos1 UE

echo "nashmesh complete"

cd $OPENAIRHOME/cmake_targets

sudo -E ./lte_noS1_build_oai/build/lte-uesoftmodem-nos1  -U 1 -C 2660000000 -r 25 --ue-scan-carrier --ue-txgain 90 --ue-rxgain 115 -d >&1 | tee UE.log

