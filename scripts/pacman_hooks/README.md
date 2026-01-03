Hooks for pacman.
Place them in `/etc/pacman.d/hooks/`

```bash
sudo mkdir /etc/pacman.d/hooks
sudo ln -s "${DOTFIFILE_DIR}/scripts/pacman_hooks"/* /etc/pacman.d/hooks/
```

You can find examples in `/usr/share/libalpm/` and more info with `man
alpm-hooks`

Naming follows traditional numeric ordering 

# Skeleton
Your hooks should look something like this

```bash
# Requiried.
# All 3 options are also required
# Operation and Target can be repeated
[Trigger]
Operation = Install | Upgrade | Remove 
Type = Path | Package
Target = <Path | PackageName >

# Required
# When and Exec are the only required options
[Action]
Description = ...
When = PreTransaction | PostTransaction
Exec = <Command>
Depends = <PkgName>
# Only works on PreTransaction
#   Causes transaction to abort if hook exits with non-zero status
AbortOnFail 
# Causes matched trigger targets to be passed to running hook
NeedsTargets 
```

# Hooks

- `10-get-news.hook`: PreTransaction to check the AUR news for important messages. If there are
any then send a copy to the user and root's mailboxes as well as make a toast
notification. This way we don't miss it or forget to check the news!
- `91-check-orphans.hook`: PostTransaction to warn about orphan packages
