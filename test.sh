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
