#!/bin/bash
#
# network_dump.sh - Dump network and system information
# Author: Henry Alvarez
# Course: CIS-245 Linux Administration
# Date: 2026-10-12
#
# Purpose: Collect a snapshot of the system and network state on this
#          server. Output goes to both the terminal and to a file in
#          ~/network_dumps/ with the date in the filename. Useful for
#          baseline documentation and for comparing before/after states
#          when troubleshooting.
#

TODAY=$(date +%Y-%m-%d)
HOST=$(hostname)
OUTFILE="$HOME/network_dumps/network_dump_${TODAY}_henry_${HOST}.txt"

mkdir -p "$HOME/network_dumps"

section() {
    echo "" | tee -a "$OUTFILE"
    echo "===============================================" | tee -a "$OUTFILE"
    echo "  $1" | tee -a "$OUTFILE"
    echo "===============================================" | tee -a "$OUTFILE"
}

run() {
    echo "" | tee -a "$OUTFILE"
    echo "\$ $*" | tee -a "$OUTFILE"
    eval "$@" 2>&1 | tee -a "$OUTFILE"
}

echo "Network Information Dump" | tee -a "$OUTFILE"
echo "Host: $HOST" | tee -a "$OUTFILE"
echo "Date: $(date)" | tee -a "$OUTFILE"
echo "User: $(whoami)" | tee -a "$OUTFILE"

section "System Information"
run "hostname"
run "hostnamectl"
run "uname -r"
run "cat /etc/os-release 2>/dev/null || cat /etc/centos-release"

section "IPv4 Addresses"
run "ip -4 addr"

section "IPv6 Addresses"
run "ip -6 addr"

section "Routing Table"
run "ip route"

section "DNS Configuration"
run "cat /etc/resolv.conf"

section "Listening Ports"
run "ss -tuln"

section "Network Service"
run "systemctl is-active NetworkManager 2>/dev/null || systemctl is-active systemd-networkd"

section "Interface Statistics"
run "ip -s link"

section "ARP / Neighbor Table"
run "ip neigh"

section "Connectivity Test - IP"
run "ping -c 3 8.8.8.8"

section "Connectivity Test - Hostname"
run "ping -c 3 google.com"

section "Path Trace"
run "tracepath google.com"

echo "" | tee -a "$OUTFILE"
echo "Done. Full output saved to: $OUTFILE" | tee -a "$OUTFILE"
