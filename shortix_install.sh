#/bin/bash

if [ -d $HOME/Shortix/ ] || [ -f $HOME/.config/systemd/user/shortix.service ]; then
  echo "########################"
  echo "#   UPDATING SHORTIX   #"
  echo  "#######################"
  rm -rf $HOME/Shortix
else
  echo "##########################"
  echo "#   INSTALLING SHORTIX   #"
  echo "##########################"
fi

mkdir -p $HOME/Shortix
cp /tmp/shortix/shortix.sh $HOME/Shortix
cp /tmp/shortix/remove_prefix.sh $HOME/Shortix
chmod +x $HOME/Shortix/shortix.sh

read -e -n 1 -p "Would you like to add the prefix id to the shortcut name (Like 'Game Name (123455678)')? [Y/n]: "
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
  if [ ! -f $HOME/Shortix/.id ]; then
    touch $HOME/Shortix/.id
  fi
fi   

read -e -n 1 -p "Would you like to setup system service for background updates [Y/n]: "
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
  if [ ! -d $HOME/.config/systemd/user ]; then
    mkdir -p $HOME/.config/systemd/user
  fi
  cp /tmp/shortix/shortix.service $HOME/.config/systemd/user
  systemctl --user daemon-reload
  if ! systemctl is-enabled --quiet --user shortix.service; then
    systemctl --user enable shortix.service
  fi
  systemctl --user restart shortix.service
else
  if systemctl is-enabled --quiet --user shortix.service; then
    systemctl --user disable shortix.service
  fi
  if [ -f $HOME/.config/systemd/user/shortix.service ]; then
    rm $HOME/.config/systemd/user/shortix.service
  fi
  systemctl --user daemon-reload
fi

if [ -f $HOME/.config/user-dirs.dirs ]; then
  source $HOME/.config/user-dirs.dirs
  if [ $XDG_DESKTOP_DIR/shortix_installer.desktop ]; then
    sed -i 's/Install/Update/' /tmp/shortix/shortix_installer.desktop
    mv /tmp/shortix/shortix_installer.desktop $XDG_DESKTOP_DIR/shortix_updater.desktop
    rm -rf $XDG_DESKTOP_DIR/shortix_installer.desktop
    chmod +x $XDG_DESKTOP_DIR/shortix_updater.desktop
  fi
fi

read -p "Shortix is set up! Press ENTER to exit."
