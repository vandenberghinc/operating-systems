# Used to start background jobs through SSG
# source : https://askubuntu.com/questions/139139/how-do-you-background-a-ssh-process
process_name=$1

# SSH into the remote server.
# ssh <username>@<host>

# Start the screen process.
screen -S $process_name
startmyprocess
echo "Escape character: CNTRL+A"

# List sessions.
screen -ls

# Reconnect with the session.
screen -r $process_name	