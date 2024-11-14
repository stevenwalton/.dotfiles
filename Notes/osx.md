# Using CLI
Apple's CLI... sucks... 
They seem to want to kill off power users.
Luckily we can always get around!

- [HN Thread on Useful OSX Cli Commands](https://news.ycombinator.com/item?id=42057431)
    - [Archive of Linked
        Website](https://archive.is/20241106121146/https://weiyen.net/articles/useful-macos-cmd-line-utilities)
    - [Archive of
        Thread](https://archive.is/rG4xk)

# Apps to Install

## Objective See Security Tools
Here are some good security related apps from [Objective
See](https://objective-see.org/). Many of these will help you detect if malware
is placed on your machine and they aren't very resource intensive.
These tools are free and Open Source. There's plenty here that are overkill for
most users.

- [LuLu](https://objective-see.org/products/lulu.html): Lets you know about unknown outgoing connections.
- [RandsomeWhere](https://objective-see.org/products/ransomwhere.html): Tells
you if files are being encrypted and interrupts. This can sometimes be annoying

#
https://www.jessesquires.com/blog/2023/12/16/macbook-notch-and-menu-bar-fixes/

# Upgrading Issues
## Sequoia
After upgrading to Sequoia OSX 15.0, I was having an issue where `ssh` would
frequently disconnect.
This happened faster and more reliably when using `tmux`.
Turns out that the problem is actually LuLu.
Uninstall it and see if the problem goes away.

# Taking Back Control
Apple is quite annoying in that there's always an "Apple Way".
Apple engineers, if you are reading this, stop trying to cut off power users!
Developers are power users, YOU are power users!
You can handhold without pissing off users[^1].
If you really want to promote creativity, give your devs powerful tools to work
with.
I promise, you will only benefit. 

[^1]: It sees Apple forgot that many devs use OSX because it is the closest
  thing to a Linux system for a functional laptop that also allows them to do
  stuff like use Microsoft Office and other things that are necessary because
  business people can't understand LibreOffice... (like Microsoft will ever be
  kind to Linux...)':

It can be hard to figure out what your Mac is doing and how to edit system files
because there's so little documentation and it is hard to search.
So let's talk first about how to find out what your system is doing

## Understanding System Files
Your most important directory might be `/System`

```bash
$ ls /System/
 Applications  
|-- Contains System applications. Everything from Automator, Calculator, Chess, to Music, Siri, and Facetime
|-- Samples:
|--  Automator.app
|--  FaceTime.app
|--  FindMy.app
|--  'Font Book.app'
|--  'Image Capture.app'
|--  'iPhone Mirroring.app'
|--  Launchpad.app
|--  'Mission Control.app'
|--  Music.app
|--  Passwords.app
|--  Photos.app
|--  Preview.app
|--  Shortcuts.app
|--  Siri.app
|--  'System Settings.app'
|--  'Time Machine.app'
 Cryptexes  
|--  App ⇒ /System/Volumes/Preboot/Cryptexes/App
|--  OS ⇒  /System/Volumes/Preboot/Cryptexes/OS
|-- Contains 2 folders App and OS which point to /System/Volumes/Preboot/Cryptexes/
 Developer
|-- Empty?
 DriverKit
|--  AppleInternal
|--  Runtime
|--  System
|--  usr
 iOSSupport
|--  dyld
|--  System
|--  usr
 Library
|-- Lots of programs!
 Volumes
|--  BaseSystem
|--  Data
|--  FieldService
|--  FieldServiceDiagnostic
|--  FieldServiceRepair
|--  Hardware
|--  iSCPreboot
|--  Preboot
|--  Recovery
|--  Update
|--  VM
|--  xarts
```
