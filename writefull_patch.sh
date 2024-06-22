#!/bin/bash

# Determine the OS type
OS_TYPE=$(uname)

# Get user's home directory
USER_HOME=$(eval echo ~$USER)

# Set the base directory for Chrome/Chromium profiles based on the OS type
if [ "$OS_TYPE" = "Darwin" ]; then
    CHROME_BASE_DIR="${USER_HOME}/Library/Application Support/Google/Chrome"
    CHROMIUM_BASE_DIR="${USER_HOME}/Library/Application Support/Chromium"
elif [ "$OS_TYPE" = "Linux" ]; then
    CHROME_BASE_DIR="${USER_HOME}/.config/google-chrome"
    CHROMIUM_BASE_DIR="${USER_HOME}/.config/chromium"
else
    echo "Unsupported OS type: $OS_TYPE"
    exit 1
fi

# Define the extension's ID
EXT_ID="edhnemgfcihjcpfhkoiiejgedkbefnhg"

# Initialize extension directory variable
EXT_DIR=""

# Function to find the extension directory
find_extension_dir() {
    local BASE_DIR=$1
    for PROFILE in "${BASE_DIR}/Default" "${BASE_DIR}"/Profile*; do
        if [ -d "${PROFILE}/Extensions/${EXT_ID}" ]; then
            EXT_DIR=$(find "${PROFILE}/Extensions/${EXT_ID}" -type d -name "*_*" | head -n 1)
            if [ -n "$EXT_DIR" ]; then
                echo "Extension found in: $EXT_DIR"
                break
            fi
        fi
    done
}

# Search for the extension directory in Chrome and Chromium profiles
find_extension_dir "$CHROME_BASE_DIR"
if [ -z "$EXT_DIR" ]; then
    find_extension_dir "$CHROMIUM_BASE_DIR"
fi

# Check if extension directory was found
if [ -z "$EXT_DIR" ]; then
    echo "Extension directory not found."
    exit 1
fi

# Define the new directory in the user's Downloads
NEW_DIR="${USER_HOME}/Downloads/writefull_chrome_patched"

# Path to manifest.json in the new directory
MANIFEST="${NEW_DIR}/manifest.json"

# Remove the new directory if it already exists
if [ -d "$NEW_DIR" ]; then
    rm -rf "$NEW_DIR"
fi

# Create a new directory
mkdir -p "$NEW_DIR"

# Check if the original manifest.json exists
if [ ! -f "${EXT_DIR}/manifest.json" ]; then
    echo "Original manifest.json not found."
    exit 1
fi

# Copy all files from the original extension directory to the new directory
cp -r "${EXT_DIR}/"* "$NEW_DIR/"

# Prompt for domain input with a default value
read -p "Enter the domain [default: sharelatex.com]: " DOMAIN
DOMAIN=${DOMAIN:-sharelatex.com}

# Create a temporary manifest file for modifications
TMP_MANIFEST="${NEW_DIR}/manifest_tmp.json"
cp "${EXT_DIR}/manifest.json" "$TMP_MANIFEST"

# Process the temporary manifest file and make replacements
if [ "$OS_TYPE" = "Darwin" ]; then
    sed -i '' "s/overleaf\.com/${DOMAIN}/g" "$TMP_MANIFEST"
    sed -i '' "s/\"Writefull for Overleaf\"/\"Writefull for ${DOMAIN}\"/g" "$TMP_MANIFEST"
else
    sed -i "s/overleaf\.com/${DOMAIN}/g" "$TMP_MANIFEST"
    sed -i "s/\"Writefull for Overleaf\"/\"Writefull for ${DOMAIN}\"/g" "$TMP_MANIFEST"
fi

# Remove the "key" line using grep
grep -v '"key":' "$TMP_MANIFEST" > "$MANIFEST"

# Clean up the temporary manifest file
rm "$TMP_MANIFEST"

# Detect script's running directory and copy new icons
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cp "${SCRIPT_DIR}/new_assets/icon.png" "${NEW_DIR}/assets/"
cp "${SCRIPT_DIR}/new_assets/icon48.png" "${NEW_DIR}/assets/"

echo "Modification completed."
echo "Manually install the patched extension in Chrome/Chromium"
echo "1. In Chrome/Chromium open chrome://extensions/"
echo "2. Enable developer mode in the top right corner."
echo "3. Click 'Load unpacked' button in the top right corner."
echo "4. Select '$NEW_DIR' folder."
echo "Ignore that the installation shows an error about the manifest version."
