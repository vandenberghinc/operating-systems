#!/bin/bash

# source: 
# - https://www.kali.org/docs/usb/dojo-kali-linux-usb-persistence-encryption/
# - https://www.kali.org/docs/usb/kali-linux-live-usb-persistence/

documentation=$(cat <<-END 
Usage: ./format.sh <options> 
Description: Automatically format raspberry pi os.
Warning: This script will wipe the specified external sd card.
ISO can be downloaded with: [$ curl -O https://cdimage.kali.org/kali-2020.3/kali-linux-2020.> 
Options:
        img=string : Specify the path to the raspberry pi image.
        disk=string : Specify the path to the disk (do not include the partition number).
        headless=boolean : Specify the headless option (default is false).
Example: ./format.sh iso=/home/administrator/Downloads/raspberry.img disk=/dev/sdb
END
)

# get parameters.
IMG=""
DISK="" # example: (/dev/sda) do not include partition number.
HEADLESS="false"
for value in "$@" # You want to use "$@" here, not "$*" !!!!!
do
    :
    if [[ "$value" == *"img="* ]]; then
          IMG=$(echo "${value/img=/}" )
        elif [[ "$value" == *"disk="* ]]; then
          DISK=$(echo "${value/disk=/}" )
        elif [[ "$value" == *"headless="* ]]; then
          HEADLESS=$(echo "${value/headless=/}" )
	elif [[ "$value" == "--help" ]] || [[ "$value" == "-h" ]]; then
          echo "$documentation"
          exit 1
        fi
done

# check parameters.
if [[ "$IMG" == "" ]]; then
        echo $documentation
        echo "Error: Invalid usage."
        echo "Define argument: img=<string> (example: img=/home/administrator/Path/To/kali.iso)"
        exit 1
elif [[ "$DISK" == "" ]]; then
        echo $documentation
        echo "Error: Invalid usage."
        echo "Define argument: disk=<string> (example: disk=/dev/sdb)"
	exit 1
fi

# format drive.
echo "Writing the Raspberry image to disk [$DISK]..."
sudo dd if=$IMG of=$DISK bs=2M

# headless.
if [[ "$HEADLESS" == "true" ]] ; then
	echo "Starting headless configuration..."
fi

# response.
echo "The formatting has completed."

