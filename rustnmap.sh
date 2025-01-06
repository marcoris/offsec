#!/bin/bash

# Fast scanning for open ports to get the best results.

# Function to check if a command exists
check_tool() {
    local tool=$1
    if ! command -v "$tool" &>/dev/null; then
        echo "$tool is not installed."
    fi
}

# Check if RustScan and Nmap are installed
check_tool "rustscan"
check_tool "nmap"

read -p "Enter the target (IP, domain, or subnet): " target

PS3="Choose an option: "
options=(
    "RustScan -> Nmap: Scan OS, service name, and port"
    "RustScan -> Nmap: Scan for vulnerabilities"
    "RustScan -> Nmap: Full combined scan"
    "RustScan -> Nmap: Scan specific ports"
    "RustScan only: Fast port scan"
    "Nmap without RustScan"
    "Exit"
)

select opt in "${options[@]}"; do
    case $REPLY in
        1) 
            echo "Running RustScan for initial port scan..."
            ports=$(rustscan -a "$target" --range 1-65535 -g)
            echo "Detected open ports: $ports"
            echo "Running Nmap on detected ports..."
            nmap -A -p "$ports" "$target"
            break
            ;;
        2)
            echo "Running RustScan for initial port scan..."
            ports=$(rustscan -a "$target" --range 1-65535 -g)
            echo "Detected open ports: $ports"
            echo "Running Nmap vulnerability scan on detected ports..."
            nmap -p "$ports" --script=vuln "$target"
            break
            ;;
        3)
            echo "Running RustScan for initial port scan..."
            ports=$(rustscan -a "$target" --range 1-65535 -g)
            echo "Detected open ports: $ports"
            echo "Running combined Nmap scan on detected ports..."
            nmap -A -p "$ports" --script=vuln "$target"
            break
            ;;
        4)
            read -p "Enter specific ports (e.g., 22,80): " ports
            echo "Running Nmap on specific ports..."
            nmap -p "$ports" "$target"
            break
            ;;
        5)
            echo "Running RustScan for a quick port scan..."
            rustscan -a "$target"
            break
            ;;
        6)
            echo "Running Nmap without RustScan..."
            read -p "Enter Nmap options (e.g., -A -p-): " nmap_options
            nmap $nmap_options "$target"
            break
            ;;
        7)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Try again."
            ;;
    esac
done
