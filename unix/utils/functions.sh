
# operating system.
function os-info() {
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            return "linux"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            return "macos"
        elif [[ "$OSTYPE" == "cygwin" ]]; then
           return "posix"     # POSIX compatibility layer and Linux environment emulation for Windows
        elif [[ "$OSTYPE" == "msys" ]]; then
            return "mysys"    # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
        elif [[ "$OSTYPE" == "win32" ]]; then
            return "win32"    # I'm not sure this can happen.
        elif [[ "$OSTYPE" == "freebsd"* ]]; then
            return "freebsd"    # ...
        else
            return "unknown"    # Unknown.
        fi
}

# Creating zips:
function create-back-up() {
	timestamp=$(date +%d-%m-%y) 
	cd ~
	zip -r Downloads/GitHub.zip /Volumes/GitHub -x /Volumes/GitHub/PokerAI/\*
	scp Downloads/GitHub.zip "nas-system:Backups/GitHub/GitHub-"$timestamp".zip"
}

# HFS+ Drives:
function mount-hfs() {
        drive=$1
        mount_point=$2
        if [ ! -d "$mount_point" ]; then
                sudo mkdir $mount_point
        fi
        sudo mount -t hfsplus -o force,rw $drive $mount_point
}
function check-hfs() {
        drive=$1
        sudo fsck.hfsplus -f $drive
}
function remount-hfs() {
        mount_point=$1
        sudo mount -t hfsplus -o remount,force,rw $mount_point
}
function format-hfs() {
        drive=$1
        sudo mkfs.hfsplus $drive

}

# EXT4 Drives:
function erase-drive() {
        # sourcce: https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux
        drive=$1 # drive without partition number!
        read -p "Warning! You are erasing drive ["$drive"], do you wish to proceed? (y/n): " -n 1 -r
        echo    # (optional) move to a new line
        if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
            echo "Aborted."
        else
            echo "Formatting drive [$drive]..."
            sudo dd if=/dev/zero of=$drive bs=4M
            echo "Finished formatting drive [$drive]."
            echo "Create a new ext4 partition with the following command:"
            echo "$ partition-ext4 $drive"
            echo "Format the new ext4 partition with the following command:"
            echo "$ format-ext4 "$drive"1 MyVolume"
            echo "Mount the newly formatted ext4 partition with the following command:"
            echo "$ mount-ext4 "$drive"1 /media/"$USER"/MyVolume"
        fi
}
function partition-ext4() {
        # sourcce: https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux
        drive=$1 # drive without partition number!
        sudo parted $drive mklabel gpt # partition drive.
        sudo parted -a opt $drive mkpart primary ext4 0% 100% # create partition.
        echo "Check if the newly created partition exists."
        echo "$ lsblk"
}
function format-ext4() {
        drive=$1 # drive must contain partition number!
        label=$2 # the comment label.
        sudo mkfs.ext4 -L datapartition $drive
        sudo e2label $drive $label
        echo "Check if the formatting was successful."
        echo "$ sudo lsblk --fs"
}
function mount-ext4() {
        drive=$1 # drive must contain partition number!
        mount_point=$2
        if [ ! -d "$mount_point" ]; then
                sudo mkdir $mount_point
        fi
        sudo mount -o defaults,rw $drive $mount_point
        sudo chown $USER:root $mount_point
        sudo chmod 700 $mount_point
        echo "Check if the mount was successful."
        echo "$ sudo ls "$mount_point
}


