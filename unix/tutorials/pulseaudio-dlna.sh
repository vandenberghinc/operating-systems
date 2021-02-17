# Stream the audio output to a dlna enabled device.
# source: https://www.ubuntu-user.com/Magazine/Archive/2015/27/Redirect-Linux-sound-to-DLNA-receivers-using-PulseAudio

# WARNING:
#	OLD REPO, DO NOT USE THIS REPO'S

# Installation:
sudo apt-add-repository -y ppa:qos/pulseaudio-dlna
sudo apt-get -y update
sudo apt-get -y install pulseaudio-dlna pavucontrol

# Setup information:
pulseaudio-dlna

# Now you should be able to forward sound to the dlna devices.