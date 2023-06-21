#!/bin/sh
#Set variables for all needed files an paths
PROTONTRICKS_NATIVE="protontricks"
PROTONTRICKS_FLAT="flatpak run com.github.Matoking.protontricks"
SHORTIX_DIR=$HOME/Shortix
TEMPFILE=/tmp/shortix_temp
COMPDATA=$HOME/.steam/steam/steamapps/compatdata
SHADER_DIR=$HOME/.steam/steam/steamapps/shadercache
SHADER_SHORTIX=$SHORTIX_DIR/_Shaders
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

    #Remove semicolons from game names because we use semicolons as separator later on
    sed -i -E 's/\;/ /g' $TEMPFILE

    #Replace the last occurence of closing and opening round brackets and replace them with semicolons and remove trailing space in one go
    sed -i -E 's/ \(([^)]+)\)$/;\1;/' $TEMPFILE

    #Remove non existant symlinks
    find -L $SHORTIX_DIR -maxdepth 1 -type l -delete

    # Chkef if the .id file is present. If true, then append the prefix id to the game name.
    #Create symlinks based on the data from the temp file.
    #IFS defines the semicolon as column separator
    #Then read the both columns as variables and create symlinks based on the data of each line
    #Also create the _Shader directory and create symlinks to the shadercache directories.
    #Some games don't use shadercache, if so, the dead end symlink will be removed directly
    #If .size file is found add the size to the file name
    mkdir -p $SHADER_SHORTIX
    if [ -f $SHORTIX_DIR/.id ]; then
        if [ -f $SHORTIX_DIR/.size ]; then
            while IFS=';' read game_name prefix_id
            do
                target="$SHORTIX_DIR/$game_name ($prefix_id)"
                if [[ ! $target =~ \ -\ [0-9.]+[A-Z] ]]; then
                    ln -sf "$COMPDATA/$prefix_id" "$target"
                    SIZE=$(du -shH "$target" | cut -f1)
                    mv "$target" "$target - $SIZE"
                fi

                target="$SHADER_SHORTIX/$game_name ($prefix_id)"
                if [[ ! $target =~ \ -\ [0-9.]+[A-Z] ]]; then
                    ln -sf "$SHADER_DIR/$prefix_id" "$target"
                    SIZE=$(du -shH "$target" | cut -f1)
                    mv "$target" "$target - $SIZE"
                fi
            done < $TEMPFILE
        else
            while IFS=';' read game_name prefix_id
            do
                ln -sf "$COMPDATA/$prefix_id" "$SHORTIX_DIR/$game_name ($prefix_id)"
                ln -sf "$SHADER_DIR/$prefix_id" "$SHADER_SHORTIX/$game_name ($prefix_id)"
                find -L $SHADER_SHORTIX -maxdepth 1 -type l -delete
            done < $TEMPFILE
        fi
    else
        while IFS=';' read game_name prefix_id
        do
            ln -sf "$COMPDATA/$prefix_id" "$SHORTIX_DIR/$game_name"
            ln -sf "$SHADER_DIR/$prefix_id" "$SHADER_SHORTIX/$game_name"
            find -L $SHADER_SHORTIX -maxdepth 1 -type l -delete
        done < $TEMPFILE
    fi

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
