Server Setup
What I did
I set up two Linux servers in VirtualBox for the CIS-245 course. The first is CentOS Stream 10 (Codename Coughlan) and the second is Ubuntu 26.04.1 LTS (Codename resolute). Both are command-line only servers, no GUI.

CentOS install
Installed CentOS Stream 10 minimal. Went through the Anaconda installer, set the root password, created a user called henry, and gave that user sudo privileges. After install, logged in at the console and ran:

ip addr

which showed the interface enp0s3 was up but had no IPv4 address. This was a networking problem. The VM was set to Bridged Adapter in VirtualBox but the bridge was pointing at my Wi-Fi card, which I had stopped using after switching my host machine to a wired connection two days earlier.

I fixed it by opening VirtualBox settings for the VM, going to Network, changing Attached to from Bridged Adapter to NAT. Then I started the VM back up and checked ip addr again. Now enp0s3 had an address of 10.0.2.15, which is the standard NAT address VirtualBox uses.

Since NAT hides the VM behind the host, I could not directly scp files to it from Windows. To fix that, I added a port forwarding rule in VirtualBox: host port 2222 forwards to guest port 22. Then from Windows CMD I could transfer files with:

scp -P 2222 "C:\path\to\file" henry@localhost:/home/henry/

Ubuntu install
Ubuntu 26.04.1 LTS installed from the server ISO. Same process: went through the installer, set up a user, gave them sudo. Network worked right away because the VM was already on NAT.

One difference I noticed: Ubuntu's clock is set to UTC by default, while CentOS picked up Eastern (EDT) from somewhere. So the timestamps on the two servers look different even though they are the same real moment. Not a problem, just something to be aware of when comparing logs.

What I learned
The difference between NAT, Bridged, and Host-only network modes in VirtualBox

How to set up port forwarding so I can scp into a NAT VM

Where the IPv4 address shows up in ip addr output

How to check the OS version with cat /etc/centos-release (CentOS) and lsb_release -a (Ubuntu)

Files and locations
CentOS user home: /home/henry

Ubuntu user home: /home/ubuntu

CentOS repo config: /etc/yum.repos.d/

Ubuntu apt sources: /etc/apt/sources.list and /etc/apt/sources.list.d/

Dates
CentOS install: Sept 6, 2026

Ubuntu install: Sept 6, 2026

Network fix on CentOS: Sept 6, 2026
