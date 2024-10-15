# Tailscale
Tailscale is pretty cool and probably something more nerds should use.
It basically lets you take your LAN with you which enables a lot of neat things
like being able to `ssh` into your systems as if you're home, block your AC from
accessing the internet (seriously, wtf, it is an AC!) but still be able to
remotely control it when not home, or you can even use it to share streaming
services with your friends and relatives even when they limit by IP address
because you can make it look like your traffic is coming through their house!
There's also cool things like being able to use your
[PiHole](https://pi-hole.net/) from anywhere or forcing all your traffic through
[Mullvad](https://mullvad.net)!
Why even use the main internet anymore!?

# Setting Up
The free account allows you to have 3 users (defined by email) and 100 devices
connected (you can pay $0.50 for each additional device per month), but this is
probably sufficient for most people. 
You could also look at [Headscale](https://headscale.net/) if you want a fully
open sourced self-hosted version, but it isn't as feature rich.

The main setup is fairly easy and you can just use their script (it is a
`curl`-`bash`...) and you'll be provided with a link where you need to
authenticate. So you can do this on headless systems (make sure to be
disconnected from any VPNs when doing this). It'll really just use your package
manager and then run `systemctl enable --now tailscale.service` so you can do
that manually. That'll provide you the link.

You can see your machines at the [admin
console](https://login.tailscale.com/admin/machines), which will also provide
you with the docs to add devices. 

If you want to be completely headless you can use an [auth
key](https://tailscale.com/kb/1085/auth-keys) and run 
`sudo tailscale up --authkey=<insert-key>`

## Setting Up A Raspberry Pi or Arm Linux
Some arm distros don't have the newest versions of tailscale in their repos for
some reason so we can manually install via the binaries.
Maybe someone can point the tailscale team towards this and they can either
correct me or write a better install script ;)
Do this if you cannot install an up to date version the normal way.

Go to the [tailscale binary package
list](https://pkgs.tailscale.com/stable/#static).
Extracting the tarball you should see these files

```bash
$ ls -l *
-rwxr-xr-x 1 foo foo  17M Mth 69 04:20 tailscale
-rwxr-xr-x 1 foo foo  33M Mth 69 04:20 tailscaled

systemd:
total 8.0K
-rw-r--r-- 1 foo foo 287 Mth 69 04:20 tailscaled.defaults
-rw-r--r-- 1 foo foo 632 Mth 69 04:20 tailscaled.service
```

We can move them to the appropriate places

```bash
# Change permissions and move to /usr/bin
# sudo chmod 644 tail* 
# sudo chown root:root tail*
sudo chown root:root -R * # will get the systemd files too
sudo mv tailscale* /usr/bin/
# Move systemd files to correct location
# sudo chown root:root systemd/*
sudo mv systemd/tailscaled.service /usr/lib/systemd/system
sudo mv systemd/tailscaled.defaults /etc/default/tailscaled

# Restart the systemctl daemon then start tailscaled
sudo systemctl daemon-reload
sudo systemctl enable --now tailscaled.service
```

Note that the `systemd` files go in different locations. If you read
`tailscaled.service` you'll see that it points to `/etc/default/tailscaled` and
I confirmed that these are the correct locations by checking on a distro that
installed tailscale via `pacman`.

Check that things are working with

```bash
$ sudo systemctl status tailscaled.service
$ sudo tailscale up
$ tailscale ip -4
# returns your tailscale ip address
```

It is a good idea to run `sudo tailscale set --auto-update` but I'm not sure how
this works with binaries, I'll update if it becomes an issue.


# System Hardening
The first thing to do is set up [tailnet lock](https://tailscale.com/kb/1226/tailnet-lock). This means you have some trusted
machines that act as verification for newly added machines.
It works by public private key pairs, like we'd see in `ssh`.

If your machine goes down and you need to sign again, check via `tailscale lock
status` and you'll get the node's lock key and it'll tell you how to lock it.
It might happen that all your machines go off and you need to do this on more
than one.

## Systemd
Like all services, we want to harden.
On their [linux instructions](https://tailscale.com/kb/1036/install-arch) they
suggest editing `/usr/lib/sysctl.d/50-defaults.conf` to change 
```bash
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1
```

Might want to read some [RedHat
'Docs'](https://access.redhat.com/solutions/53031) where they suggest running
the command `$ sysctl -a 2>/dev/null | grep "\.rp_filter"` so you can see what
everything is set to.
You can also take those values and write them individually like `sudo sysctl -w
net.ipv4.conf.default.rp_filter=1`

Basically, the `rp_filter` makes IP Spoofing harder. `0` means no filtering (so
you won't detect spoofing), `1` means strict (reject anything that looks to come
from where it isn't expected), and `2` (loose) is a common default that tries to be
strict but will fall back if a packet's source address is reachable by *any*
interface. `1` is recommended to prevent IP spoofing fro DDoS attacks and `2` is
recommended for [asymmetric routing](https://support.riverbed.com/bin/support/static/pcr9vojfp932f0gmdicklcnkmq/html/iu06209f7na4qeqjk1le65qpu2/sh_ex_5.5_ug_html/index.html#page/sh_ex_5.5_ug_html/setupAdvNet_asymmetric.html) 
and anything "complex".

Be sure to take note at what these were originally set to (probably `*.all.*`
was set to `0` and the rest were to `2`).

# Using Mullvad or a VPN
By default, if you are running a machine on Mullvad, or something else,
constantly, then tailscale will block your internet.
Bummer. 
More annoying, setting up a [Mullvad Exit
Node](https://tailscale.com/kb/1258/mullvad-exit-nodes) requires paying
***Tailscale*** $5/mo!
Sure, it is what you pay Mullvad, but you can send them cash in the mail if
you wanted to.
While I trust Tailscale (you'd need to to do what we're doing!) we don't want to
be limited by such arbitrary constraints! 

So let's try this instead, we'll setup a basic raspberry pi and install mullvad
on it, then set that pi as an exit node.
Now we can use any machine to exit through that pi.
Bonus, set up a second pi to use as an exit node that's not on mullvad.
Then you can choose where you want to exit through in case you're getting
blocked. 

# Services
Services can be a little confusing but aren't too hard once you get it.
You might not even need this!
If you're fine accessing by ip addresses you don't need to worry about this.
You can just type in the `100.*.*.*` number tailscale gives you with `:port` and
you're good to go!

*** TODO: (not working) ***

Here's some examples (you'll likely need sudo)

```bash
# Check your services
tailscale serve status
# Expose a service (jellyfin) that works via http or https
tailscale serve --bg --set-path /jellyfin https+insecure://localhost:8096
# Turn off that service 
tailscale serve localhost:8096 off
# Turn off all services
tailscale serve reset
```

# Mullvad on Exit (WIP)
While tailscale has an official [Mullvad exit
node](https://tailscale.com/kb/1258/mullvad-exit-nodes) method, it requires you
to pay for Mullvad through them.
Cool, but we want more flexibility.
If we're doing this for privacy and want to minimize our footprint, then let's
try to do it ourselves!
Plus, if we can figure it out we'll be able to do it with
[Headscale](https://headscale.net/)!
But mostly, for fun, because that's how we learn things!

So what do we need to know?
Tailscale and Mullvad are using
[wireguard](https://wiki.archlinux.org/title/WireGuard), so we need to
understand that.
My link to headscale is also helpful, because it openly discusses how tailscale
works!
So we need to understand DNS (possibly [Split-Horizon
DNS?](https://en.wikipedia.org/wiki/Split-horizon_DNS))

```bash
# Check mullvad connection
curl https://am.i.mullvad.net/connected
```


# TODO
- [ ] Mullvad 
- [ ] Exit Nodes
- [ ] Services (`tailscale serve`)
    - [ ] Containers
- [ ] File drop
- [ ] PiHole
- [ ] DNS
    - [ ] SSL Certs

## Maybe todo?
- [ ] PAM
- [ ] OAuth
- [ ] Webhooks 

# Resources
- [Reddit showing motivation like game streaming](https://www.reddit.com/r/SteamDeck/comments/12o1lre/dont_sleep_on_tailscale_it_is_borderline_magical/)
