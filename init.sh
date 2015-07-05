#!/bin/bash
# ubuntu-config/init.sh
# Init config script for fresh distro installation
# Ubuntu Desktop 14.04-LTS amd64

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

## Update packages
apt-get update -y
apt-get dist-upgrade -y
apt-get autoremove --purge -y
apt-get autoclean

## Install packages
apt-get install dcfldd dnsutils nano net-tools sudo tcpdump strace \
openvpn network-manager network-manager-gnome network-manager-openvpn network-manager-openvpn-gnome 

## Configure sudo
echo "%wheel  ALL=(ALL) NOPASSWD:ALL

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

