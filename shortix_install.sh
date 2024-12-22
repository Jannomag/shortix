#/bin/sh
# Terminal color variables:
NC='\033[0m'  
CY='\033[1;96m'
RE='\033[1;91m'  
YL='\033[1;93m'

PROTONTRICKS_NATIVE="protontricks"
PROTONTRICKS_FLAT="flatpak run com.github.Matoking.protontricks"
PROTONTRICKS_FLATID="com.github.Matoking.protontricks"

if [ "$(command -v kdialog)" ]; then
	USEKDIALOG=true
else
	USEKDIALOG=false
fi

#Check if and how protontricks is installed, if yes run, if no, stop the script
if [ "$(command -v $PROTONTRICKS_NATIVE)" ]; then
	echo "Protontricks is installed natively"
elif [ "$(flatpak info "$PROTONTRICKS_FLATID" >/dev/null 2>&1 && echo "true")" ]; then
	echo "Protontricks is installed as Flatpak"
else
	if [ $USEKDIALOG == true ]; then
		kdialog --title "Shortix installer" --error "Protontricks not found! Please install Protontricks either as Flatpak or native by using pacman or yay."
		exit
	else
		echo -e "${RE}Protontricks could not be found! Please install it. Aborting...${NC}"
		read -n 1 -s -r -p "Press any key to continue"
		exit
	fi

fi

if [ -d $HOME/Shortix/ ] || [ -f $HOME/.config/systemd/user/shortix.service ]; then
  TYPE="updater"
  if [ $USEKDIALOG == true ]; then
  	kdialog --title "Shortix $TYPE" --msgbox "Welcome to Shortix! This setup will update Shortix."
  else
  	echo -e "${CY}Welcome to Shortix-$TYPE. This setup will update Shortix.${NC}"
  	sleep 1
  fi
  rm -rf $HOME/Shortix
else
  TYPE="installer"
  if [ $USEKDIALOG == true ]; then
  	kdialog --title "Shortix installer" --msgbox "Welcome to Shortix! This setup will install Shortix."
  else
  	echo "${CY}Welcome to Shortix-$TYPE. This setup will install Shortix.${NC}"
  	sleep 1
  fi
fi

mkdir -p $HOME/Shortix
cp /tmp/shortix/shortix.sh $HOME/Shortix
cp /tmp/shortix/remove_prefix.sh $HOME/Shortix
p /tmp/shortix/shortix_uninstall.sh $HOME/Shortix
chmod +x $HOME/Shortix/shortix.sh
chmod +x $HOME/Shortix/remove_prefix.sh
chmod +x $HOME/Shortix/shortix_uninstall.sh


if [ $USEKDIALOG == true ]; then
	kdialog --title "Shortix $TYPE" --yesno "Would you like to add the prefix id to the shortcut name?\nLike this:\nGame Name (123455678)" 2> /dev/null
	case $? in
	0)  if [ ! -f $HOME/Shortix/.id ]; then
	      touch $HOME/Shortix/.id
	    fi
	    ;;
	1)  if [ -f $HOME/Shortix/.id ]; then
	      rm -rf $HOME/Shortix/.id
	    fi
	    ;;
	esac
else
	read -p "Would you like to add the prefix id to the shortcut name? ike this: Game Name (123455678) " yn
	case $yn in
	yY)  if [ ! -f $HOME/Shortix/.id ]; then
	      touch $HOME/Shortix/.id
	    fi
	    ;;
	nN)  if [ -f $HOME/Shortix/.id ]; then
	      rm -rf $HOME/Shortix/.id
	    fi
	    ;;
	esac
fi

if [ $USEKDIALOG == true ]; then
	if [ -f $HOME/Shortix/.id ]; then
	  kdialog --title "Shortix $TYPE" --yesno "Would you also like to add the size of the target directory to the shortcut name?\nLike this: \nGame Name (123455678) - 1.6G" 2> /dev/null
	  case $? in
	  0)  if [ ! -f $HOME/Shortix/.size ]; then
		touch $HOME/Shortix/.size
	      fi
	      ;;
	  1)  if [ -f $HOME/Shortix/.size ]; then
		rm -rf $HOME/Shortix/.size
	      fi
	      ;;
	  esac
	else
	  kdialog --title "Shortix $TYPE" --yesno "Would you like to add the size of the target directory to the shortcut name?\nLike this:\nGame Name - 1.6G?"
	  case $? in
	  0)  if [ ! -f $HOME/Shortix/.size ]; then
		touch $HOME/Shortix/.size
	      fi
	      ;;
	  1)  if [ -f $HOME/Shortix/.size ]; then
		rm -rf $HOME/Shortix/.size
	      fi
	      ;;
	  esac
	fi
else
	if [ -f $HOME/Shortix/.id ]; then
	  read -p "Would you also like to add the size of the target directory to the shortcut name? Like this: Game Name (123455678) - 1.6G " yn 
	  case $yn in
	  yY)  if [ ! -f $HOME/Shortix/.size ]; then
		touch $HOME/Shortix/.size
	      fi
	      ;;
	  nN)  if [ -f $HOME/Shortix/.size ]; then
		rm -rf $HOME/Shortix/.size
	      fi
	      ;;
	  esac
	else
	  read -p "Would you like to add the size of the target directory to the shortcut name?\nLike this:\nGame Name - 1.6G? " yn
	  case $yn in
	  yY)  if [ ! -f $HOME/Shortix/.size ]; then
		touch $HOME/Shortix/.size
	      fi
	      ;;
	  nN)  if [ -f $HOME/Shortix/.size ]; then
		rm -rf $HOME/Shortix/.size
	      fi
	      ;;
	  esac
	fi
fi

if [ $USEKDIALOG == true ]; then
	kdialog --title "Shortix $TYPE" --yesno "Would you like to setup system service for background updates?"
	case $? in
	0)  if [ ! -d $HOME/.config/systemd/user ]; then
	    mkdir -p $HOME/.config/systemd/user
	    fi
	    cp /tmp/shortix/shortix.service $HOME/.config/systemd/user
	    systemctl --user daemon-reload
	    if ! systemctl is-enabled --quiet --user shortix.service; then
	      systemctl --user enable shortix.service
	    fi
	    systemctl --user restart shortix.service
	    ;;
	1)  if systemctl is-enabled --quiet --user shortix.service; then
	      systemctl --user disable shortix.service
	    fi
	    if [ -f $HOME/.config/systemd/user/shortix.service ]; then
	      rm $HOME/.config/systemd/user/shortix.service
	    fi
	      systemctl --user daemon-reload
	    ;;
	esac
else
	read -p "Would you like to setup system service for background updates? " yn
	case $yn in
	yY)  if [ ! -d $HOME/.config/systemd/user ]; then
	    mkdir -p $HOME/.config/systemd/user
	    fi
	    cp /tmp/shortix/shortix.service $HOME/.config/systemd/user
	    systemctl --user daemon-reload
	    if ! systemctl is-enabled --quiet --user shortix.service; then
	      systemctl --user enable shortix.service
	    fi
	    systemctl --user restart shortix.service
	    ;;
	nN)  if systemctl is-enabled --quiet --user shortix.service; then
	      systemctl --user disable shortix.service
	    fi
	    if [ -f $HOME/.config/systemd/user/shortix.service ]; then
	      rm $HOME/.config/systemd/user/shortix.service
	    fi
	      systemctl --user daemon-reload
	    ;;
	esac
fi

if [ $USEKDIALOG == true ]; then
	kdialog --title "Shortix Backup" --yesno "Would you like to create a backup of Shortix on a different location?\nIf yes, please select the location where the Shortix-Backup directory should be created."
	case $? in
	  0)  if [ ! -f $HOME/Shortix/.backup ]; then
		touch $HOME/Shortix/.backup
	      fi
	      ;;
	  1)  if [ -f $HOME/Shortix/.backup ]; then
		rm -rf $HOME/Shortix/.backup
	      fi
	      ;;
	esac
else
	read -p "Would you like to create a backup of Shortix on a different location?" yn
	case $yn in
	  yY)  if [ ! -f $HOME/Shortix/.backup ]; then
		touch $HOME/Shortix/.backup
	      fi
	      ;;
	  nN)  if [ -f $HOME/Shortix/.backup ]; then
		rm -rf $HOME/Shortix/.backup
	      fi
	      ;;
	esac
fi

if [ $USEKDIALOG == true ]; then
	if [ -f $HOME/Shortix/.backup ]; then
	  kdialog --getexistingdirectory . > $HOME/Shortix/.backup
	  mkdir -p $(cat $HOME/Shortix/.backup)/Shortix-Backup
	fi
else
	if [ -f $HOME/Shortix/.backup ]; then
 	read -p "Please enter your path where the Shortix-Backup directory should be created (like '/home/deck'): " backdir
  	mkdir -p $backdir/Shortix-Backup
   	fi
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

if [ $USEKDIALOG == true ]; then
	kdialog --title "Shortix $TYPE" --msgbox "Shortix is set up!"
else
	echo -e "${YL}Short is set up!${NC}"
	sleep 4
fi

[ $? = 0 ] && exit
