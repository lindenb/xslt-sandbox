<?xml version='1.0' encoding="UTF-8"?>
<!--

-->

<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:svg="http://www.w3.org/2000/svg"
	extension-element-prefixes="str"
	version='1.1'
	>
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

<xsl:param name="fh" select="number(30)"/>
<xsl:param name="fdh" select="number(90)"/>
<xsl:param name="width" select="number(900)"/>
<xsl:param name="left-margin" select="number(100)"/>
<xsl:param name="right-margin" select="number(10)"/>

<xsl:variable name="seqmax">
  <xsl:for-each select="/GBSet/GBSeq/GBSeq_length">
    <xsl:sort select="." data-type="number" order="descending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="number(text())" />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>



<xsl:template match="/">
<xsl:apply-templates select="GBSet"/>
</xsl:template>

<xsl:template match="GBSet">
<xsl:variable name="gbseqcount" select="count(GBSeq)"/>
<xsl:element name="svg:svg">
<xsl:attribute name="height"><xsl:value-of select="($gbseqcount+2) * ($fh+$fdh) +1"/></xsl:attribute>
<xsl:attribute name="width"><xsl:value-of select="$width + $left-margin + $right-margin"/></xsl:attribute>
<svg:title>Biostar https://www.biostars.org/p/337928/ / Pierre Lindenbaum</svg:title>
<svg:style>
rect.chrom { stroke:gainsboro;fill:ghostwhite;stroke-width:0.5px;}
.gene { stroke:darkgray;fill:crimson;stroke-width:0.5px;opacity:0.6;}
.label {stroke:lightslategrey;}
.g {font-size:7px;opacity:0.5;color:blue;}
</svg:style>
<svg:g>
<xsl:attribute name="transform">translate(<xsl:value-of select="$left-margin"/>,<xsl:value-of select="($fh+$fdh)"/>)</xsl:attribute>
<xsl:for-each select="GBSeq">
<svg:g>
<xsl:attribute name="transform">translate(0,<xsl:value-of select="position() * ($fh + $fdh)"/>)</xsl:attribute>
<xsl:apply-templates select="."/>
</svg:g>
</xsl:for-each>
</svg:g>
</xsl:element>
</xsl:template>

<xsl:template match="GBSeq">
<svg:text class="label" style="text-anchor:end;">
	<xsl:attribute name="y"><xsl:value-of select="$fh"/></xsl:attribute>
	<xsl:attribute name="x">-3</xsl:attribute>
	<xsl:value-of select="GBSeq_locus"/>
</svg:text>
<svg:rect class="chrom" x="0" y="0">
	<xsl:attribute name="height"><xsl:value-of select="$fh"/></xsl:attribute>
	<xsl:attribute name="width"><xsl:value-of select="(number(GBSeq_length/text()) div $seqmax) * $width"/></xsl:attribute>
</svg:rect>
<xsl:for-each select="GBSeq_feature-table/GBFeature[GBFeature_key='gene']">
	<xsl:variable name="p1" select="number(GBFeature_intervals/GBInterval/GBInterval_from/text())"/>
	<xsl:variable name="p2" select="number(GBFeature_intervals/GBInterval/GBInterval_to/text())"/>
	<xsl:variable name="x1" select="($p1 div $seqmax) * $width"/>
	<xsl:variable name="x2" select="($p2 div $seqmax) * $width"/>
	<xsl:variable name="a" select="number(5)"/>
	<svg:path class="gene">
	<xsl:attribute name="d">
		<xsl:choose>
			<xsl:when test="$x1  &lt; $x2 and ($x2 - $x1 ) &gt; $a">M <xsl:value-of select="$x1"/>,0 L <xsl:value-of select="$x2 - $a"/>,0 L <xsl:value-of select="$x2"/>,<xsl:value-of select="$fh div 2.0"/> L <xsl:value-of select="$x2 - $a"/>,<xsl:value-of select="$fh"/> L <xsl:value-of select="$x1"/>,<xsl:value-of select="$fh"/> Z</xsl:when> 
			<xsl:when test="$x2  &lt; $x1 and ($x1 - $x2 ) &gt; $a">M <xsl:value-of select="$x1"/>,0 L <xsl:value-of select="$x2 + $a"/>,0 L <xsl:value-of select="$x2"/>,<xsl:value-of select="$fh div 2.0"/> L <xsl:value-of select="$x2 + $a"/>,<xsl:value-of select="$fh"/> L <xsl:value-of select="$x1"/>,<xsl:value-of select="$fh"/> Z</xsl:when> 
			<xsl:otherwise>M <xsl:value-of select="$x1"/>,0 L <xsl:value-of select="$x2"/>,0 L <xsl:value-of select="$x2"/>,<xsl:value-of select="$fh"/> L <xsl:value-of select="$x1"/>,<xsl:value-of select="$fh"/> Z</xsl:otherwise>
		</xsl:choose>
	</xsl:attribute>

	<svg:title>
		<xsl:value-of select="GBFeature_quals/GBQualifier[GBQualifier_name='locus_tag']/GBQualifier_value"/>
	</svg:title>
	
	</svg:path>
	<svg:text y="0" x="0" class="g" >
		<xsl:choose>
		<xsl:when test="$p1  &lt; $p2">
			<xsl:attribute name="transform">translate(<xsl:value-of select="$x1"/>,0) rotate(-45)</xsl:attribute>
			<xsl:value-of select="$p1"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:attribute name="transform">translate(<xsl:value-of select="$x2"/>,0) rotate(-45)</xsl:attribute>
			<xsl:value-of select="$p2"/>
		</xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<xsl:value-of select="GBFeature_quals/GBQualifier[GBQualifier_name='locus_tag']/GBQualifier_value"/>
	</svg:text>
</xsl:for-each>

</xsl:template>

</xsl:stylesheet>
