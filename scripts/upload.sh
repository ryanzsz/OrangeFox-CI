#!/bin/bash

# Source Vars
source $CONFIG

# Change to the Source Directory
cd $SYNC_PATH

# Change to the Output Directory
cd out/target/product/${DEVICE}

DATE_L=$(date +%d\ %B\ %Y)
DATE_S=$(date +"%T")

# A Function to Send Posts to Telegram
telegram_message() {
	curl -v "https://api.telegram.org/bot""$TG_TOKEN""/sendPhoto?chat_id=""$TG_CHAT_ID""$ARGS_EXTRA" -H 'Content-Type: multipart/form-data' \
	-F photo=@"${CIRRUS_WORKING_DIR}/logo/OrangeFox.jpg" \
	-F "parse_mode=html" \
	-F caption="🦊 <b>OrangeFox Recovery CI</b>
==========================
✅ <b>Build Completed Successfully</b>

📱 <b>Device:</b> "${DEVICE}"
🖥 <b>Branch Build:</b> "${FOX_BRANCH}"
📂 <b>Size: "$(ls -lh $FILENAME | cut -d ' ' -f5)"</b>
📥 <b>Download Link:</b> <a href=\"${DL_LINK}\">Here</a>
📅 <b>Date:</b> "$(date +%d\ %B\ %Y)"
⏰ <b>Time:</b> "$(date +%T)"
=========================="
}

# Color
ORANGE='\033[0;33m'

# Display a message
echo "============================"
echo "Uploading the Build..."
echo "============================"

# Set FILENAME var
FILENAME=$(echo $OUTPUT)

# Upload to oshi.at
if [ -z "$TIMEOUT" ];then
    TIMEOUT=20160
fi

# Upload to WeTransfer
# NOTE: the current Docker Image, "registry.gitlab.com/sushrut1101/docker:latest", includes the 'transfer' binary by Default
transfer wet $FILENAME > link.txt || { echo "ERROR: Failed to Upload the Build!" && exit 1; }

# Mirror to oshi.at
curl -T $FILENAME https://oshi.at/${FILENAME}/${OUTPUT} > mirror.txt || { echo "WARNING: Failed to Mirror the Build!"; }

DL_LINK=$(cat link.txt | grep Download | cut -d\  -f3)
MIRROR_LINK=$(cat mirror.txt | grep Download | cut -d\  -f1)

# Show the Download Link
echo "=============================================="
echo "Download Link: ${DL_LINK}" || { echo "ERROR: Failed to Upload the Build!"; }
echo "Mirror: ${MIRROR_LINK}" || { echo "WARNING: Failed to Mirror the Build!"; }
echo "=============================================="

# Send the Message on Telegram
telegram_message

echo " "

# Exit
exit 0
