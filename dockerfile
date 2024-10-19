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

# Create a directory for SFTP files
RUN mkdir -p /home/sftpuser/uploads && \
    chown root:root /home/sftpuser && \
    chmod 755 /home/sftpuser && \
    chown sftpuser:sftpuser /home/sftpuser/uploads

# Update sshd_config to allow only SFTP
RUN echo "Match User sftpuser" >> /etc/ssh/sshd_config && \
    echo "    ForceCommand internal-sftp" >> /etc/ssh/sshd_config && \
    echo "    ChrootDirectory /home/sftpuser" >> /etc/ssh/sshd_config && \
    echo "    PermitTunnel no" >> /etc/ssh/sshd_config && \
    echo "    AllowAgentForwarding no" >> /etc/ssh/sshd_config && \
    echo "    AllowTcpForwarding no" >> /etc/ssh/sshd_config && \
    echo "    X11Forwarding no" >> /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Command to run the SSH server
CMD ["/usr/sbin/sshd", "-D"]