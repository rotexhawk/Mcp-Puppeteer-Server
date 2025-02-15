ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:17.1.5
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# --- Build Stage ---
WORKDIR /tmp/build

# Copy source files
COPY ./index.ts ./
COPY ./package*.json ./
COPY ./tsconfig.json ./

# Install dependencies (including devDependencies)
RUN npm ci  # Use npm ci for reliable builds

# Build the TypeScript code
RUN npm run build

# --- Prepare rootfs ---
# Everything that should be in the final container's root (/) goes into /rootfs
# The base image handles copying this to the right place.

RUN mkdir -p /rootfs/app
COPY --from=0 /tmp/build/dist /rootfs/app/dist
COPY --from=0 /tmp/build/node_modules /rootfs/app/node_modules
COPY --from=0 /tmp/build/package.json /rootfs/app/package.json


# Set the working directory (within the rootfs)
WORKDIR /app

# No CMD or ENTRYPOINT needed - run.sh handles this.