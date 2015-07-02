#!/bin/bash
# ubuntu-config.d/apt.sh
# Aptitude Package Manager

message="Cleanly update repositories, install upgrades, and remove unused packages?"
choices="[Y/n]"
default="y"

echo -n $message
read -n 1 apt1

echo $apt1
