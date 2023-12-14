#!/bin/bash
app_name="Jamf Student"
app_path="/Applications/$app_name.app"

if [ -e "$app_path" ];then
	# echo $app_path
	osascript << EOF
	tell application "System Events" to display dialog "Inserire le proprie credenziali Google nella App $app_name. (Cliccare OK per continuare)" with title "Avviso" buttons {"OK"} default button 1 with icon POSIX file "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Accounts.icns"
EOF
	# sleep 3
    open -a "$app_path"  # Apri l'applicazione se presente
else
	# Notifica l'utente con un messaggio di avviso
	echo $app_path
	osascript << EOF
tell application "System Events" to display dialog "L'applicazione $app_name non è installata." with title "Avviso" buttons {"OK"} default button 1 with icon POSIX file "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertStopIcon.icns"
EOF
fi

