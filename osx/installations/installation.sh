
# settings,
user=$(echo $USER)
# developer tools.
sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install

# homebrew.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# sublime text 3.
brew install --cask sublime-text
if [[ ! -d "/usr/local/bin/" ]] ; then
	sudo mkdir /usr/local/bin/
	sudo chown -R $user:staff /usr/local/bin/
	sudo chmod -R 770 /usr/local/bin/
fi
if [[ ! -d "/usr/local/lib/" ]] ; then
	sudo mkdir /usr/local/lib/
	sudo chown -R $user:staff /usr/local/lib/
	sudo chmod -R 770 /usr/local/lib/
fi
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime

# basic.
brew install --cask osxfuse
brew install python3
brew install openssh
brew install sshfs
brew install dlib
brew install cmake
brew install portaudio

# osxfuse & ext4 support.
brew install --cask osxfuse
brew install ext4fuse

# ccxt.
brew uninstall --ignore-dependencies c-ares
pip3 install ccxt

# nmap.
brew install nmap

# tor.
brew install tor torbrowser

# spotify.
brew install spotify

# firefox.
brew install firefox

# balena etcher.
brew install balenaetcher

# opensc.
brew install opensc yubico-piv-tool ykman

# metasploit.
brew install --cask metasploit

# vandenberghinc.
pip3 install netw0rk --upgrade && python3 -c "import netw0rk" --create-alias --sudo
pip3 install ssht00ls --upgrade && python3 -c "import ssht00ls" --create-alias --sudo
pip3 install syst3m --upgrade && python3 -c "import syst3m" --create-alias --sudo
pip3 install encrypti0n --upgrade && python3 -c "import encrypti0n" --create-alias --sudo