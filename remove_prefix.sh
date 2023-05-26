#!/bin/bash

SHORTIX_DIR=$HOME/Shortix

echo "##########################"
echo "# Shortix prefix remover #"
echo "##########################"

echo "Drag & Drop the shortcut(s) to the prefix(es) you want to remove and press enter."
echo "(Do not drag&drop/paste/type text)"
IFS="" read -r input
eval "files=( $input )"

echo "This are your desired prefixes:"
for file in "${files[@]}"
do
  echo -n $file
  echo -n " : "
  readlink -f "$file"
done
while true; do
echo -e "Do you really want to delete them? [y/n] \n PLEASE NOTE: This will remove ALL prefix data including savegames COMPLETELY!"
read -p "" yn
  case $yn in
      yes|y|Y )
          echo "Removing...";
          for file in "${files[@]}"
          do
            rm -r "$(readlink -f "$file")"
            rm -r "$file"
          done
          read -p "Done. You can close this window now.";
          exit;;
      no|n|N ) echo "Okay, nothing  deleted! You can close this window now.";
          exit 1;;
      * ) echo "invalid input, chosse y or n" >&2;

  esac
done

