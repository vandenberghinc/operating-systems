#!/bin/bash

# source: 
# - https://www.kali.org/docs/usb/dojo-kali-linux-usb-persistence-encryption/
# - https://www.kali.org/docs/usb/kali-linux-live-usb-persistence/

# check balena installation.
if [ ! -d "/etc/balena-cli" ] ; then
	echo "Installing Balena-CLI ..."
	export VERSION='v9.12.0'
	export FILENAME="balena-cli-$VERSION-linux-x64"
	export URL="https://github.com/balena-io/balena-cli/releases/download/$VERSION/$FILENAME.zip"
	sudo apt -y update
	sudo apt -y install httpie unzip
	cd $HOME
	http --download $URL
	unzip $FILENAME.zip
	sudo rm -fr /usr/local/bin/balena
	sudo rm -fr /etc/balena-cli
	sudo cp -r $HOME/balena-cli /etc/balena-cli
	rm -fr $HOME/balena-cli
	sudo ln -s /etc/balena-cli/balena /usr/local/bin/balena
fi

documentation="""

	Description: \n
		Automatically format, installing & encrypt kali linux live persistance on the specified external hard drive. \n
		Warning: This script will wipe the specified external hard drive. \n
		\n 
	Information: \n
		ISO can be downloaded with: [$ curl -O https://cdimage.kali.org/kali-2020.3/kali-linux-2020.3-live-amd64.iso && mv kali-linux-2020.3-live-amd64.iso Downloads/kali.iso] \n
		OS: Linux. \n
		\n
	Troubleshooting: \n
		- Make sure the disk is not mounted at any point. \n
		- Make sure you have closed all luks mounts. \n
		- Check [$ ls /dev/mapper], if there are any [luks-..] directories present unmount them with [$ sudo cryptsetup luksClose luks-.....]. \n
		\n
	Usage: \n 
		$ ./format.sh <options> \n
		\n
	Options: \n
		--kali-iso=string : Specify the path to the kali iso. \n
		--disk=string : Specify the path to the disk (do not include the partition number). \n
		--size=integer : Specify the size (in GB) of the total disk volume. \n
		--flash=boolean : Enable/disable the flashing of the kali iso to the disk (default is true). \n
	Examples: \n
		$ sudo ./format.sh --kali-iso=Downloads/kali.iso --disk=/dev/sdb --size=16 --flash true \n

"""

# get parameters.
KALI_ISO=""
DISK="" # example: (/dev/sda) do not include partition number.
SIZE="" # exmaple: 10  (in gb).
FLASH="false"
for value in "$@" # You want to use "$@" here, not "$*" !!!!!
do
    :
    if [[ "$value" == *"--kali-iso="* ]]; then
	  KALI_ISO=$(echo "${value/--kali-iso=/}" )
	elif [[ "$value" == *"--size="* ]]; then
	  SIZE=$(echo "${value/--size=/}" )
	elif [[ "$value" == *"--disk="* ]]; then
	  DISK=$(echo "${value/--disk=/}" )
	elif [[ "$value" == *"--flash="* ]]; then
	  FLASH=$(echo "${value/--flash=/}" )
	elif [[ "$value" == "--help" ]] || [[ "$value" == "-h" ]]; then
	  echo $documentation
	  exit 1
	fi
done

# check parameters.
if [[ "$KALI_ISO" == "" ]]; then
	echo $documentation
	echo "Error: Invalid usage."
	echo "Define argument: kali-iso=<string> (example: kali-iso=Path/To/kali.iso)"
	exit 1
elif [[ "$DISK" == "" ]]; then
	echo $documentation
	echo "Error: Invalid usage."
	echo "Define argument: disk=<string> (example: disk=/dev/sdb)"
	exit 1
elif [[ "$SIZE" == "" ]]; then
	echo $documentation
	echo "Error: Invalid usage."
	echo "Define argument: size=<integer> (example: size=8) (in gb)"
	exit 1
fi

# must be executed as super user.
if [ "$EUID" -ne 0 ] ; then
	echo "Error: this script must be executed with root permissions."
  	exit
fi

# format drive.
if [[ "$FLASH" == "true" ]]; then
	echo "Writing the Kali Linux image to disk [$DISK]..."
	#dd if=$KALI_ISO of=$DISK bs=4M
	balena local flash $KALI_ISO --drive $DISK --yes
fi

# create partition.
echo "Creating the persistance partition..."
#sudo parted $DISK mkpart primary 4000 $PERSISTANCE_SIZE"000"
end=$SIZE"GiB"
read start _ < <(du -bcm $KALI_ISO | tail -1); echo $start
parted $DISK mkpart primary ${start}MiB $end

# ecnrypt the parition with LUKS.
echo "Create a passphrase for the encrypted persistance partition."
cryptsetup -q --verbose --verify-passphrase luksFormat $DISK'3'
echo ""
echo "Enter the passphrase you just created."
cryptsetup luksOpen $DISK"3" my_usb

# create ex3 file system.
mkfs.ext3 -L persistence /dev/mapper/my_usb
e2label /dev/mapper/my_usb persistance

# mount the partition.
mkdir -p /mnt/my_usb
mount /dev/mapper/my_usb /mnt/my_usb
chown $USER /mnt/my_usb
echo "/ union" > /mnt/my_usb/persistance.conf
umount /dev/mapper/my_usb
cryptsetup luksClose /dev/mapper/my_usb

echo "The installation has finished."
echo "Select the encrypted live persistance option when booting into kali linux."
echo "Unlocking an encrypted LUKS volume."
echo "1. Unlock encryption: [$ sudo cryptsetup luksOpen "$DISK"3 my_usb ]"
echo "2. Mount: [$ sudo mount /dev/mapper/my_usb /mnt/my_usb ]"
echo "3. Unmount: [$ sudo umount /dev/mapper/my_usb ]"
echo "4. Lock encryption: [$ sudo cryptsetup luksClose /dev/mapper/my_usb ]"
