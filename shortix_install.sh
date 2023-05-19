#/bin/bash
if [ -d /home/deck/Shortix/ ] || [ -f /home/deck/.config/systemd/user/shortix.service ]; then
  echo "########################"
  echo "#   UPDATING SHORTIX   #"
  echo  "#######################"
  rm -rf /home/deck/Shortix
else
  echo "##########################"
  echo "#   INSTALLING SHORTIX   #"
  echo "##########################"
fi

mkdir -p /home/deck/Shortix
cp /tmp/shortix/shortix.sh /home/deck/Shortix
chmod +x /home/deck/Shortix/shortix.sh
systemctl --user start shortix.service
cp /tmp/shortix/shortix.service /home/deck/.config/systemd/user
systemctl --user daemon-reload
if [ ! systemctl is-enabled --user  shortix.service ]; then
  systemctl --user enable shortix.service
fi
systemctl --user start shortix.service
echo  "DONE!"
