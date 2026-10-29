Installs, Updates, and Documentation Lab

## Overview
Installed six packages on both CentOS Stream 10 and Ubuntu 26.04.1 LTS (tmux, emacs, fail2ban, cowsay, lolcat, and vim). Documented the installation process, repository management, service configurations, and how to test each program.

## CentOS Stream 10 Installs
Installed via `dnf`. Each install was run with `sudo dnf install -y <package>`.
- **tmux:** Installed tmux-3.3a.
- **emacs:** Installed successfully.
- **fail2ban:** Not in default repos. Enabled EPEL, then installed `fail2ban-systemd` to get the systemd service working.
- **cowsay:** Installed successfully.
- **lolcat:** Installed successfully.
- **vim:** Already installed.

## Ubuntu 26.04.1 LTS Installs
Installed via `apt`. Each install was run with `sudo apt install -y <package>`.
- **tmux:** Already newest version (3.6a).
- **emacs:** Installed. (Postfix configuration prompt appeared, selected "No configuration").
- **fail2ban:** Installed cleanly from default repos.
- **cowsay:** Installed successfully.
- **lolcat:** Installed successfully.
- **vim:** Already newest version.

## Repositories
- **CentOS:** Repo files live in `/etc/yum.repos.d/`. Enabled EPEL using `sudo dnf install epel-release -y`.
- **Ubuntu:** Main repo list is `/etc/apt/sources.list`. Extra repos go into `/etc/apt/sources.list.d/`.

## Fail2Ban Notes
On CentOS, fail2ban required the EPEL repo and the `fail2ban-systemd` package for systemd integration. The service was started and enabled on both servers (`sudo systemctl start fail2ban` and `sudo systemctl enable fail2ban`). No settings were changed in `/etc/fail2ban/jail.conf`.

## How to open, use, and close each program

**tmux** 
Open a session with `tmux`. Split the window with Ctrl+b then % (vertical) or " (horizontal). Detach with Ctrl+b then d. Reattach with `tmux attach`. Exit with `exit`.

**emacs** 
Open a file with `emacs filename.txt`. If there is no GUI, use `emacs -nw`. Exit with Ctrl+x then Ctrl+c.

**fail2ban** 
Runs as a background service. Check status with `sudo systemctl status fail2ban`. See jails with `sudo fail2ban-client status`.

**cowsay** 
Run `cowsay "message"` to print a cow with the message. On Ubuntu, use `/usr/games/cowsay`.

**lolcat** 
Pipe text into it: `echo "hello" | lolcat` to print text in rainbow colors.

**vim** 
Open a file with `vim filename.txt`. Press `i` to insert. Press `Esc` to leave insert mode. Type `:wq` to save and quit, or `:q!` to quit without saving.
