# Use the --platform argument for multi-arch
FROM --platform=$TARGETPLATFORM node:22-bookworm-slim AS builder

# Set noninteractive for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Set Puppeteer environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV PUPPETEER_EXECUTABLE_PATH /usr/bin/chromium

WORKDIR /app

# Copy source code for the build stage
COPY ./mcp_puppeteer/package*.json ./mcp_puppeteer/
COPY ./mcp_puppeteer/index.ts ./mcp_puppeteer/
COPY ./mcp_puppeteer/tsconfig.json ./mcp_puppeteer/

RUN mkdir -p /project
RUN cp -r ./mcp_puppeteer/* /project
WORKDIR /project/

# Install *all* dependencies (including devDependencies)
RUN npm install

# Run the build command
RUN npm run build

# --- Final Stage ---
FROM --platform=$TARGETPLATFORM node:22-bookworm-slim

# Set Puppeteer environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV PUPPETEER_EXECUTABLE_PATH /usr/bin/chromium

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget gnupg fonts-ipafont-gothic fonts-wqy-zenhei \
                       fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
                       libgtk2.0-0 libnss3 libatk-bridge2.0-0 libdrm2 \
                       libxkbcommon0 libgbm1 libasound2 chromium && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
# Copy the build artifacts from the builder stage
COPY --from=builder /project/dist ./dist
COPY --from=builder /project/node_modules ./node_modules
COPY --from=builder /project/package.json ./package.json

# No CMD or ENTRYPOINT