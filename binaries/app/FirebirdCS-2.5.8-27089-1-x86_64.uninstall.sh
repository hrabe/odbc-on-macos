#!/bin/sh
echo "Clean Services"
echo "Clean User"
dscl localhost -delete /Local/Default/Users/firebird
echo "Clean Group"
dscl localhost -delete /Local/Default/Groups/firebird
if [ -f "/Library/StartupItems/Firebird" ]; then
echo "Remove SuperServer StartupItem"
rm -fr /Library/StartupItems/Firebird
fi
if [ -f "/Library/LaunchDaemons/org.firebird.gds.plist" ]; then
echo "Remove Launchd"
launchctl unload /Library/LaunchDaemons/org.firebird.gds.plist
rm /Library/LaunchDaemons/org.firebird.gds.plist
fi
echo "Remove Framework"
rm -fr /Library/Frameworks/Firebird.framework
echo "Remove Receipt"
rm -fr /Library/Receipts/Firebird*.pkg
