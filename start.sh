#!/bin/bash

# Download files
wget -q https://raw.githubusercontent.com/tuhwe005/suoha/main/censys.sh
wget -q https://raw.githubusercontent.com/tuhwe005/suoha/main/ip.txt
wget -q https://raw.githubusercontent.com/tuhwe005/suoha/main/iptestport

# Set execute permission
chmod +777 asscan.sh
chmod +777 masscan
chmod +777 iptest
chmod +777 locations.json

# Run asscan.sh script
./censys.sh
