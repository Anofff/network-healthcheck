#!/bin/bash

# Log everything to screen and report file
exec > >(tee -a network_report.txt) 2>&1

echo "=================================="
echo "Network Health Check Report"
echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=================================="
echo

echo "Starting the network health check..."
echo

echo "=== SERVER INFORMATION ==="
echo "Hostname: $(hostname)"
echo "Current User: $(whoami)"
echo "Date/Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo "IP Address: $(hostname -I)"
echo "Default Gateway: $(ip route | grep '^default' | awk '{print $3}')"
echo "DNS Server: $(grep '^nameserver' /etc/resolv.conf | awk '{print $2}')"
echo

echo "=== INTERNET CONNECTIVITY ==="
if ping -c 2 8.8.8.8 > /dev/null 2>&1; then
    echo "Internet Connectivity: UP"
else
    echo "Internet Connectivity: DOWN"
fi
echo

echo "=== DNS RESOLUTION ==="
if nslookup google.com > /dev/null 2>&1; then
    echo "DNS Resolution: WORKING"
else
    echo "DNS Resolution: FAILED"
fi
echo

echo "=== WEBSITE AVAILABILITY ==="
for site in google.com github.com amazon.com lms.kode.camp; do
    if curl -s --max-time 5 -o /dev/null "https://$site"; then
        echo "$site : UP"
    else
        echo "$site : DOWN"
    fi
done

echo
echo "Network health check completed."
echo "=================================="