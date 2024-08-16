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
