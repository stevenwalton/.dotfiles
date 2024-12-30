[Ghostty](https://ghostty.org/) is a new terminal that aims to performant,
feature rich, native, and hackable. 
Part of the philosophy is that config files are minimal.
This is great because we can take the popular features but it still allows us to
make it our own (hackable). 

There are some issues though and this doc will update with these things as well
as some discussion of my config. 

# Restore <C-[>
If you're a `vim` user like me you probably[^1] use `<C-[>` instead of `ESC`.
This by default acts as an undo in ghostty.
We can fix that by adding this to our config

```
keybind = ctrl+left_bracket=text:\x1b
```

Credit goes to hankertrix for opening [this
issue](https://github.com/ghostty-org/ghostty/issues/2976)


[^1]: I know you crazy people remap to capslocks but `<C-[>` requires no
    configuration!

# SSH
There's a weird issue if you ssh where it might complain about the terminal
being used and you'll have some crazy font issues (such as characters repeating
themselves and things not rendering properly). 
There is a very simple fix.
Add this to your ssh config

```config
SetEnv      TERM=xterm-256color
```

I put this under `Host *`, which applies to everything.

# References
[Ghostty is Native, So What](https://gpanders.com/blog/ghostty-is-native-so-what/)


