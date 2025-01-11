#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <IP> <Domain>"
    exit 1
fi

target=$1
domain=$2

if grep -q "$domain" /etc/hosts; then
    sudo sed -i "s/^[^#]*\b$domain\b.*/$target $domain/" /etc/hosts
    echo "IP for $domain was reset"
else
    echo "$target $domain" | sudo tee -a /etc/hosts > /dev/null
    echo "New entry for $domain with IP $target"
fi
