Notes on bash and scripting.
Mostly things that I forget and so more of a cheat-sheet

# Pitfalls
[bash pitfalls](https://mywiki.wooledge.org/BashPitfalls)
([archive](https://archive.is/20231024030742/http://mywiki.wooledge.org/BashPitfalls))

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

These are common bash pitfalls and we probably want to do better than we think a
command might be.
```bash
# When using variables put flags first and then use special "--" which says "no more flags"
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

# Bang!
The bang (`!`) command is super fucking useful and will make you look like a
wizard when you use them.
Maybe because you are.
****Knowing these can help you make good habits!***
```bash
# Run last
!! # Do last command
!<str> # run last command that starts with 
!?<str> # Like !<str> but <str> can be anywhere (fuzzy)

# Modify last
!!:s^foo^bar # run last command but replace any instance of foo with bar
^foo^bar # short version
!!:$ # argument of last command 
!$ # ditto
!_ # ditto but zsh runs immeditately

# Use last arguments
!:n # repeats last nth argument
!:0 # 0 is the command
```
Note that `bash` will straight run these commands while `zsh` will just give you
back the requested line where you need to press `enter` again.
This is identical to adding `:p` to the end (like `!!:p` prints out the last
command but doesn't run it)

Here's some useful examples
```bash
apt install foo # ops, forgot sudo
sudo !!

git diff long/path/to/foo.py
!!:s^diff^add
git add $_
!g:^diff^add

mkdir -p foo/bar    # Make a directory
touch foo/bar/bazz.txt  # some other command 
cd !m:$ # Oh, now we want to cd into there

mkdir -p foo/{bar,baz} buff
cd !:3 # cd into buff. Note how brace expansion works!
```
Note that this relies on your history (e.g. `~/.bash_history`) and so if you do
something like `$ fc -p` or `$  ls` (2 spaces!) that causes the history to not
be recorded, then you can't rely on these.
Also note, don't rely on history if you think hackers got in because they'll
just run `$  fc -p` when they're in and nothing will get recorded.

# Find
`find` is one of the most powerful and underrated programs in bash.
It is one you should master!
There are newer tools like [fd](https://github.com/sharkdp/fd) that help and 
make some things easier but you should make sure you understand `find` first.
Let's see a pretty useful example that you might use in real life:
Suppose you are starting a new project in python and you know the general
structure of your module. So we can set that up pretty efficiently with brace
expansion and find:
```bash
# Make some arbitrary directory structure
mkdir -p src/{a,b,c,d} src/e/e{a,b} src/d/da/dd{a,b}
# Add __init__.py to all directorires
find src -type d -exec touch "{}/__init__.py" \;
```
Through `find` we were able to add our python init files to all directories!
Now remember that you can use regex and do far more complicated commands, so
this can do quite a lot for you.

*Be Aware* that `find` (and `ssh`) can sometimes be tricky to use in scripts.
When using their outputs in a loop or when used as variables.
***This applies to commands that also read stdin***.
You will often want to add `< /dev/null` to the command (not `> /dev/null`!. You
pass `/dev/null` to the command, not the command output to `/dev/null`).
Think of this like `--` (2 dashes) which often signifies that no more arguments
are being passed.
```bash
# WRONG!
while IFS= read -r foo;
do
   ffmpeg -i "$foo" -c:v libaom-av1 -crf 23 "${foo%.*}.mkv"
done < <(find . -type f -name "*.mp4" -o -name "*.mkv")

# Works
while IFS= read -r foo;
do
   ffmpeg -i "$foo" -c:v libaom-av1 -crf 23 "${foo%.*}.mkv" < /dev/null
done < <(find . -type f -name "*.mp4" -o -name "*.mkv")
```
When scripting it is often better to build your command based on options so
might actually look more like this
```bash
declare ffmpeg_command="ffmpeg"
if [[ $USE_HW_ACCEL -eq 1 ]];
then
   ffmpeg_command+=" -hwaccel cuda -hwaccel_output_format cuda"
fi
ffmpeg_command+="-i $foo"
```


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

# Quoting
echo "There is no place like $HOME" # prints "There is no place like /home/yourname"
echo 'There is no place like $HOME" # prints "There is no place like $HOME"
## Note you can't escape like 'There\'s' in the single quote. 

"$VAR" # Double quotes expand special characters
VAR="$(ls ${HOME%/})" # stores output of comamnd as VAR
'$VAR' # Single quotes preserve special characters 
VAR='$(ls ${HOME%/})' # variable is the literal string

${VAR} # Defensive! Makes variable unambiguious
```

Also note that double quotes prevent variable splitting.
That is, if you have a variable with a space in it bash will treat it like an
array rather than a single variable.
Try this example:
```bash
$ mkdir a b "a and b"
$ touch "a/I'm in a.txt" "b/biz bazz.log" "a and b/lol look at me.xz"
$ foo="a and b"
$ ls $foo # `ls ${foo}` is identical!
ls: cannot access 'and': No such file or directory
a:
"I'm in a.txt"

b:
'bizz bazz.log'
$ ls "$foo"
'lol look at me.xz'
$ ls '$foo'
ls: cannot access '$foo': No such file or directory
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

# [Shell Math](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html) ([archive](https://archive.is/20220503112900/http://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html))
Some basics 
```bash
echo "$(( 1 + 1 )), $(( 1 - 2 ))" # 2, -1
echo "$(( 2 * 2 )), $(( 2 / 3 )), $(( 2 ** 8 ))" # 4, 0, 256
echo "$(( 8 >> 1 )), $(( 8 << 1 ))" # 4, 16
```
Note that bash only does integers.
To do floating point we need to use tricks.
People often suggest using `bc` (basic calculator) but I find this often isn't
installed by default so I think `awk` is better.
(See [list of POSIX
commands](https://en.wikipedia.org/wiki/List_of_POSIX_commands) and you'll
notice that `bc` is optional. It seems to be included in OSX and Ubuntu but not
EndeavourOS)
```bash
$ awk 'BEGIN {printf "%.3f\n", 10 / 3}'
3.333
$ declare -i a=10
$ declare -i b=3
$ awk -v a="$a" -v b="$b" 'BEGIN {printf "%.3f\n", a/b}'
3.333

# You can be a bit fancier with
$ myexpr="$a/$b"
$ awk_expr="BEGIN {printf \"%3f\n\", $myexp}"
$ awk $awk_expr
3.333
# And it'll do more complex calcs
$ myexpr="($a + $b) / $b" # 4.333
$ myexpr="($a ^ $b) / ($b ^ $b)" # 37.037 
$ myexpr="int($a/$b)/$a" # 0.300

# Awk also supports
# ^ or ** for exponents
# % for modulus
```
Yeah, `awk` is annoying. That's why people suggest `bc`, but this work.
Remember that you can also use `python` or `perl`, which are exceptionally
common.
```bash
python -c "print(f\"{$a/$b:.3f}\")"
perl -e "printf \"%.3f\n\", $a/$b"
```
But sometimes we just like to be POSIX native ^_^

# Misc Useful commands
```bash
# Tips and tricks
$(< file) # faster than $(cat file)
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

# Colors
This useful little loop will help you see and remember your ansi color codes
```bash
# This top part is just to make our column headings
for i in {1..9}
do
    if [[ $i -eq 1 ]]; then echo -n "\t"; fi
    echo -ne "\e[${i}m\t\\\e[${i};3xm\e[0m"
done
echo ""
echo -n "\t\t"
printf %136s | tr ' ' '_'
echo ""
# You really just need this below
for i in {1..9}
do
    # Next line is just for row label
    echo -ne "\e[3${i}m\\\e[x;3${i}m\e[0m   |   \t"
    for j in {1..9}
    do
        echo -ne "\e[${j};3${i}m\\\e[${j};3${i}m\e[0m"
        echo -ne "\t"
    done
    echo ""
done
```
You should get an output with demonstrating an example with the visual display
of the code.

Recall that `\e` and `\033` are the same.
And don't forget that in scripts you need to use `echo -e`

# Scripting
Shebang! 
```bash
# Use the version of bash from the user's $PATH
# USE THIS!
#!/usr/bin/env bash
# Similarly for python (will respect venvs, conda, etc)
#!/usr/bin/env python

# Use the bash located at /bin/bash (less flexible)
#!/bin/bash
# Use POSIX 
#!/bin/sh
# Python (note this may not exist and is very likely not the expected version)
#!/usr/bin/python
# Slightly better but sill don't do this
#!/usr/bin/python3 

# The shebang can accept options!
# Run a restricted shell
#!/usr/bin/env bash -r
```
Note that a [restricted
shell](https://www.gnu.org/software/bash/manual/html_node/The-Restricted-Shell.html)
means the script cannot `cd`, change `$SHELL`, `$PATH`, `$HISTFILE`, `$ENV`, or 
`$BASH_ENV`, use *commands* with `/` (`/bin/ls` not allowed but `ls /bin` is),
perform redirects, or other things.

An interactive shell 


# Scripts to Write Or Modify
- [ ] [PDF Shrinker](https://bash.cyberciti.biz/file-management/linux-shell-script-to-reduce-pdf-file-size/)
    - Make more robust and give options

# Other Resources
- [Advanced Bash](https://samrowe.com/wordpress/advancing-in-the-bash-shell/)
([archive](https://archive.is/20220710151815/https://samrowe.com/wordpress/advancing-in-the-bash-shell/))
-
[Command Line Tools Can Be 235x Faster Than Your Hadoop Cluster](https://adamdrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html) ([archive](https://archive.is/IFQ3Y#selection-224.0-224.3))

- [Google Style Guide](https://google.github.io/styleguide/shellguide.html)
