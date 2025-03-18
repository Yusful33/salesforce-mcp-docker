FROM node:20-slim AS build

WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source files
COPY tsconfig.json ./
COPY src/ ./src/

# Build TypeScript code
RUN npm run build

# Use a smaller image for runtime
FROM node:20-slim

WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=build /app/package*.json ./
COPY --from=build /app/build ./build

# Install only production dependencies
RUN npm ci --omit=dev

# Copy .env.example file for reference
COPY .env.example ./

# Create a volume to mount custom .env file
VOLUME /app/config

# Environment variables can be overridden via docker-compose or docker run
ENV SF_LOGIN_URL=https://login.salesforce.com
ENV SF_USERNAME=
ENV SF_PASSWORD=
ENV SF_SECURITY_TOKEN=

# Allow script to be run
RUN chmod +x ./build/index.js

# Expose MCP server on stdio
CMD ["node", "build/index.js"]