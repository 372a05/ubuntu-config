#!/bin/bash
# ubuntu-config.d/apt.do_update_all.sh
# aptitude package manager - run update-all

id="apt_do_update_all"
message="Cleanly update repositories, install upgrades, and remove unused packages? [Y/n] "
choices="y,n"
default="y"

if[ $input=="y" ]; then
  echo "Starting apt packages update-all... " 
  sudo apt-get update -y
  sudo apt-get dist-upgrade -y
  sudo apt-get autoremove --purge -y
  sudo apt-get autoclean -y
  echo "Finished apt packages update-all. "
fi
