# About
These are just a list of useful commands and notes that I don't want to forget

# Working With Remote Machines
- Always check the display: `echo $DISPLAY`
    - Usually this is 0, but sometimes on 1
    - Try forcing a specific display `DISPLAY=:1 my command`
- Use `nohup` to make run in the background. No `tmux` needed and no `<c-z>; bg;
disown` workarounds needed

## Using Remote As If Local
Ever want to use a remote machine as if it was the one you're physically at?
For example, say you have a computer hooked up to a TV and you need to type
things into it but don't want to connect a keyboard.
Have no fear, you can do this over ssh!

Single key press (example presses 'Down button')
```bash
DISPLAY=:1 xdotool key Down
```

Type a string
```bash
DISPLAY=:1 xdotool type "The quick brown fox jumped over the lazy brown dog."
```
Unlock lockscreen
```bash
sudo loginctl unlock-sessions
```
technically `loginctl unlock-session` (or `loginctl unlock-sessions`) should
work but often it doesn't.

## Bluetooth connections
Bluetooth is fucked. 
When in doubt, just remove the device and reconnect
```bash
# bluetoothctl
remove <mac>
pair <mac>
trust <mac>
connect <mac>
```
