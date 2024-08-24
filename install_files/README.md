# Organization
Each file is a script to install a specific program, which follows the file's
name.
The exception to this is `apt.sh` and `brew.sh` which are the non-source
installers (`brew.sh` will install `brew`)
These will read from `txt` files for packages to install that are contained in
the respective package managers.
Packages that need to be installed on both Ubuntu-like systems and OSX systems
***and*** have the same name (counter e.g. is `fd` and `fd-find`) go into
`common_list.txt`.
Programs from source are preferred and are often done for extended functionality
and better control.
But I also don't want to go full Gentoo, as that's too much work.

# TODO:
- [ ] General
    - [ ] Add program description and explanation md file
- [ ] Source installers
    - [x] [vim](https://github.com/vim/vim)
    - [ ] [zsh](https://www.zsh.org/pub/)
        - [x] Upstream mirror
        - [ ] Allow using it
    - [ ] [cmake](https://cmake.org/download/)
    - [ ] fonts
    - [ ] [lsd](https://github.com/lsd-rs/lsd)
    - [ ] [bat](https://github.com/sharkdp/bat)
    - [ ] [btop](https://github.com/aristocratos/btop)
    - [ ] [sheldon](https://github.com/rossmacarthur/sheldon)
        - Can we resolve the [`PATH` issue?](https://github.com/rossmacarthur/sheldon/issues/176)
    - [ ] cloudflared
    - [ ] wezterm
    - [ ] foot
    - [ ] [gh](https://github.com/cli/cli#installation)
        - [gh-dash](https://github.com/dlvhdr/gh-dash)
    - [ ] [Lynx](https://lynx.invisible-island.net/current/index.html) cli
        browser
- [ ] Script installers
    - [ ] cuda
    - [ ] TensorRT
    - [ ] CUDNN
    - [ ] mamba / anaconda

