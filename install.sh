#!/bin/bash

# Installs necessary tools
sudo apt update

## Install tools

tools_list=(
  docker.io
)

for tool in "${tools_list[@]}"; do
  echo "Installiere $tool ..."
  sudo apt install "$tool" -y
  if [[ $? -eq 0 ]]; then
    echo "$tool was installed."
  else
    echo "There was an error by the installation of $tool."
  fi
done


## Download other tools on github
# Download latest rustscan
LATEST_RELEASE_URL=$(curl -s "https://api.github.com/repos/RustScan/RustScan/releases/latest" | grep "browser_download_url" | cut -d '"' -f 4)

if [[ -z "$LATEST_RELEASE_URL" ]]; then
    echo "Error: Download-Link was not found!"
    exit 1
fi

wget -q --show-progress "$LATEST_RELEASE_URL"
