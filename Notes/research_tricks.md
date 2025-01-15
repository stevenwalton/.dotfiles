# Notes About Things Involving Research 
These are not research notes, but notes about things that involve research.
Tips and tricks I often forget and that might not always be so obvious.

# Papers and Bibtex
Getting the right bibtex file is often not so easy.
This gets complicated as Google Scholar, Semantic Scholar, and others might not
have the correct bibtex, or point to the arXiv version of the paper.
Finding the GitHub sometimes helps but for some reason authors do not update
their citations (and sometimes don't include them!) so this isn't always
reliable :(
Searching Google can often help you to get to the official paper, but it will
link to the pdf version on the conference page and not the main page.
This is frustrating.
The easy thing is to just remember how the url patterns fit so you can just use
that and jump to the right page.

## Conference URL reformatting

***CVPR***

There's two possible CVPR html formats I'm aware of. These are pretty close and
the difference is `/content_CVPR_<YEAR>` vs `/content/CVPR<YEAR>/`

```bash
# Older version
https://openaccess.thecvf.com/content_CVPR_<YEAR>/papers/<FIRST_AUTHOR>_<TITLE>_CVPR_<YEAR>_paper.pdf
# Newer Version
https://openaccess.thecvf.com/content/CVPR<YEAR>/papers/<FIRST_AUTHOR>_<TITLE>_CVPR_<YEAR>_paper.pdf
```
Change `/paper/` to `/html` and `.pdf` to `.html`
```bash
# Older 
https://openaccess.thecvf.com/content_CVPR_<YEAR>/html/<FIRST_AUTHOR>_<TITLE>_CVPR_<YEAR>_paper.html
# Newer
https://openaccess.thecvf.com/content/CVPR<YEAR>/html/<FIRST_AUTHOR>_<TITLE>_CVPR_<YEAR>_paper
```

***NeruIPS/NIPS***

This one is a bit more convoluted...
```bash
# pdf version
https://papers.nips.cc/paper/<YEAR>/file/<HASH>-Paper.pdf
https://proceedings.neurips.cc/paper_files/paper/<YEAR>/file/<HASH>-Paper.pdf
################
# abstract/main page
https://papers.nips.cc/paper_files/paper/<YEAR>/hash/<HASH>-Abstract.html
https://proceedings.neurips.cc/paper_files/paper/<YEAR>/hash/<HASH>-Abstract.html
```
Note that here we need to add `/paper_files/` before `/paper`, and that `/file/`
becomes `/hash/` where this is the literal string and not the paper's hash.
Finally we change the tag before the extension changes from `Paper` to `Abstract`.
The `.html` extension is necessary.[^2]
Then we get to *download* the file... oh joy...

[^2]: If anyone on the NeurIPS committee is reading this, you should probably
  resolve this. Enable `Options +Multiviews` in `.htaccess` to allow files to be
  accessed without their extensions. See [Apache
  docs under Multiviews](https://httpd.apache.org/docs/current/content-negotiation.html)

***OpenReview***

This is by far the easiest

```bash
# Paper
https://openreview.net/pdf?id=<HASH>
# Review page
https://openreview.net/forum?id=<HASH>
```

***PMLR***

The transition is easy here.
There is a repeated string at the end and you just remove the redundancy.

```bash
# Paper
https://proceedings.mlr.press/v<Number>/<AuthorNum>/<AuthorNum>.pdf
# Abstract
https://proceedings.mlr.press/v<Number>/<AuthorNum>.html
```

***ICCV***

This one is ***tricky***. 
It is case sensitive so it is harder to guess your way in.

***ICCV*** changes to ***iccv***. Make changes similar to CVPR where you change
`papers` and `pdf` to `html`

```bash
# Paper
https://openaccess.thecvf.com/content_ICCV_<YEAR>/papers/<AUTHOR>_<ShortName>_for_ICCV_<YEAR>_paper.pdf
# Abstract
https://openaccess.thecvf.com/content_iccv_<YEAR>/html/<AUTHOR>_<ShortName>_for_ICCV_<YEAR>_paper.html
```

## Illustrative Example of Issue

Let's see an example, and we'll google one of my papers:
*"Neighborhood Attention Transformer"*.
The official CVPR bibtex file is:

```bibtex
@InProceedings{Hassani_2023_CVPR,
    author    = {Hassani, Ali and Walton, Steven and Li, Jiachen and Li, Shen and Shi, Humphrey},
    title     = {Neighborhood Attention Transformer},
    booktitle = {Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR)},
    month     = {June},
    year      = {2023},
    pages     = {6185-6194}
}
```

Of course, our first Google hit is [arXiv](https://arxiv.org/abs/2204.07143). 
They have bibtex files! 
But these don't communicate if the work has been accepted anywhere[^1].
It looks like this

[^1]: Note that you can add a comment on your arXiv listings. We do so here
  linking to our github page and noting that it appears in CVPR 2023

```bibtex
@misc{hassani2023neighborhoodattentiontransformer,
      title={Neighborhood Attention Transformer},
      author={Ali Hassani and Steven Walton and Jiachen Li and Shen Li and Humphrey Shi},
      year={2023},
      eprint={2204.07143},
      archivePrefix={arXiv},
      primaryClass={cs.CV},
      url={https://arxiv.org/abs/2204.07143},
}
```
Our second Google hit is our GitHub, and we did update.
Third is our [CVPR pdf issue...](https://openaccess.thecvf.com/content/CVPR2023/papers/Hassani_Neighborhood_Attention_Transformer_CVPR_2023_paper.pdf)
That's good since we know our trick above, but let's continue.
Next is Google Scholar.
Frequently this doesn't correctly point to the official page and instead to
arXiv again.
Luckily ours does but look, it is different...

```bibtex
@inproceedings{hassani2023neighborhood,
  title={Neighborhood attention transformer},
  author={Hassani, Ali and Walton, Steven and Li, Jiachen and Li, Shen and Shi, Humphrey},
  booktitle={Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition},
  pages={6185--6194},
  year={2023}
}
```
At least this will communicate conference information but it's worth noting that
it is different. 
Then we get [papers with code](https://paperswithcode.com/method/na) but that
points to the Neighborhood Attention page, instead of the paper page, though
from there we can get to the CVPR abstract page (PWC is often good for getting
to the right bibtex).
Then we have [Hugging
Face](https://huggingface.co/docs/transformers/main/en/model_doc/nat), which
again doesn't include a bibtex and will link to the arXiv file.
After that is someone else's GitHub who links to our official page `¯\_(ツ)_/¯`
Then after that we have Semantic Scholar, which gives us this

```bibtex
@article{Hassani2022NeighborhoodAT,
  title={Neighborhood Attention Transformer},
  author={Ali Hassani and Steven Walton and Jiacheng Li and Shengjia Li and Humphrey Shi},
  journal={2023 IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR)},
  year={2022},
  pages={6185-6194},
  url={https://api.semanticscholar.org/CorpusID:248178045}
}
```

Again, different from the official but at least has the conference information.

--------------------


Let's see an example, we'll google *"A Style-Based Generator Architecture for
Generative Adversarial Networks"*.
This paper was published at CVPR 2019 and we want their bibtex file.
The "official" bibtex is:



The first hit is arXiv, which yes, will provide a bibtex, but it looks like this

```bibtex
@misc{karras2019stylebasedgeneratorarchitecturegenerative,
      title={A Style-Based Generator Architecture for Generative Adversarial Networks},
      author={Tero Karras and Samuli Laine and Timo Aila},
      year={2019},
      eprint={1812.04948},
      archivePrefix={arXiv},
      primaryClass={cs.NE},
      url={https://arxiv.org/abs/1812.04948},
}
```
Not what we want, it doesn't say that it was published in CVPR.
The next link is to CVPR! But it is the pdf! :(
[https://openaccess.thecvf.com/content_CVPR_2019/papers/Karras_A_Style-Based_Generator_Architecture_for_Generative_Adversarial_Networks_CVPR_2019_paper.pdf](https://openaccess.thecvf.com/content_CVPR_2019/papers/Karras_A_Style-Based_Generator_Architecture_for_Generative_Adversarial_Networks_CVPR_2019_paper.pdf)
Third hit is luckily Google Scholar, and it has a cite. Nice. Let's see

```bibtex
@inproceedings{karras2019style,
  title={A style-based generator architecture for generative adversarial networks},
  author={Karras, Tero and Laine, Samuli and Aila, Timo},
  booktitle={Proceedings of the IEEE/CVF conference on computer vision and pattern recognition},
  pages={4401--4410},
  year={2019}
}
```
Okay, that's mostly, right. I'm not sure why this isn't correct. 
The next is
[computer.org](https://www.computer.org/csdl/journal/tp/2021/12/08977347/1h2AHNHb9bW)
which does generate a bibtex, but again it is not quite right and this says it
is IEEE TPAMI.
Semantic scholar 
