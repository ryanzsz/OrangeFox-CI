#!/bin/bash

# Source Configs
source $CONFIG

cd $WORKDIR
mkdir -p ~/.config/rclone
echo "$RCLONECONFIG_DRIVE" > ~/.config/rclone/rclone.conf
rclone copy --drive-chunk-size 256M --stats 1s NFS:recovery/ccache/$DEVICE/ccache.tar.gz $WORKDIR -P
tar xzf ccache.tar.gz
rm -rf ccache.tar.gz
