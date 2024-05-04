# Enable vim keybindings
c.TerminalInteractiveShell.editing_mode = 'vim'
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
