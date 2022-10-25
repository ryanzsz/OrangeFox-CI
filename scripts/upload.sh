#!/bin/bash

# Source Vars
source $CONFIG

# Change to the Source Directory
cd $SYNC_PATH

# Change to the Output Directory
cd out/target/product/${DEVICE}

DATE_L=$(date +%d\ %B\ %Y)
DATE_S=$(date +"%T")

# Color
ORANGE='\033[0;33m'

# Set FILENAME var
FILENAME=$(echo $OUTPUT)

# A Function to Send Posts to Telegram
telegram_message() {
	curl -v "https://api.telegram.org/bot""$TG_TOKEN""/sendPhoto?chat_id=""$TG_CHAT_ID""$ARGS_EXTRA" -H 'Content-Type: multipart/form-data' \
	-F photo=@"${CIRRUS_WORKING_DIR}/logo/OrangeFox.jpg" \
	-F "parse_mode=html" \
	-F caption="$1"
}

# Display a message
echo "============================"
echo "Uploading the Build..."
echo "============================"

# Upload to Google Drive
rclone copy --drive-chunk-size 256M --stats 1s $FILENAME NFS:recovery/$DEVICE -P || { echo "ERROR: Failed to Upload the Build!" && exit 1; }

DL_LINK=https://nfs.projek.workers.dev/0:/recovery/$DEVICE/$FILENAME

# Show the Download Link
echo "=============================================="
echo "Download Link: ${DL_LINK}" || { echo "ERROR: Failed to Upload the Build!"; }
echo "=============================================="

# Send the Message on Telegram
echo -e \
"
🦊 <b>OrangeFox Recovery CI</b>
==========================
✅ <b>Build Completed Successfully</b>

📱 <b>Device:</b> "${DEVICE}"
🖥 <b>Branch Build:</b> "${FOX_BRANCH}"
📂 <b>Size:</b> "$(ls -lh $FILENAME | cut -d ' ' -f5)"
📥 <b>Download Link:</b> <a href=\"${DL_LINK}\">Here</a>
📅 <b>Date:</b> "${date +%d\ %B\ %Y}"
⏰ <b>Time:</b> "${date +"%T"}"
==========================
" > tg.html

TG_TEXT=$(< tg.html)
telegram_message "$TG_TEXT"

cd $WORKDIR
com ()
{
  tar --use-compress-program="pigz -k -$2 " -cf $1.tar.gz $1
}
time com ccache 1
rclone copy --drive-chunk-size 256M --stats 1s ccache.tar.gz NFS:recovery/ccache/$DEVICE -P
rm -rf ccache.tar.gz

echo " "

# Exit
exit 0
