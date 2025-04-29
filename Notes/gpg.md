We're going to create a test gpg key and figure out how to use.

You can follow along.
There will be no permanent operations here and we'll undo everything.
We'll create some test keys, revoke them, and then delete them.
```bash
# generate a key
# You may also use `gpg --gen-key` which selects defaults
$ gpg --full-gen-key
gpg (GnuPG) 2.4.7; Copyright (C) 2024 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (9) ECC (sign and encrypt) *default*
  (10) ECC (sign only)
  (14) Existing key from card
Your selection? 1
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (3072) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0)                 <== Do not do this. Make your key expire!
Key does not expire at all
Is this correct? (y/N) y

GnuPG needs to construct a user ID to identify your key.

Real name: Ada Lovelace
Email address: ada@lovelace.org
Comment: This is a test key
You selected this USER-ID:
    "Ada Lovelace (This is a test key) <ada@lovelace.org>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
adasasasdgpg: revocation certificate stored as '/Users/steven/.gnupg/openpgp-revocs.d/914C5F1738D77C4F5FE82D525BA1E42F98444F71.rev'
public and secret key created and signed.

pub   rsa4096 2025-04-23 [SC]
      914C5F1738D77C4F5FE82D525BA1E42F98444F71
uid                      Ada Lovelace (This is a test key) <ada@lovelace.org>
sub   rsa4096 2025-04-23 [E]
```
Why make your key expire?
Well if you're gonna put it on a keyserver you're probably going to lose that
key when moving computers later or something and well now that key is there
forever and just littering things!
(Yeah... my 2015 gpg keys are defunct)

We also want to be able to revoke the key.
GPG automatically does this now (see the "revocation certificate stored as" line
above)
but if you want to do it manually or create another one we can do this!
It also allows us to specify why we're revoking a key.
```bash
 gpg --output revoke.crt --gen-revoke "ada@lovelace.org"

sec  rsa4096/5BA1E42F98444F71 2025-04-23 Ada Lovelace (My uni email test) <alovelace@turing.edu>

Create a revocation certificate for this key? (y/N) y
Please select the reason for the revocation:
  0 = No reason specified
  1 = Key has been compromised
  2 = Key is superseded
  3 = Key is no longer used
  Q = Cancel
(Probably you want to select 1 here)
Your decision? 0
Enter an optional description; end it with an empty line:
> This is a test key
>
Reason for revocation: No reason specified
This is a test key
Is this okay? (y/N) y
ASCII armored output forced.
Revocation certificate created.

Please move it to a medium which you can hide away; if Mallory gets
access to this certificate he can use it to make your key unusable.
It is smart to print this certificate and store it away, just in case
your media become unreadable.  But have some caution:  The print system of
your machine might store the data and make it available to others!
```

If you followed along you can view the keys
```bash
# Show the public keys you have
$ gpg --list-keys
gpg --list-keys
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
[keyboxd]
---------
pub   rsa4096 2025-04-23 [SC]
      914C5F1738D77C4F5FE82D525BA1E42F98444F71
uid           [ultimate] Ada Lovelace (This is a test key) <ada@lovelace.org>
sub   rsa4096 2025-04-23 [E]

# Show your private keys
$ gpg --list-secret-keys
[keyboxd]
---------
sec   rsa4096 2025-04-23 [SC]
      914C5F1738D77C4F5FE82D525BA1E42F98444F71
uid           [ultimate] Ada Lovelace (This is a test key) <ada@lovelace.org>
ssb   rsa4096 2025-04-23 [E]
```
Given that this is for email, we probably want to add another valid email
address.
```bash
$ gpg --edit-key "Ada Lovelace"
gpg (GnuPG) 2.4.7; Copyright (C) 2024 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

sec  rsa4096/5BA1E42F98444F71
     created: 2025-04-23  expires: never       usage: SC
     trust: ultimate      validity: ultimate
ssb  rsa4096/FDEA23E07B6BF6B6
     created: 2025-04-23  expires: never       usage: E
[ultimate] (1). Ada Lovelace (This is a test key) <ada@lovelace.org>

gpg> adduid
Real name: Ada Lovelace
Email address: alovelace@turing.edu
Comment: My uni email test
You selected this USER-ID:
    "Ada Lovelace (My uni email test) <alovelace@turing.edu>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O

sec  rsa4096/5BA1E42F98444F71
     created: 2025-04-23  expires: never       usage: SC
     trust: ultimate      validity: ultimate
ssb  rsa4096/FDEA23E07B6BF6B6
     created: 2025-04-23  expires: never       usage: E
[ultimate] (1)  Ada Lovelace (This is a test key) <ada@lovelace.org>
[ unknown] (2). Ada Lovelace (My uni email test) <alovelace@turing.edu>

gpg> q
Save changes? (y/N) y

$ gpg --list-keys
[keyboxd]
---------
pub   rsa4096 2025-04-23 [SC]
      914C5F1738D77C4F5FE82D525BA1E42F98444F71
uid           [ultimate] Ada Lovelace (My uni email test) <alovelace@turing.edu>
uid           [ultimate] Ada Lovelace (This is a test key) <ada@lovelace.org>
sub   rsa4096 2025-04-23 [E]

$ gpg --list-secret-keys
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
[keyboxd]
---------
sec   rsa4096 2025-04-23 [SC]
      914C5F1738D77C4F5FE82D525BA1E42F98444F71
uid           [ultimate] Ada Lovelace (My uni email test) <alovelace@turing.edu>
uid           [ultimate] Ada Lovelace (This is a test key) <ada@lovelace.org>
ssb   rsa4096 2025-04-23 [E]
```
Let's now revoke they keys and then delete them
```bash
# Revoke the key
$ gpg --import revoke.crt
gpg: key 5BA1E42F98444F71: "Ada Lovelace (My uni email test) <alovelace@turing.edu>" revocation certificate imported
gpg: Total number processed: 1
gpg:    new key revocations: 1
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
# If you submitted to a keyserver then send your keys
# gpg --keyserver pgp.mit.edu --send-keys "Ada Lovelace"

# Notice both ids are revoked
# Notice we can create multiple revoke files!
$ gpg --list-keys
[keyboxd]
---------
pub   rsa4096 2025-04-23 [SC] [revoked: 2025-04-23]
      914C5F1738D77C4F5FE82D525BA1E42F98444F71
uid           [ revoked] Ada Lovelace (My uni email test) <alovelace@turing.edu>
uid           [ revoked] Ada Lovelace (This is a test key) <ada@lovelace.org>

# We see they are revoked!
# To delete we need to do our private key first
# GPG will yell at you, and for good reason
$ gpg --delete-secret-key "Ada Lovelace"
gpg (GnuPG) 2.4.7; Copyright (C) 2024 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.


sec  rsa4096/5BA1E42F98444F71 2025-04-23 Ada Lovelace (My uni email test) <alovelace@turing.edu>

Delete this key from the keyring? (y/N) y
This is a secret key! - really delete? (y/N) y
# Alternatively we could have done
# gpg --delete-secret-key "914C5F1738D77C4F5FE82D525BA1E42F98444F71"

# Now the public key
$ gpg --delete-key "Ada Lovelace"
gpg (GnuPG) 2.4.7; Copyright (C) 2024 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.


pub  rsa4096/5BA1E42F98444F71 2025-04-23 Ada Lovelace (My uni email test) <alovelace@turing.edu>

Delete this key from the keyring? (y/N) y

# Check
$ gpg --list-secret-keys
gpg: checking the trustdb
gpg: no ultimately trusted keys found

$ gpg --list-keys
[keyboxd]
---------
# You might have something here but you won't have the Lovelace key
# I'm hiding my keys even though it is not really needed
```

# Signing
You may want to sign a file or message.
The point of signing is to verify authenticity.

```bash
# Make a secret message
# We use parentheses and umask to make sure secrets is born 
# with the correct permissions.
# umask will return to 022 afterwards
$ (umask 077; echo "I like cats" > secret.txt)

# We have 2 ways to sign

## OPTION 1:
# Plain Text
$ gpg --clearsign secret.txt
# Check message
$ cat secret.txt.asc
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I like cats
-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQTmG1w8Pc+9rC85Aqi0cOgrdl6SOgUCaAiTGgAKCRC0cOgrdl6S
OviIAP9TBlR7PThHGbmpgnV+8hnaeDUDgWwjaMXfQYux6cn1+wEAhUL4fkHSXiNo
4ToArJ9QA1G2qN3GOyMWFSMzyo8xUwI=
=asEj
-----END PGP SIGNATURE-----

## OPTION 2:
# Binary
$ gpg --sign secret.txt
# Check message
$ cat secret.txt.gpg
<garbage binary output>

# We can instead "decrypt" them
$ gpg --decrypt secret.txt.asc
I like cats
gpg: Signature made Wed Apr 23 00:13:30 2025 PDT
gpg:                using EDDSA key E61B5C3C3DCFBDAC2F3902A8B470E82B765E923A
gpg: Good signature from "Ada Lovelace <ada@lovelace.edu>" [ultimate]
#
$ gpg --decrypt secret.txt.gpg
I like cats
gpg: Signature made Wed Apr 23 00:15:43 2025 PDT
gpg:                using EDDSA key E61B5C3C3DCFBDAC2F3902A8B470E82B765E923A
gpg: Good signature from "Ada Lovelace <ada@lovelace.edu>" [ultimate
```
Because this is signed, you know that Ada Lovelace likes cats.
It proves the authenticity of her statement! 

# More Reading
- [Dev Dungeon's GPG Tutorial](https://www.devdungeon.com/content/gpg-tutorial)
- [Arch Wiki](https://wiki.archlinux.org/title/GnuPG)
- [GPG Guide](https://www.gnupg.org/gph/en/manual/c14.html)
- [RedHat Guide](https://www.redhat.com/en/blog/creating-gpg-keypairs)
