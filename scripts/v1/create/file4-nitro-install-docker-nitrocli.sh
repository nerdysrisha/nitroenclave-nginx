#!/bin/bash
set -euo pipefail

echo "=== Installing Nano ==="
sudo dnf install -y nano 

echo "=== Installing Docker ==="
sudo dnf install -y docker
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

echo "=== Installing Nitro Enclaves ==="
sudo dnf install -y aws-nitro-enclaves-cli aws-nitro-enclaves-cli-devel
sudo usermod -aG ne "$USER"

echo "=== Starting nitro-enclaves-allocator service ==="
sudo systemctl enable --now nitro-enclaves-allocator

echo "=== Waiting for allocator to settle ==="
sleep 3

echo "=== Verifying service status ==="
sudo systemctl status nitro-enclaves-allocator --no-pager

echo "=== Current Nitro Enclaves Allocation configuration ==="
sudo cat /etc/nitro_enclaves/allocator.yaml 

echo "=== CPU info ==="
lscpu | grep '^CPU(s):'
