#!/bin/bash
# Fixed version of the health check script
# Henry Alvarez - CIS 245
# Changed the log path, removed the sleep commands, and fixed the network check.

# Thresholds for warnings (change these if needed)
CPU_THRESHOLD=85
MEM_THRESHOLD=85
LOGFILE="/var/log/server_health_$(date +%Y%m%d).log"

# Writes the header for the report
headerWriter() {
    {
        echo "--------------------------------------"
        echo "Server Health Report - $(date)"
        echo "--------------------------------------"
    } >> "$LOGFILE"
}

# Calculate CPU usage
checkCPU() {
    echo "Checking CPU..." >> "$LOGFILE"
    # Using /proc/stat because top works differently on CentOS vs Ubuntu
    # Learned in CIS 245 Server Security Lab
    CPU_USAGE=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.2f\n", usage}')
    echo "CPU Usage: ${CPU_USAGE}%" >> "$LOGFILE"
    
    if awk -v u="$CPU_USAGE" -v t="$CPU_THRESHOLD" 'BEGIN {exit !(u > t)}'; then
        echo "WARNING: CPU usage is high." >> "$LOGFILE"
    fi
    echo "" >> "$LOGFILE"
}

# Check memory
checkMemory() {
    echo "Checking memory..." >> "$LOGFILE"
    mem=$(free -m | grep Mem | awk '{print $3}')
    total=$(free -m | grep Mem | awk '{print $2}')
    perc=$(awk "BEGIN {print ($mem/$total)*100}")
    
    echo "Memory in use: ${perc}%" >> "$LOGFILE"
    if awk -v p="$perc" -v t="$MEM_THRESHOLD" 'BEGIN {exit !(p > t)}'; then
        echo "WARNING: Memory usage is high." >> "$LOGFILE"
    else
        echo "Memory usage is normal." >> "$LOGFILE"
    fi
    echo "" >> "$LOGFILE"
}

# Check disk usage
checkDisk() {
    echo "Checking disk usage..." >> "$LOGFILE"
    df -h | grep '^/' | awk '{print "Disk:", $1, "Used:", $5}' >> "$LOGFILE"
    echo "" >> "$LOGFILE"
}

# Check network
checkNetwork() {
    echo "Checking network interface..." >> "$LOGFILE"
    # Checking if the interface has an IP instead of pinging Google
    # Learned in CIS 245 Networking Lab
    if ip -4 addr show enp0s3 | grep -q "inet "; then
        IP_ADDR=$(ip -4 addr show enp0s3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
        echo "Network appears... there (Interface up with IP: $IP_ADDR)." >> "$LOGFILE"
    else
        echo "No IP address found on enp0s3. Maybe you're offline." >> "$LOGFILE"
    fi
    echo "" >> "$LOGFILE"
}

# Main function to run all checks
main() {
    echo "Starting health check. Hold on..." >> "$LOGFILE"
    headerWriter
    checkCPU
    checkMemory
    checkDisk
    checkNetwork
    echo "Done! Report saved to $LOGFILE" >> "$LOGFILE"
}

# Run the script
main
exit 0
