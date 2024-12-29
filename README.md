Organization
====
Use the following organization scheme
- `ansible`: location for ansible scripts, tasks, playbooks, etc
- `assets`: Location for assets like the imgs here
- `configs`: configs that belong to `${HOME}/.config`
- `installs`: scripts to install some programs from source
- `Notes`: Notes and self-documentation
- `misc`: Stuff where I have nowhere better to place it.
- `rc_files`: rc and config files that belong in `$HOME`
- `scripts`: Useful scripts

Previously .vimrc repo

# Using these files
Most things should be able to be installed with the install script. 
The install script has some options available so be sure to run `install -h` to
see options.
A lot of stuff is setup by default so I don't suggest blind installing.
You'll notice that I have installs with functions so you can install anything
independently by itself (see [installs](installs) and run `install_program -h`
for more info. I try to document a lot)

A system is yours.

Design it for you.

It should be both pretty for you AND make you more productive.

I install a lot of things from source because I work on a number of machines and
I don't always have control over them.
Installing from source gives a lot more flexibility and shell scripts are
something we all should learn and use.

# Programs
## Cross-Platform 

## Linux
- [foot](https://codeberg.org/dnkl/foot/) is a great fast terminal. ([HN](https://news.ycombinator.com/item?id=37622997))
Make sure to enable wayland, if in Pop goto `/etc/gdm3/custom.conf`

## OSX

# Wishing for
- I hope the foot dev enables cross platform support for OSX.
- ~~One day [ghostty](https://mitchellh.com/ghostty) may come out!~~[ghostty](https://ghostty.org/) lives!

# TODOs
A list of TODOs can be found in [TODO.md](TODO.md).
If you wish to contribute, these would be great things to look at.
It is likely vague but I'm happy to talk.
You're welcome to submit PRs where this file is updated, but if you do please
make sure that you've linked the associated issue.

# Resources
Resources and other cool dotfiles or inspirations
- [Emergency Tools](https://www.brendangregg.com/blog/2024-03-24/linux-crisis-tools.html) ([HN](https://news.ycombinator.com/item?id=39804214))
- [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe)
- [The RobertElderSoftware channel is my *favorite* YouTube channel](https://www.youtube.com/@RobertElderSoftware)
- [Rofi](https://github.com/davatorium/rofi/)
