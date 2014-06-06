# my XSLT sandbox.


## Examples

Saving a github-wiki page so I can use it in a blog:

```bash
$ curl -s "https://github.com/lindenb/jvarkit/wiki/Illuminadir" |\
  xsltproc --html ./github2html.xsl  -   >  file.html
  
```

Saving a github-wiki page to **LaTex**:

```bash
$ curl -s "https://github.com/lindenb/jvarkit/wiki/Illuminadir" |\
  xsltproc --html ./github2html.xsl  -   >  file.html
  
```


Transforming (X)html to **LaTex**

```bash
$ curl -s "https://github.com/lindenb/jvarkit/wiki/Illuminadir" |\
  xsltproc --html ./stylesheets/github/github2tex.xsl  -  > tmp.tex && \
  pdflatex tmp.tex && \
  evince tmp.pdf
```

Insert **Blast** results in **sqlite3**:
```bash
$ xsltproc --novalid blast2sqlite.xsl blast.xml | sqlite3 blast.sqlite3
```

Convert blast to HTML (see also http://www.biostars.org/p/6635/ )

```bash
$ xsltproc --novalid blast2html.xsl blast.xml > result.html
```


Convert kegg-xml (kgml) to GEXF (see also http://www.biostars.org/p/85763/ )

```bash
$ xsltproc --novalid kgml2gexf.xsl "http://kgmlreader.googlecode.com/svn/trunk/KGMLReader/testData/kgml/non-metabolic/organisms/hsa/hsa04060.xml" > result.gexf
```

Insert **Pubmed** into a **sqlite3** database.

```bash
$ xsltproc --novalid stylesheets/bio/ncbi/pubmed2sqlite.xsl pubmed_result.xml | sqlite3 jeter.db
```

convert **Pubmed** to **JSON**

```bash
$ xsltproc --novalid stylesheets/bio/ncbi/pubmed2json.xsl pubmed_result.xml  | python -mjson.tool

```


Create a simple Blast dot plot (see  http://www.biostars.org/p/85258/ "Make a dotplot from blast alignment" ) 

```bash
$ xsltproc --novalid stylesheets/bio/ncbi/pubmed2sqlite.xsl pubmed_result.xml | sqlite3 jeter.db
```


Get the number of children for each term in gene-ontology (see  https://www.biostars.org/p/102699/ "How to determine the terminal GO terms within GO DAG" ) 

```bash
curl  "http://archive.geneontology.org/latest-termdb/go_daily-termdb.rdf-xml.gz" |\
	gunzip -c |\
	xsltproc --novalid go2countchildren.xsl go.rdf - > count.tsv
```



