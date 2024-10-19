FROM debian:latest

# Install OpenSSH server
RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get clean

# Create the necessary directory for privilege separation
RUN mkdir -p /run/sshd

# Create sftpuser and set a password
RUN useradd -m sftpuser && \
    echo "sftpuser:password" | chpasswd

# Create a directory inside /mnt for the sftpuser
RUN mkdir -p /mnt/sftp_server && \
    chown sftpuser:sftpuser /mnt/sftp_server && \
    chmod 700 /mnt/sftp_server

# Update sshd_config to allow only SFTP
RUN echo "Match User sftpuser" >> /etc/ssh/sshd_config && \
    echo "    ForceCommand internal-sftp" >> /etc/ssh/sshd_config && \
    echo "    ChrootDirectory /mnt" >> /etc/ssh/sshd_config && \
    echo "    PermitTunnel no" >> /etc/ssh/sshd_config && \
    echo "    AllowAgentForwarding no" >> /etc/ssh/sshd_config && \
    echo "    AllowTcpForwarding no" >> /etc/ssh/sshd_config && \
    echo "    X11Forwarding no" >> /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Command to run the SSH server
CMD ["/usr/sbin/sshd", "-D"]