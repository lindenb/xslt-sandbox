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
	This stylesheet transform xml to dot, to visulaze the XML tree

-->
<xsl:output method="text" />


<xsl:template match="/">
digraph G
	{
	<xsl:value-of select="generate-id()"/> [label="&lt;ROOT&gt;"];
	<xsl:apply-templates select="*"/>
	}
</xsl:template>

<xsl:template match="*">
<xsl:value-of select="generate-id()"/> [label="<xsl:value-of select="name(.)"/>",shape=oval]
<xsl:apply-templates select="@*"/>
<xsl:choose>
	<xsl:when test="count(*)&gt;0">
		<xsl:apply-templates select="*"/>
	</xsl:when>
	<xsl:otherwise><xsl:apply-templates select="text()"/></xsl:otherwise>
</xsl:choose>
<xsl:value-of select="generate-id(.)"/>
<xsl:text> -&gt; </xsl:text>
<xsl:value-of select="generate-id(..)"/>
<xsl:text>;
</xsl:text>
</xsl:template>

<xsl:template match="@*">
<xsl:value-of select="generate-id(.)"/> [label="@<xsl:value-of select="name(.)"/>=<xsl:value-of select="."/>",shape=box]
<xsl:value-of select="generate-id(.)"/>
<xsl:text> -&gt; </xsl:text>
<xsl:value-of select="generate-id(..)"/>
<xsl:text>;
</xsl:text>
</xsl:template>

<xsl:template match="text()">
<xsl:value-of select="generate-id(.)"/><xsl:text> [label="</xsl:text>
<xsl:choose>
	<xsl:when test="string-length(.)&gt;20"><xsl:value-of select="concat(substring(.,1,20),'...')"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
</xsl:choose>
<xsl:text>",shape=plaintext]
</xsl:text>
<xsl:value-of select="generate-id(.)"/>
<xsl:text> -&gt; </xsl:text>
<xsl:value-of select="generate-id(..)"/>
<xsl:text>;
</xsl:text>
</xsl:template>



</xsl:stylesheet>

