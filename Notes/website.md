# Hosting
Documentation for hosting my website and other such information.

I got my domain name on [cloudflare](https://cloudflare.com) but I host my page
with [github.io](https://docs.github.com/en/pages).[^1]
This is an easy way to just set up a static website.

[^1]: We'll do that because this page will be scrapped and I don't want a bunch
    of spam hitting my website because I put down some instructions...

## Connecting GitHub.io to Cloudflare

For this purpose, let's suppose I'm trying to connect my github page
`example.github.io` to my cloudflare website `example.com`
You can also find all instructions [here on Cloudflare's
Blog](https://blog.cloudflare.com/secure-and-fast-github-pages-with-cloudflare/).
This works similarly for other domain services.
I used to have a site on [NameCheap](https://www.namecheap.com/) and it worked
similarly.
A reason I like Cloudflare is that they do things like HTTPS and email
forwarding for free.

We'll need to do a few things, on both GitHub and on Cloudflare.
First, in your repo you need to add a file called `CNAME` to the root.
This file just contains the url of your website

### In your repo

```bash
$ [ john@foo ~/example.github.io ] $ echo 'example.com' > CNAME

$ [ john@foo ~/example.github.io ] $ git add CNAME
$ [ john@foo ~/example.github.io ] $ git commit -m "Adding CNAME Record"
$ [ john@foo ~/example.github.io ] $ git push
```

### On Github
Head over to your repo and go to `Settings > Code and Automation > Pages`, the
url will end up being something like
`https://github.com/johndoe/example.github.io/settings/pages`.
From here you can add your new domain `example.com`

You should be able to get a challenge code from here.
We'll use it in just a second.

### On Cloudflare

It's all about the DNS.
You'll want to add these DNS records to Cloudflare.
Go to your Cloudflare dashboard `> DNS > Records` and we'll need to add these
records.

Check [the github
docs](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)
to ensure these addresses are correct

| Type | Name | Content | 
|:-----|:-----|:--------|
| A | example.com | 185.199.108.153 |
| A | example.com | 185.199.109.153 |
| A | example.com | 185.199.110.153 |
| A | example.com | 185.199.111.153 |
| A | www | 185.199.108.153 |
| AAA | example.com | 2606:50c0:8000::153 |
| AAA | example.com | 2606:50c0:8001::153 |
| AAA | example.com | 2606:50c0:8002::153 |
| AAA | example.com | 2606:50c0:8003::153 |
| TXT   | _github-pages-challenge-example | enter challenge code here |

I actually have two sites that point towards the same location.
My second site looks a lot more like the docs

| Type | Name | Content | 
|:-----|:-----|:--------|
| CNAME | www | example.github.io |
| CNAME | example.com | example.github.io |
| TXT   | _github-pages-challenge-example | enter challenge code here |


_This party might be a little incorrect. I'm writing after the fact. Please let
me know if this doesn't work._

Let's also head over to the rules page: `dashboard > Rules > Page Rules`.
You get 3 free rules and I use these for enabling https and caching.
Since your site is static it is a good idea to cache everything.
It is nice to Cloudflare and you benefit from quicker access.
It'll even work if github is down.

| Position | URL/Description | Rule |
|:--------:|:----------------|:-----|
| 1 | http://www.example.com/* | Always Use HTTPS |
| 2 | example.com/* | Forwarding URL > 301 - Permanent Redirect > https://example.github.io |
| 3 | https://www.example.com/* | Cache Level > Cache Everything |

### Wrapup

That should be it.
It may take some time to get this going. 
You can test the dig commands if you want to double check.
You probably won't need to, but it can help 

```bash
$ [ john@foo ~/ ] $ dig example.com +noall +answer -t A

# Let's check Cloudflare
$ [ john@foo ~/ ] $ dig example.com --trace @1.1.1.1
# and Google
$ [ john@foo ~/ ] $ dig example.com --trace @8.8.8.8
# and Quad9
$ [ john@foo ~/ ] $ dig example.com --trace @9.9.9.9
```

# Email
Another cool feature of Cloudflare is that they'll do email forwarding for you!
So you can still use your normal email address but the person on the other side
will see as if you are emailing them from your website.
This is great if you are hosting a personal website or an open source package or
whatever. 
You can communicate with them through that channel, automate things, keep your
identities separate, or whatever.
It's a nice feature, so let's use it.
The official docs are
[here](https://www.cloudflare.com/developer-platform/products/email-routing/).

Head back to your cloudflare dashboard and go to `Email > Email Routing` on the side tab.
Then go to the tab `Routing Rules` and add an address.
We need some base email address so let's do `info@example.com` set the action to
`Send to an email` and add whatever your email is: `johndoe@gmail.com`.
You can set up multiple destination addresses, so we could direct
`john@example.com` to `johndoe@gmail.com` and `jane@example.com` to
`janedoe@gmail.com` if we wanted to. 

After that, if you want, you can add a catch-all email address.
By default it will drop emails so if you want them all forwarded make sure to
change that option. 

At this point you should try sending yourself a test email.
You will *need* to do this from an address other than you are forwarding to.

## Replying from Gmail
Now we've just set up forwarding, but if you reply to these emails the person
you reply to will see your email address.
Let's fix that.

Let's first make an app password for our Google account.
This way we can cut off access easily if needed.
Head over to the [google security page](https://security.google.com/settings/security/apppasswords)[^2]
and let's create that password.
Name it something like `Cloudflare Email` or something descriptive.
Write this down!
Add it to your password manager!

[^2]: I'm not sure how to find this page except by using the search bar within
    your account page. So this link is helpful. WTF Google...

Now, let's head over to [gmail](mail.google.com).
Click the cog wheel at the top right `settings > See All Settings > Accounts and
Import > Send mail as: > Add another email address`.
You'll get a page that has info like this, where you will need to add your name
(`John Doe`).
Leave the alias checkbox marked

```
Edit email address
    Edit information for john@example.com
    (your name and email address will be shown on mail you send)
    
             Name: John Doe
    Email address: john@example.com
              [x]  Treat as an alias. Learn more
                   Specify a different "reply-to" address (optional)

             --------   --------------
            | Cancel | | Next Step >> |
             --------   --------------
```

Then on the next screen we'll set up the SMTP server.
Remember that our *gmail* address is `johndoe@gmail.com`!

```
Edit email address
    Send mail through your SMTP server

    Configure your mail to be sent through example.com SMTP servers Learn more

                You are currently using: secured connection on port 587 using
                TLS
                To edit, please adjust your preferences below.

     SMTP Server: smtp.gmail.com            Port: 587
        Username: johndoe
        password: <your app password here>
                  (.) Secured connection using TLS (recommended)
                  ( ) Secured connection using SSL

             --------   ----------    -------------- 
            | Cancel | | << Back  |  | Save Changes |
             --------   ----------    -------------- 
```

Now when you reply in Gmail make sure to click on your name and select the
alias.
If you don't do this then you will respond from your main gmail address.
I wish this was by default, but ¯\\\_(ツ)\_/¯	

## Thunderbird
I'm a big fan of
[ThunderBird](https://www.thunderbird.net/en-US/thunderbird/all/), Mozilla's
email client.
So let's also set up Thunderbird to work this way as well!

Go to your `Account Settings`, click on your gmail page (the line that has the
        email icon and says `johndoe@gmail.com`)
Down at the bottom you'll see a button that says `Manage Identities...`.
Click that and `Add` one.
Under `Public Data` add the following information

```
Your Name:          John Doe
Email Address:      john@example.com
Reply-to Address:   john@example.com
Organization:       example.com

... skip to the bottom ...

Identity Label:     example.com
```

Make sure to have that `Reply-to Address` filled in because that's what makes it
appear to come from your domain.

Like gmail, you will need to make sure you are replying from the correct
identity.
Luckily ThunderBird makes this more noticeable given the colored markings and
more detailed info in the to and from forums. 

Side note: if you are testing from within ThunderBird you might get a weird
error.
So if you send from `other_john@myotheremail.com` and send to `john@example.com` 
when you select `john@example.com` from your identity it might put in the wrong
address in the reply. 
I had a friend send me an email and I never experienced this bug, so probably
something you'll only experience in testing, but if you run into this don't
freak out. 
