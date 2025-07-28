There's some latex commands you might not know about

```bash
# Open PDF for documentation on package
$ texdoc <packagename>
# Try these options, which are different
$ texdoc {nutshell,gentle,lshort,tex,texbytopic,impatient}

# Show path to a cls or sty file
# Let's say we want to know where beamer is
$ kpsewhich beamer.cls
/usr/local/texlive/2025/texmf-dist/tex/latex/beamer/beamer.cls
# Then maybe we want to know where the default theme file is
$ kpsewhich beamerinnerthemedefault.sty
/usr/local/texlive/2025/texmf-dist/tex/latex/beamer/beamerinnerthemedefault.sty

# Suppose we don't know if beamer is a class or style file? 
#   As a better example, what about beamerposter?
#   Let's instead do
$ tlmgr info beamerposter --list --only-files
```

# Resources
(expect these to be pdfs. I mean... it is LaTeX...)
## General LaTeX

- [The Not So Short Introduction to LaTeX](https://tobi.oetiker.ch/lshort/lshort.pdf) 
- [LaTeX for Authors](https://www.latex-project.org/help/documentation/usrguide.pdf)
- [Tools for creating LaTeX-integrated graphics and animations under
GNU/Linux](https://www.tug.org/pracjourn/2010-1/sunol/sunol.pdf)
- [LaTeX Wiki](https://en.wikibooks.org/wiki/LaTeX)
- [LaTeX.net](https://latex.net/) (has a lot of everything)

## TikZ
- [Tikz examples](https://texample.net/tikz/examples/)
- [LaTeX Cookbook](https://latex-cookbook.net/)
- [TikZ.net](https://tikz.net/) (has some pretty [crazy](https://tikz.net/tux/)
[examples](https://tikz.net/symmetry_in_stereographic_projection_of_90_degree_rotated_sphere/))
- [PGFplots.net](https://pgfplots.net/)
