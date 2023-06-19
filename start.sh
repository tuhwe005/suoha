#!/bin/bash

# Download files
wget -q https://raw.githubusercontent.com/tuhwe005/suoha/main/censys.sh
wget -q https://raw.githubusercontent.com/tuhwe005/suoha/main/ip.txt
wget -q https://raw.githubusercontent.com/tuhwe005/suoha/main/iptestport

# Run asscan.sh script
./censys.sh
