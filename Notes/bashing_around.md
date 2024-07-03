Notes on bash and scripting.
Mostly things that I forget and so more of a cheat-sheet

# ESSENTIALS
```bash
# Exit command in vim ($EDITOR)
^x^e
# Brace expansion
echo Hello {world,you,me,everyone}
# Hello world you me everyone
```
Don't forget to use the `man` pages. Remember there are examples at the bottom.
And if on nix you have `info` for `builtins` and if specifically using bash `help`.

# Pitfalls
[bash pitfalls](https://mywiki.wooledge.org/BashPitfalls)
([archive](https://archive.is/20231024030742/http://mywiki.wooledge.org/BashPitfalls))

These are common bash pitfalls and we probably want to do better than we think a
command might be.
```bash
# When using variables put flags first and then use special "--" which says "no
# more flags
mkdir -p -- $director/subdir
cp -r -- $file1 $file2
ln -s -- $source $dest
cd -P -- "$(dirname -- "$f")"

# Redirection happens before command is executed
somecmd >>logfile 2>&1
# More complicated with sudo since redirect and command are being executed by
# different users
# No
sudo sh -c 'mycmd > /myfile'
# Yes
mycmd | sudo tee /myfile >/dev/null
```

Be sure to also check out [avoiding code injection](https://mywiki.wooledge.org/BashProgramming/05)
Notably passing commands to `ssh` makes all arguments a single string 
```bash
# BAD!
ssh user@host fooscript "$argument"
# Better
ssh user@host fooscript "${argument@Q}"

# sh quoting
# Works on any Bourne family of shells
# Convert all " into '\''
q=\' b=\\
ssh user@host fooscript "'${argument//$q/$q$b$q$q}'"

# We can separate code and data by this complicated nonsensense
q=\' b=\\
ssh user@host bash -s "'${argument//$q/$q$b$q$q}'" <<'EOF'
long and complicated script
goes here
EOF
```

# Useful commands
```bash
# Tips and tricks
$(< file) # faster than $(cat file)

##
# Touch a file in all directories. Utility shown in example
find . -type d -exec touch "{}/__init__.py" \;

# Rename extensions
find . -type f -name "*.abc" -exec sh -c 'mv "$0" "${0/%abc/def}"' {} \;
```
We use the [parameter expansion](https://mywiki.wooledge.org/BashFAQ/073) with 
replace to change `abc` to `def` when `abc` is the *end* of the argument.
We use `$0` because `sh -c` makes the first argument `$0` instead of the usual
`$1`.
You might see `sh -c 'mv "$1" "${1/.abc/.def}"' _ {} \;` or `sh -c 'mv "$1"
"${1%.abc}.def" _ {} \;` and the `_` is a dummy variable because `{}` is the
first, which is the output of `find`.
`$0` is much easier than what [SO says](https://askubuntu.com/questions/35922/how-do-i-change-extension-of-multiple-files-recursively-from-the-command-line).
It helps to read the docs!


# Variables
```bash
$0 # Program name
$# # Number of arguments passed to $0
$@ # All variables except $0
"${@:2}" # All except first
$? # Exit status
$$ # Process ID
$SECONDS # time since script started
$LINENO # Script line number
"${HOME%/}" # use %/ to avoide excessive /'s
# Quotes
"$VAR" # Double quotes expand special characters
VAR="$(ls ${HOME%/})" # stores output of comamnd as VAR
'$VAR' # Single quotes preserve special characters 
VAR='$(ls ${HOME%/})' # variable is the literal string
```
# Parameter Expansions
[Docs here](https://mywiki.wooledge.org/BashGuide/Parameters#Parameter_Expansion).
Very useful when scripting, especially the following
```bash
file="${HOME%/}/.dotfiles/rc_files/vimrc"
# default variable. If $var undefined, use ...
${var:-I am a string}
${var:=$file} # NOT same as ${var:-$file}. := sets $var to $file

# Replace vimrc with bashrc
echo "${file/files/piles}"  # .dotfiles -> .dotpiles replaces first occurance of 'files'
echo "${file//files/piles}" # /home/steven/.dotpiles/rc_piles/ replaces all occurances
# Note that % is end anchor and # is beginning anchor. 
echo "${file//%rc/st}" # /home/steven/.dotfiles/rc_files/vimst
# Remove leading path and only print 'vimrc'. Opposite of `dirname`
echo "${file##*/}"
# Same as `dirname`
echo "${file%/*}"
```

# Conditional flags
List can be found
[ohere](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html)
([archive](https://archive.is/20140307173542/http://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html))

One's you'll use the most are
```bash
# Existence
-a file
-d directory
-f regular_file
-h symbolic_link
-L symbolic_link
-v VARIBALE
-z string_length_zero
-n string_length_nonzero
# Attributes
-r readable_file
-w writable_file
-x executable_file
-N updated_since_last_read
newer_file -nt older_file
older_file -ot newer_file
# Operators
# = !=
-eq, -ne
# < <= > >=
-lt, -le, -gt, -ge

# You can also use regular expressions with =~
my_regex='v.*c'
if [[ ${file##*/} =~ $my_regex ]]; then echo $file; fi
# Or substrings
if [[ $file = *"rc" ]]; then # Matches vimrc, bashrc, and *rc (not rc_files)
```
[regex cheatsheet](https://www.rexegg.com/regex-quickstart.php)

# [Shell
Math](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html) ([archive](https://archive.is/20220503112900/http://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html))
```bash
echo "$(( 1 + 1 )), $(( 1 - 2 ))" # 2, -1
echo "$(( 2 * 2 )), $(( 2 / 3 )), $(( 2 ** 8 ))" # 4, 0, 256
echo "$(( 8 >> 1 )), $(( 8 << 1 ))" # 4, 16
```
# Scripts to Write Or Modify
- [ ] [PDF Shrinker](https://bash.cyberciti.biz/file-management/linux-shell-script-to-reduce-pdf-file-size/)
    - Make more robust and give options

# Other Resources
- [Advanced Bash](https://samrowe.com/wordpress/advancing-in-the-bash-shell/)
([archive](https://archive.is/20220710151815/https://samrowe.com/wordpress/advancing-in-the-bash-shell/))
-
[Command Line Tools Can Be 235x Faster Than Your Hadoop Cluster](https://adamdrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html) ([archive](https://archive.is/IFQ3Y#selection-224.0-224.3))

- [Google Style Guide](https://google.github.io/styleguide/shellguide.html)
