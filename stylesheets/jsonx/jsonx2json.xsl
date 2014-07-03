<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:x="http://www.ibm.com/xmlns/prod/2009/jsonx"
	version='1.0'
	>
<!--

Author:
	Pierre Lindenbaum PhD
	plindenbaum@yahoo.fr

Motivation:
	JSONX-schema to json
Usage:
	xsltproc  x
-->
<xsl:output method="text" />


<xsl:template match="/">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="x:object">
<xsl:text>{</xsl:text>
<xsl:for-each select="*">
<xsl:if test="position()&gt;1">,</xsl:if>
<xsl:text>"</xsl:text>
<xsl:value-of select="@name"/>
<xsl:text>":</xsl:text>
<xsl:apply-templates select="."/>
</xsl:for-each>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="x:array">
<xsl:text>[</xsl:text>
<xsl:for-each select="*">
<xsl:if test="position()&gt;1">,</xsl:if>
<xsl:apply-templates select="."/>
</xsl:for-each>
<xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="x:string">
<xsl:text>"</xsl:text>
<xsl:value-of select="."/>
<xsl:text>"</xsl:text>
</xsl:template>

<xsl:template match="x:number|x:boolean">
<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="x:null">
<xsl:text>null</xsl:text>
</xsl:template>

</xsl:stylesheet>

