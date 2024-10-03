This is mostly stuff I forget.
This is not a good way to learn linux and is for someone who's already been
using it.

# Some Random Stuff For Noobs
Wonder what all those files in `/` are? `man hier`

# Initial configuring 
## Protecting your system from yourself and updates
You probably want to use [timeshift](https://wiki.archlinux.org/title/Timeshift).
This tool helps create regular snapshots which will help avoid and debug issues,
as you can roll back.
***Timeshift is NOT a data backup tool, it is a system backup tool***.
It won't protect user data, but it does protect system data.
This makes it lightweight, but you can include contents in `/home` if you wish
to do so.
Specifically, [timeshift-autosnap](https://gitlab.com/gobonja/timeshift-autosnap)
is a [Pacman Hook](https://wiki.archlinux.org/title/Pacman#Hooks) that will make a snapshot
prior to any updates.
You can also create snapshots with a systemd timer (don't use `cron`. `cron` is
a thing of the past).
There are also `apt` based hooks.
With a hook in place, you can *more* safely run automatic weekly updates.

I placed some `systemd` timers and service files in [`/systemd_files`](/systemd_files)

Note that if you're using Arch or Endeavour and ***systemd-boot*** that you
should not have timeshift reinstall grub files.
See the debugging section below.

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
Install [timeshift](https://wiki.archlinux.org/title/Timeshift) (and [pacman
hook](https://gitlab.com/gobonja/timeshift-autosnap)) to take incremental
backups. Do this before updating and reap the benefits.

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

# KDE
A useful tool might be to use [KDE
Connect](https://kdeconnect.kde.org/download.html).
This can allow you to control your computer by your phone and vise versa.
Need a mouse and keyboard? What about a presentation pointer? Can even run
commands!

[Note](https://userbase.kde.org/KDEConnect#I_have_two_devices_running_KDE_Connect_on_the_same_network.2C_but_they_can.27t_see_each_other) that it runs on a range of ports `1714-1764` but `firewallcmd` has got your
back
```bash
sudo firewall-cmd --permanent --zone=public --add-service=kdeconnect
sudo firewall-cmd --reload
```
You can even build on [OSX](https://community.kde.org/KDEConnect/Build_MacOS)
but should *build* not install.

# Arch and Endeavour
Instead of `mkinitcpio` see [`dracut`](https://wiki.archlinux.org/title/Dracut)

# Gotta Go Fast
Make your system faster!
First, we'll want to run
```bash
$ systemd-analyze blame
```
which will tell us the startup time for each service.
Often disks are a bit slow to startup.
Because of this, note that you will probably only need to load your disk that
the OS is on when booting and the rest can be handled later

We can also get some information graphically with
```bash
systemd-analyze plot > ~/bootup.svg
```
You might need to scroll to the right pretty far.
You can hover over the services and it might give you some more info.

# Debugging
There's lots to debug....


## Timeshift and can't mount /efi
This can be done easily by accident when doing a rollback (ask me how I know).
If this happens, you'll probably see an error on boot about not being able to
boot `/efi`. If this happens there's no need to worry. Load up a live-cd, then
mount your main drive

Here is an example of what your drive might look like *BEFORE* the live environment
You'll see these same things but the mount points will not be shown (they
aren't mounted!)

```bash
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    0 232.9G  0 disk
└─sda1        8:1    0 232.9G  0 part
nvme0n1     259:2    0   1.8T  0 disk
├─nvme0n1p1 259:3    0     1G  0 part /efi
├─nvme0n1p2 259:4    0   1.8T  0 part /
└─nvme0n1p3 259:5    0   8.8G  0 part [SWAP]
```

Now that you've mounted up the live-cd

```bash
$ mkdir tmp_home
$ sudo mount /dev/nvme01n1p2 tmp_home
$ arch-chroot tmp_home
```

You are now in the root of the old system
Now you can mount the efi partition

```bash
# mount /dev/nvme0n1p1 /efi
```

# You should check that it is mounted and let's look at disk usage
```
# du -ch --max-depth=3 /efi | sort -hr
553M    total
553M    /efi
552M    /efi/80b560bbc8e743de83929b15d1246828
278M    /efi/80b560bbc8e743de83929b15d1246828/6.11.1-arch1-1
275M    /efi/80b560bbc8e743de83929b15d1246828/6.6.52-1-lts
224K    /efi/EFI
108K    /efi/EFI/systemd
108K    /efi/EFI/BOOT
36K     /efi/loader
20K     /efi/loader/entries
4.0K    /efi/EFI/Linux
```

Notice that the images are quite large. Kinda unfortunate.
You can reinstall the kernels with the following command

```bash
# reinstall-kernels
```

reinstall-kernels is actually a script so you can run 
`cat /usr/bin/reinstall-kernels` and see that it will run
kernel-install on whatever is found from 
`find /usr/lib/modules -maxdepth 2 -type f -name vmlinuz`

You might run into a problem where you run out of space on /efi
If this happens you can remove a kernel with the following 
(we'll imagine we have the kerenl 6.10.1-arch1-1)

```bash
# kernel-install -v remove 6.10.1-arch1-1
```

The -v is unnecessary but helpful

You can view info about the generated image with (commands are the same)

```bash
# lsinitrd /efi/long_random_sequence/kernel_number/initrd |less
# lsinitrd /efi/80b560bbc8e743de83929b15d1246828/6.11.1-arch1-1/initrd | less
```

If you still have issues with 

## Login and then blank screen and cursor (Wayland)
Nvidia drivers?

It's always nvidia...

We need to edit the kernel so we have `nvidia_drm.modeset=1`

If you're using `grub` then edit and rebuild

```bash
# vi /etc/default/grub/
# grub-mkconfig -o /boot/grub/grub.cfg 
```

If you're using `systemd-boot` then

```bash
# vi /etc/kernel/cmdline
```

Here is what mine looks like for reference

```bash
nvme_load=YES nowatchdog rw root=UUID=abc123de-fg45-6789-123a-bcde4567fghi resume=UUID=1234abcd-567e-fghi-890j-kl123mnop456 nvidia_drm.modeset=1 rw
```

Still having issues? 

Try... 

## Downgrading

### Packages
There's a helpful tool [downgrade](https://github.com/archlinux-downgrade/downgrade) 
that makes it easier to downgrade.
You might need to do 

```bash
# downgrade nvidia nvidia-utils linux linux-headers
```

Make sure that `nvidia-utils` and `linux-headers` is in there!

### Kernel
Need to downgrade your kernel? Let's check if you have then on your system first

```bash
ls /var/cache/pacman/pkg | grep "^linux*"
```

If you find a version you'd like to switch back to then you can just use
`pacman` (suppose we want 6.10.10.arch1-1)

```bash
pacman -U \
    file:///var/cache/pacman/pkg/linux-6.10.10.arch1-1-x86_64.pkg.tar.zst \
    file:///var/cache/pacman/pkg/linux-headers-6.10.10.arch1-1-x86_64.pkg.tar.zst \
    file:///var/cache/pacman/pkg/nvidia-560.35.03-6-x86_64.pkg.tar.zst
```

Note that if you run these individually they will trigger timeshift autosnap.
Remember that you can do 

```bash
sudo SKIP_AUTOSNAP= \
    pacman -U \
        file:///var/cache/pacman/pkg/linux-{,headers-}6.10.10.arch1-1-x86_64.pkg.tar.zst \
        file:///var/cache/pacman/pkg/nvidia-560.35.03-6-x86_64.pkg.tar.zst
```

If you need to do nvidia drivers, I suggest using one of these

```bash
$ ls /var/cache/pacman/pkg | grep "nvidia" | sort -hr
$ ls -l /var/cache/pacman/pkg | grep "nvidia" | sort -k6,6M -k7,7M -k8,8n -k11
$ ls -lt /var/cache/pacman/pkg | grep "nvidia"
```

Remember that `pacman -Qi <package>` can be used to see when a package was
installed (`pacman -Qi <package 1> ... <package n> | grep "Install Date"`)


