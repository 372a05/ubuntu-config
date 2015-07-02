#!/bin/bash
# ubuntu-config.d/apt.alias_update_all.sh
# aptitude package manager - add update-all alias to .bash_aliases

id="apt_alias_update_all"
message="Add previous action as `update-all` alias to .bash_aliases file? [Y/n] "
choices="y,n"
default="y"

if[ $input=="y" ]; then
  echo "Adding update-all alias... "
  alias update-all="sudo apt-get dist-upgrade -y && sudo apt-get autoremove --purge -y && sudo apt-get autoclean -y"
  sudo echo 'alias update-all="sudo apt-get dist-upgrade -y && sudo apt-get autoremove --purge -y && sudo apt-get autoclean -y"'>>~/.bash_aliases
  echo "Finished adding update-all alias. "
fi
