
#!/bin/bash
# This script will install all required stuff to run a BitCore RPC Server.
# BitCore Repo : https://github.com/LIMXTEC/BitCore/
# !! THIS SCRIPT NEED TO RUN AS ROOT !!
######################################################################
# Options and variables
# exit when any command fails
set -e
# Installation starts
clear
echo "*********** Welcome to the BitCore RPC Server Setup Script ***********"
echo 'This script will install all required updates & packages for Ubuntu 16.04 !'
echo 'Create specific user for the rpcserver, set firewall options and add bitcored as a service.'
echo '****************************************************************************'
echo '*** Step 3/10 - Running updates and installing required packages ***'
apt-get update -y
apt-get dist-upgrade -y
apt-get install build-essential libtool autotools-dev autoconf automake pkg-config -y \
libssl-dev libboost-all-dev git software-properties-common libminiupnpc-dev libevent-dev -y
#add-apt-repository ppa:bitcoin/bitcoin -y
#apt-get update -y
#apt-get upgrade -y
#apt-get install libdb4.8-dev libdb4.8++-dev -y
apt-get install libdb4.8 libdb4.8++ -y
echo '*** Step 4/10 - Cloning and Compiling BitCore Wallet ***'
cd
git clone https://github.com/LIMXTEC/BitCore.git
cd BitCore
./autogen.sh
./configure --disable-dependency-tracking --enable-tests=no --without-gui --disable-hardening --disable-wallet
make
cd
cd BitCore/src
strip bitcored
strip bitcore-cli
rm bitcore-qt
chmod 775 bitcore*
