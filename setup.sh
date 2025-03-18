#!/bin/bash
set -e

# Colors for console output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  Salesforce MCP Server Setup Script ${NC}"
echo -e "${BLUE}=====================================${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Warning: Docker Compose is not installed. Some functionality may be limited.${NC}"
    HAS_COMPOSE=false
else
    HAS_COMPOSE=true
fi

# Create config directory if it doesn't exist
echo -e "${GREEN}Creating configuration directory...${NC}"
mkdir -p config

# Check if .env file exists
if [ ! -f "config/.env" ]; then
    echo -e "${GREEN}Creating .env file from template...${NC}"
    cp .env.example config/.env
    echo -e "${YELLOW}Please edit config/.env with your Salesforce credentials.${NC}"
    echo -e "${YELLOW}Opening file for editing...${NC}"
    
    # Open the file with the default editor
    if [ -n "$EDITOR" ]; then
        $EDITOR config/.env
    elif command -v nano &> /dev/null; then
        nano config/.env
    elif command -v vim &> /dev/null; then
        vim config/.env
    else
        echo -e "${YELLOW}Please manually edit config/.env with your Salesforce credentials.${NC}"
    fi
else
    echo -e "${GREEN}Using existing .env file.${NC}"
fi

# Build and start containers
echo -e "${GREEN}Building and starting the container...${NC}"
if [ "$HAS_COMPOSE" = true ]; then
    docker-compose up --build -d
    echo -e "${GREEN}Container is running in the background.${NC}"
    echo -e "${GREEN}To view logs, run: docker-compose logs -f${NC}"
else
    echo -e "${GREEN}Building Docker image...${NC}"
    docker build -t salesforce-mcp-server .
    
    echo -e "${GREEN}Running container...${NC}"
    docker run -d \
      --name salesforce-mcp-server \
      -v "$(pwd)/config:/app/config" \
      --restart unless-stopped \
      salesforce-mcp-server
    
    echo -e "${GREEN}Container is running in the background.${NC}"
    echo -e "${GREEN}To view logs, run: docker logs -f salesforce-mcp-server${NC}"
fi

echo -e "${BLUE}=====================================${NC}"
echo -e "${GREEN}Setup complete!${NC}"
echo -e "${BLUE}=====================================${NC}"