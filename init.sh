#!/bin/bash
# ubuntu-config/init.sh
# Init config script for fresh distro installation
# Ubuntu Desktop 14.04-LTS amd64

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

# Get inputs
read -p "Primary normal, non-root username [$USER]: " user
if [[ -z $user ]]; then 
   user=$USER; 
fi

## Update packages
read -n 1 -p "Update packages? [Y/n]: " yn
if [[ $yn =~ [nN] ]]; then 
   echo "Skipping updates."
else
   apt-get update -y
   apt-get dist-upgrade -y
   apt-get autoremove --purge -y
   apt-get autoclean -y
fi

## Install packages
apt-get install dcfldd dnsutils nano net-tools sudo tcpdump strace wget \
openvpn network-manager network-manager-gnome network-manager-openvpn network-manager-openvpn-gnome 

## Configure sudo
read -p "Password for wheel (sudoers) group: " wheelpw
groupadd -p$wheelpw wheel
echo "%wheel  ALL=(ALL) NOPASSWD:ALL">>/etc/sudoers
usermod -a -G wheel $user

## Add bash aliases
cat > ~/.bash_aliases << __ALIASES__
#!/bin/bash
# Bash Aliases

## Verbose and force common operations
alias cp="cp -vf"
alias mv="mv -vf"
alias rm="rm -vf" 
alias chown="chown -v"
alias chmod="chmod -v"

## Shorthand ops
alias update-all="sudo apt-get update -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove --purge -y && sudo apt-get autoclean -y"
__ALIASES__

## Setup Ipredator
# (Input) VPN port [default=1194]
read -p "Connect to IPredator VPN port [1194]: " ipredport
if [[ ! $ipredport =~ [0-9]* ]]; then 
   ipredport=1194; 
fi

# (Input) Use NAT server? [default=n]
read -n 1 -p "Connect to IPredator NAT vpn server? [N/y]: " iprednat
if [[ $iprednat =~ [yY]]; then 
   ipredhostpre="nat"
else 
   ipredhostpre="pw"
fi

# (Input) VPN Creds [leaving user or passwd blank will disable auto-login]
read -p "Username for IPredator VPN (leave blank to prompt each login): " ipreduser
read -p "Password for IPredator VPN (leave blank to prompt each login): " ipredpass
if [[ -n $ipreduser && -n $ipredpass ]]; then
   echo -e "$ipreduser\n$ipredpass\n" > /etc/openvpn/config/ipredator.auth
   chmod -v 400 /etc/openvpn/config/ipredator.auth
   ipredauth="etc/openvpn/config/ipredator.auth"
else 
   ipredauth=""
fi

# Setup VPN config files
cd /tmp
mkdir -p /etc/openvpn/config

# CA Certificate
wget -v -P /tmp/ https://www.ipredator.se/static/downloads/openvpn/ubuntu/IPredator.se.ca.crt
mv -v /tmp/IPredator.se.ca.crt /etc/openvpn/config/ipredator.ca.crt
chmod -v 400 /etc/openvpn/config/ipredator.ca.crt

# TLS key
wget -v -P /tmp/ https://www.ipredator.se/static/downloads/openvpn/ubuntu/IPredator.se.ta.key
mv -v /tmp/IPredator.se.ta.key /etc/openvpn/config/ipredator.ta.key
chmod -v 400 /etc/openvpn/config/ipredator.ta.key

# OpenVPN client config
cat > /etc/openvpn/config/ipredator.ovpn << __IPRED_CONF__
# VER: 0.25
client
dev tun0
proto udp
remote $ipredhostpre.openvpn.ipredator.se $ipredhostport
remote $ipredhostpre.openvpn.ipredator.me $ipredhostport
remote $ipredhostpre.openvpn.ipredator.es $ipredhostport
resolv-retry infinite
nobind

auth-user-pass $ipredauth
auth-retry nointeract

ca /etc/openvpn/config/ipredator.ca.crt

tls-client
tls-auth /etc/openvpn/config/ipredator.ta.key
ns-cert-type server

# Disabled for NM because it does not import all settings correctly
#remote-cert-tls server
#remote-cert-ku 0x00e0 

keepalive 10 30
cipher AES-256-CBC
persist-key
comp-lzo
tun-mtu 1500
mssfix 1200
passtos
verb 3
replay-window 512 60
mute-replay-warnings
ifconfig-nowarn

# Enable this if your system does support it!
#tls-version-min 1.2

__IPRED_CONF__

