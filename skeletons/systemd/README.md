# System-D Skeletons/Templates
Please read the comments in each of the files.
Some of these can be just softlinked right into `/etc/systemd/system/` while
others should serve as examples and you should follow along but manually type
`systemctl edit --full file.extension`
If the file doesn't already exist then you'll need to edit via path.

For more systemd notes see the notes folder.

# Mounts
The template files `mnt-hdd.mount` and `mnt-hdd.automount` serve as examples to
create mounts with systemd.
You can edit fstab but I find this easier and gives more granular control.
Make sure you note that the name of the mount file needs to be the path but with
`/` replaced with `-`, removing the root.
This is the same as this silly line 
`echo "${ $(echo "/path/to/mount/point"):1}" | sed 's@/@-@g'`
(assuming `@` isn't in your path name)

# Timers
Timers are things that go off periodically or at a certain time.
This can be a bit confusing.
The [template.timer](template.timer) file should help explain that.
Note that a timer file must be accompanied by a service file or else it won't
work.

The timeshift timers are quite useful and you should consider them.
Set to how frequently you want to do.
Also look into creating a hook for your package manager.

# Services
These are services that I have locked down from the standard files.
Mostly for fun.
Some of these are in use while others aren't.

If they are an override file then you can either softlink them to their expected
override locations or run `systemctl edit` with the specified service and enter
in these values.

# Resources
- Nice little
[gist](https://gist.github.com/ageis/f5595e59b1cddb1513d1b425a323db04)
