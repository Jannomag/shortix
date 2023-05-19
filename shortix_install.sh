#/bin/bash
echo "##########################"
echo "#   INSTALLING SHORTIX   #"
echo "##########################"
mkdir -p /home/deck/Shortix
cp /tmp/shortix/shortix.sh /home/deck/Shortix
chmod +x /home/deck/Shortix/shortix.sh
cp /tmp/shortix/shortix.service /home/deck/.config/systemd/user
systemctl --user daemon-reload
systemctl --user enable shortix.service
systemctl --user start shortix.service
echo  "DONE!"
