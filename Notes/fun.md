Watch Star Wars in the terminal
```bash
telnet towel.blinkenlights.nl
# unsupported? (note says IPV6 has color)
telnet -6 towel.blinkenlights.nl
```

There's a whole lot of VT100 ASCII animations located at
[http://artscene.textfiles.com/vt100/](http://artscene.textfiles.com/vt100/)

```bash
VIDEO="trek.vt"
curl -s "http://artscene.textfiles.com/vt100/$VIDEO" | pv -q -L 750
```
The `-L` controls the rate of output so if you need slower, reduce the number or
use a higher number for faster.

