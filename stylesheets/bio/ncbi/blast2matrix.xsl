<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	>
<!--
Author
    Pierre Lindenbaum PhD
Mail:
    plindenbaum@yahoo.fr
Motivation:
    https://www.biostars.org/p/121126
    transforms a blastn xml result to a HTML matrix
Example:
    xsltproc  blast2matrix.xsl blastn.xml

-->
<xsl:key name="hits" match="Hit" use="Hit_id" />

<xsl:output method='html' indent="yes"/>

<xsl:template match="/">
<html>
<head>
 <meta charset="UTF-8"/>
</head>
<body>
<xsl:apply-templates select="BlastOutput"/>
</body></html>
</xsl:template>

<xsl:template match="BlastOutput">
<table border="1">
<tr>
	<th>Hit</th>
	<xsl:for-each select="//Hit">
	<xsl:if test="generate-id(.) = generate-id(key('hits',Hit_id))">
		<th><xsl:value-of select="Hit_def"/></th>
	</xsl:if>
	</xsl:for-each>
</tr>
<xsl:for-each select="BlastOutput_iterations/Iteration">
<xsl:variable name="iteration" select="."/>
<tr>
<th><xsl:value-of select="Iteration_query-def"/></th>
<xsl:for-each select="//Hit">

<xsl:variable name="hitid" select="Hit_id"/>
<xsl:if test="generate-id(.) = generate-id(key('hits',$hitid))">
<td>
<xsl:choose>
<xsl:when test="count($iteration/Iteration_hits/Hit[Hit_id = $hitid]) &gt; 0">&#10004;</xsl:when>
<xsl:otherwise></xsl:otherwise>
</xsl:choose>
</td>
</xsl:if>


</xsl:for-each>
</tr>
</xsl:for-each>
</table>
</xsl:template>


</xsl:stylesheet>

