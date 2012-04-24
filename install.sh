#!/bin/sh

set -e
set -u


PROCESS=stackoverflowfanatic.modocache.github
PLIST="$PROCESS".plist
LAUNCHD_DIR=~/Library/LaunchAgents
SCRIPT_PATH=~/.fanatic
SCRIPT_NAME=open_stackoverflow.sh

pushd $(dirname "${0}") > /dev/null
BASE_DIR=$(pwd -L)
popd > /dev/null

cd "${BASE_DIR}"

mkdir -p "$SCRIPT_PATH"
cp "$SCRIPT_NAME" "$SCRIPT_PATH"
SCRIPT_ABSPATH=`echo "$SCRIPT_PATH"/"$SCRIPT_NAME" | sed -e "s#\/#\\\\\/#g"`
echo "Created $SCRIPT_PATH/$SCRIPT_NAME"


cp "$PLIST.template" "$PLIST"
sed "s#PROGRAM_PATH#$SCRIPT_ABSPATH#g" "$PLIST.template" > "$PLIST"
mv "$PLIST" "$LAUNCHD_DIR"
echo "Created $LAUNCHD_DIR/$PLIST"


launchctl unload "$LAUNCHD_DIR/$PLIST"
launchctl load "$LAUNCHD_DIR/$PLIST"
launchctl stop "$PROCESS"
launchctl start "$PROCESS"
echo "`date`: launchctl start $PROCESS"
echo "Will continue to launch process every 24 hours."

exit
