#!/bin/bash

# env variable

# Default Branch for Orangefox
export FOX_BRANCH="fox_12.1"
export ARGS_EXTRA=""

# Device Tree
export DT_LINK="https://github.com/NFS-Project/ofx_device_xiaomi_rosy"
export DT_BRANCH="fox_12.1"

export DEVICE="rosy"
export OEM="xiaomi"

# Build Target
## "recoveryimage" - for A-Only Devices without using Vendor Boot
## "bootimage" - for A/B devices without recovery partition (and without vendor boot)
## "vendorbootimage" - for devices Using vendor boot for the recovery ramdisk (Usually for devices shipped with Android 12 or higher)
export TARGET="recoveryimage"

export OUTPUT="OrangeFox*.zip"

# Kernel Source
# Uncomment the next line if you want to clone a kernel source.
#export KERNEL_SOURCE="https://github.com/NFS-Project/android_kernel_xiaomi_rosy"
#export KERNEL_BRANCH="thirteen"

# Extra Command
export EXTRA_CMD1="git clone https://github.com/OrangeFoxRecovery/Avatar.git misc"
export EXTRA_CMD2="git clone --depth=1 https://github.com/TeamWin/android_device_xiaomi_mithorium-common -b android-12.1 device/xiaomi/mithorium-common"
export EXTRA_CMD3=""
export EXTRA_CMD4=""
export EXTRA_CMD5=""

# Magisk
## Use the Latest Release of Magisk for the OrangeFox addon
OF_USE_LATEST_MAGISK=true

# Not Recommended to Change
export SYNC_PATH="$HOME/work" # Full (absolute) path.
export USE_CCACHE=1
export CCACHE_SIZE="50G"
export CCACHE_DIR="$HOME/work/.ccache"
export J_VAL=8

if [ ! -z "$PLATFORM" ]; then
    export KERNEL_PATH="kernel/$OEM/$PLATFORM"
else
    export KERNEL_PATH="kernel/$OEM/$DEVICE"
fi
export DT_PATH="device/$OEM/$DEVICE"
