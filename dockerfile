FROM ubuntu:latest

# Install OpenSSH server
RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create the necessary directory for privilege separation
RUN mkdir -p /run/sshd

# Set a password for the root user
ARG SSH_PASSWORD=password
RUN echo "root:${SSH_PASSWORD}" | chpasswd

# Allow root login and password authentication
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Command to run the SSH server
CMD ["/usr/sbin/sshd", "-D"]