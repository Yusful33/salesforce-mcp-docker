# Salesforce MCP Server - Deployment Guide

This guide will walk you through the process of deploying the containerized Salesforce MCP Server.

## 1. System Requirements

- Docker Engine 20.10.0 or later
- Docker Compose 2.0.0 or later (recommended)
- At least 1GB of RAM
- Internet connectivity for accessing Salesforce APIs
- Valid Salesforce credentials with API access

## 2. Deployment Options

### Option 1: Quick Start with setup.sh (Recommended)

The included `setup.sh` script automates the container setup process:

```bash
# Clone the repository
git clone https://github.com/Yusful33/salesforce-mcp-docker.git
cd salesforce-mcp-docker

# Make the setup script executable
chmod +x setup.sh

# Run the setup script
./setup.sh
```

The script will:
- Create the config directory
- Copy the .env.example to config/.env and prompt you to edit it
- Build and start the Docker container

### Option 2: Manual Deployment with Docker Compose

```bash
# Clone the repository
git clone https://github.com/Yusful33/salesforce-mcp-docker.git
cd salesforce-mcp-docker

# Create config directory and environment file
mkdir -p config
cp .env.example config/.env

# Edit the environment file with your credentials
nano config/.env

# Build and start the container
docker-compose up -d
```

### Option 3: Manual Deployment with Docker

```bash
# Clone the repository
git clone https://github.com/Yusful33/salesforce-mcp-docker.git
cd salesforce-mcp-docker

# Build the Docker image
docker build -t salesforce-mcp-server .

# Create config directory
mkdir -p config

# Run the container
docker run -d \
  --name salesforce-mcp-server \
  -e SF_USERNAME=your-username@example.com \
  -e SF_PASSWORD=your-password \
  -e SF_SECURITY_TOKEN=your-security-token \
  -v $(pwd)/config:/app/config \
  --restart unless-stopped \
  salesforce-mcp-server
```