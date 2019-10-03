#!/bin/bash
# The script will setup the sytem for OAI-UE
clear
dl_frequency=750000000 # band 13
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




while getopts 'abf:v' flag; do
			case "${flag}" in 

				UE) echo_info "Running UE ---"
				sudo ./lte-uesoftmodem -d -S -q -C 2680000000 -r 25 --ue-rxgain 120 --ue-txgain 0 --ue-max-power 0 --ue-scan-carrier --nokrnmod 1 --noS1 --threadIQ 3
;;

				eNB) sudo -E ./lte_build_oai/build/lte-softmodem -O ~/openairinterface5g/ci-scripts/conf_files/my-enb.band7.tm1.25PRB.usrpb210.conf -d --nokrnmod 1 --noS1 --eNBs.[0].rrc_inactivity_threshold 0;;
