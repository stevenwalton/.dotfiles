# GPU Goes Burrrr
I'm going to break out notes on GPUs for linux.
This is because linux and nvidia is and always has been a pain.

If you have a graphics problem AND an nvidia GPU, look here first.

This should be a high motivation for using tools like `timeshift` (discussed in
[linux notes](/Notes/linux.md)), [btfrs](https://wiki.archlinux.org/title/Btrfs)
filesystem, or some other backup system.
I suggest also making sure to not frequently delete your package manager's cache
or making a backup for relevant files.
If you are on an arch system you can look for these under
`/var/cache/pacman/pkg` and you can always reinstall old files with `pacman -U
file:///var/cache/pacman/pkg/<name>`, or use tools like
[`downgrade`](https://aur.archlinux.org/packages/downgrade). More on arch
downgrading [in the
wiki](https://wiki.archlinux.org/title/Downgrading_packages).

# Which driver to use?
A list of common drivers can be found
[here](https://www.nvidia.com/en-us/drivers/unix/). An older archive is located
[here](https://www.nvidia.com/en-us/drivers/unix/linux-display-archive/) but as
time of writing has nothing newer than 390 (released 2022). Here is the [main
driver page](https://www.nvidia.com/en-us/drivers/)

You may want to read the release notes on these drivers.
Unfortunately you need to search first and then lookup, I do not know of a
directory listing.

(as of Oct 2024)
- 550 is the mainline branch. This should be stable. If you're having issues,
try this!
- 555 is a new feature or beta branch, but generally stable
- 560 is a new feature or beta branch, but can have mixed stability. OSes like Pop and
Endeavour often use this one, so be prepared. 
If you use the nvidia driver search "New Feature Branch" has *newer* drivers
than "Beta" (because?).

***NOTE***: there may be subversions of these drivers too!
For example, this week Endeavour upgraded my nvidia driver from `560.35.03-6` to 
`560.35.03-9` and this resulted in an issue where I could login but then I'd get
a black screen with my visible cursor. So ***pay close attention!***

# Kernel Parameters
This part is annoying.
I'm not aware of a full listing of these options but I'll try to collect one
here. We'll try to describe more below but a table for quick reference

| Parameter | Description |
|:----------|:------------|
| nvidia_drm.modeset | Direct Render Mode |
| nvidia_drm.fbdev | Frame Buffer | 
| nvidia_uvm.modeset | Unified Memory Kernel |

# Random Resources
- []()
- [Archive for other drivers](https://download.nvidia.com/XFree86/Linux-x86_64/): There's a special file `latest.txt` here that contains a single line denoting the latest version. Sample: `550.120 550.120/NVIDIA-Linux-x86_64-550.120.run`.

To get the latest docs you can navigate to whatever the result of the following

```bash
URL='https://download.nvidia.com/XFree86/Linux-x86_64/'
echo "${URL%/}/$(curl -SsL "${URL%/}/latest.txt" | cut -d ' ' -f1)/README"
```

Leaving off `README` will give you a directory for the driver where you can
download. It might look like this

```bash
$ curl -SsL "${URL%/}/$(curl -SsL "${URL%/}/latest.txt" | cut -d ' ' -f1)" \
    | grep -E "href='.*'>.*<"
    | sed -E "s/.*='.*'>(.*)<\/a>.*/\1/g"
..
NVIDIA-Linux-x86_64-550.120.run
NVIDIA-Linux-x86_64-550.120.run.md5sum
NVIDIA-Linux-x86_64-550.120.run.sha256sum
NVIDIA-Linux-x86_64-550.120-no-compat32.run
NVIDIA-Linux-x86_64-550.120-no-compat32.run.md5sum
NVIDIA-Linux-x86_64-550.120-no-compat32.run.sha256sum
README/
license.txt
```

The `grep` (don't need to worry about `\grep`) searches for links using regex.
They will have the format `something <a href='link here'>What we want<`
The `sed` command just grabs the part we want.

Any of these results can be used directly to access the file (note `README/` is
the documentation and a directory). So for example we can get the latest driver
and its md5sum with (you could make this simpler but this is explicit)

```bash
$ URL='https://download.nvidia.com/XFree86/Linux-x86_64/'
$ VERSION="$(curl -SsL "${URL%/}/latest.txt" | cut -d ' ' -f1)" 
$ VERSION_PAGE="$(curl -sL "${URL%/}/${VERSION}" | grep -E "href='.*'>.*<" | sed -E "s/.*='.*'>(.*)<\/a>.*/\1/g")
$ # Get driver
$ DRIVER_NAME="$(echo "${VERSION_PAGE}" | \grep -E "${VERSION}\.run$")"
$ curl -sL "${URL%/}/${VERSION%/}/${DRIVER_NAME}" -O "${DRIVER_NAME}"
$ curl -sL "${URL%/}/${VERSION%/}/${DRIVER_NAME}.md5sum" -O "${DRIVER_NAME}.md5sum"
$ if [[ "$(md5sum "${DRIVER_NAME}")" == "$(\cat "${DRIVER_NAME}.md5sum")" ]];
then
    echo "SUCCESS"
fi
```
