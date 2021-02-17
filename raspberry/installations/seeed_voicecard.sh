
# Seeed Voicecard for 6-Mic ReSpeaker array.
sudo apt-ge --assume-yes update
sudo apt-get --assume-yes upgrade
cd ~
git clone https://github.com/respeaker/seeed-voicecard.git
cd seeed-voicecard
sudo ./install.sh  --compat-kernel 

# Pulseaudio config: Irrelivant
sudo apt --assume-yes install pulseaudio
cd ~/seeed-voicecard/pulseaudio/
sudo cp pulse_config_6mic/seeed-voicecard.conf /usr/share/pulseaudio/alsa-mixer/profile-sets/seeed-voicecard-8mic.conf
sudo cp 91-seeedvoicecard.rules /etc/udev/rules.d/91-seeedvoicecard.rules
sudo cp pulse_config_6mic/default.pa /etc/pulse/
sudo cp pulse_config_6mic/daemon.conf /etc/pulse/

# Pixel ring:
cd ~
git clone --depth 1 https://github.com/respeaker/pixel_ring.git
cd pixel_ring
pip install -U -e .
sudo pip install -U -e .

# Completion:
echo "Installation completed."
echo "Test the LED ring with: [$ python3 examples/respeaker_4mic_array.py]."
#echo "Start the pusle audio server on boot up with: [$ pulseaudio --start ]"
#echo "Get pulseaudio info with: [$ pactl info ]"
echo "Manually reboot for the changes to take effect: [$ sudo reboot]."