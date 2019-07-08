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

