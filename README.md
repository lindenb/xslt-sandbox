# my XSLT sandbox.


## Examples

Saving a github-wiki page so I can use it in a blog:

```bash
$ curl -s "https://github.com/lindenb/jvarkit/wiki/Illuminadir" |\
  xsltproc --html ./github2html.xsl  -   >  file.html
  
```

Transforming (X)html to **LaTex**

```bash
$ xsltproc  html2latex.xsl input.html > tmp.tex && pdflatex tmp.tex 
```

Insert **Blast** results in **sqlite3**:
```bash
$ xsltproc --novalid blast2sqlite.xsl blast.xml | sqlite3 blast.sqlite3
```

Convert blast to HTML (see also http://www.biostars.org/p/6635/ )

```bash
$ xsltproc --novalid blast2html.xsl blast.xml > result.html
```
