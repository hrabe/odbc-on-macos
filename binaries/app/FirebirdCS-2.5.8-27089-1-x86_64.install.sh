#!/bin/sh
SCRIPTPATH=$(cd "$(dirname "$0")"; pwd)
echo "Unattended install of: $1"
installer -allowUntrusted -verboseR -pkg "$SCRIPTPATH/$1" -target /
echo "Stop and prevent Launchd"
launchctl unload -w /Library/Frameworks/Firebird.framework/Versions/A/Resources/org.firebird.gds.plist

