#!/bin/sh
#Set variables for all needed files an paths
PROTONTRICKS_NATIVE="protontricks"
PROTONTRICKS_FLAT="flatpak run com.github.Matoking.protontricks"
SHORTIX_DIR=$HOME/Shortix
TEMPFILE=/tmp/shortix_temp
COMPDATA=$HOME/.steam/steam/steamapps/compatdata
FIRSTRUN=$HOME/Shortix/.shortix
LASTRUN=$HOME/Shortix/.shortix_last_run

shortix_script () {
    #Check if and how protontricks is installed, if yes run in, if no, stop the script
    if [ "$(command -v $PROTONTRICKS_NATIVE)" ]; then
        PROTONTRICKS=$PROTONTRICKS_NATIVE
    elif [ "$(command -v $PROTONTRICKS_FLAT)" ]; then
        PROTONTRICKS=$PROTONTRICKS_FLAT
    else
        echo "Protontricks could not be found! Please install it. Aborting..."
        exit
    fi
    eval "$PROTONTRICKS" -l > $TEMPFILE 2> /dev/null

    #remove all lines which doesn't have a round bracket in it
    sed -i -ne '/)/p' $TEMPFILE

    #Remove the "Non_Steam shortcut: " string from temp file
    sed -i 's/Non-Steam shortcut: //' $TEMPFILE

    #Replace the last occurence of closing and opening round brackets and replace them with semicolons and remove trailing space in one go
    sed -i -E 's/ \(([^)]+)\)$/;\1;/' $TEMPFILE

    #Remove non existant symlinks
    find -L $SHORTIX_DIR -maxdepth 1 -type l -delete

    #Create symlinks based on the data from the temp file.
    #IFS defines the semicolon as column separator
    #Then read the both columns as variables and create symlinks based on the data of each line
    while IFS=';' read game_name prefix_id
    do
        ln -sf "$COMPDATA/$prefix_id" "$SHORTIX_DIR/$game_name"
    done < $TEMPFILE

    touch "$LASTRUN"
}

if [ ! -d $COMPDATA ]; then
    echo "Steam compatibility data directory (${COMPDATA}) could not be found! Aborting..."
    exit
fi

if [ ! -f $FIRSTRUN ]; then
    shortix_script
    touch "$FIRSTRUN"
else
    dorun=1
    # if there is lastrun file, only run if there are compatdata folders newer than the lastrun file timestamp
    if [ -f $LASTRUN ]; then
        dorun=0
        lastrun_timestamp=$(date +%s -r "$LASTRUN")
        if [ "$(find $COMPDATA -newermt "@${lastrun_timestamp}" -type d)" ]; then
            dorun=1
        fi
    fi
    if [ $dorun -eq 1 ]; then
        shortix_script
    fi
fi

echo "Done, you can close this window now!"
