<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
 version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:svg="http://www.w3.org/2000/svg"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 exclude-result-prefixes="svg xlink"
 >
<!--

This stylesheet transforms a blast xml result to XHTML+SVG

Author: Pierre Lindenbaum PhD plindenbaum@yahoo.fr


-->
<!-- ========================================================================= -->
<xsl:output method='xml' indent='yes' omit-xml-declaration="yes"/>
<!-- we preserve the spaces in that element -->


<!-- ========================================================================= -->
<!-- the width of the SVG -->
<xsl:variable name="SIZE">400</xsl:variable>


<!-- ========================================================================= -->

<!-- matching the root node -->
<xsl:template match="/">
<!-- start XHTML -->
<html>
<head>
	<title>BLAST2DOT</title>
</head>
<body>
<h1>BLAST2DOT</h1>
<xsl:apply-templates select="BlastOutput/BlastOutput_iterations/Iteration"/>
</body>
</html>
</xsl:template>

<xsl:template match="Iteration">
<h1>Query: <xsl:value-of select="Iteration_query-def"/></h1>
<xsl:apply-templates select="Iteration_hits/Hit"/>
</xsl:template>

<xsl:template match="Hit">
<h2>Hit: <xsl:value-of select="Hit_def"/></h2>

<div style="text-align:center">
<!-- starts SVG figure -->
<svg version="1.1">
<xsl:attribute name="width"><xsl:value-of select="$SIZE"/></xsl:attribute>
<xsl:attribute name="height"><xsl:value-of select="$SIZE"/></xsl:attribute>

<xsl:apply-templates select="Hit_hsps/Hsp"/>

<rect style="fill:none;stroke:black;" x="0" y="0">
	<xsl:attribute name="width"><xsl:value-of select="number($SIZE) - 1"/></xsl:attribute>
	<xsl:attribute name="height"><xsl:value-of select="number($SIZE) - 1"/></xsl:attribute>
</rect>
</svg>
</div>
</xsl:template>



<!-- ========================================================================= -->
<xsl:template match="Hsp">
<xsl:variable name="HITLEN" select="number(../../Hit_len)"/>
<xsl:variable name="QUERYLEN" select="number(../../../../Iteration_query-len)"/>

<xsl:variable name="x1" select="(number(Hsp_hit-from) div $HITLEN ) * $SIZE"/>
<xsl:variable name="x2" select="(number(Hsp_hit-to) div $HITLEN ) * $SIZE"/>
<xsl:variable name="y1" select="(number(Hsp_query-from) div $QUERYLEN ) * $SIZE"/>
<xsl:variable name="y2" select="(number(Hsp_query-to) div $QUERYLEN ) * $SIZE"/>

<line style="stroke:blue;stroke-width:3;">
	<xsl:attribute name="x1"><xsl:value-of select="$x1"/></xsl:attribute>
	<xsl:attribute name="y1"><xsl:value-of select="$y1"/></xsl:attribute>
	<xsl:attribute name="x2"><xsl:value-of select="$x2"/></xsl:attribute>
	<xsl:attribute name="y2"><xsl:value-of select="$y2"/></xsl:attribute>
</line>
</xsl:template>
<!-- ========================================================================= -->


</xsl:stylesheet>
