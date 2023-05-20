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
systemctl --user restart shortix.service
echo  "DONE!"
