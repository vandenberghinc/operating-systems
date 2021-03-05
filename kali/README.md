# Kali Linux
Author(s):  Daan van den Bergh<br>
Copyright:  © 2020-2030 Daan van den Bergh All Rights Reserved<br>
<br>
<br>
<p align="center">
  <img src="https://raw.githubusercontent.com/vandenberghinc/public-storage/master/vandenberghinc/icon/icon.png" alt="Bergh-Encryption" width="50"/>
</p>


# Formatting an encrypted hard drive:
BUG:
	- use BalenaEtcher to flash kali iso to the disk.
	- set option: [flash=false] to disable the kali iso flashing.
Assuming:
1. The kali linux iso is located at: Downloads/kali.iso.
2. The external disk path is /dev/sdb.
3. The external disk path size is 930GB.

####

	git clone -q https://github.com/vandenberghinc/OperatingSystems.git
	cd OperatingSystems/KaliLinux/
	chmod 755 format.sh
	./format.sh kali-iso=Downloads/kali.iso disk=/dev/sdb size=900000


# Post-Installation:
The post installation script (run this script when logged into kali linux):

	git clone -q https://github.com/vandenberghinc/OperatingSystems.git
	cd OperatingSystems/KaliLinux/
	chmod 755 installation.sh
	./installation.sh
