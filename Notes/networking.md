# SSH
Here's the [man page](https://man.openbsd.org/ssh_config) for `ssh_config`,
which is for `~/.ssh/config` (same as `man ssh_config`).

- Client settings are `ssh_config`
- Server settings are `sshd_config`

- [Nice commend on HN explaining all
configs](https://news.ycombinator.com/item?id=43598837)

### Speeding Up Connections

```bash
Host *
    ControlMaster   auto
    ControlPath     /tmp/ssh-%r@%h:%p
    ControlPersist  yes
```

- `ControlMaster` will allow multiple sessions to be shared over the same
network connection. This can help speed things up
- `ControlPath` defines the location of that socket file. In our case it'll be
`/tmp/ssh-<remote-username>@<remote hostname>:<remote port>`. Note that this
will be on your local machine and may look like `ssh-steven@192.168.1.123:22`.
- `ControlPersist` puts the master command in the background. This can be
helpful if you're getting connections that close with `tmux` or similar
software. You can also specify an amount of time or use commands like
`ServerAliveInterval` and `ServerAliveCountMax`.

Sockets might be guessable so if you want to avoid that you can use something
like `%C` in the file, which is a hash of `%l%h%p%r%j` (local hostname, remote
hostname, remote port, remote username, contents of ProxyJump). You could be
better by using `%f` (fingerprint of server's host key), or `%K` (base64 encoded
host key) but these don't appear to work in OSX's implementation. :(

You can also be more descriptive by doing something like `ssh-%u@%l->%r@%n` to
specify the user on your local machine is pointing to user on remote machine.
You can even use spaces!

On some machines you may want to place this in a home folder or somewhere else
besides `/tmp` because `/tmp` is not a secure location 
(see [systemd Notes](/Notes/systemd.md))

### Matching
You can conditionally match addresses.
Say you're using [tailscale](https://tailscale.com/) and when you're on a local
network you want to use the local address but when you're on tailscale you want
to use the tailscale address.
You can do something like this!

```bash
Match Host mymachine exec "tailscale status | grep '^100'"
    Hostname    100.1.2.3
Host    mymachine
    Hostname    192.168.1.123
```
Note here that you ***need*** the `Host mymachine` part of `Match Host
mymachine`.
If you do not include that part then `ssh` in its infinite wisdom will match
***all*** `Hostname` keywords to `100.1.2.3` if the `Match` is found. 
It does not matter if you place the `Match` argument under `Host`. 
Unfortunately this does not seem to be stated well in documentation and 

This runs the command `tailscale status` and then greps for something starting
with "100", which is expected if you have done `tailscale up`.
If this returns something then the `Hostname` provided is used instead of the
one under `mymachine`.
Yo can do this multiple times and `Match` will use the first match.
So assuming you are on a mac you could do the following to always connect using
the local address when on your local network, regardless of tailscale status but
otherwise use another IP.
`ssh` will use the first match (use `ssh -v` to test and you will be able to see
the commands being issued.

```bash
Match exec "ipconfig getsummary en0 | grep -e '[^B]SSID.*YourHomeSSID'"
    Hostname    192.168.1.123
Match exec "tailscale status | grep '^100'"
    Hostname    100.1.2.3.
Host    mymachine
    Hostname    1.2.3.4
```

### Jumping 
`ProxyJump` is a really useful method where you can `ssh` through machines.
So essentially you connect to a machine through another machine.
This is really useful when you're needing to get through a firewall or there are
certain network restrictions.
There is also `ProxyCommand` that will run a command (using `exec`) on the
remote machine that is last in line.

```bash
Host foo
    HostName        100.10.10.123
    User            swalton
    IdentityFile    ~/.ssh/foo_key
    ProxyJump       steven@192.168.1.123
```
This would first ssh into `192.168.1.123` with username `steven` and key
`foo_key`, then to `100.10.10.123` with username `swalton`.

You can also do this conditionally!

```bash
Match host internalOnlyWorkMachine !exec "ifconfig en0 | grep 192.168.1.987"
    ProxyJump   user@AccessibleWorkMachine

Host internalOnlyWorkMachine
    Hostname    192.168.1.123
```

If your IP address at work was `192.168.1.987` and if you were trying to access
`internalOnlyMachine` from work then you would just do so. But if not (say,
you're at home) then you would first jump through `AccessibleWorkMachine`.
SSID is probably better to use than the IP because it might be rotating or you
could use both in conjunction. 

~~Note that in OSX you used to be able to run
`/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I`
but this no longer works and `wdutil` requires `sudo` AND doesn't show SSID (it
is redacted).
You can use 
`system_profiler SPAirPortDataType | awk '/Current Network/ {getline; $1=$1; print $0 | tr -d ':'";exit}'` 
but this is quite slow and probably not appropriate here.
`system_profiler SPNetworkDataType` is at least fast but won't show SSID.
Though it will give you your DNS and DHCP servers so can probably use that.
You could try using `networksetup -getairportnetwork en0` but you'll probably
get `You are not associated with an AirPort network.`
OR you could try `ioreg -l -n AirPortDriver | perl -lne 'print $1 if $_ =~ /IO80211SSID.*"(.*)"/;'`
but on Sequoia you get `<SSID Redacted>`.
So I guess classic ***WHAT THE FUCK APPLE?!***~~

On Mac (Sequoia), use any of the following
```bash
ipconfig getsummary en0 | grep -e '[^B]SSID' | cut -d ":" -f2 | tr -d ' '
ipconfig getsummary en0 | grep -e '[^B]SSID' | cut -d ":" -f5
ipconfig getsummary en0 | grep -e '[^B]SSID' | sed -E 's/^.*: (.*)/\1/g'
```
This can be very useful for the ssh matching

- [Visual Guide To SSH Tunneling & Port
Forwarding](https://ittavern.com/visual-guide-to-ssh-tunneling-and-port-forwarding/)
    - [HN comments](https://news.ycombinator.com/item?id=41596818) has some
        useful tricks
### Random Useful Things
In `ssh` there is a 'secret' command `~` that you can use.
You must enter this on a new command line.
This is an [escape character](https://man.openbsd.org/ssh#ESCAPE_CHARACTERS).
It will allow you to edit your ssh session on the fly.
Here's useful ones (note that it may appear like nothing is happening and that
the terminal just eats your `~` command. This is normal)
```bash
~? # Show help
~. # Kill current session
# suspend the session. Will return you to your normal terminal until you
# type the `fg` (foreground) command. Useful if you only have one terminal
# window
~^Z # (~ + ctrl-Z) 
~V / ~v # Increase or decrease verbosity. Great for debugging without re-entering

# Editing your current ssh session
~C  # Puts you in command mode. This must be run first
# Note that it might be disabled
ssh> -L 123:address:456 # Add port forwarding
ssh> -R 456:localhost:123 # Reverse of above
ssh> -KL 123:address:456 # Kill port forward (also works for R and D)
```

### ssh-agent
You can easily create a lot of `ssh-agent` processes running.
There are a number of ways to resolve this but I think the easiest is to use
[`~/.zlogout`](https://zsh.sourceforge.io/Guide/zshguide02.html#l9), where you 
check if `$SSH_AGENT_PID` is defined and then kill it if it is.
Another way is to use the trap function

You might be tempted to use `ssh -A` or `AgentForwarding` but this can create a
security risk by allowing users with root access to hijack your session.
Probably not that bad but if we don't have to introduce it, why do that?

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
