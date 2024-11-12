# Vim wonderful vim

Just a collection of some fun commands I learned with examples

## Reformatting Doc-String Blocks
I was given some python code that had doc-strings in an interesting format

```python

"""
I'm a docstring
"""
def foo():
    pass
```

Obviously we won't let this stand!

```vim
" Use non-greedy matching to move the blocks below the function definition
:%s/\(^\s\{-}"""\_.\{-}"""$\)\(\_.\{-}\)\(^\s\{-}def \_.\{-}:$\)/\2\3\r\1/g
" Search for the triple quote *block*
/^\s\{-}"""\_.\{-}"""$
" Indent the block
gn>
" Continue pressing `n` (twice) then `gn>` till we have all blocks reformatted
```
If anyone knows how to get the indenting to occur in the replace command, please
let me know! I could get the first line indented properly by using the
whitespace before the `def` but couldn't figure out how to apply that to each
line :(

## Dual-language commenting
I had some students turn in an assignment that had some comments in a different
language paired with comments in English.
I do really appreciate that they did this to allow me (the TA) and the other
English speakers in the group to read the comments.
But it did make the code hard to read because the lines became very long.
Here's the original format

```python
class Foo:
    def __init__():
        pass

    # Foreign Language Comment / English Comment
    def bar():
        a = 1 # Foreign Language Comment / English Comment
```
Let's fix that right up!
```vim
" Get the single line comments
:%s/\_^\(\s*\)#\(.*\)\/\(.*\)$/\1#\2\r\1#\3/g
" And the code lines
:%s/\_^\(\s*\)\(.*\)\s*#\(.*\)\/\(.*\)$/\1#\3\r\1#\4\r\1\2/g
```
I was a bit surprised we didn't need non-greedy matching and there seemed to be
some oddities due to the character encoding (trivial one being `\w+` doesn't
work, but other things were off...).

This gives the result

```python
class Foo:
    def __init__():
        pass

    # Foreign Language Comment 
    # English Comment
    def bar():
        # Foreign Language Comment 
        # English Comment
        a = 1 
```
Much cleaner!
