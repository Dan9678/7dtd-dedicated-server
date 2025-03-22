#!/bin/bash
set -euo pipefail  # Add strict error handling

# Install/update 7 Days to Die server
echo "Installing/Updating 7 Days to Die server..."

max_retries=3
retry_delay=30
attempt=1
install_dir="/steamapps"

# Add validation for beta format
if [ -n "${BETA:-}" ]; then
    if [[ ! "$BETA" =~ ^[a-zA-Z0-9_.-]+$ ]]; then
        echo "Error: Invalid beta version format"
        exit 1
    fi
    BETA_OPTION="-beta $BETA"
else
    BETA_OPTION=""
fi

# Create installation directory if missing
mkdir -p "$install_dir"

while [ $attempt -le $max_retries ]; do
    echo "Attempt $attempt of $max_retries"
    if /home/steam/steamcmd/steamcmd.sh \
        +force_install_dir "$install_dir" \
        +login anonymous \
        +app_update 294420 $BETA_OPTION validate \
        +quit;
    then
        echo "Installation/Update successful."
        break
    else
        echo "Attempt $attempt failed. Retrying in $retry_delay seconds..."
        sleep $retry_delay
    fi
    attempt=$((attempt + 1))
done

[ $attempt -le $max_retries ] || { echo "Installation failed after $max_retries attempts"; exit 1; }

# Validate mode input
case "${MODE:-manual}" in
    server|manual) ;;
    *) echo "Error: Invalid MODE specified"; exit 1 ;;
esac

if [ "${MODE:-manual}" = "server" ]; then 
    echo "Starting 7DTD server..."
    exec ./start7dtd.sh  # Use exec to replace shell process
else
    echo "Server not starting automatically (MODE=manual). To start:"
    echo "1. Attach to container: docker exec -it <container> bash"
    echo "2. Run: ./start7dtd.sh"
    exec tail -f /dev/null  # Keep container alive
fi


