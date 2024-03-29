#!/bin/bash

GSETTINGS=$(which gsettings)
if [[ -z "$GSETTINGS" ]]
then
  echo gsettings not found.
  exit 1;
fi

if [[ $# -ne 1 ]]
then
  echo "Please set the image folder location."
  exit 1;
fi

IMAGES=("$1"/*)

# Check current image-index. If it doesn't exist, it will be initalized to 0 later.
CURRENT_BG_INDEX=0
if [[ -e image-index ]]
then
    CURRENT_BG_INDEX=$(cat image-index)
fi

# Go back to first file if reached the last one.
if [[ $(($CURRENT_BG_INDEX + 1)) -gt ${#IMAGES[@]} ]]
then
    CURRENT_BG_INDEX=0
fi

# Load Gnome session.
RUID=$(id -u -r)
PID=($(pgrep -u $RUID gnome-session))
# PID could potentially be more than one so any will do for now.
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/${PID[1]}/environ| tr '\0' '\n' | cut -d= -f2-)
RND_BG="${IMAGES[$CURRENT_BG_INDEX]}"

# Write latest current index to a temp file
echo $(($CURRENT_BG_INDEX+1)) > image-index

# As of Ubuntu 22.04, the following check must be applied.
PICTURE_URI=picture-uri
COLOR_SCHEME=$($GSETTINGS get org.gnome.desktop.interface color-scheme)
# The response to the above command is enclosed in single quotes.
if [[ $COLOR_SCHEME == "'prefer-dark'" ]]
then
  PICTURE_URI=picture-uri-dark
fi

# Get the current background for tracking.
CURRENT_BG=$($GSETTINGS get org.gnome.desktop.background $PICTURE_URI)
# If the same image was pulled randomly, skip it. Rotate it on the next schedule.
if [[ $CURRENT_BG != *"$RND_BG"* ]]
then
  /usr/bin/gsettings set org.gnome.desktop.background $PICTURE_URI "$RND_BG"
  echo Old background: "$CURRENT_BG"
  echo New background: "'$RND_BG'"
fi
