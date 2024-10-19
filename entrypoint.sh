#!/bin/bash

# Check if the environment variable for the password is set
if [ -z "$SFTP_USER_PASSWORD" ]; then
    echo "Error: SFTP_USER_PASSWORD environment variable not set."
    exit 1
fi

# Set the password for the sftpuser
echo "sftp_user:$SFTP_USER_PASSWORD" | chpasswd

# Start the SSH server
exec /usr/sbin/sshd -D