#!/bin/bash
#
# net_troubleshoot.sh - Interactive network troubleshooting helper
# Author: Henry Alvarez
# Course: CIS-245 Linux Administration
# Date: 2026-10-12
#
# Purpose: Ask which server type the user is on, then give step-by-step
#          troubleshooting suggestions for common network problems.
#          Covers CentOS (dnf/NetworkManager) and Ubuntu (apt/systemd-networkd).
#

echo "=================================================="
echo " Network Troubleshooting Helper"
echo "=================================================="
echo ""
echo "Which server are you working on?"
echo "  1) CentOS Stream 10"
echo "  2) Ubuntu 26.04"
echo ""
read -p "Enter 1 or 2: " SERVER
echo ""

if [ "$SERVER" != "1" ] && [ "$SERVER" != "2" ]; then
    echo "Invalid choice. Run the script again and pick 1 or 2."
    exit 1
fi

echo "What kind of problem are you troubleshooting?"
echo "  1) No internet connectivity at all"
echo "  2) Setting a static IP address"
echo "  3) DNS is not resolving hostnames"
echo "  4) Trace the path to a common website"
echo ""
read -p "Enter 1, 2, 3, or 4: " PROBLEM
echo ""

# ---- CentOS branch ----
if [ "$SERVER" = "1" ]; then

    if [ "$PROBLEM" = "1" ]; then
        echo "=== CentOS: No Internet Connectivity ==="
        echo ""
        echo "1. Check the interface is up:"
        echo "   ip link show"
        echo ""
        echo "2. Check you have an IP address:"
        echo "   ip -4 addr"
        echo ""
        echo "3. Check the default route exists:"
        echo "   ip route"
        echo "   (you should see a line starting with 'default via')"
        echo ""
        echo "4. Ping the gateway directly:"
        echo "   ping -c 3 <gateway-ip>"
        echo ""
        echo "5. Ping an external IP (skips DNS):"
        echo "   ping -c 3 8.8.8.8"
        echo ""
        echo "6. Restart the network service:"
        echo "   sudo systemctl restart NetworkManager"
        echo ""
        echo "7. Check NetworkManager state:"
        echo "   nmcli device status"

    elif [ "$PROBLEM" = "2" ]; then
        echo "=== CentOS: Setting a Static IP ==="
        echo ""
        echo "1. First find your current connection name:"
        echo "   nmcli connection show"
        echo ""
        echo "2. Set a static IPv4 address (replace values with yours):"
        echo "   sudo nmcli connection modify <name> ipv4.method manual \\"
        echo "     ipv4.addresses 192.168.1.50/24 \\"
        echo "     ipv4.gateway 192.168.1.1 \\"
        echo "     ipv4.dns 8.8.8.8"
        echo ""
        echo "3. Apply the change:"
        echo "   sudo nmcli connection up <name>"
        echo ""
        echo "4. Verify:"
        echo "   ip -4 addr"
        echo "   ip route"
        echo ""
        echo "Note: doing this over SSH will drop your connection."
        echo "Have console access before you change networking."

    elif [ "$PROBLEM" = "3" ]; then
        echo "=== CentOS: DNS Not Resolving ==="
        echo ""
        echo "1. Check what DNS servers are configured:"
        echo "   cat /etc/resolv.conf"
        echo ""
        echo "2. Test resolution directly with dig:"
        echo "   dig google.com"
        echo "   dig @8.8.8.8 google.com"
        echo ""
        echo "3. Quick lookup test with nslookup:"
        echo "   nslookup google.com"
        echo ""
        echo "4. If DNS servers are wrong, set them:"
        echo "   sudo nmcli connection modify <name> ipv4.dns \"8.8.8.8 8.8.4.4\""
        echo "   sudo nmcli connection up <name>"
        echo ""
        echo "5. Confirm the change:"
        echo "   cat /etc/resolv.conf"

    elif [ "$PROBLEM" = "4" ]; then
        echo "=== CentOS: Trace Path to a Website ==="
        echo ""
        echo "1. Run tracepath to google.com:"
        echo "   tracepath google.com"
        echo ""
        echo "2. Alternative with traceroute (if installed):"
        echo "   traceroute google.com"
        echo ""
        echo "3. If tracepath is missing, install it:"
        echo "   sudo dnf install -y tracepath"
        echo ""
        echo "Reading the output: each line is a router hop between you"
        echo "and the destination. If lines start showing * * *, that is"
        echo "where the path stops responding. That usually points at"
        echo "where the problem is."
    fi

# ---- Ubuntu branch ----
elif [ "$SERVER" = "2" ]; then

    if [ "$PROBLEM" = "1" ]; then
        echo "=== Ubuntu: No Internet Connectivity ==="
        echo ""
        echo "1. Check the interface is up:"
        echo "   ip link show"
        echo ""
        echo "2. Check you have an IP address:"
        echo "   ip -4 addr"
        echo ""
        echo "3. Check the default route:"
        echo "   ip route"
        echo ""
        echo "4. Ping the gateway:"
        echo "   ping -c 3 <gateway-ip>"
        echo ""
        echo "5. Ping an external IP:"
        echo "   ping -c 3 8.8.8.8"
        echo ""
        echo "6. Restart the network service:"
        echo "   sudo systemctl restart systemd-networkd"
        echo ""
        echo "7. Apply any netplan changes:"
        echo "   sudo netplan apply"

    elif [ "$PROBLEM" = "2" ]; then
        echo "=== Ubuntu: Setting a Static IP ==="
        echo ""
        echo "1. Look at the current netplan config:"
        echo "   ls -l /etc/netplan/"
        echo "   sudo cat /etc/netplan/*.yaml"
        echo ""
        echo "2. Edit the netplan file:"
        echo "   sudo nano /etc/netplan/00-installer-config.yaml"
        echo ""
        echo "3. Change the config to look like this (adjust for your IPs):"
        echo "   network:"
        echo "     version: 2"
        echo "     ethernets:"
        echo "       enp0s3:"
        echo "         dhcp4: no"
        echo "         addresses:"
        echo "           - 192.168.1.50/24"
        echo "         routes:"
        echo "           - to: default"
        echo "             via: 192.168.1.1"
        echo "         nameservers:"
        echo "           addresses: [8.8.8.8, 8.8.4.4]"
        echo ""
        echo "4. Apply the config:"
        echo "   sudo netplan apply"
        echo ""
        echo "5. Verify:"
        echo "   ip -4 addr"
        echo "   ip route"
        echo ""
        echo "Note: over SSH this will drop your session. Use console."

    elif [ "$PROBLEM" = "3" ]; then
        echo "=== Ubuntu: DNS Not Resolving ==="
        echo ""
        echo "1. Check what DNS is being used (Ubuntu uses systemd-resolved):"
        echo "   resolvectl status"
        echo ""
        echo "2. Check the resolv.conf symlink:"
        echo "   ls -l /etc/resolv.conf"
        echo ""
        echo "3. Test resolution with dig:"
        echo "   dig google.com"
        echo "   dig @8.8.8.8 google.com"
        echo ""
        echo "4. If DNS needs changing, edit the netplan file:"
        echo "   sudo nano /etc/netplan/00-installer-config.yaml"
        echo "   add a nameservers section under enp0s3"
        echo ""
        echo "5. Apply and verify:"
        echo "   sudo netplan apply"
        echo "   resolvectl status"

    elif [ "$PROBLEM" = "4" ]; then
        echo "=== Ubuntu: Trace Path to a Website ==="
        echo ""
        echo "1. Run tracepath to google.com:"
        echo "   tracepath google.com"
        echo ""
        echo "2. Alternative with traceroute:"
        echo "   traceroute google.com"
        echo ""
        echo "3. If tracepath is missing, install it:"
        echo "   sudo apt install -y iputils-tracepath"
        echo ""
        echo "Reading the output: each line is a hop. If lines show"
        echo "* * * that is where the path stopped responding. That"
        echo "usually tells you where the problem is."
    fi
fi

echo ""
echo "Done. If these steps did not solve it, document what you tried"
echo "and what output you got at each step."
