#!/bin/bash

# Define the installation directory
INSTALL_DIR="/usr/local/bin"

#!/bin/bash

# Replace with the actual URL of the binary you want to download

DOWNLOAD_URL="https://clappit-public.s3.us-west-2.amazonaws.com/clappit-osx-arm64.zip"

[ $(uname -m) = x86_64 ] && DOWNLOAD_URL="https://clappit-public.s3.us-west-2.amazonaws.com/clappit-osx-x64.zip"
[ $(uname -m) = aarch64 ] && DOWNLOAD_URL="https://clappit-public.s3.us-west-2.amazonaws.com/clappit-osx-arm64.zip"
[ $(uname -m) = arm64 ] && DOWNLOAD_URL="https://clappit-public.s3.us-west-2.amazonaws.com/clappit-osx-arm64.zip"


# Replace with the desired filename for the downloaded binary
BINARY_NAME="clappit"

# Download directory (change if you prefer a different location)
DOWNLOAD_DIR="/tmp"

# Define the installation directory
INSTALL_DIR="/usr/local/bin"

SHELL_TYPE="$(basename "$SHELL")"

# Check if binary already exists
if [ -f "$DOWNLOAD_DIR/$BINARY_NAME" ]; then
  echo "$BINARY_NAME already exists. Skipping download."
else
  echo "Downloading $BINARY_NAME..."
  curl -L "$DOWNLOAD_URL" -o "$DOWNLOAD_DIR/$BINARY_NAME.zip"

  if [[ $? -ne 0 ]]; then
    echo "Download failed. Exiting."
    exit 1
  fi
fi

# Extract the downloaded artifact
echo "Extracting $BINARY_NAME.zip..."
unzip -q "$DOWNLOAD_DIR/$BINARY_NAME.zip" -d "$DOWNLOAD_DIR"

if [[ $? -ne 0 ]]; then
  echo "Extraction failed. Exiting."
  exit 1
fi
echo "cleaning $DOWNLOAD_DIR/$BINARY_NAME.zip"
sudo rm $DOWNLOAD_DIR/$BINARY_NAME.zip

# Check if the installation directory exists
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Installation directory $INSTALL_DIR does not exist. Creating..."
    sudo mkdir -p "$INSTALL_DIR"
fi

# Make the binary executable
chmod +x "$DOWNLOAD_DIR/$BINARY_NAME"
# Copy the clappit executable to the installation directory
sudo mv "$DOWNLOAD_DIR/$BINARY_NAME" "$INSTALL_DIR/clappit"

# Choose which shell configuration file to modify (edit as needed)
SHELL_CONFIG_FILE=~/.bash_profile  # For Bash shell
if [ "$SHELL_TYPE" = "bash" ]; then
    SHELL_CONFIG_FILE=~/.bash_profile  # For Bash shell
elif [ "$SHELL_TYPE" = "zsh" ]; then
    SHELL_CONFIG_FILE=~/.zshrc # For Bash shell
else
    echo "Unsupported shell: $SHELL_TYPE"
fi


# Check if the directory is already in PATH
if ! echo $PATH | grep -q "$INSTALL_DIR"; then
  # Add the download directory to PATH
  echo "Adding $INSTALL_DIR to PATH..."

  #echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> ~/.bash_profile
  echo "export PATH=$INSTALL_DIR:\$PATH" >> "$SHELL_CONFIG_FILE"
else
  echo "$INSTALL_DIR already exists in your PATH."
fi

# Source the shell configuration file to apply the changes immediately
source "$SHELL_CONFIG_FILE"

echo "Done! You can now run $BINARY_NAME from any directory."
