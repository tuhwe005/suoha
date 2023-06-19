#!/bin/bash

# Download files
wget -q https://raw.githubusercontent.com/tuhwe005/suoha/main/censys.sh
wget -q https://raw.githubusercontent.com/tuhwe005/suoha/main/ip.txt
wget -q https://raw.githubusercontent.com/tuhwe005/suoha/main/iptestport

# Set execute permission
chmod +x censys.sh
chmod +777 ip.txt
chmod +777 iptestport

# Run censys.sh script
./censys.sh
