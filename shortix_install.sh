#/bin/bash

if [ -d $HOME/Shortix/ ] || [ -f $HOME/.config/systemd/user/shortix.service ]; then
  TYPE="updater"
  kdialog --title "Shortix $TYPE" --msgbox "Welcome to Shortix! This setup will update Shortix."

  rm -rf $HOME/Shortix
else
  TYPE="installer"
  kdialog --title "Shortix installer" --msgbox "Welcome to Shortix! This setup will install Shortix."
fi

mkdir -p $HOME/Shortix
cp /tmp/shortix/shortix.sh $HOME/Shortix
cp /tmp/shortix/remove_prefix.sh $HOME/Shortix
chmod +x $HOME/Shortix/shortix.sh
chmod +x $HOME/Shortix/remove_prefix.sh



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

kdialog --title "Shortix Backup" --yesno "Would you like to create a backup of Shortix on a different location?\nIf yes, please create and select the backup directory in the next window."
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


if [ -f $HOME/Shortix/.backup ]; then
  kdialog --getexistingdirectory . > $HOME/Shortix/.backup
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

kdialog --title "Shortix $TYPE" --msgbox "Shortix is set up!"
[ $? = 0 ] && exit
