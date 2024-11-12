Previously in [bashing around](bashing_around.md)

Random notes on Git

# MD Formatting on GitHub

Take pride in your work.
Make things look pretty!
It will also help you communicate better!.
There's lots of things you can do in GitHub's markdown that can really help make
things look nicer.
I've been learning more so thing will continue to improve ;)

One cool thing we can do is display images conditioned on if the user is using
github dark mode or light mode.
From [Ali Hassani](https://github.com/alihassanijr)'s [Neighborhood
Attention](https://github.com/SHI-Labs/Neighborhood-Attention-Transformer)
project you'll find 

```markdown
![NAT-Intro](assets/dinat/intro_dark.png#gh-dark-mode-only)
![NAT-Intro](assets/dinat/intro_light.png#gh-light-mode-only)
```

<details closed>
<summary>This will render like this</summary>
<br>

![NAT-Intro](https://github.com/SHI-Labs/Neighborhood-Attention-Transformer/blob/d334f5bb0bd73cad05e5aeaf7c14cce3876a9650/assets/dinat/intro_dark.png#gh-dark-mode-only)
![NAT-Intro](https://github.com/SHI-Labs/Neighborhood-Attention-Transformer/blob/d334f5bb0bd73cad05e5aeaf7c14cce3876a9650/assets/dinat/intro_light.png#gh-light-mode-only)

</details>

But can we do better?
Of course we can, or else we wouldn't be writing this.
Let's throw it in a table and then add a caption.
Of course, we need to do centering as well because we aren't madmen!
Markdown doesn't let us do this, but luckily it supports HTML!
(we'll shrink the image size a little to more explicitly show the effect)

```markdown
<table align="center">
    <tr>
        <td>
            <img width=400px src="https://github.com/SHI-Labs/Neighborhood-Attention-Transformer/blob/d334f5bb0bd73cad05e5aeaf7c14cce3876a9650/assets/dinat/intro_dark.png#gh-dark-mode-only"  alt="NAT-Intro" />
            <img width=400px src="https://github.com/SHI-Labs/Neighborhood-Attention-Transformer/blob/d334f5bb0bd73cad05e5aeaf7c14cce3876a9650/assets/dinat/intro_light.png#gh-light-mode-only" alt="NAT-Intro" />
            <br>
            <p align="center"><sub>Comparison of NA/DiNA with different dilations</sub></p>
        </td>
    </tr>
</table>
```

<details closed>
<summary>This will render like this</summary>
<br>

<table align="center">
    <tr>
        <td>
            <img width=400px src="https://github.com/SHI-Labs/Neighborhood-Attention-Transformer/blob/d334f5bb0bd73cad05e5aeaf7c14cce3876a9650/assets/dinat/intro_dark.png#gh-dark-mode-only"  alt="NAT-Intro" />
            <img width=400px src="https://github.com/SHI-Labs/Neighborhood-Attention-Transformer/blob/d334f5bb0bd73cad05e5aeaf7c14cce3876a9650/assets/dinat/intro_light.png#gh-light-mode-only" alt="NAT-Intro" />
            <br>
            <p align="center"><sub>Comparison of NA/DiNA with different dilations</sub></p>
        </td>
    </tr>
</table>

</details>

# .git is large!
Git can be a bit crazy. 
One of the things that bothers me the most is how large the `.git` folder can get.
As of this writing this dotfiles takes 229M of disk space.
82M is from the `rc_files` of which 81M is from plugged, so won't be part of the
`git clone` process but will be from `vim -c PlugInstall -c qa`
`.git` you ask? It is 147M! That's crazy considering no single directory here
takes even 1M of space.
What can we do?
[Linus recommends](https://gcc.gnu.org/legacy-ml/gcc/2007-12/msg00165.html)
`git repack -a -d --depth=250 --window=250`
But I think what he actually means is `git repack -adf --depth=250 --window=250
--threads 4` (or some other number of threads).
The `-f` (which he mentions) drops all old deltas.
`depth` is how long our delta chains are and `window` is the object window to
scan for a candidate.
So `depth` is our history and `window` is our context window.
I ran `git repack -adf --depth=50 --window=500 --threads 4` and this reduced it
to 180M but took 10 minutes on my M2 Air.

Let's do a bit better.
This is an old repo, I've made lots of mistakes and there are definitely bins
from vim, zsh, and elsewhere.

```bash
# Collect garbage
# Prunes with default of 2 weeks ago
$ git gc
# // 171M 
# Remove old files and respect the .gitignore
$ git clean -fx
$ git reflog expire --all
$ git filter-branch --index-filter 'git rm --cached --ignore-unmatch filename' HEAD
# // 175M :(
```

Let's try something a bit different and use `git-filter-repo`.
Since we know that 
`find rc_files -type f -not -path "rc_files/vim/plugged/*" -size +10k`
returns only a few files, we know we can probably prune quite a lot of stuff!
Only thing larger than 50K is `plugged` which is an ignored directory!
At 20k we only have that and our ipython history, which should be removed!

***WARNING:*** don't do the following on group or production code where you care
about history!

```bash
$ wget https://raw.githubusercontent.com/newren/git-filter-repo/main/git-filter-repo \
    -o ~/.local/bin/git-filter-repo
$ chmod +x ~/.local/bin/git-filter-repo
$ git-filter-repo --analyze
# Ah ha! Nerd fonts git in there. Bunch of .ttf, otf and pngs
$ git-filter-repo --strip-blobs-bigger-than 1M --force
# 140M! .git is not 58M
# Let's be aggressive! 
$ git-filter-repo --strip-blobs-bigger-than 20K --force
# 84M! .git is 2.2M
$ git clean -xf
$ git prune --now 
# For some reason this destroyed upstream
$ git remote add origin git@github.com:stevenwalton/.dotfiles.git
$ git push --set-upstream origin master
$ git push --force --all origin
```
Did I destroy a lot of my git history?
Yeah, probably.
But this is an evolving dotfiles and I'm not really too concerned about the
history, so it is a good place to experiment.
But considering that our directory is now under 100M and the upstream is under
3M I'm taking this as a big win.
I want to be able to clone this repo fast.
Timing this, I downloaded the repo prior to these changes and it took about 2
minutes and gave me a directory that was 162M in size.
NOW it takes under 2 seconds to clone and I get a 2M folder!
What a win!

***Note:***
you may also need to run

```bash
$ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
$ vim -c "PlugInstall" -c "qa"
```
