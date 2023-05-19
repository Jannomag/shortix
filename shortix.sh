#!/bin/bash
#Set variables for all needed files an paths
PROTONTRICKS="flatpak run com.github.Matoking.protontricks"
SHORTIX_DIR=/home/deck/Shortix
TEMPFILE=/tmp/shortix
COMPDATA=/home/deck/.steam/steam/steamapps/compatdata

TIME=15

#Run the script if there's at least one directory newer than TIME variable (minutes).
if [ $(find $COMPDATA -mmin -$TIME -type d) ]; then

    #Run protontricks to list all installed games and write the result into the temp file
    eval "$PROTONTRICKS" -l > $TEMPFILE

    #remove all lines which doesn't have a round bracket in it
    sed -i -ne '/)/p' $TEMPFILE

    #Remove the "Non_Steam shortcut: " string from temp file
    sed -i 's/Non-Steam shortcut: //' $TEMPFILE

    #Replace the opening round bracket with a simicolon in temp file - this is needed to reading the contents as variable later on
    sed -i 's/ (/;/' $TEMPFILE

    #Do the same with the closing round bracket
    sed -i 's/)/;/' $TEMPFILE

    #Remove non existant symlinks
    find -L $SHORTIX_DIR -maxdepth 1 -type l -delete

    #Create symlinks based on the data from the temp file.
    #IFS defines the semicolon as column separator
    #Then read the both columns as variables and create symlinks based on the data of each line
    while IFS=';' read game_name prefix_id
    do
        ln -sf "$COMPDATA/$prefix_id" "$SHORTIX_DIR/$game_name"
    done < $TEMPFILE
fi
