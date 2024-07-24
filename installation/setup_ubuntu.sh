#!/bin/bash

# Define the installation directory
INSTALL_DIR="/usr/local/bin"

# Replace with the actual URL of the binary you want to download
DOWNLOAD_URL="https://clappit-public.s3.us-west-2.amazonaws.com/clappit-linux-x64.zip"
BINARY_NAME="clappit"
# Detect architecture and adjust DOWNLOAD_URL if necessary
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        DOWNLOAD_URL="https://clappit-public.s3.us-west-2.amazonaws.com/clappit-linux-x64.zip"
        BINARY_NAME="clappit"
        ;;
    aarch64 | arm64)
        DOWNLOAD_URL="https://clappit-public.s3.us-west-2.amazonaws.com/clappit-linux-arm64.zip"
        BINARY_NAME="clappit"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Download directory (change if you prefer a different location)
DOWNLOAD_DIR="/tmp"

# Check if binary already exists
if [ -f "$DOWNLOAD_DIR/$BINARY_NAME.zip" ]; then
    echo "$BINARY_NAME.zip already exists. Skipping download."
else
    echo "Downloading $BINARY_NAME.zip..."
    curl -L "$DOWNLOAD_URL" -o "$DOWNLOAD_DIR/$BINARY_NAME.zip"

    if [[ $? -ne 0 ]]; then
        echo "Download failed. Exiting."
        exit 1
    fi
fi

apt-get install unzip
# Extract the downloaded artifact
echo "Extracting $BINARY_NAME.zip..."
unzip -q "$DOWNLOAD_DIR/$BINARY_NAME.zip" -d "$DOWNLOAD_DIR"
echo "cleaning $DOWNLOAD_DIR/$BINARY_NAME.zip"
sudo rm $DOWNLOAD_DIR/$BINARY_NAME.zip

if [[ $? -ne 0 ]]; then
    echo "Extraction failed. Exiting."
    exit 1
fi

# Check if the installation directory exists
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Installation directory $INSTALL_DIR does not exist. Creating..."
    sudo mkdir -p "$INSTALL_DIR"
fi

# Make the binary executable
chmod +x "$DOWNLOAD_DIR/$BINARY_NAME"
# Copy the clappit executable to the installation directory
sudo mv "$DOWNLOAD_DIR/$BINARY_NAME" "$INSTALL_DIR/clappit"

# Determine which shell the user is using
SHELL_TYPE="$(basename "$SHELL")"

# Choose which shell configuration file to modify
SHELL_CONFIG_FILE=~/.bashrc  # Default to Bash shell configuration
PATH_CMD="export PATH=\"$INSTALL_DIR:\$PATH\""

# Check if the directory is already in PATH
if ! echo $PATH | grep -q "$INSTALL_DIR"; then
    echo "Adding $INSTALL_DIR to PATH..."

    if [ "$SHELL_TYPE" = "fish" ]; then
        echo $PATH_CMD >> "$SHELL_CONFIG_FILE"
    else
        echo $PATH_CMD >> "$SHELL_CONFIG_FILE"
    fi
else
    echo "$INSTALL_DIR already exists in your PATH."
fi

#Source the shell configuration file to apply the changes immediately
source "$SHELL_CONFIG_FILE"

# Inform the user to restart their shell or source their config file
echo "Done! Please restart your shell or source your shell configuration file to apply the changes."
echo "For example: source $SHELL_CONFIG_FILE"
echo "You can now run clappit from any directory."
