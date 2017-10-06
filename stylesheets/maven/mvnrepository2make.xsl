<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        xmlns:date="http://exslt.org/dates-and-times" 
        xmlns:xi="http://www.w3.org/2001/XInclude"
        xmlns:pom="http://maven.apache.org/POM/4.0.0"
		version='1.0'
		exclude-result-prefixes="date xi"
        >
<!--
Author:
        Pierre Lindenbaum @yokofakun
        http://plindenbaum.blogspot.com

Motivation:
	generate Makefile from a mvnrepository page
	
Example:
	curl -s "https://mvnrepository.com/artifact/org.apache.spark/spark-core_2.11/2.2.0" |\
	xsltproc -\-html mvnrepository2make.xsl  -


-->
<xsl:output method="text"/>

<xsl:template match="/">
<xsl:value-of select="translate(substring-after((html/head/link[@rel='canonical']/@href),'/artifact/'),'/','.')"/>.jar = \
<xsl:apply-templates select="//h2[contains(text(),'Compile Dependencies (')]/following-sibling::table" />
</xsl:template>

<xsl:template match="table">
<xsl:apply-templates select="tbody/tr"/>
</xsl:template>

<xsl:template match="tr">
<xsl:variable name="basename" select="td[3]/a[2]/text()"/>
<xsl:variable name="version" select="normalize-space(td[4]/a/text())"/>

<xsl:text>	</xsl:text>
<xsl:value-of select="translate(substring-after(td[3]/a[1]/@href,'/artifact/'),'.','/')"/>
<xsl:text>/</xsl:text>
<xsl:value-of select="$basename"/>
<xsl:text>/</xsl:text>
<xsl:value-of select="$version"/>
<xsl:text>/</xsl:text>
<xsl:value-of select="$basename"/>
<xsl:text>.</xsl:text>
<xsl:value-of select="$version"/>
<xsl:text>.jar \
</xsl:text>
</xsl:template>

</xsl:stylesheet>
