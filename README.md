![Shortix](https://github.com/Jannomag/shortix/blob/70b21e950f71dfd89ada095197fba86fa4d580c4/shortix_logo.svg)     
A script that creates human readable symlinks for Proton game prefixes (Steam Deck / SteamOS)

# Prerequireties
You need to install Protontricks from Discover on your Steam Deck, that's it.

# Installation (Automatic)
Download the [installer](https://github.com/Jannomag/shortix/releases/latest/download/shortix_installer.desktop) to the Desktop and double click it.   
Afterwards there's a new directory in you home directory, called Shortix.    
In there you'll find all created symlinks / shortcuts to the installed games - which were found by Protontricks.    

# Manual installation
1. Go to the /tmp folder using `cd /tmp`
2. Clone this repo with `git clone https://github.com/Jannomag/shortix`
3. Create Shortix directory with `mkdir -p /home/deck/Shortix`
4. Copy the script with `cp /tmp/shortix/shortix.sh /home/deck/Shortix`
5. Copy the systemd service with `cp /tmp/shortix/shortix.service /home/deck/.config/systemd/user`
6. Reload systemd daemon with `systemctl --user daemon-reload`
7. Enable service with `systemctl --user enable shortix.service`
8. Start service with `systemctl --user start shortix.service`
9. Done (all those steps does the `shortix_installer.sh` for you


# Background and explanation
I just wanted to have easier access to the prefixes for the games on my Steam Deck, so I created Shortix.
What it does is really simple:
- Run protontricks to get a list of all installed games, including Non-Steam games.
- Use the data to create symlinks in `/home/deck/Shortix`
- If there's a dead end symlink, it will get removed
- The script will be executed every 15 minutes by a systemd user service

To change the restart interval you need to change two things:
1. in `/home/deck/Shortix/shortix.sh` - change the value of the TIME variable in minutes
2. in `/home/deck/.config/systemd/user/shortix.service` - change the 1800s value to your desired value in seconds

If you want you can also change the directory. For this modify the directory within the shortix.sh and also in the shortix.service file.

You can also run the script manually either by using the terminal directly using this command: `/bin/bash /home/deck/Shortix/shortix.sh` or right click on the file and chosse "Run in Konsole".

# Known issues
Nothing yet, let me know! I'm not a pro!

# Contribution
If you have any suggestions, let me know!
