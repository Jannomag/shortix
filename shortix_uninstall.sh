#!/bin/sh
echo "This will uninstall Shortix from your system!"
read -p "Press ENTER if you want to continue, otherwise close this window"

if [ ! -d $HOME/Shortix ]; then
  echo "Shortix is not installed in $HOME/Shortix!"
  echo "Please remove your Shortix directory manually if there's one"
else
  if [ -f $HOME/Shortix/.backup ]; then
    rm -rf $(cat $HOME/Shortix/.backup)/Shortix-Backup
  fi
  if [ -f $HOME/.config/systemd/user/shortix.service ]; then
    systemctl --user stop shortix.service
    systemctl --user disable shortix.service
    rm -rf $HOME/.config/systemd/user/shortix.service
  fi
  rm -rf $HOME/Shortix
fi

echo "Everything is done! Shortix is uninstalled, including backup and service (if it was installed).\nThanks and Bye!"
exit
