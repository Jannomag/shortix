![Shortix](https://raw.githubusercontent.com/Jannomag/shortix/main/shortix_logo.svg)     
A script that creates human readable symlinks for Proton game prefixes

# Prerequireties
You need to install Protontricks from Discover on your Steam Deck, that's it.

# Installation (Automatic)
Download the [installer](https://github.com/Jannomag/shortix/releases/latest/download/shortix_installer.desktop) to the Desktop and double click it.    
##### Attention for Firefox users: I noticed that Firefox will append ".download" to the file. I don't know why, but you need to remove this, so the file is called "shortex_installer.desktop" in order to be executable.    

The installer will you ask you two things:
- Add prefix id to the game name - this will make the shortcuts look like this: `Game Name (12345678)`
- Install the Shortix service - this will allow Shortix to be executed automatically after a time interval (default is 30 Minutes). This will work in Game Mode as well.
  
If you changed your mind about the service, just run the "Update Shortix" again.

Afterwards there's a new directory in you home directory, called Shortix.    
In there you'll find all created symlinks / shortcuts to the installed games - which were found by Protontricks.  

In the Shortix directory you'll also find the `shortix.sh` and `remove_prefix.sh` scripts.    
With `shortix.sh` you can run Shortix manually (run this in a Terminal or use right click and choose "Run in Konsole" if you're running KDE).    
For `remove_prefix.sh` read the tutorial below.

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

# Prefix removal script
I've added a script called `remove_prefix.sh` to the Shortix directory.    
This script allows you to remove not just the shortcut but also the whole prefix directory.     
Run this script in a terminal (or do right click -> "Run in Konsole" for KDE / Steam Deck).    
Then you can drag an drop all shortcuts from the Shortix directory of which you want to remove the prefix directory.    
Afterwards press enter, the script will notify you about the paths.    
It will also ask you if you really want to delete them.    
**Pleas note: The deletion will remove the prefix completely! This will also remove savegames (except cloud saves) and other game specific user data - finally!**

# Uninstall
To uninstall run the "Update Shortix" from the desktop and choose "no" when the script asks you if you want to install the service.
Afterwards delete the Shortix directory in your home directory and the "Update Shortix" from desktop.
That's it.

# Tested systems / distros
- Steam Deck (SteamOS 3.4)
- EndeavourOS
- Ubuntu 22.04

# Known issues
~~- if the name of a game contains round brackets, for example "Aaa aaa Aaa: Aaa Aaa (16-bit)" (thanks to [u/octopus_erectus](https://www.reddit.com/r/SteamDeck/comments/13luaiz/release_shortix_a_script_for_human_readable/jksiery/?utm_source=share&utm_medium=ios_app&utm_name=ioscss&utm_content=1&utm_term=1&context=3)) the script will fail. I will try to fix this when I find a bit time. For now a workaround can be to rename the games, but I don't know if this work for native Steam games.~~
(fixed)

# Contribution
If you have any suggestions, let me know!
