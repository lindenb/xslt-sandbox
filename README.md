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

Get all the child terms in **Disease ontology** under **DOID:2914** ( immune system disease ) http://disease-ontology.org/ .


```bash
$ curl "http://www.berkeleybop.org/ontologies/doid.owl" |\
    xsltproc --stringparam ID "DOID:2914" do_children.xsl -
```

```tsv
#ID	LABEL	URI	DESCRIPTION
DOID:2914	immune system disease	http://purl.obolibrary.org/obo/DOID_7	A disease of anatomical entity that is located_in the immune system.
DOID:0060056	hypersensitivity reaction disease	http://purl.obolibrary.org/obo/DOID_2914	
DOID:1205	hypersensitivity reaction type I disease	http://purl.obolibrary.org/obo/DOID_0060056	An immune system disease that is an exaggerated immune response to allergens, such as insect venom, dust mites, pollen, pet dander, drugs or some foods.
DOID:3044	food allergy	http://purl.obolibrary.org/obo/DOID_1205	A hypersensitivity reaction type I disease that is an abnormal response to a food, triggered by the body's immune system.
DOID:0060057	gluten allergic reaction	http://purl.obolibrary.org/obo/DOID_3044	
DOID:3660	wheat allergic reaction	http://purl.obolibrary.org/obo/DOID_3044	
DOID:4376	milk allergic reaction	http://purl.obolibrary.org/obo/DOID_3044	A food allergy that results in adverse immune reaction to one or more of the proteins in cow's milk and/or the milk of other animals, which are normally harmless to the non-allergic individual.
DOID:4377	egg allergy	http://purl.obolibrary.org/obo/DOID_3044	A food allergy that is an allergy or hypersensitivity to dietary substances from the yolk or whites of eggs, causing an overreaction of the immune system which may lead to severe physical symptoms.
DOID:4378	peanut allergic reaction	http://purl.obolibrary.org/obo/DOID_3044	A food allergy that is an allergy or hypersensitivity to dietary substances from peanuts causing an overreaction of the immune system which in a small percentage of people may lead to severe physical symptoms.
(...)
```

### Generation of new java __KNIME__ nodes

see https://github.com/lindenb/xslt-sandbox/wiki/Knime2java

### Draw a [Manhattan plot](https://en.wikipedia.org/wiki/Manhattan_plot) in SVG

see https://github.com/lindenb/xslt-sandbox/wiki/ManhattanPlot

![Plot](http://i.imgur.com/HrGjouY.jpg)

## Create a Makefile from an apache-maven pom.xml to download the required jars:

```
$ xsltproc pom2make.xsl "http://central.maven.org/maven2/org/eclipse/jetty/jetty-server/9.3.0.M2/jetty-server-9.3.0.M2.pom"  2> /dev/null 
```

```make
lib.dir=lib
all.jars = $(addprefix ${lib.dir}/,$(sort  org/eclipse/jetty/jetty-server/9.3.0.M2/jetty-server-9.3.0.M2.jar javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.jar org/eclipse/jetty/jetty-http/9.3.0.M2/jetty-http-9.3.0.M2.jar org/eclipse/jetty/jetty-util/9.3.0.M2/jetty-util-9.3.0.M2.jar javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.jar org/slf4j/slf4j-api/1.7.10/slf4j-api-1.7.10.jar org/eclipse/jetty/jetty-io/9.3.0.M2/jetty-io-9.3.0.M2.jar org/eclipse/jetty/jetty-util/9.3.0.M2/jetty-util-9.3.0.M2.jar javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.jar org/slf4j/slf4j-api/1.7.10/slf4j-api-1.7.10.jar org/eclipse/jetty/jetty-jmx/9.3.0.M2/jetty-jmx-9.3.0.M2.jar org/eclipse/jetty/jetty-util/9.3.0.M2/jetty-util-9.3.0.M2.jar javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.jar org/slf4j/slf4j-api/1.7.10/slf4j-api-1.7.10.jar))

.PHONY:all

all: ${all.jars}
${all.jars} : 
	mkdir -p $(dir $@) && curl -o $@ "http://central.maven.org/maven2/$(patsubst ${lib.dir}/%,%,$@)"
```
see https://github.com/lindenb/xslt-sandbox/wiki/Maven2Make


### Plotting project Tycho data:

see https://github.com/lindenb/xslt-sandbox/wiki/Tycho

![http://i.imgur.com/gBZCVTX.png](http://i.imgur.com/gBZCVTX.png)

### Pubmed Trending Articles as a RSS feed.

see https://github.com/lindenb/xslt-sandbox/wiki/PubmedTrending

![http://i.imgur.com/a1VAdCa](http://i.imgur.com/a1VAdCa.jpg)


## Contribute

- Issue Tracker: http://github.com/lindenb/xslt-sandbox/issues`
- Source Code: http://github.com/lindenb/xslt-sandbox

## License

The project is licensed under the MIT license.

## Author

Pierre Lindenbaum PhD @yokofakun



