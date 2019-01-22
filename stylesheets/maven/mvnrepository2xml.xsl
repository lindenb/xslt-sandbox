<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
		version='1.0'
		exclude-result-prefixes="date xi pom"
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
<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
<mvn>
<dependencies>
<xsl:apply-templates select="//div[@class='version-section'][1]//table[1]" />
</dependencies>
</mvn>
</xsl:template>



<xsl:template match="table">
<xsl:apply-templates select="tbody/tr"/>
</xsl:template>

<xsl:template match="tr">
<dependency>
<xsl:variable name="group" select="td[3]/a[1]/text()"/>
<xsl:variable name="arctifact" select="td[3]/a[2]/text()"/>
<xsl:variable name="version" select="normalize-space(td[4]/a/text())"/>
<gradle><xsl:value-of select="$group"/>:<xsl:value-of select="$arctifact"/>:jar:<xsl:value-of select="$version"/></gradle>
<group><xsl:value-of select="$group"/></group>
<arctifact><xsl:value-of select="$arctifact"/></arctifact>
<version><xsl:value-of select="$version"/></version>

</dependency>
</xsl:template>

</xsl:stylesheet>
