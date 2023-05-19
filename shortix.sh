#!/bin/sh
#Set variables for all needed files an paths
PROTONTRICKS="flatpak run com.github.Matoking.protontricks"
SHORTIX_DIR=/home/deck/Shortix
TEMPFILE=/tmp/shortix_temp
COMPDATA=/home/deck/.steam/steam/steamapps/compatdata
FIRSTRUN=/home/deck/Shortix/.shortix

TIME=15

#Run the script if there's at least one directory newer than TIME variable (minutes).

shortix_script () {
    #Run protontricks to list all installed games and write the result into the temp file
    eval "$PROTONTRICKS" -l > $TEMPFILE 2> /dev/null

    #remove all lines which doesn't have a round bracket in it
    sed -i -ne '/)/p' $TEMPFILE

    #Remove the "Non_Steam shortcut: " string from temp file
    sed -i 's/Non-Steam shortcut: //' $TEMPFILE

    #Replace the the last occurence of a closing round bracket with a simicolon in esch line in temp file - this is needed to reading the contents as variable later on
    sed -i 's/\(.*\))/\1;/' $TEMPFILE

    #Do the same with the last occurence of an opening round bracket
    sed -i 's/\(.*\)(/\1;/' $TEMPFILE
    
    #Remove the trailing space after the game name
    sed -i 's/ ;/;/' $TEMPFILE
    
    #Remove non existant symlinks
    find -L $SHORTIX_DIR -maxdepth 1 -type l -delete

    #Create symlinks based on the data from the temp file.
    #IFS defines the semicolon as column separator
    #Then read the both columns as variables and create symlinks based on the data of each line
    while IFS=';' read game_name prefix_id
    do
        ln -sf "$COMPDATA/$prefix_id" "$SHORTIX_DIR/$game_name"
    done < $TEMPFILE
}


if [ ! -f $FIRSTRUN ]; then
    shortix_script
    touch $FIRSTRUN
elif [ $(find $COMPDATA -mmin -$TIME -type d) ]; then
    shortix_script
fi
echo "Done, you can close this window now!"
