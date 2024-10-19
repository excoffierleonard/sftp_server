#!/bin/bash

# Function to generate a random password
generate_random_password() {
    openssl rand -base64 16
}

# Check if the environment variable for the password is set
if [ -z "$SFTP_USER_PASSWORD" ]; then
    echo "SFTP_USER_PASSWORD not set. Generating a random password."
    SFTP_USER_PASSWORD=$(generate_random_password)
    echo "Generated password: $SFTP_USER_PASSWORD"
fi

# Set the password for the sftpuser
echo "sftp_user:$SFTP_USER_PASSWORD" | chpasswd

# Start the SSH server
exec /usr/sbin/sshd -D