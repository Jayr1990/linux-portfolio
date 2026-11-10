#!/bin/bash
# Troubleshooting Script - Generated with help from ChatGPT
# Modified by: Henry Alvarez
# Learned in CIS 245 Server Security Lab

LOG_FILE="/var/log/troubleshoot_$(date +%Y%m%d_%H%M%S).log"

echo "=== System Troubleshooting Report ===" > $LOG_FILE
echo "Date: $(date)" >> $LOG_FILE

# Check 1: Is the bash shell present? (The B0rk script deletes this)
echo "--- Checking for /bin/bash ---" >> $LOG_FILE
if [ -f /bin/bash ]; then
    echo "OK: /bin/bash exists." >> $LOG_FILE
else
    echo "CRITICAL: /bin/bash is missing!" >> $LOG_FILE
fi

# Check 2: Are the kernel files present? (The B0rk script deletes these)
echo "--- Checking /boot directory ---" >> $LOG_FILE
if ls /boot/vmlinuz-* >/dev/null 2>&1; then
    echo "OK: Kernel files found in /boot." >> $LOG_FILE
else
    echo "CRITICAL: No kernel files found in /boot!" >> $LOG_FILE
fi

# Check 3: Is networking up? (The B0rk script breaks this)
echo "--- Checking Network Connectivity ---" >> $LOG_FILE
ping -c 3 8.8.8.8 >> $LOG_FILE 2>&1
if [ $? -eq 0 ]; then
    echo "OK: Network is reachable." >> $LOG_FILE
else
    echo "CRITICAL: Cannot reach the internet." >> $LOG_FILE
fi

echo "Troubleshooting complete. Check $LOG_FILE for details."
