Templates for `cron` and some possibly more complex `cron` things.

On Linux don't use cron, use systemd!
On Mac? Someday I'll sitdown and learn `launchd`

# General template
Useful to just place this at the top of the `cron` file so you don't forget.
```bash
# Special characters
# *     Every possible value
# ?     No specific value
# -     Range
# ,     List
# /     Increments (e.g. 1/3 in dom == every 3 days)
# L     (dom and dow) last value (last day of week/month)
# W     Weekday nearest value
# #     Nth day (e.g. 6/3 in dow == every 3rd friday)
# e.g. 0 15 10 ? * 6#3 => Every 3rd Friday at 10:15 am
# |---------------------- Minute (0-59)
# | |-------------------- Hour (0-23)
# | |  |----------------- Day of Month (1-31)
# | |  |   |------------- Month (1-12)
# | |  |   |   |--------- Day of Week (0-6: Sun - Sat; 0==7==Su)
# | |  |   |   |     |--- Command to run
# m h dom mon dow command
```

# Some example cron jobs
```bash
# Update homebrew every Monday at 10am
0 10 * * 1 /opt/homebrew/bin/brew update &> /dev/null
# Update vim plugins at noon on Mondays
0 12 * * 1 /opt/homebrew/bin/nvim -c "PlugUpdate" -c ":qa" &> /dev/null
```
