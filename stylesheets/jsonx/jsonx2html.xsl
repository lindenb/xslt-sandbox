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
<xsl:output method="html" />


<xsl:template match="/">
<html>
<head>
<style>
.string { color: gray;}
.boolean { color: green;}
.null { color: red;}
.number { color: blue;}
</style>
</head>
<body>
<xsl:apply-templates/>
</body></html>
</xsl:template>

<xsl:template match="x:object">
<dl class="object">
<xsl:for-each select="*">
<dt><xsl:value-of select="@name"/></dt>
<dd><xsl:apply-templates select="."/></dd>
</xsl:for-each>
</dl>
</xsl:template>

<xsl:template match="x:array">
<ol class="array">
<xsl:for-each select="*">
<li>
<xsl:apply-templates select="."/>
</li>
</xsl:for-each>
</ol>
</xsl:template>

<xsl:template match="x:string">
<span class="string"><xsl:value-of select="."/></span>
</xsl:template>

<xsl:template match="x:number">
<span class="number"><xsl:value-of select="."/></span>
</xsl:template>

<xsl:template match="x:boolean">
<span class="boolean"><xsl:value-of select="."/></span>
</xsl:template>

<xsl:template match="x:null">
<span class="null">NULL</span>
</xsl:template>

</xsl:stylesheet>

