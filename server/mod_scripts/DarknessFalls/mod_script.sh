#!/bin/bash
# Darkness Falls Mod Installer for a fresh 7 Days to Die server

# Environment Variables (set in docker-compose.yml)
# MOD_URL
# MOD_SCRIPT (points to this script)

# Variables 
SERVER_DIR="/steamapps"
MODS_DIR="${SERVER_DIR}/Mods"
TEMP_DIR=$(mktemp -d)

# Ensure the Mods directory exists
mkdir -p "${MODS_DIR}"

# Download the mod
echo "Downloading Darkness Falls mod..."
if ! curl -L "${MOD_URL}" -o "${TEMP_DIR}/darkness_falls.zip"; then
    echo "Error: Failed to download the mod."
    exit 1
fi

# Extract the mod
echo "Extracting Darkness Falls mod..."
if ! unzip -qo "${TEMP_DIR}/darkness_falls.zip" -d "${TEMP_DIR}"; then
    echo "Error: Failed to extract the mod."
    exit 1
fi

# Deploy the mod files to the server's Mods directory
echo "Deploying Darkness Falls mod to the server..."
MOD_EXTRACTED_DIR=$(find "${TEMP_DIR}" -type d -name "Mods" | head -n 1)
if [ -z "${MOD_EXTRACTED_DIR}" ]; then
    echo "Error: Mods folder not found in the extracted files."
    exit 1
fi

if ! cp -r "${MOD_EXTRACTED_DIR}/"* "${MODS_DIR}"; then
    echo "Error: Failed to copy mod files."
    exit 1
fi

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -rf "${TEMP_DIR}"

echo "Darkness Falls mod installed successfully."


