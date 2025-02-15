ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:17.1.5
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /app

# Copy source (adjust paths if needed, but this should work with your current structure)
COPY ./mcp_puppeteer/package*.json ./mcp_puppeteer/
COPY ./mcp_puppeteer/index.ts ./mcp_puppeteer/
COPY ./mcp_puppeteer/tsconfig.json ./

RUN mkdir -p /project
RUN cp -r ./mcp_puppeteer/* /project/
WORKDIR /project/

# Install ALL dependencies (including devDependencies for building)
RUN npm install

# Build the TypeScript code
RUN npm run build  # Ensure this is your correct build command

# Copy ONLY the necessary files for runtime
RUN mkdir -p /app
RUN cp -r ./dist /app
RUN cp -r ./node_modules /app
RUN cp ./package.json /app

WORKDIR /app

#Home Assistant will automatically add the labels.