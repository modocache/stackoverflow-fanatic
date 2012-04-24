#!/bin/sh

set -e
set -u


PROCESS=stackoverflowfanatic.modocache.github
PLIST="$PROCESS".plist
LAUNCHD_DIR=~/Library/LaunchAgents
SCRIPT_PATH=~/.fanatic
SCRIPT_NAME=OpenStackOverflow.scpt


mkdir -p "$SCRIPT_PATH"
cp "$SCRIPT_NAME" "$SCRIPT_PATH"

cp "$PLIST.template" "$PLIST"

SCRIPT_ABSPATH=`echo "$SCRIPT_PATH"/"$SCRIPT_NAME" | sed -e "s#\/#\\\\\/#g"`
sed "s#PROGRAM_PATH#$SCRIPT_ABSPATH#g" "$PLIST.template" > "$PLIST"
mv "$PLIST" "$LAUNCHD_DIR"

launchctl unload "$LAUNCHD_DIR/$PLIST"
launchctl load "$LAUNCHD_DIR/$PLIST"
launchctl stop "$PROCESS"
launchctl start "$PROCESS"


exit
