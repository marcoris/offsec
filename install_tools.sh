#!/bin/bash

sudo apt update

# Install tools
tools_list=(
	assetfinder
	docker.io
	grepcidr
	gowitness
	httprobe
	jq
	peass
	sublist3r
	subfinder
)

for tool in "${tools_list[@]}"; do
	if ! command -v "$tool" &>/dev/null; then
		echo "$tool is not installed."
		echo "Installing $tool ..."
		sudo apt install "$tool" -y
		if [[ $? -eq 0 ]]; then
			echo "$tool was installed."
		else
			echo "There was an error by the installation of $tool."
		fi
	else
		echo "$tool is already installed"
	fi
done

# Create necessary folders
./create_folders.sh

# Download scripts
# Coming soon

# Copy script in created folder
cp /usr/share/peass/linpeas/linpeas.sh "$HOME/Pentesting/scripts/linux/bash/"
cp /usr/share/peass/winpeas/winPEAS.bat "$HOME/Pentesting/scripts/windows/"
cp /usr/share/peass/winpeas/winPEASx64.exe "$HOME/Pentesting/scripts/windows/"
cp /usr/share/peass/winpeas/winPEASx86.exe "$HOME/Pentesting/scripts/windows/"

sudo chmod +x githubdorker && cp githubdorker /usr/bin
sudo chmod +x googledorker && cp googledorker /usr/bin
sudo chmod +x network-scanner && cp network-scanner /usr/bin
sudo chmod +x vhost-fuzzer && cp vhost-fuzzer /usr/bin

## Download other tools on github
install_rustscan() {
	# Download latest rustscan
	LATEST_RUSTSCAN_RELEASE_URL=$(curl -s "https://api.github.com/repos/RustScan/RustScan/releases/latest" | grep -m 1 "browser_download_url" | cut -d '"' -f 4)

	if [[ -z "$LATEST_RUSTSCAN_RELEASE_URL" ]]; then
		echo "Error: Download-Link was not found!"
		exit 1
	fi

	if command -v wget &> /dev/null; then
		wget -q --show-progress "$LATEST_RUSTSCAN_RELEASE_URL"
	elif command -v curl &> /dev/null; then
		curl -L --progress-bar -O "$LATEST_RUSTSCAN_RELEASE_URL"
	else
		echo "Error. Could not download rustscan."
		exit 1
	fi

	sudo cp rustscan /usr/bin/
 	rm rustscan
}

install_dalfox() {
	# Download latest dalfox
	LATEST_DALFOX_RELEASE_URL=$(curl -s "https://api.github.com/repos/hahwul/dalfox/releases/latest" | grep "browser_download_url" | grep "linux_amd64.tar.gz" | cut -d '"' -f 4)
	FILE_NAME=$(basename "$LATEST_DALFOX_RELEASE_URL")

	if [[ -z "$LATEST_DALFOX_RELEASE_URL" ]]; then
		echo "Error: Download-Link was not found!"
		exit 1
	fi

	if command -v wget &> /dev/null; then
		wget -q --show-progress "$LATEST_DALFOX_RELEASE_URL"
	elif command -v curl &> /dev/null; then
		curl -L --progress-bar -O "$LATEST_DALFOX_RELEASE_URL"
	else
		echo "Error. Could not download dalfox."
		exit 1
	fi

	tar -xzf "$FILE_NAME"
	sudo chmod +x dalfox && cp dalfox /usr/bin
	rm "$FILE_NAME" dalfox LICENSE.txt README.md
}

install_waybackurls() {
	# Download latest waybackurls
	LATEST_WAYBACKURLS_RELEASE_URL=$(curl -s "https://api.github.com/repos/tomnomnom/waybackurls/releases/latest" | grep "browser_download_url" | grep "linux-amd64" | grep ".tgz" | cut -d '"' -f 4)
	FILE_NAME=$(basename "$LATEST_WAYBACKURLS_RELEASE_URL")

	if [[ -z "$LATEST_WAYBACKURLS_RELEASE_URL" ]]; then
		echo "Error: Download-Link was not found!"
		exit 1
	fi

	if command -v wget &> /dev/null; then
		wget -q --show-progress "$LATEST_WAYBACKURLS_RELEASE_URL"
	elif command -v curl &> /dev/null; then
		curl -L --progress-bar -O "$LATEST_WAYBACKURLS_RELEASE_URL"
	else
		echo "Error. Could not download waybackurls."
		exit 1
	fi

	tar -xzf "$FILE_NAME"
	sudo chmod +x waybackurls && cp waybackurls /usr/bin
	rm "$FILE_NAME" waybackurls
}

install_rustscan
install_dalfox
install_waybackurls
