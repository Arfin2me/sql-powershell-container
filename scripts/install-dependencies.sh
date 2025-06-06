#!/bin/bash

set -e
echo "[+] Installing base dependencies..."

apt-get update && \
apt-get install -y \
    curl \
    gnupg \
    apt-transport-https \
    software-properties-common \
    unixodbc-dev \
    wget \
    ca-certificates \
    iptables && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*
