#!/bin/bash

# Install/update 7 Days to Die server
echo "Installing/Updating 7 Days to Die server..."

max_retries=3  # Increased retries
retry_delay=30  # Increased delay
attempt=1
install_dir="/steamapps"  # Specify install directory

while [ $attempt -le $max_retries ]; do
    /home/steam/steamcmd/steamcmd.sh +force_install_dir "$install_dir" +login anonymous +app_update 294420 validate +quit
    if [ $? -eq 0 ]; then
        echo "Installation/Update successful."
        break
    else
        echo "Attempt $attempt failed. Retrying in $retry_delay seconds..."
        sleep $retry_delay
    fi
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_retries ]; then
    echo "Installation/Update failed after $max_retries attempts."
    exit 1
fi

# Set default mode if not specified
MODE=${MODE:-"manual"}

if [ "$MODE" = "server" ]; then 
    echo "Starting 7DTD server..."
    if ! ./start7dtd.sh; then
        echo "Failed to start 7DTD server."
        exit 1
    fi
else
    echo "To start server run ./start7dtd.sh or ./install.sh to reinstall 7dtd."
    # Keep the container running
    exec tail -f /dev/null
fi

