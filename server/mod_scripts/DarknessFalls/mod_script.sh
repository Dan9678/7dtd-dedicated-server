#!/bin/bash
# Darkness Falls Mod Installer for a fresh 7 Days to Die server

# Variables
SERVER_DIR="/steamapps"
MODS_DIR="${SERVER_DIR}/Mods"
MOD_URL="http://darknessfallsmod.co.uk/DF-V6-DEV-B19.zip"
TEMP_DIR="/tmp/darkness_falls"

# Ensure the Mods directory exists
mkdir -p "${MODS_DIR}"

# Download the mod
echo "Downloading Darkness Falls mod..."
mkdir -p "${TEMP_DIR}"
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

MOD_EXTRACTED_DIR=$(find "${TEMP_DIR}" -type d -name "DarknessFalls*" | head -n 1)

if [ ! -d "${MOD_EXTRACTED_DIR}/Mods" ]; then
    echo "Error: Mods folder not found in the extracted Darkness Falls files."
    exit 1
fi

# Deploy the mod files to the server's Mods directory
echo "Deploying Darkness Falls mod to the server..."
cp -r "${MOD_EXTRACTED_DIR}/Mods/"* "${MODS_DIR}"

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -rf "${TEMP_DIR}"

# Set environment variables for server configuration
#export GameWorld="DFalls-Navezgane"
#export GameName="Darkness Falls Server"
#export EACEnabled="false"

echo "Darkness Falls mod installed successfully."
