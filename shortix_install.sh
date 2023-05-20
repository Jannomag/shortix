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
chmod +x $HOME/Shortix/shortix.sh
if [ ! -d $HOME/.config/systemd/user ]; then
    mkdir -p $HOME/.config/systems/user
fi
cp /tmp/shortix/shortix.service $HOME/.config/systemd/user
systemctl --user daemon-reload
if [ ! systemctl is-enabled --user  shortix.service ]; then
  systemctl --user enable shortix.service
fi
if [ -f $HOME/.config/user-dirs.dirs ]; then
  source $HOME/.config/user-dirs.dirs
  if [ $XDG_DESKTOP_DIR/shortix_installer.desktop ]; then
    sed -i 's/Install/Update/' /tmp/shortix_installer.desktop
    mv /tmp/shortix_installer.desktop $XDG_DESKTOP_DIR/shortix_updater.desktop
  fi
fi
systemctl --user restart shortix.service
echo  "DONE!"
