# Use the --platform argument for multi-arch
FROM --platform=$TARGETPLATFORM node:22-bookworm-slim AS builder

# Set noninteractive for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Set Puppeteer environment variables (still needed for runtime)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV PUPPETEER_EXECUTABLE_PATH /usr/bin/chromium

WORKDIR /app

# Copy *only* the source code needed for building
COPY ./src/puppeteer/package*.json ./src/puppeteer/
COPY ./src/puppeteer/index.ts ./src/puppeteer/
COPY ./tsconfig.json ./

RUN mkdir -p /project
RUN cp -r ./src/puppeteer/* /project/
RUN cp ./tsconfig.json /project/
WORKDIR /project

# Install *all* dependencies (including devDependencies) for the build stage
RUN npm install

# Run the build command
RUN npm run build  # Make SURE this is the correct build command

# --- Start a new stage for the final image ---
FROM --platform=$TARGETPLATFORM node:22-bookworm-slim

# Set Puppeteer environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV PUPPETEER_EXECUTABLE_PATH /usr/bin/chromium

# Install runtime dependencies (Chromium, etc.)
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget gnupg fonts-ipafont-gothic fonts-wqy-zenhei \
                       fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
                       libgtk2.0-0 libnss3 libatk-bridge2.0-0 libdrm2 \
                       libxkbcommon0 libgbm1 libasound2 chromium && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy *only* the built code and production dependencies from the builder stage
COPY --from=builder /project/dist ./dist
COPY --from=builder /project/node_modules ./node_modules
COPY --from=builder /project/package.json ./package.json

# No CMD or ENTRYPOINT