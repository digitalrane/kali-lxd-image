#!/bin/bash

echo "Installing dependencies"
# Install dependencies (debootstrap)
sudo apt-get -y install gpg
sudo apt-get -y install gpgv
sudo apt-get -y install debootstrap curl lxc

echo "Fetching debootstrap template for kali"
# Fetch the latest Kali debootstrap script from git
curl "http://git.kali.org/gitweb/?p=packages/debootstrap.git;a=blob_plain;f=scripts/kali;hb=HEAD" > kali-debootstrap 

echo "Importing kali release GPG to /usr/share/keyrings/kali-archive-keyring.gpg"
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/kali-archive-keyring.gpg --fingerprint --recv-keys ED444FF07D8D0BF6 

echo "Bootstrappin'"
# Do the 'strap
sudo rm -Rf ./kali-root
sudo debootstrap --arch=amd64 kali-rolling ./kali-root http://http.kali.org/kali ./kali-debootstrap --include isc-dhcp-client,sudo,vim,ifupdown,iproute2,ssh,apt-transport-https 

echo "Writing config files to container image"
mkdir -p ./etc/network
cat <<EOF > etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).
# The loopback network interface

auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF

# set the hostname
cat <<EOF > etc/hostname
kali
EOF

# set minimal hosts
sudo cat <<EOF > etc/hosts
127.0.0.1   localhost kali
# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

sudo cp -rv etc ./kali-root/

echo "Writing metadata"
echo "
architecture: ""x86_64""
creation_date: 1511264820
properties:
    architecture: ""x86_64""
    description: ""Kali Rolling ($(date -u))""
    os: ""kali""
    release: ""rolling""
" > metadata.yaml

echo "Tarring up metadata"
tar cf metadata.tar metadata.yaml

# Generate tarball 
echo "Tarring up image"
sudo tar -f kali-root.tar -C kali-root -c . 

echo "Importing image"
sudo lxc image import metadata.tar kali-root.tar --alias kali --verbose
