<?xml version="1.0" encoding="ASCII"?>
<xsl:stylesheet
 version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:svg="http://www.w3.org/2000/svg"
 xmlns="http://www.w3.org/2000/svg"
 xmlns:dc="http://purl.org/dc/elements/1.1/"
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
 xmlns:t="https://www.tycho.pitt.edu/"
 xmlns:math="http://exslt.org/math"
 extension-element-prefixes="math"
 >
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Motivation:
     print RDF data as SVG for the tycho project. 
	
	
-->
<xsl:output method='xml' />

<xsl:variable name="square.size" select="number(20)"/>
<xsl:variable name="num.years" select="count(/rdf:RDF/t:Year)"/>
<xsl:variable name="num.states" select="count(/rdf:RDF/t:State)"/>
<xsl:variable name="margin.left" select="300"/>
<xsl:variable name="margin.right" select="50"/>
<xsl:variable name="margin.top" select="100"/>
<xsl:variable name="margin.bottom" select="50"/>

<xsl:template match="/">
<svg>
		<xsl:attribute name="width"><xsl:value-of select="$num.years * $square.size + $margin.left + $margin.right"/></xsl:attribute>
		<xsl:attribute name="height"><xsl:value-of select="$num.states * $square.size + $margin.top + $margin.bottom"/></xsl:attribute>
		<xsl:attribute name="style">fill:white;stroke:black;font-size:<xsl:value-of select="$square.size - 2"/>px;stroke-width:0.5px;</xsl:attribute>

<xsl:apply-templates select="rdf:RDF"/>
</svg>
</xsl:template>


<xsl:template match="rdf:RDF">

<title><xsl:value-of select="rdf:Description[@rdf:about='']/dc:title"/></title>
<desc><xsl:value-of select="rdf:Description[@rdf:about='']/dc:title"/></desc>

<text x="10" y="20" style="font-size:18px;"><xsl:value-of select="rdf:Description[@rdf:about='']/dc:title"/></text>

<g>
<xsl:attribute name="transform">translate(<xsl:value-of select="$margin.left"/>,<xsl:value-of select="$margin.top"/>)</xsl:attribute>


<xsl:variable name="this.rdf" select="."/>

<g>

<!-- Draw Y-axis with states -->
<xsl:for-each select="$this.rdf/t:State">
<xsl:sort select="dc:title" data-type="text"/>
<!-- draw Y label (state) -->
<text x="-1" text-anchor="end">
	<xsl:attribute name="y"><xsl:value-of select=" position()  * $square.size - ($square.size div 4.0)"/></xsl:attribute>
	<xsl:value-of select="dc:title"/>
</text>
</xsl:for-each>

<!-- loop over X axis (years) -->
<xsl:for-each select="$this.rdf/t:Year">
<xsl:sort select="dc:title" data-type="number"/> 
<xsl:variable name="year" select="."/>
<xsl:variable name="year_index" select="position()"/>
<xsl:message terminate="no">Processing Year <xsl:value-of select="$year/dc:title"/></xsl:message>

<!-- translate column -->
<g>
	<xsl:attribute name="title"><xsl:value-of select="dc:title"/></xsl:attribute>
	<xsl:attribute name="transform">translate(<xsl:value-of select="( $year_index -1 ) * $square.size"/>,0)</xsl:attribute>


<!-- draw X label (year) -->
<text y="0" x="0">
	<xsl:attribute name="transform">translate(<xsl:value-of select="$square.size - $square.size div 4.0"/>,-2) rotate(-90) </xsl:attribute>
	<xsl:value-of select="dc:title"/>
</text>

<!-- loop over Y axis (states) -->
<xsl:for-each select="$this.rdf/t:State">
<xsl:sort select="dc:title" data-type="text"/> 
<xsl:variable name="state" select="."/>
<xsl:variable name="state_index" select="position()"/>

<xsl:variable name="maxvalue" select="number(100000.0)"/>

<xsl:variable name="total">
	<xsl:call-template name="sum">
		<xsl:with-param name="nodes" select="$this.rdf/t:Data[t:state/@rdf:resource=$state/@rdf:about and t:year/@rdf:resource=$year/@rdf:about]"/>
		<xsl:with-param name="index" select="number(1)"/>
		<xsl:with-param name="total" select="number(0)"/>
	</xsl:call-template>
</xsl:variable>

<xsl:if test="$total &gt; 0">
<xsl:variable name="channel">
<xsl:choose>
	<xsl:when test="number($total)&gt;= $maxvalue">1.0</xsl:when>
	<xsl:otherwise><xsl:value-of select=" ( math:log(number($total)) div math:log($maxvalue))"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>

	<rect x="0">
		<xsl:attribute name="title"><xsl:value-of select="$state/dc:title"/> (<xsl:value-of select="$year/dc:title"/>) N=<xsl:value-of select="$total"/></xsl:attribute>
		<xsl:attribute name="y"><xsl:value-of select="($state_index -1 ) * $square.size"/></xsl:attribute>
		<xsl:attribute name="width"><xsl:value-of select="$square.size"/></xsl:attribute>
		<xsl:attribute name="height"><xsl:value-of select="$square.size"/></xsl:attribute>
		<xsl:attribute name="style">fill:rgb(<xsl:value-of select="round( number($channel) * 255.0)"/>,0,<xsl:value-of select="round(255.0 - number($channel) * 255.0)"/>);stroke:gray;</xsl:attribute>
	</rect>
</xsl:if>

</xsl:for-each>
</g>
</xsl:for-each>
</g>

</g>
</xsl:template>

<xsl:template name="sum">
<xsl:param name="nodes"/>
<xsl:param name="index"/>
<xsl:param name="total"/>

<xsl:choose>
<xsl:when test="$index &gt; count($nodes)">
	<xsl:value-of select="$total"/>
</xsl:when>
<xsl:otherwise>
	<xsl:call-template name="sum">
		<xsl:with-param name="nodes" select="$nodes"/>
		<xsl:with-param name="index" select="number($index) + 1"/>
		<xsl:with-param name="total" select="number($total) + number($nodes[$index]/t:count)"/>
	</xsl:call-template>
</xsl:otherwise>

</xsl:choose>

</xsl:template>


</xsl:stylesheet>


