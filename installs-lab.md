Installs Lab
What I did
Installed six packages on both of my Linux servers (CentOS Stream 10 and Ubuntu 26.04.1 LTS) and documented the whole process. The assignment was to learn how package management works, how to find and modify repositories, and how to keep a change log with dates.

Packages installed
tmux

emacs

fail2ban

cowsay

lolcat

vim

CentOS Stream 10 installs
Installed via dnf. Each install was run with sudo dnf install -y <package>. Before each one, I ran date so the timestamp would appear in my screenshot.

Package	Date	Result
tmux	Oct 4, 2026	Installed tmux-3.3a
emacs	Oct 4, 2026	Installed
fail2ban	Oct 4, 2026	Needed EPEL, see notes below
cowsay	Oct 4, 2026	Installed
lolcat	Oct 4, 2026	Installed
vim	-	Already installed at /usr/bin/vim
Ubuntu 26.04.1 LTS installs
Installed via apt. Each install was run with sudo apt install -y <package>.

Package	Date	Result
tmux	Oct 5, 2026	Already newest version (3.6a)
emacs	Oct 5, 2026	Installed. Postfix config prompt appeared, chose "No configuration"
fail2ban	Oct 5, 2026	Installed cleanly from default repos
cowsay	Oct 5, 2026	Installed
lolcat	Oct 5, 2026	Installed
vim	Oct 5, 2026	Already newest version
Repositories
CentOS — Repo files live in /etc/yum.repos.d/. The two default files are centos.repo and centos-addons.repo. To see enabled repos, run dnf repolist. To add a third party repo, drop a .repo file into /etc/yum.repos.d/ or use sudo dnf config-manager --add-repo URL.

Ubuntu — Main repo list is /etc/apt/sources.list. Extra repos go into /etc/apt/sources.list.d/ as .list files. To add a PPA, use sudo add-apt-repository ppa:user/ppa-name. PPAs are Ubuntu-specific and do not exist on CentOS.

fail2ban notes
On CentOS, fail2ban is not in the default repos. The first install attempt failed with "No match for argument." I enabled EPEL with sudo dnf install epel-release -y, then reinstalled. That got the main package in, but the systemd service was still not found when I tried to start it. I installed the fail2ban-systemd package, which provides the systemd journal integration, and then the service started cleanly.

On Ubuntu, fail2ban installed from the default repos with no extra packages needed. The service started right away.

I did not change any of the default settings in /etc/fail2ban/jail.conf. The defaults watch SSH on port 22, ban for 10 minutes, and trigger after 5 failed attempts. Those are fine for a lab machine.

Services turned on
fail2ban on both servers, started and enabled so it comes up on boot.

EPEL repository on CentOS, enabled with sudo dnf install epel-release -y.

Nothing was turned off.

How to find installed packages
CentOS:

text
rpm -qa
rpm -q tmux
Ubuntu:

text
apt list --installed
dpkg -l tmux
On both servers, which <program> shows where a program's executable lives. Note that fail2ban is a background service, so which fail2ban comes back blank. Use which fail2ban-client or dpkg -l fail2ban instead.

Quick usage notes for each program
tmux — Run tmux to start a session. Split with Ctrl+b then % (vertical) or " (horizontal). Detach with Ctrl+b then d. Reattach with tmux attach. Exit with exit.

emacs — Open a file with emacs filename.txt. Exit with Ctrl+x then Ctrl+c.

fail2ban — Runs as a service. Check status with sudo systemctl status fail2ban. See jails with sudo fail2ban-client status.

cowsay — cowsay "message" prints a cow with the message. On Ubuntu the full path is /usr/games/cowsay.

lolcat — echo "hello" | lolcat prints text in rainbow colors.

vim — vim filename.txt. Press i to insert. Esc to leave insert mode. :wq to save and quit. :q! to quit without saving.

Challenges and how I handled them
Network drop on CentOS — My VM lost its IP address after I switched my host machine from Wi-Fi to a wired connection. The bridged adapter was still pointing at the old Wi-Fi card. Fix: switched the VM from Bridged to NAT mode in VirtualBox settings, which does not care what the host's physical adapter is.

fail2ban repo issue — Covered above in the fail2ban notes.

Postfix prompt during emacs install on Ubuntu — Postfix was pulled in as a dependency. Selected "No configuration" because the lab does not need mail services.

Sources
Instructor's Installs lab: https://www.aholdengouveia.name/LinuxAdmin/installs.html

CentOS documentation: https://docs.centos.org/

Ubuntu Server documentation: https://ubuntu.com/server/docs

man pages for dnf, apt, systemctl, and fail2ban

