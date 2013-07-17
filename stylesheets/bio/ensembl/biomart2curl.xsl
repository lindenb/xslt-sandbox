<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	exclude-result-prefixes="x"
	xmlns:x="http://exslt.org/strings"
	extension-element-prefixes="x"
	version='1.0' >
<!--
Author
	Pierre Lindenbaum PhD
Mail:
	plindenbaum@yahoo.fr
Motivation:
	transforms a Biomart XML to a CURL statement
Example:
	xsltproc biomart2curl.xsl biomart.xml | bash


-->

<xsl:output method="text"/>

<xsl:template match="/">
<xsl:text>curl -s -d "query=</xsl:text>
<xsl:apply-templates select="*"/>
<xsl:text>" "http://www.biomart.org/biomart/martservice/result"
</xsl:text>
</xsl:template>

<xsl:template match="*">
<xsl:value-of select="x:encode-uri(concat('&lt;',name()),true())"/>
<xsl:for-each select="@*">
<xsl:value-of select="x:encode-uri(concat(' ',name(),'=&quot;',.,'&quot;'),true())"/>
</xsl:for-each>
<xsl:choose>
<xsl:when test="count(child::node())=0">
	<xsl:value-of select="x:encode-uri('/&gt;',true())"/>
</xsl:when>
<xsl:otherwise>
	<xsl:value-of select="x:encode-uri('&gt;',true())"/>
	<xsl:apply-templates select="*"/>
	<xsl:value-of select="x:encode-uri(concat('&lt;/',name(),'&gt;'),true())"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>


</xsl:stylesheet>

