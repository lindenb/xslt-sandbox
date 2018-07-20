<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:x="http://www.ibm.com/xmlns/prod/2009/jsonx"
	xmlns:atom="http://www.w3.org/2005/Atom"
        xmlns="http://www.w3.org/2005/Atom"
        xmlns:date="http://exslt.org/dates-and-times"
	exclude-result-prefixes="atom date x"
	version='1.0'
	>
<!--

Author:
	Pierre Lindenbaum PhD
	plindenbaum@yahoo.fr

Motivation:
	qwant json-x to atom
Usage:

cat ~/bin/qwant.all.bash


```
#!/bin/bash
cat << EOF | while read A B ; do bash ${HOME}/bin/qwant1.bash "$A" "$B" && sleep 1; done
q1	bioinformatics
q2	genetics
EOF

```

 ~/bin/qwant1.bash 
 
```
#!/bin/bash
wget -q -O - "https://api.qwant.com/api/search/web?q=${2}" |\
java -jar ${HOME}/src/jsandbox/dist/json2xml.jar  |\
xsltproc -o "${HOME}/public_html/feed/qwant.${1}.xml" ${HOME}/src/xslt-sandbox/stylesheets/qwant/jsonx2atom.xsl -
```
crontab -e

```
# m h  dom mon dow   command
0 10 * * * /home/lindenb/bin/qwant.all.bash
```


-->
<xsl:output method="xml" indent="yes"/>


<xsl:template match="/">
<xsl:variable name="q" select="x:object/x:object[@name='data']/x:object[@name='query']/x:string[@name='query']"/>
<feed>
	<title><xsl:value-of select="$q"/></title>
	<id>https://api.qwant.com/api/search/web?q=<xsl:value-of select="translate($q,' ','+')"/></id>
	<updated> <xsl:value-of select="date:date-time()"/></updated>
	<xsl:apply-templates select="x:object/x:object[@name='data']/x:object[@name='result']/x:array[@name='items']/x:object" mode='item'/>
</feed>
</xsl:template>

<xsl:template match="x:object" mode='item'>
<entry>
	<id><xsl:value-of select="x:string[@name='url']/text()"/></id>
	<author><name>qwant</name></author>
	<title><xsl:value-of select="x:string[@name='title']/text()"/></title>
	<link rel="alternate">
		<xsl:attribute name="href">
			<xsl:value-of select="x:string[@name='url']/text()"/>
		</xsl:attribute>
	</link>
	<content type="html"><xsl:value-of select="x:string[@name='desc']/text()"/></content>
</entry>
</xsl:template>


</xsl:stylesheet>

