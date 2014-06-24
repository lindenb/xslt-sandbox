<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        version='1.0'
        >
<!--

Author:
	Pierre Lindenbaum
	plindenbaum@yahoo.fr
WWW:
	http://plindenbaum.blogspot.com
Usage:
	xsltproc -\-novalid entrezfields.xsl http://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi 

Motivation:
	XSLT version of Neil Saunder's post http://nsaunders.wordpress.com/2010/11/05/what-the-world-needs-is-lists-of-entrez-database-fields
-->
<xsl:output method="html" encoding="UTF-8" indent="yes"/>


<xsl:template match="/">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="eInfoResult[DbList]">
<html>
<head>
<meta charset="utf-8" />
</head><body>
<h1>NCBI Fields</h1>
<div><xsl:for-each select="DbList/DbName">
<xsl:element name="a">
<xsl:attribute name="href"><xsl:value-of select="concat('#',.)"/></xsl:attribute>
<xsl:text>[</xsl:text>
<xsl:value-of select="."/>
<xsl:text>]</xsl:text>
</xsl:element>
<xsl:text> </xsl:text>
</xsl:for-each></div>
<xsl:apply-templates select="DbList/DbName"/>
</body></html>
</xsl:template>

<xsl:template match="eInfoResult[DbInfo]">
<xsl:apply-templates select="DbInfo/FieldList"/>
</xsl:template>

<xsl:template match="DbName">
<xsl:element name="a">
<xsl:attribute name="name"><xsl:value-of select="."/></xsl:attribute>
</xsl:element>
<h2><xsl:value-of select="."/></h2>
<xsl:variable name="url"><xsl:value-of select="concat('http://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi?db=',.)"/></xsl:variable>
<xsl:message terminate="no">Downloading <xsl:value-of select="$url"/></xsl:message>
<xsl:apply-templates select="document($url,/eInfoResult)" />
</xsl:template>


<xsl:template match="FieldList">
<div>
<table border="1">
	<caption>Fields for <xsl:value-of select="../DbName"/><br/><xsl:value-of select="../Description"/></caption>
<tr>
	<th>Name</th>
	<th>Full Name</th>
	<th>Description</th>
	<th>Count</th>
	<th>Date</th>
	<th>Numeric</th>
	<th>Single Token</th>
	<th>Hierarchy</th>
	<th>Hidden</th>
</tr>
<xsl:for-each select="Field">
<tr>
	<td><xsl:value-of select="Name"/></td>
	<td><xsl:value-of select="FullName"/></td>
	<td><xsl:value-of select="Description"/></td>
	<td><xsl:value-of select="TermCount"/></td>
	<td><xsl:apply-templates select="IsDate" mode="bool"/></td>
	<td><xsl:apply-templates select="IsNumerical" mode="bool"/></td>
	<td><xsl:apply-templates select="SingleToken" mode="bool"/></td>
	<td><xsl:apply-templates select="Hierarchy" mode="bool"/></td>
	<td><xsl:apply-templates select="IsHidden" mode="bool"/></td>
</tr>
</xsl:for-each>
</table>
</div>
</xsl:template>

<xsl:template match="*" mode="bool">
<xsl:choose>
<xsl:when test=".='Y'">&#x2714;</xsl:when>
<xsl:otherwise>&#160;</xsl:otherwise>
</xsl:choose>
</xsl:template>



</xsl:stylesheet>