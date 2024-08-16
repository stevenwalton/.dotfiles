# Setting up iptables
You usually come with iptables installed, we'll assume it is.

```bash
###### Basic commands ###### 
###### requires sudo ###### 
iptables -L # see rules
iptables -L -n # same but no DNS lookup
iptables -F # Flush rules (start over!)

```

# Setting up knockd
[knockd](https://man.archlinux.org/man/knockd.1) is a daemon that helps set up
[port knocking](https://wiki.archlinux.org/title/Port_knocking).
This is basically performing a secret knock for your "door" to reveal.
Or, you knock ports in a specific sequence and then are able to open a port like
ssh.
There's no feedback so process is difficult to brute force.

# Fail2Ban
Please note that [`OpenSSH 9.8`](https://www.openssh.com/txt/release-9.8) has a new parameter `PerSourcePenaltyExemptList`
which will accomplish similar things.
See `sshd_config(5)` (`man 5 sshd_config`)
[Fail2Ban](https://wiki.archlinux.org/title/fail2ban) creates a firewall jail.
If you do too many things that aren't allowed, you will go to jail and get
banned.
Useful to prevent things like brute force attacks in ssh, especially when
combined with knocking.

# Get CA cert handshake
openssl s_client -connect www.test.com:443 -prexit

# Want your IP info?
Curl various addresses at [ipinfo.io](https://ipinfo.io/)

# Setting Up SSL Certs
