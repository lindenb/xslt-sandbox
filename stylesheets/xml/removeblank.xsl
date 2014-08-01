<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns="http://www.w3.org/1999/xhtml"
	version='1.0'
	>
<!--

Author:
	Pierre Lindenbaum PhD
	plindenbaum@yahoo.fr

Motivation:
	Remove blanks from XML

-->
<xsl:output method="xml" indent="no" />


<xsl:template match="/">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*">
<xsl:copy select="."/>
</xsl:template>

<xsl:template match="*">
<xsl:copy select=".">
<xsl:apply-templates select="@*"/>
<xsl:variable name="content">
<xsl:for-each select="text()">
<xsl:value-of select="normalize-space(.)"/>
</xsl:for-each>
</xsl:variable>
<xsl:choose>
	<xsl:when test="string-length(normalize-space($content)) = 0">
	  	<xsl:apply-templates select="*"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates select="*|text()"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:copy>
</xsl:template>


</xsl:stylesheet>

