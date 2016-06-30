#!/bin/bash

set -e

echo "Installing nodejs 5 and npm"
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install nodejs