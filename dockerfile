FROM debian:stable-slim

# Set the envs
ENV SFTP_USER_PASSWORD=""

# Install OpenSSH server
RUN apt update && \
    apt install -y openssh-server openssl && \
    apt clean

# Create the necessary directory for privilege separation
RUN mkdir -p /run/sshd

# Create sftp_user without password
RUN useradd -m sftp_user

# Set the appropriate permission for /mnt/sftp_server
RUN mkdir -p /mnt/sftp_server && \
    chown sftp_user:sftp_user /mnt/sftp_server && \
    chmod 700 /mnt/sftp_server

# Update sshd_config to allow only SFTP
RUN echo "Match User sftp_user" >> /etc/ssh/sshd_config && \
    echo "    ForceCommand internal-sftp" >> /etc/ssh/sshd_config && \
    echo "    ChrootDirectory /mnt" >> /etc/ssh/sshd_config && \
    echo "    PermitTunnel no" >> /etc/ssh/sshd_config && \
    echo "    AllowAgentForwarding no" >> /etc/ssh/sshd_config && \
    echo "    AllowTcpForwarding no" >> /etc/ssh/sshd_config && \
    echo "    X11Forwarding no" >> /etc/ssh/sshd_config

# Add a script to set the password and start the SSH service
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the volume
VOLUME /mnt/sftp_server

# Expose SSH port
EXPOSE 22

# Command to run the SSH server with password setting
CMD ["/usr/local/bin/entrypoint.sh"]