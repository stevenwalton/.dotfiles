# What goes here?
Files that are rc or configs that will be placed in `${HOME%/}`

Files are expected to be prepended with a `.` to be made hidden.
We remove this for easy editing. 
On a Linux and OSX machines you should be able to do
```bash
# DOTFILES_PATH=${HOME%/}/.dotfiles
find "${DOTFILES_PATH%/}/rc_files" \
    -mindepth 1 -maxdepth 1 \
    ! -name '.*' \
    ! \( -name '*.md' -o -name '*root' -o -name 'zsh' \) \
    -exec bash -c 'for f; do ln -sfn "$f" "${HOME%/}/.${f##*/}"; done' _ {} +
```
Worth reading closely, because three of these are easy to get wrong:

- `-mindepth 1` — the start directory is itself at depth 0, so without this
  `find` returns `rc_files` too and you end up with a `~/.rc_files` symlink
  pointing at the entire tree.
- `-sfn` — the `-n` is for macOS. `~/.vim` and `~/.ipython` are symlinks *to
  directories*; BSD `ln` follows such a link and creates `~/.vim/vim` inside
  it, while GNU `ln` replaces it. `-n` makes both replace.
  Note this does **not** cover a *real* directory at the destination — there
  `ln` links inside it on either platform and `-n` is no help. GNU's `-T`
  refuses correctly but BSD has no equivalent, so `install.sh` tests for that
  case itself and skips with a warning rather than silently nesting.
- `-exec ... {} +` — hands the whole batch to a single `bash` as `"$@"` rather
  than forking one per file the way `\;` does, which is why the callback needs
  the `for` loop and the `_` placeholder for `$0`. `find` itself is
  single-threaded; if you actually want parallelism it comes from
  `... -print0 | xargs -0 -P 8 -n 16 bash -c '...' _`, at the cost of losing
  find's exit status and any hope of readable `ln -i` prompts.
<sub><sub>Note: on OSX add `! -name "mozilla"`. The _contents_ needs to instead 
go to `${HOME%/}/Library/Mozilla/Profiles/<profile folder>`</sub></sub>
This will create a softlink (*WARNING*: `-f` replaces existing files!) to your dotfiles.
Don't copy, use softlinks.
This way you can track changes.
