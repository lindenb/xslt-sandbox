<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0' >
<xsl:output method="html" />

<xsl:template match="/">
<html>

<xsl:apply-templates select="refentry"/>
</html>
</xsl:template>

<xsl:template match="refentry">
<head>
<style>
dt {
	text-decoration:underline;
	}
.code {	
	background-color:black;
	color:white;
	margin:10px;
	padding:10px;
	}
.refsect1 p,div,dt,pre  {
	margin-left:50px;
	}
</style>
<xsl:apply-templates select="refmeta"/>
</head>
<body>
	<xsl:apply-templates select="refnamediv"/>
	<xsl:apply-templates select="refsynopsisdiv"/>
	<xsl:apply-templates select="refsect1"/>
</body>
</xsl:template>

<xsl:template match="refmeta">
<xsl:apply-templates select="refentrytitle|manvolnum"/>
</xsl:template>



<xsl:template match="manvolnum">
<meta name="manvolnum">
<xsl:attribute name="content">
<xsl:apply-templates/>
</xsl:attribute>
</meta>
</xsl:template>

<xsl:template match="refentrytitle">
<xsl:choose>
<xsl:when test="name(..) = 'refmeta'">
<title>
<xsl:apply-templates/>
</title>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="refname"/>
<xsl:apply-templates select="refentrytitle"/>
<xsl:apply-templates select="refpurpose"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="refname">
<h1><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="refpurpose">
<div class="refsect1">
<h3>NAME</h3>
<p><xsl:apply-templates/></p>
</div>
</xsl:template>

<xsl:template match="refsynopsisdiv">
<div class="refsect1">
<h3>SYNOPSIS</h3>
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="cmdsynopsis">
<div class=" cmdsynopsis code refsect1">
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="command">
<strong><xsl:apply-templates/></strong>
</xsl:template>

<xsl:template match="arg">
<xsl:text> [</xsl:text>
<xsl:apply-templates/>
<xsl:text>] </xsl:text>
</xsl:template>

<xsl:template match="option">
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="refsect1">
<div class="refsect1">
<xsl:apply-templates/>
</div>

</xsl:template>

<xsl:template match="title">
<h3><xsl:apply-templates/></h3>
</xsl:template>

<xsl:template match="para">
<p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="variablelist">
<dl><xsl:apply-templates select="varlistentry"/></dl>
</xsl:template>

<xsl:template match="varlistentry">
<xsl:apply-templates select="term"/>
<xsl:apply-templates select="listitem"/>
</xsl:template>

<xsl:template match="term">
<dt><xsl:apply-templates/></dt>
</xsl:template>

<xsl:template match="listitem">
<dd><xsl:apply-templates/></dd>
</xsl:template>

<xsl:template match="ulink">
<a>
<xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
<xsl:apply-templates/>
</a>
</xsl:template>

<xsl:template match="email">
<a>
<xsl:attribute name="href"><xsl:value-of select="concat('mailto:',.)"/></xsl:attribute>
<xsl:apply-templates/>
</a>
</xsl:template>

<xsl:template match="refnamediv">
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="citerefentry">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="replaceable">
<xsl:text>|</xsl:text>
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="*">
<xsl:message terminate="no">not handled <xsl:value-of select="name(.)"/></xsl:message>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="text()">
<xsl:value-of select="."/>
</xsl:template>
</xsl:stylesheet>

