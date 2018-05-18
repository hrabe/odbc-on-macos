#!/bin/sh
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
echo "Unattended install of: $1"
sudo installer -allowUntrusted -verboseR -pkg "$SCRIPTPATH/$1"
echo "Stop and prevent Launchd"
sudo launchctl unload -w /Library/LaunchDaemons/org.firebird.gds.plist
