# Android

## Useful Apps
- Material Files: File explore but makes it easy to access {,S}FTP, SMB, and
WebDAV servers

## Termux
`termux` is an Android app that gives you a terminal.
Install it from fdroid, not the playstore.

Here's things you should do 
```bash
termux-setup-storage # Sets up storage and creates ~/storage folder
pkg update && pkg upgrade
passwd # Set up a password
```
pkgs to install 
```bash
openssh # what, you wanted to use a terminal with a touch screen? 
# ssh is on 8022. Make sure to run `passwd` and then `sshd`
rsync # Backups!
vim-python # what, vim without python?!
cronie # cron jobs!
termux-api # also install from fdroid 
tmux
python
```
[Termux-API](https://wiki.termux.com/wiki/Termux:API) give you a lot more access
to your phone and you can do things like get device status, take pictures, send
texts, notifications, etc.
[Termux-Boot](https://wiki.termux.com/wiki/Termux:Boot) needs fdroid but allows
you to run stuff at boot.

Note that you will need to grant permissions on your phone and the best way to
do this is from the termux app (can't do over ssh)
```bash
termux-location # will ask for gpt
termux-senseors -l # list sensors but asks for permissions
termix-sms-list # asks for contacts
```

pkgs you might want
```bash
man
jq
fzf
sqlite
ffmpeg
ffsend # Firefox send (up to 1GB)
```
- [Termux-Widget](https://github.com/termux/termux-widget): run scripts from a
widget
- [Termux-Tasker](https://wiki.termux.com/wiki/Termux:Tasker): Automate some
stuff

## As A Server
Why buy a RaspberryPi when you have an old phone stuffed in the back of your
drawer?
Google/Apple may give you money back, but how much?

Let's consider a >10 year old phone I have vs a RaspberryPi 

|   | Galaxy S3 | RaspberryPi 4B | RaspberryPi 5 |
|:-:|:---------:|:-------------:|:-------------:|
| CPU | 4x 1.4GHz A9 | 4x 1.8GHz A72 | 4x 2.4 GHz A76 |
| RAM | 1GB | {1,2,4,8} GB | {4,8} GB |
| Memory | 16 GB | - | - |
| Camera | 8 MP + 1.9 MP | - | - |
| Video | 1080p@30fps + 720p@30fps | - | - |
| WiFi | 802.11 a/b/g/n | 802.11 ac |
| Bluetooth | 4.0 | 5.0 BLE | 5.0 BLE |

Not to mention that we have an included battery, a touch screen, this one has a
GPU ([Mali-400MP4](https://developer.arm.com/Processors/Mali-400)), GPU,
micro-sd expansion, speakers, and all sorts of things.
Sure, there are times you would rather have a rpi, but in any cases, your old
phone can serve as a great server.
Best of all, "free" is a lot cheaper than any rpi.
And I think many of us forgot the old recycling commercials:
`reduce, reuse, recycle`.
So Google/Apple might promise you a few hundred, end up offering $100, and then
it just goes to a landfil in a third-world country to be burned in an open pit.
Let's reuse.

The easy way is to just use termux.
Don't need to install another operating system or anything. 
