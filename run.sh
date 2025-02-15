#!/bin/bash

# Start the Puppeteer container
docker run -d \
  --name mcp-puppeteer \
  --restart always \
  -e DOCKER_CONTAINER=true \
  mcp/puppeteer

# Keep the add-on running (important!)
while true; do
  sleep 3600 # Sleep for an hour
done