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


Transforms a **NCBI taxonomy** to **Graphiz dot**:
```bash
 xsltproc taxon2dot.xsl "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&id=9606,9913,30521,562,2157" |\
 	dot -oout.png -Tpng 
```

Get the number of children for each term in gene-ontology (see  https://www.biostars.org/p/102699/ "How to determine the terminal GO terms within GO DAG" ) 

```bash
curl  "http://archive.geneontology.org/latest-termdb/go_daily-termdb.rdf-xml.gz" |\
	gunzip -c |\
	xsltproc --novalid go2countchildren.xsl go.rdf - > count.tsv
```

Extract **HTML** form:
```bash
$ curl -L google.com | xsltproc --html  stylesheets/html/html2curl.xsl -
'&ie=ISO-8859-1&hl=fr&source=hp&q=&btnG=Recherche%20Google&btnI=J'ai%20de%20la%20chance&gbv=1'
```

convert **NCBI/EInfo** to **HTML**

```
xsltproc --novalid \
	stylesheets/bio/ncbi/einfo2html.xsl \
	http://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi  > index.html
```

convert **Blast/XML** to a **HTML** matrix

```
xsltproc --novalid \
	stylesheets/bio/ncbi/blast2matrix.xsl \
	blastn.xml  > blast.html
```

convert **NCBI Taxonomy** to **newick**

```
$ xsltproc stylesheets/bio/ncbi/taxon2newick.xsl "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&id=9606,10090,9031,7227,562" 

(((((((((((((((((((((((((((((((Homo_sapiens)Homo)Homininae)Hominidae)Hominoidea)Catarrhini)Simiiform
es)Haplorrhini)Primates,((((((((Mus_musculus)Mus)Mus)Murinae)Muridae)Muroidea)Sciurognathi)Rodentia)
Glires)Euarchontoglires)Boreoeutheria)Eutheria)Theria)Mammalia,(((((((((((((((Gallus_gallus)Gallus)P
hasianinae)Phasianidae)Galliformes)Galloanserae)Neognathae)Aves)Coelurosauria)Theropoda)Saurischia)D
inosauria)Archosauria)Archelosauria)Sauria)Sauropsida)Amniota)Tetrapoda)Dipnotetrapodomorpha)Sarcopt
erygii)Euteleostomi)Teleostomi)Gnathostomata)Vertebrata)Craniata)Chordata)Deuterostomia,((((((((((((
(((((((((((((((((Drosophila_melanogaster)melanogaster_subgroup)melanogaster_group)Sophophora)Drosoph
ila)Drosophiliti)Drosophilina)Drosophilini)Drosophilinae)Drosophilidae)Ephydroidea)Acalyptratae)Schi
zophora)Cyclorrhapha)Eremoneura)Muscomorpha)Brachycera)Diptera)Endopterygota)Neoptera)Pterygota)Dico
ndylia)Insecta)Hexapoda)Pancrustacea)Mandibulata)Arthropoda)Panarthropoda)Ecdysozoa)Protostomia)Bila
teria)Eumetazoa)Metazoa)Opisthokonta)Eukaryota,((((((Escherichia_coli)Escherichia)Enterobacteriaceae
)Enterobacteriales)Gammaproteobacteria)Proteobacteria)Bacteria)cellular_organisms);

```
