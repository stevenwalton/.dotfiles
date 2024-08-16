# What goes here?
Files that are rc or configs that will be placed in `${HOME%/}`

Files are expected to be prepended with a `.` to be made hidden.
We remove this for easy editing. 
On a Linux and OSX machines you should be able to do
```bash
# DOTFILES_PATH=${HOME%/}/.dotfiles
find "${DOTFILES_PATH%/}/rc_files" \
    -maxdepth 1 \
    ! -name "*.md" \
    ! -name "*root" \
    ! -name "zsh" \
    -exec bash -c \
    'ln -sf "${0}" "${HOME%/}.${0##*/}"' \
    {} \; 
```
<sub><sub>Note: on OSX add `! -name "mozilla"`. The _contents_ needs to instead 
go to `${HOME%/}/Library/Mozilla/Profiles/<profile folder>`</sub></sub>
This will create a softlink (*WARNING*: `-f` replaces existing files!) to your dotfiles.
Don't copy, use softlinks.
This way you can track changes.
