[fail2ban](https://wiki.archlinux.org/title/Fail2ban) helps prevent brute
forcing. It will read logfiles and look for failed attempts and autoban.
These configuration files are not secret and we're a bit stricter than defaults
or templates on the archwiki.
These files are a good place to start but modify for your system.
We assume you are using `systemd` and `firewalld`.

`fail2ban` works by reading log files (typically `/var/log/`).
If your log files aren't in the default location, be sure to point to them.
You can also be more efficient by reading from the systemd journal.

# Commands
```bash
# View commands
fail2ban-client
# View enabled jails
fail2ban-client status
# Jail status
fail2ban-client status sshd
# Compact, show jailed
fail2ban-client banned
# Unban IP
fail2ban-client set <jail-name> unbanip <ip-address>

# Interactive mode (effectively prepends `fail2ban-client` to commands)
fail2ban-client -i
```
# Organization
- Files located in [jail.d/](./jail.d/) may be linked to `/etc/fail2ban/jail.d/`.
- Files located in [filter.d/](./filter.d/) may be linked to `/etc/fail2ban/filter.d/`
- [systemd_override.conf](./systemd_override.conf) should link to `/etc/systemd/system//ail2ban.service.d/override.conf`
