# IPTables Lab

## Overview
Configured firewall rules on both CentOS and Ubuntu servers to allow specific services, block insecure traffic, and protect against DDoS attacks. Tested using ApacheBench and Wireshark.

## Requirement 1: Web Server & Forwarding
**Commands used:**
`sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT`
`sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT`
`sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080`

**Why I chose this:** (Source: Baeldung) I opened port 80 for standard web traffic and 8080 for the actual web service. The NAT table rule redirects traffic hitting port 80 to port 8080.

## Requirement 2-5: Filter Table Rules
**Commands used:**
`sudo iptables -A INPUT -p tcp --dport 3306 -j ACCEPT` (MySQL)
`sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT` (SSH)
`sudo iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT` (SSH return)
`sudo iptables -A INPUT -s 10.0.2.15 -j DROP` (Block specific host)
`sudo iptables -A INPUT -p tcp --dport 23 -j DROP` (Block Telnet)
`sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP` (Block Ping)

**Why I chose this:** 
- MySQL: (Source: CIS 245 Lab) 3306 is the default port. Allowed for remote database connections.
- SSH: (Source: CIS 245 Lab) Allowed port 22 for remote management. The OUTPUT rule ensures established connections stay open.
- Hosts: (Source: CIS 245 Lab) Used `-s` to block a specific IP from connecting.
- Telnet/Ping: (Source: Week 8 Security Lecture) Telnet is unencrypted, so I blocked port 23. I blocked ICMP echo-request to prevent network discovery.

## Requirement 6: DDoS Protection
**Command used:**
`sudo iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 10 -j REJECT`

**Why I chose this:** (Source: Tencent Cloud) This limits any single IP to 10 concurrent connections on port 80. If an attacker tries to flood the server, the 11th connection and beyond will be rejected with a TCP RST packet.

## Testing
I started a Python web server on port 8080 on Ubuntu, and used ApacheBench (`ab`) and a `curl` loop from CentOS to send 20 concurrent connections. I captured the traffic with `tcpdump` and verified the blocked connections in Wireshark by looking for TCP `[RST, ACK]` packets.

## Sources
- Baeldung IPTables Guide
- Tencent Cloud DDoS Mitigation
- CIS 245 IPTables Lab Document
- Week 8 Server Security Lecture (Holden-Gouveia)
