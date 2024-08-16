# Filters
Message filters are annoying, but more annoyingly, you can't directly export a
message filter from one account to another.
Instead, use `fzf` or `find` to search for a file called `msgFilterRules.dat`.
This contains your filter rules and there are one per account.
To export, close Thunderbird, copy lines from one to another, repoen
Thunderbird. 

On OSX, these are under `Library/Thunderbird/Profiles/` and then some hash (so
should use `fzf` or `find` from here)

For making filters with these files directly, here's the format:
```bash
# These lines always exist, don't edit
verison="9"
logging="no"
# Edit below
name="Name of filter"
enabled="yes" # or "no"
type="" # ??? No documentation
action="" # See type link below
actionValue="imap://email_adderess%40domain@host_like_outlook.com/stuff..."
```
Remove the comments
types are supposedly defined
[here](https://searchfox.org/comm-central/source/mailnews/search/public/nsMsgFilterCore.idl)
but I have filters with `type="273"` and actions `action="AddTag"` as well as
`action="Move to folder"` but also an add tag action with `type="17"` and seems
to match documentation.
