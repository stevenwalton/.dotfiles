Make Steam better and faster. See [Tips and Tricks
ArchWiki](https://wiki.archlinux.org/title/Steam#Tips_and_tricks)

# `~/.steam/steam/steam_dev.cfg`
Add these things here

### Faster shared pre-compilation (multithreaded)
```
unShaderBackgroundProcessingThreads 8

```
### Disable HTTP2
Increases download speed. Can also be used as a console command
```
@nClientDownloadEnableHTTP2PlatformLinux 0
```
