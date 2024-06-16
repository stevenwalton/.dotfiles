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

# Tips and tricks
- `$(< file)` is faster than `$(cat file)`

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

# Conditional flags
List can be found
[here](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html)
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
```

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
