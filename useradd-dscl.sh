#Creates 'user' user
dscl . -create /Users/user
dscl . -create /Users/user UserShell /bin/bash
dscl . -create /Users/user RealName "user" 
dscl . -create /Users/user UniqueID "401"
dscl . -create /Users/user PrimaryGroupID 20
dscl . -create /Users/user NFSHomeDirectory /Users/user
dscl . -passwd /Users/user mypassword

#Creates home folder
mkdir /Users/user
chown -R user /Users/user

#Makes 'user' a local admin
# dscl . -append /Groups/admin GroupMembership user

#Hide user
# defaults write /Library/Preferences/com.apple.loginwindow Hide500Users -bool YES

#Gives SSH access to 'user'
# dseditgroup -o edit -n /Local/Default -u ExistingAdminAccount -P ExistingAdminPassword -a user -t user com.apple.access_ssh