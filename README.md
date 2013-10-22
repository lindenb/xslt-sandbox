my XSLT sandbox.


# Examples

Saving a github-wiki page so I can use it in a blog:

```bash
$ curl -s "https://github.com/lindenb/jvarkit/wiki/Illuminadir" |\
  xsltproc --html ./github2html.xsl  -   >  file.html
  
```

Transforming (X)html to **LaTex**

```bash
$ xsltproc  html2latex.xsl input.html > tmp.tex && pdflatex tmp.tex 
```
