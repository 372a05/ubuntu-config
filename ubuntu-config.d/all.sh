#!/bin/bash
# Ubuntu initial install configuration script

apt-get update -y
apt-get dist-upgrade -y
apt-get autoremove --purge -y
apt-get autoclean

apt-get install sudo nano tcpdump traceroute dnsutils net-tools
