# Why?
Email is basically all text.
So why are our programs using hundreds of MB or even a Gig?!
Plus, I live in the terminal anyways, why move?

# How to setup
[Neomutt](https://wiki.archlinux.org/title/Mutt) can be kinda confusing and I
think a lot of documentation is terrible.
So I'm writing as I figure it out!

I utilize the following structure to help organize everything
<ul>
    <li>
        <a href="accounts">accounts</a>:
            Folder that contains all accounts. One for each
    </li>
    <ul>
        <li>
            <a href="accounts/template/">template</a>:
                Template for arbitrary account
        </li>
        <ul>
            <li>
                <a href="accounts/template/template_config">template_config</a>:
                    Template for arbitrary account
            </li>
        </ul>
    </ul>
    <li>
        <a href="neomuttrc">neomuttrc</a>:
            Main - Wrangler for everything else
    </li>
    <li>
        <a href="settings">settings</a>:
            Main settings. Handles general settings
    </li>
    <li>
        <a href="colors">colors</a>:
            defines colorscheme
    </li>
    <li>
        <a href="mappings">mappings</a>:
            defines keybindings
    </li>
    <li>
        <a href="mailcap">mailcap</a>:
            Behavior for <a href="https://en.wikipedia.org/wiki/Media_type">MIME Types</a> (media)
    </li>
    <li>
        <a href="setup.sh">setup.sh</a>:
            Script to help initialization
    </li>
</ul>

The idea is to create a unique folder under <a href="accounts">accounts/</a>
that defines the settings for each mail account.

## Adding Accounts
This is the whole shebang, right?
There's a folder [accounts/template/](accounts/template) that serves as
documentation for how to set up a new email account.
[accounts/template/template_config](accounts/template/template_config) has a
documented file that will explain all the configurations you will need to make a
connection.

### Adding Office 365 and Gmail
We unfortunately need to use OAuth here, making this a bit more complicated.
Neomutt should be bundled with the `mutt_oauth2.py` file, so copy that somewhere
easier to access (or not).

```bash
# If on OSX and installed with brew try
find $HOMEBREW_PREFIX -name "mutt_oauth*"
```

We can either generate our own API key for Microsoft or just use Thunderbird's
;)
So we should do something like this

```bash
./mutt_oauth2.py accounts/my_account/my_account_office365.tokens \
        --verbose --authorize \
        --client-id='08162f7c-0fd2-4200-a84a-f25a4db0b584' \
        --client-secret='TxRBilcHdC6WGBee]fs?QR:SJ8nI[g82'

# If will present you with this information, so where's an example
Available app and endpoint registrations: google, microsoft
OAuth2 registration: microsoft
Preferred OAuth2 flow ("authcode" or "localhostauthcode" or "devicecode"): localhostauthcode
Account e-mail address: myemailaddress@uoregon.edu
Client secret: mysupersecretpassword
https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=08162f7c-0fd2-4200-a84a-f25a4db0b584--client-secret%3DTxRBilcHdC6WGBee%andamuchlongerurlhere
```

Then test

```bash
./mutt_oauth2.py --verbose --test \
    accounts/my_account/my_account_office365.tokens
```

If you run into a problem like 

```bash
Difficulty decrypting token file. Is your decryption agent primed for 
non-interactive usage, or an appropriate environment variable such as GPG_TTY 
set to allow interactive agent usage from inside a pipe?
```

then try

```bash
export GPG_TTY=$(tty)
```

This should get you going but multi-accounts can be a bit of a pain.
To get around this we'll need to be more of a power user

### Creating GPG Keys
Head over to [Notes/gpg.md](../../Notes/gpg.md) to read my notes on creating a
gpg key
We store our passwords securely (see [setup.sh](setup.sh)) using GPG.

# Better setup
One annoying factor is that Microsoft servers are really really slow.
We're on the terminal and love everything to be instant, so we'll have to go
about this another way.
We're going to use the following tools as suggested by [Jonathan
Hodgson](https://jonathanh.co.uk/blog/mutt-setup/)

- [Neomutt](https://neomutt.org/): Mail client
- [mbsync](https://isync.sourceforge.io/mbsync.html): IMAP/Maildir synchronization
- [notmuch](https://notmuchmail.org/): Indexer/search
- [msmtp](https://marlam.de/msmtp/): Email sender
- [DavMail](https://davmail.sourceforge.net/): Bridge/Gateway
- [ImapFilter](https://github.com/lefcha/imapfilter): Email filterer
- [Abook](http://abook.sourceforge.net/): Contact manager

All these can be installed through `brew`, `yay`, or whatever your package
manager is (note `mbsync` == `isync`)

```
# osx
$ brew install neomutt isync notmuch msmtp abook davmail imapfilter
# I use Arch btw
$ yay -S neomutt isync notmuch msmtp abook davmail imapfilter
```
