echo "Installing Kali Linux."

# Edit password.
clear && echo "Create a new password for user: root"
sudo passwd root
echo "Create a new password for user: kali"
sudo passwd kali

# System Update.
sudo apt-get update && sudo apt-get upgrade && sudo apt-get -y dist-upgrade

# Default.
sudo apt-get install git
sudo apt --assume-yes install members screen curl
sudo apt-get --assume-yes install tmux

# Install network tools.
echo "Installing network tools..."
sudo apt --assume-yes install net-tools
sudo apt-get --assume-yes install sshfs

# Bluetooth.
sudo apt-get -y install bluetooth bluez bluez-tools rfkill
rfkill list
rfkill unblock bluetooth
service bluetooth start
sudo apt-get -y install blueman

# Install SSH.
echo "Installing OpenSSH..."
sudo apt-get -y install openssh-server

# Enable SSH.
sudo ufw allow ssh
chmod 700 .ssh
touch .ssh/authorized_keys 
chmod 600 .ssh/authorized_keys
touch .ssh/config 
chmod 644 .ssh/config 
touch .ssh/known_hosts 
chmod 644 .ssh/known_hosts 

# Change SSH default keys.
update-rc.d -f ssh remove
update-rc.d -f ssh defaults
mkdir /etc/ssh/insecure_old
mv /etc/ssh/ssh_host* insecure_old
dpkg-reconfigure openssh-server
sudo service ssh restart
update-rc.d -f ssh enable 2 3 4 5
# sudo service ssh status
# sudo service ssh start

# Make home dir not writeable to others.
chmod go-w /home/$USE

# Sublime Text:
echo "Installing Sublime Text..."
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
sudo apt -y install sublime-text
echo "Finished installing Sublime Text."
echo "Open the sublime editor with command $ subl /path/to/file"

# Installing Python
echo "Installing python..."
sudo apt-get upgrade python3
sudo apt-get -y install libjpeg-dev zlib1g-dev
sudo apt-get --assume-yes install build-essential cmake pkg-config
sudo apt-get --assume-yes install libx11-dev libatlas-base-dev
sudo apt-get --assume-yes install libgtk-3-dev libboost-python-dev
sudo apt-get --assume-yes install python-dev python-pip python3-dev python3-pip
sudo apt-get --assume-yes install python3-venv
sudo apt-get  --assume-yes install python3-setuptools
sudo apt install --assume-yes python3-pip
sudo -H pip3 install -U pip numpy

# Yubico Manager (Smart Cards)
sudo apt-add-repository --assume-yes ppa:yubico/stable
sudo apt --assume-yes install yubikey-manager
sudo apt-get --assume-yes install -y yubico-piv-tool

# Installing Hack tools:
sudo apt -y install aircrack-ng
sudo apt -y install reaver

# Completion:
echo "Installation completed."
