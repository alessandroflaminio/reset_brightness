#!/bin/sh

MAC_UUID=$(system_profiler SPHardwareDataType | awk '/UUID/ { print $3; }')
WORKDIR=~/brightness_reset
PLIST_DIR=/var/db/hidd/Library/Preferences/ByHost

mkdir $WORKDIR
mkdir $WORKDIR/backup

# Deletes any previous file (except the backup ones)
sudo rm -f $WORKDIR/*.plist

# Places a backup copy of the .plist file in ~/brightness_reset/backup. If a backup file already exists,
# appends the .old prefix to the older backup file
sudo install -b $PLIST_DIR/com.apple.iokit.AmbientLightSensor.$MAC_UUID.plist $WORKDIR/backup

cd $WORKDIR
sudo cp backup/com.apple.iokit.AmbientLightSensor.$MAC_UUID.plist .
sudo defaults delete $WORKDIR/com.apple.iokit.AmbientLightSensor.$MAC_UUID.plist

# Appends to the old .plist the suffix .old and copies the new .plist
sudo install -b -m 600 -o _hidd $WORKDIR/com.apple.iokit.AmbientLightSensor.$MAC_UUID.plist $PLIST_DIR

echo "You may now reboot the Mac for changes to be applied."