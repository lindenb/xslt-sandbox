<?xml version='1.0'  encoding="ISO-8859-1" ?>
<xsl:stylesheet
	xmlns:h="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
	>
<xsl:output method="xml" encoding="UTF-8" />

<xsl:template match="/documentation">
<html><body>
<xsl:apply-templates select="page"/>
</body></html>
</xsl:template> 

<xsl:template match="page">
<div>
<h3><xsl:value-of select="@title"/></h3>
<p><b><xsl:value-of select="@title"/></b> is a C++ tool that is part of my <a href="http://code.google.com/p/variationtoolkit/">Variation Toolkit</a>.</p>
<p><xsl:value-of select="@desc"/></p>
<xsl:apply-templates/>
</div>
</xsl:template> 


<xsl:template match="cite">
<div>
<xsl:value-of select="."/>
</div>
</xsl:template>

<xsl:template match="br">
<br/>
</xsl:template>

<xsl:template match="pmid">
<a>
<xsl:attribute name="href">
<xsl:value-of select="concat('http://www.ncbi.nlm.nih.gov/pubmed/',.)"/>
</xsl:attribute>
<xsl:attribute name="title">
<xsl:value-of select="concat('PMID:',.)"/>
</xsl:attribute>
<xsl:attribute name="target">
<xsl:value-of select="concat('PMID',.)"/>
</xsl:attribute>
<xsl:value-of select="concat('PMID:',.)"/>
</a>
</xsl:template>

<xsl:template match="a">
<a>
<xsl:attribute name="href">
<xsl:value-of select="@href"/>
</xsl:attribute>
<xsl:value-of select="."/>
</a>
</xsl:template>

<xsl:template match="url">
<a>
<xsl:attribute name="href">
<xsl:value-of select="."/>
</xsl:attribute>
<xsl:value-of select="."/>
</a>
</xsl:template>

<xsl:template match="img">
<a>
<xsl:attribute name="href">
<xsl:value-of select="@src"/>
</xsl:attribute>
<img>
<xsl:attribute name="src">
<xsl:value-of select="@src"/>
</xsl:attribute>
</img>
</a>
</xsl:template>

<xsl:template match="pre">
<pre style="margin:10px; background-color: black; color: white; padding:10px; font-size:120%; overflow:auto;">
<xsl:if test="@style">
<xsl:attribute name="style">
<xsl:value-of select="@style"/>
</xsl:attribute>
</xsl:if>
<xsl:apply-templates/>
</pre>
</xsl:template>


<xsl:template match="span">
<xsl:if test="@style">
<xsl:attribute name="style">
<xsl:value-of select="@style"/>
</xsl:attribute>
</xsl:if>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="div">
<div>
<xsl:if test="@style">
<xsl:attribute name="style">
<xsl:value-of select="@style"/>
</xsl:attribute>
</xsl:if>
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="ul">
<ul>
<xsl:for-each select="li">
<li>
<xsl:apply-templates/>
</li>
</xsl:for-each>
</ul>
</xsl:template>

<xsl:template match="code">
<code>
<xsl:apply-templates/>
</code>
</xsl:template>

<xsl:template match="b">
<b>
<xsl:apply-templates/>
</b>
</xsl:template>

<xsl:template match="i">
<i>
<xsl:apply-templates/>
</i>
</xsl:template>

<xsl:template match="strike">
<strike>
<xsl:apply-templates/>
</strike>
</xsl:template>

<xsl:template match="h1">
<h1><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="h2">
<h2><xsl:apply-templates/></h2>
</xsl:template>

<xsl:template match="h3">
<h3><xsl:apply-templates/></h3>
</xsl:template>

<xsl:template match="h4">
<h4><xsl:apply-templates/></h4>
</xsl:template>

<xsl:template match="h5">
<h5><xsl:apply-templates/></h5>
</xsl:template>

<xsl:template match="h6">
<h6><xsl:apply-templates/></h6>
</xsl:template>

</xsl:stylesheet>
