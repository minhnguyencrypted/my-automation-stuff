#!/bin/bash

# This script is used to update the CRC version by extracting the `crc` binary
# from the TAR archive then place it under `~/bin` directory.

BIN_DIR="$HOME/bin"
# If not enough arguments are provided, print the usage and exit
if [ $# -ne 2 ]; then
  echo "Usage: update-crc.sh <archive_path> <target_version>"
  exit 1
fi
ARCHIVE_PATH=$1
TARGET_VERSION=$2
# Check if TARGET_VERSION is a valid version
if ! [[ $TARGET_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Invalid version: $TARGET_VERSION, should be in the form of x.y.z"
  exit 1
fi
# Extract the `crc` binary from the tar.xz archive
# Catch the error if extracting the `crc` binary failed
if ! tar -xvf $ARCHIVE_PATH -C $BIN_DIR --strip-components=1 crc-linux-$TARGET_VERSION-amd64/crc; then
  echo "Failed to extract the crc binary from the archive"
  exit 1
fi
# Check the version of the `crc` binary
CURRENT_VERSION=$(crc version | head -n 1 | cut -d ' ' -f 3 | cut -d '+' -f 1)
# Check if the version of the `crc` binary is the same as the target version
if [ "$CURRENT_VERSION" == "$TARGET_VERSION" ]; then
  echo "crc version $TARGET_VERSION updated successfully"
else
  echo "crc version $TARGET_VERSION could not update"
fi

