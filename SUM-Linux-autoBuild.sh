#!/usr/bin/env bash

D=$PWD


# Create Swap for faster build
if [ ! -f /swapfile ]; then
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
sudo sh -c "echo '/swapfile none swap sw 0' >> /etc/fstab"
fi

# Get updates to Ubuntu
sudo apt-get update

# Install needed Sumcoind essentials
sudo apt-get install \
      git -y \
      build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils \
      libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev \
      libboost-all-dev \
      software-properties-common \

      sudo add-apt-repository ppa:bitcoin/bitcoin -enter \

      sudo apt-get update \
      libdb4.8-dev libdb4.8++-dev \
      libminiupnpc-dev \
      libzmq3-dev \
      libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler \
      libqt4-dev libprotobuf-dev protobuf-compiler \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python python-zmq \
      zlib1g-dev wget bsdmainutils automake curl apache2 libzmq3-dev

# install branch 17 Sumcoin
git clone -b 0.17 https://github.com/sumcoinlabs/sumcoin.git

# Make .sumcoin data directory, touch sumcoin.conf, insert starter .conf
mkdir .sumcoin

# create sumcoin.conf
cat << EOF > .sumcoin/sumcoin.conf
server=1
daemon=1
deprecatedrpc=accounts
deprecatedrpc=estimatefee
whitelist=127.0.0.1
rpcallowip=SERVER_IP_TO_YOUR_CAS
txindex=1
rpcuser=YOUR_SECUREsumcoinusername
rpcpassword=YOUR_SecurePassword
rpcport=3332
maxconnections=100
EOF

# Build Sumcoin Ubuntu Client 
cd ~/sumcoin
./autogen.sh
./configure --disable-tests --without-gui
make

# Copy Binaries to root
cd src
cp sumcoind ~/
cp sumcoin-cli ~/

echo "Your Sumcoin Daemon Should Now Be Built and Server Started"
echo "You can run commands using ./sumcoin-cli"
echo "Be sure to backup your wallet.dat file located in .sumcoin directory"

echo "For assistance email support@sumcoin.org"
