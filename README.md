![](https://raw.githubusercontent.com/Jannomag/shortix/main/shortix_logo.svg)
A script that creates human readable symlinks for Proton game prefixes (Steam Deck / SteamOS)

# Prerequireties
You need to install Protontricks from Discover on your Steam Deck, that's it.

# Installation
Download the [installer](https://github.com/Jannomag/shortix/releases/latest/download/shortix_installer.desktop) to the Desktop and double click it.
Afterwards there's a new directory in you home directory, called Shortix. 
In there you'll find all created symlinks / shortcuts to the installed games - which were found by Protontricks.

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

You can also run the script manually either by using the terminal directly using this command: `/bin/bash /home/deck/Shortix/shortix.sh` or right click on the file and chosse "Run in Konsole".

# Known issues
Nothing yet, let me know! I'm not a pro!

# Contribution
If you have any suggestions, let me know!
