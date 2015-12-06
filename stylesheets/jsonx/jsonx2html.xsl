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
dt {
    font-weight: bold;
    color: blue;
  }
dt:after {
    content: " : ";
  }
.string { color: darkgray;}
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
<span class="string">
<xsl:choose>
  <xsl:when test='starts-with(text(),"http://") or starts-with(text(),"https://") or starts-with(text(),"ftp://")'>
    <a><xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></a>
  </xsl:when>
  <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
</xsl:choose>
</span>
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

