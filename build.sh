#!/bin/bash

# Build the add-on's Docker image
docker build -t rotexhawk/hassio-mcp-puppeteer .

# Push the image to Docker Hub (or your registry)
docker push rotexhawk/hassio-mcp-puppeteer