# SFTP Server

This Docker image provides a simple and secure way to run an SFTP Server.

![SFTP Server Logo](sftp_server.png)

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Project Structure](#project-structure)
4. [Features](#features)
5. [Environment Variables](#environment-variables)
6. [Usage](#usage)
7. [Volume](#volume)
8. [Ports](#ports)
9. [Customization](#customization)
10. [Building the Image Locally](#building-the-image-locally)
11. [Contributing](#contributing)
12. [License](#license)
13. [Support](#support)

## Prerequisites

- Docker
- Docker Compose (Necessary for Quick Start)

## Quick Start

Execute the following command to download the `compose.yaml` file and start the SFTP server using Docker Compose, useful if you don't want to think about the configuration.

```bash
curl -o compose.yaml https://raw.githubusercontent.com/excoffierleonard/sftp_server/refs/heads/main/compose.yaml && docker compose up -d
```

## Project Structure

- `dockerfile`: Defines the Docker image, including dependencies and configuration.
- `entrypoint.sh`: Script to initialize and set up the environment for the SFTP Server.
- `compose.yaml`: Docker Compose file to define and manage the container.

## Features

- 🚀 Automatically sets up an OpenSSH server configured for SFTP access
- 🔧 Easy configuration through environment variables
- 💾 Persistent data storage using Docker volumes
- 🔄 Auto-restarts on crashes

## Environment Variables

The following environment variables can be set either in a .env file, directly written in compose.yaml, or hardcoded in the Run command:

- SFTP_USER_PASSWORD: Password for the SFTP user (default: randomly generated if not set)
- SFTP_SERVER_PORT: The port for the SFTP server (default: 22)
- SFTP_SERVER_SERVICE: The name of the service (default: sftp_server)
- SFTP_SERVER_VOLUME: The volume or mount-point for SFTP storage (default: sftp_server, a docker volume is recommended)
- SFTP_SERVER_NETWORK: The network for the SFTP server (default: sftp_server)

If you provide empty or invalid environment variables, the default values will be used.

## Usage

### Preferred Method: Docker Compose

1. **Create a `compose.yaml` File:**

Create a `compose.yaml` file with the following content, you can find a template in the repo [here](compose.yaml).

```yaml
services:
  sftp_server:
    build:
      context: .
      dockerfile: dockerfile
    image: ghcr.io/excoffierleonard/sftp_server
    container_name: ${SFTP_SERVER_SERVICE:-sftp_server}
    environment:
      SFTP_USER_PASSWORD: ${SFTP_USER_PASSWORD}
    ports:
      - "${SFTP_SERVER_PORT:-22}:22"
    volumes:
      - sftp_server:/mnt/sftp_server
    networks:
      - sftp_server
    restart: on-failure:5

volumes:
  sftp_server:
    name: ${SFTP_SERVER_VOLUME:-sftp_server}

networks:
  sftp_server:
    name: ${SFTP_SERVER_NETWORKS:-sftp_server}
```

Alternatively, you can download the [compose.yaml](compose.yaml) file directly from the repository:

```bash
curl -o compose.yaml https://raw.githubusercontent.com/excoffierleonard/sftp_server/refs/heads/main/compose.yaml
```

2. **Create a `.env` File (Optional):**

Set up environment variables by creating a `.env` file in the same directory as `compose.yaml`. You can use the example below as a guideline:

```bash
SFTP_USER_PASSWORD=""
SFTP_SERVER_PORT=22
SFTP_SERVER_SERVICE=sftp_server
SFTP_SERVER_VOLUME=sftp_server
SFTP_SERVER_NETWORK=sftp_server
```

Alternatively, you can hardcode these values directly in [compose.yaml](compose.yaml).

3. **Launch the Service:**

Start the containers in detached mode with Docker Compose:

```bash
docker compose up -d
```

### Alternative Method: Docker Run

1. **Create a Docker Network:**

```bash
docker network create sftp_server
```

2. **Execute the `Run` command:**

```bash
docker run \
  -d \
  --name sftp_server \
  -e SFTP_USER_PASSWORD="" \
  -p 22:22 \
  -v sftp_server:/mnt/sftp_server \
  --net=sftp_server \
  ghcr.io/excoffierleonard/sftp_server
```

## Volume

The container exposes a docker volume at `/mnt/sftp_server`. This directory is the root directory of the server. You can mount this volume to a local directory on your host machine to access the files, or to a docker volume for persistent storage.

## Ports

The container exposes port 22 by default, which is the default port for SFTP servers. You are free to change it if you need multiple SFTP servers.

## Customization

Future updates may include the option to modify the `sshd_config` file.

## Building the Image Locally

```bash
git clone https://github.com/excoffierleonard/sftp_server.git && \
cd sftp_server && \
docker compose build
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the [MIT License](LICENSE).

## Support

If you encounter any problems or have any questions, please open an issue in this repository.
