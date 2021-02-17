# Using SSH Keys:

## 1. Enable SSH
Go to: Control Panel (Advanced Mode) > Terminal & SNMP. <br>
Enable the option: "Enable SSH service". <br>
Leave the default port 22. <br>

## 2. Enable User Home
Go to: Control Panel > User > Advanced. <br>
Scroll all the way to the bottom. <br>
Enable the option: "Enable user home service". <br>

## 3. Login with SSH:
login from a client machine with the following command: (replace the user)
	
	ssh <your-username>@<server-ip-address>

## 4. Create SSH Directory:
execute the following script when logged in:

	mkdir ~/.ssh
	touch ~/.ssh/authorized_keys
	touch ~/.ssh/banner
	chmod 0711 ~
	chmod 0711 ~/.ssh
	chmod 0600 ~/.ssh/authorized_keys

## 5. Logout:
log out the interactive shell session with:

	exit

## 6. Client Side:
Create a key pair on the client machine & push it to the server (execute the following script on the client machine):

	ssh-keygen -t rsa -b 4096 -f /path/to/your/private_key -C "<your-username>@nas-system"
	ssh-copy-id -i /path/to/your/private_key <your-username>@<server-ip-address>

Try to log in from the client machine using the ssh key:

	ssh -i /path/to/your/private_key <your-username>@<server-ip-address>

When you get the prompt for the private key's passphrase, the key installation was succesfull.

## 7. Server Configuration:
Log back into the server & edit the server configuration:

	ssh -i /path/to/your/private_key <your-username>@<server-ip-address>
	sudo vim /etc/ssh/sshd_config

Press [i] to start editing. <br>
Edit the following lines:
	
	Edit 1:
		from:
			#PubkeyAuthentication no
			#AuthorizedKeysFile  .ssh/authorized_keys
		to:
			PubkeyAuthentication yes
			AuthorizedKeysFile  .ssh/authorized_keys
	Edit 2:
		from:
			PasswordAuthentication yes
			#PermitEmptyPasswords no
		to:
			PasswordAuthentication no
			PermitEmptyPasswords no

Press [escape] to stop editing. <br>
Press [:] & enter [wq] to write out and quit. <br>
Log out of the server with:
	
	exit

## 8. Test Succes:
Try to log in without a private key:
	
	ssh <your-username>@<server-ip-address>

You will receive the error message [Permission denied (publickey)] if the installation was succesfull. <br>
Do not lose the key and store the private key on an external USB / hard drive.

## Troubleshooting:
### Locked out of ssh:
Enable [telnet] <br>
Execute client side: 

	telnet <server-ip-address>

Press enter to skip pass <br>
Login with your username & password. <br>
now you can change the /etc/ssh/sshd_config file again. <br>
 <br>
source: https://silica.io/using-ssh-key-authentification-on-a-synology-nas-for-remote-rsync-backups/