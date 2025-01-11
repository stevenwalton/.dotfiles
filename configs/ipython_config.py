# Be sure to check the latest documentations. This won't be the latest but there
# should be a link
# https://ipython.readthedocs.io/en/8.27.0/config/shortcuts/index.html
# Enable vim keybindings
c.TerminalInteractiveShell.editing_mode = 'vi'
# Escape means escape, not insert vim keycommands as if they are text!
#   Fuck off emacs
#   Resource: https://github.com/ipython/ipython/issues/13443
c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False
# Make the timeout happen even faster! (default 0.5) 
#   Don't go do 0 or dd won't work
c.TerminalInteractiveShell.timeoutlen = 0.25
# No automagic. Must require %
c.InteractiveShell.automagic = False
# Remove extra line between commands
#c.InteractiveShellApp.exec_lines
#c.TerminalIPythonApp.display_banner = False
# Fast load
c.TerminalIPythonApp.quick = True
# Auto indent
c.InteractiveShell.autoindent = True
c.InteractiveShell.banner2 = "Steven Walton's iPython Configuration"
# Format with black
c.TerminalInteractiveShell.autoformatter = 'black'
# More vivid colors. Also 'Neutral' for darker, 'LightBG' for dark colors (hard
# to see on dark bg)
c.InteractiveShell.colors = 'Linux'
# Add autoreload functionality
# https://stackoverflow.com/questions/5364050/reloading-submodules-in-ipython
#   See note about differences from 
#   import importlib
#   importlib.reload(foo)
c.InteractiveShellApp.extensions = ['autoreload']
c.InteractiveShellApp.exec_lines = ['%autoreload 2']
