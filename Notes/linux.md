This is mostly stuff I forget.
This is not a good way to learn linux and is for someone who's already been
using it.

# Reporting System Info
Most people request things like `uname -a` but that doesn't give us much.
Instead we might want to use `inxi`.
You will find this more common on forms now and find requests for pasting things
like `inxi -Gxx | curl -F 'file=@-' 0x0.st` which will upload your graphics
information to 0x0.st, which can be temporarily read by other users. 

```bash
-A # Audo
-b # Basic info. What you'd want to share to tell someone your machine
-C # CPU, model, cache info, etc
-D # Disk info, including /dev location, vendor, model, and capacity
-F # Full. Probably too much into
-G # Graphics including your GPU, driver, and lots of nice info
-i # ip. This reveals your ip addresses so best to only use internally
-M # Machine info like mobo
-w # yes, even the fucking weather. Can add zip code or other info too
```

# Updating
## Nvidia drivers on Ubuntu
```bash
# Ubuntu drivers: 
# https://ubuntu.com/server/docs/nvidia-drivers-installation
# Archive: https://archive.is/20231119101129/https://ubuntu.com/server/docs/nvidia-drivers-installation

# See current drivers
cat /proc/driver/nvidia/version
# List drivers
sudo ubuntu-drivers list
sudo ubuntu-drivers list --gpgpu
# Install
sudo ubuntu-drivers install
# Auto detection for GPU
sudo ubuntu-drivers install --gpgpu
# If you have NVSwitch Hardware (Server)
sudo apt install nvidia-fabricmanager-525 libnvidia-nscq-525
```
If drivers are held back you might want to try `apt{,titude} full-upgrade`/`nala upgrade
--full`

## [Screen Tearing](https://wiki.archlinux.org/title/NVIDIA/Troubleshooting#Avoid_screen_tearing)
Try `nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"`
(You may need to install `nvidia-settings`)

If this resolves the issue then you will need to make it permanent. 
```bash
/etc/X11/xorg.conf.d/20-nvidia.conf
------------------------ ------------------------
Section "Device"
        Identifier "NVIDIA Card"
        Driver     "nvidia"
        VendorName "NVIDIA Corporation"
        BoardName  "GeForce GTX 1050 Ti"
EndSection

Section "Screen"
    Identifier     "Screen0"
    Device         "Device0"
    Monitor        "Monitor0"
    Option         "ForceFullCompositionPipeline" "on"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
EndSection
```
If you don't have that nvidia conf then run `# nvidia-xconfig`.
Pay attention to output. May be just easier to edit `/etc/X11/xorg.conf` but
better to be organized!

# Drive Management
## Partitioning Dives
`fdisk` is the most common but I like `cfdisk` because it is a bit easier to
use.
```bash
# Useful builtins
## We use format /dev/sdXY which would be similar to /dev/sda1 where X is the
## device letter and Y is the partition number
findmnt # shows 
findmnt --real # Shows only the real mounts, so a little less cluttered
lsblk -f # Also shows mount points and file system info

wipefs # wipes the filesystem and labels
wipefs -af /dev/sdXY # force write all. Useful if previously a ZFS pool

mkfs.ext4 /dev/sdXY # Makes the file system
mkswap /dev/sdXY # Makes swap space
```
- [RedHat on File System Types](https://access.redhat.com/articles/3129891):
useful if you are doing specialized stuff
- [RedHat on
Swap](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/storage_administration_guide/ch-swapspace)
| System Ram | Recommended Swap | Recommend Swap (if hibernate) |
|:-----------|-----------------:|------------------------------:|
| <= 2GB  |  2x RAM | 3x RAM |
| 2GB - 8GB | = RAM | 2x RAM |
| 8GB - 64GB | >4 GB | 1.5x RAM |
| >= 64GB | > 4GB | Not Recommended |

## Mounting Drives
The old way was to edit `/etc/fstab`, but now we probably want to use `systemd`
which will autogenerate fstab.
We should place files in `/etc/systemd/system` and give them the name
`path-to-mount-point.mount` (or `*.automount` if we want [on demand
mounting](https://unix.stackexchange.com/a/570987)).
If you still want to use fstab, see [systemd.mount](https://man.archlinux.org/man/systemd.mount.5#FSTAB)
```bash
# Example /etc/systemd/system/mnt-backup.mount
[Unit]
Description=Backup drive

[Mount]
What=/dev/disk/by-uuid/abcdefgh-1234-5678-ijklmnopqrst
Where=/mnt/backup
Type=ext4
# Use defaults options which is: rw,suid,dev,exec,auto,nouser,async
# Probably only potentially want ro (read only) and noexec (don't allow running executables)
# see `man mount` for more details
Options=defaults
# Create a directory (and parents) if needed
DirectoryMode=0755
# I don't like waiting 90 seconds
TimeoutSec=30

[Install]
# Tells us when to run this command. After boot but before GUI
# See table below and `man systemd.special` for mode information.
WantedBy=multi-user.target
```
Then you will need to run `sudo systemctl enable path-to-mount-point.mount` to
enable this (use the `--now` option to also do `start`, i.e. mount it now)

Here's a short table for reference provided by [Tobias Holm](https://unix.stackexchange.com/a/451617)
```
# Run Lvl Target Units                        Description
# 0       runlevel0.target, poweroff.target   Shut down and power off
# 1       runlevel1.target, rescue.target     Set up a rescue shell
# 2,3,4   runlevel[234].target,               Set up a non-gfx multi-user shell
#         multi-user.target
# 5       runlevel5.target, graphical.target  Set up a gfx multi-user shell
# 6       runlevel6.target, reboot.target     Shut down and reboot the system
```

# Arch and Endeavour
`mkinitcpio` -> `dracut`
