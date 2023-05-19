#/bin/bash
mkdir -p /home/deck/Shortix
cp ./shortix.sh /home/deck/Shortix
cp ./shortix.service /home/deck/.config/systemd/user
systemctl --user enable shortix.service
systemctl --user start shortix.service
