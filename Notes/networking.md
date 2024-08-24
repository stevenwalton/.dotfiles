# Setting up iptables
You usually come with iptables installed, we'll assume it is.

```bash
###### Basic commands ###### 
###### requires sudo ###### 
iptables -L # see rules
iptables -L -n # same but no DNS lookup
iptables -F # Flush rules (start over!)

```

# Firewalld
[Firewalld](https://wiki.archlinux.org/title/Firewalld) is a firewall by RedHat
that's based on [nftables](https://wiki.archlinux.org/title/Nftables).

What's nice is being able to define the service easily by the service name. 
```bash
# print predefined services
firewall-cmd --get-services
# show running services
firewall-cmd --list-services
# Add a service by name (e.g. ssh)
firewall-cmd --add-service ssh
# add it permanently 
firewall-cmd --add-service ssh --permanent
# Do so temporarily (1 hour. Also knows 'm' for minutes)
firewall-cmd --add-service ssh --timeout=1h
# use `--runtime-to-permanent` to make a temp a permanent
```
Firewalld also has a bunch of [rich
rules](https://man.archlinux.org/man/firewalld.richlanguage.5) ([more
docs](https://firewalld.org/documentation/man-pages/firewalld.richlanguage.html))

For example, if you are using [`kdeconnect`](https://kdeconnect.kde.org/) you'd
need to run something like `sudo firewall-cmd --permanent --zone=public
--add-service=kdeconnect`

There's also [predefined
zones](https://firewalld.org/documentation/zone/predefined-zones.html)
```bash
drop # ~~fuck off~~ Drop anything from here. No reply
{public,external} # Don't trust other computers, so only selected incoming messages
dmz # untrusted, for computers in dmz with partial internal access
{work,home,internal} # Mostly trust computers, but selected incoming connections only 
trusted # what it says
```

# Block malicious clients
## Fail2Ban
Please note that [`OpenSSH 9.8`](https://www.openssh.com/txt/release-9.8) has a new parameter `PerSourcePenaltyExemptList`
which will accomplish similar things.
See `sshd_config(5)` (`man 5 sshd_config`)
[Fail2Ban](https://wiki.archlinux.org/title/fail2ban) creates a firewall jail.
If you do too many things that aren't allowed, you will go to jail and get
banned.
Useful to prevent things like brute force attacks in ssh, especially when
combined with knocking.

If you wish to instead of ban malicious actors to instead waste their time,
check out [endless ssh](https://github.com/skeeto/endlessh) and
[fail2ban-endlessssh](https://github.com/itskenny0/fail2ban-endlessh).
Basically sends an endless but slowly generating ssh banner.

## Setting up knockd
[knockd](https://man.archlinux.org/man/knockd.1) is a daemon that helps set up
[port knocking](https://wiki.archlinux.org/title/Port_knocking).
This is basically performing a secret knock for your "door" to reveal.
Or, you knock ports in a specific sequence and then are able to open a port like
ssh.
There's no feedback so process is difficult to brute force.



## CrowdSec
[CrowdSec](https://wiki.archlinux.org/title/CrowdSec) tries to detect malicious
clients and handle them by blocking or doing things like handing captcha or MFA
enforcement.

# Get CA cert handshake
openssl s_client -connect www.test.com:443 -prexit

# Want your IP info?
Curl various addresses at [ipinfo.io](https://ipinfo.io/)

# Setting Up SSL Certs
