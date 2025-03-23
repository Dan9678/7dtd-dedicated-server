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

# Default value for VALIDATE if not set
VALIDATE=${VALIDATE:-true}

while [ $attempt -le $max_retries ]; do
    echo "Attempt $attempt of $max_retries"
    if /home/steam/steamcmd/steamcmd.sh \
        +force_install_dir "$install_dir" \
        +login anonymous \
        +app_update 294420 $BETA_OPTION \
        ${VALIDATE:+validate} \
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

# Run mod script
if [ -n "${MOD_SCRIPT:-}" ]; then
    script_path="mod_scripts/${MOD_SCRIPT}/mod_script.sh"
    if [ ! -f "$script_path" ]; then
        echo "Error: Mod script not found at '$script_path'"
        exit 1
    fi
    echo "Executing $MOD_SCRIPT mod script"
    ./"$script_path"
fi

# Validate mode input
case "${MODE:-manual}" in
    server|manual) ;;
    *) echo "Error: Invalid MODE specified"; exit 1 ;;
esac

# Insure start7dtd.sh exists
start_script="/home/steam/start7dtd.sh"

if [ ! -f "$start_script" ]; then
    echo "Error: The server start script $start_script was not found"
    echo "Please verify it is being installed in the Docker file and rebuild the image"
    exit 1
fi

# Launch manual mode or start the server
if [ "${MODE:-manual}" = "server" ]; then 
    echo "Starting 7DTD server..."
    exec "$start_script"  # Use exec to replace shell process
else
    echo "Server not starting automatically (MODE=manual). To start:"
    echo "1. Attach to container: docker exec -it <container> bash"
    echo "2. Run: $start_script"
    exec tail -f /dev/null  # Keep container alive
fi

