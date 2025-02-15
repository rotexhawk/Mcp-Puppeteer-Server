#!/usr/bin/with-contenv bashio

# Access add-on options
DEBUG_MODE=$(bashio::config debug)

# Start the mCP Puppeteer service
echo "Starting mCP Puppeteer..."

if [ "$DEBUG_MODE" = "true" ]; then
  # Example:  Check mCP Puppeteer docs for how to enable debugging.
  # node dist/index.js --debug  # Adjust as needed
  node dist/index.js #if no debug option exists, run normally
else
  node dist/index.js
fi

# Do NOT exit the script.