This is mostly stuff I forget.
This is not a good way to learn linux and is for someone who's already been
using it.

# Updating
## Nvidia drivers
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


