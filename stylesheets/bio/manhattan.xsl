<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:math="http://exslt.org/math" 
	version="1.0">
<!--

Author : Pierre Lindenbaum PhD @yokofakun
Motivation: draw a manhattan plot using svg
Date: 20 Feb 2015
Example input: https://gist.github.com/lindenb/702239b1193f2306c6b1

-->
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:variable name="width" select="number(1000)"/>
<xsl:variable name="height" select="number(400)"/>
<xsl:variable name="width_plus" select="$width + 2"/>
<xsl:variable name="height_plus" select="$height + 100"/>


<!-- genome size -->
<xsl:variable name="genomeSize">
	<xsl:call-template name="sumLengthChrom">
	  <xsl:with-param name="length" select="number(0)"/>
	  <xsl:with-param name="node" select="manhattan/chromosome[1]"/>
	</xsl:call-template>
</xsl:variable>

<!--maxpvalue -->
<xsl:variable name="minpvalue">
  <xsl:for-each select="manhattan/chromosome/data">
    <xsl:sort select="@p" data-type="number" order="ascending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="number(@p)" />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="maxlog2value">
<xsl:message terminate="no"><xsl:value-of select="$minpvalue" />:</xsl:message>
  <xsl:value-of select=" math:log(number($minpvalue)) * -1"/>
</xsl:variable>


<xsl:template match="/">
<xsl:message terminate="no">maxlog2value=<xsl:value-of select="$maxlog2value" /></xsl:message>
<svg:svg width="{$width_plus}" height="{$height_plus}" style="stroke-width:1px;">
<svg:title>Manhattan Plot - Pierre Lindenbaum</svg:title>
<svg:defs>
</svg:defs>
<svg:g>
	<xsl:call-template name="plotChromosomes">
	  <xsl:with-param name="previous" select="number(0)"/>
	  <xsl:with-param name="node" select="manhattan/chromosome[1]"/>
	</xsl:call-template>
</svg:g>
</svg:svg>
</xsl:template>
 
 <!-- plot chromosome -->
<xsl:template name="plotChromosomes">
<xsl:param name="previous"/>
<xsl:param name="node"/>

<xsl:variable name="chromlen">
	<xsl:apply-templates select="$node" mode="length"/>
</xsl:variable>

<svg:g>
<xsl:attribute name="transform">
<xsl:text>translate(</xsl:text>
	<xsl:value-of select="(number($previous) div number($genomeSize)) * $width" />
<xsl:text>,0)</xsl:text>
</xsl:attribute>

<xsl:apply-templates select="$node" mode="plot"/>
</svg:g>

<xsl:if test="count($node/following-sibling::chromosome)&gt;0">
	<xsl:call-template name="plotChromosomes">
	  <xsl:with-param name="previous" select="$previous + number($chromlen)"/>
	  <xsl:with-param name="node" select="$node/following-sibling::chromosome[1]"/>
	</xsl:call-template>
</xsl:if>

</xsl:template>


<!-- plot one chromosome -->
<xsl:template match="chromosome" mode="plot">

<xsl:variable name="chromWidth">
	<xsl:apply-templates select="." mode="width"/>
</xsl:variable>

<xsl:variable name="midX">
	<xsl:value-of select=" number($chromWidth) div 2.0 "/>
</xsl:variable>

<svg:g>
<xsl:attribute name="title"><xsl:value-of select="@name"/></xsl:attribute>
<xsl:attribute name="style">
<xsl:text>fill:</xsl:text>
<xsl:choose>
<xsl:when test="(count(./following-sibling::chromosome) mod 3) = 0">
	<xsl:text>red</xsl:text>
</xsl:when>
<xsl:when test="(count(./following-sibling::chromosome) mod 3) = 1">
	<xsl:text>blue</xsl:text>
</xsl:when>
<xsl:otherwise>
	<xsl:text>green</xsl:text>
</xsl:otherwise>
</xsl:choose>
<xsl:text>;</xsl:text>
</xsl:attribute>
<svg:g style="fill-opacity:0.5;">
<xsl:apply-templates select="data" mode="plot"/>
</svg:g>
<svg:rect x="0" width="{$chromWidth}" y="0" height="{$height}" style="fill:none;stroke:black;stroke-width=0.5px;" >
<xsl:attribute name="title"><xsl:value-of select="@name"/></xsl:attribute>
</svg:rect>

<svg:text style="fill:black;">
	<xsl:attribute name="transform">translate(<xsl:value-of select="$midX"/>,<xsl:value-of select="number($height) + 20"/>) rotate(90)</xsl:attribute>
	<xsl:value-of select="@name"/>
</svg:text>
</svg:g>
</xsl:template> 


 
 <!-- get chromosome length -->
<xsl:template match="chromosome" mode="width">
<xsl:variable name="chromlen">
	<xsl:apply-templates select="." mode="length"/>
</xsl:variable>
<xsl:value-of select="(number($chromlen) div number($genomeSize)) * $width" />
</xsl:template>
 
<!-- get chromosome length -->
<xsl:template match="chromosome" mode="length">
<xsl:choose>
<xsl:when test="@length">
	<xsl:value-of select="number(@length)"/>
</xsl:when>
<xsl:otherwise>
  <xsl:for-each select="data">
    <xsl:sort select="@position" data-type="number" order="descending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="number(@position)" />
    </xsl:if>
  </xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
  
 
<!-- plot data -->
<xsl:template match="data" mode="plot">
<xsl:choose>
<xsl:when test="@rs">
	<svg:a target="_blank">
	<xsl:attribute name="xlink:href">
   	<xsl:value-of select="concat('http://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=',@rs)"/>
	</xsl:attribute>
 	<xsl:apply-templates select="." mode="plotshape"/>
 	</svg:a>
</xsl:when>
<xsl:otherwise>
	<xsl:apply-templates select="." mode="plotshape"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="data" mode="plotshape">
<svg:circle r="5">
<xsl:attribute name="cx"><xsl:apply-templates select="." mode="x"/></xsl:attribute>
<xsl:attribute name="cy"><xsl:apply-templates select="." mode="y"/></xsl:attribute>
</svg:circle>
</xsl:template>

<xsl:template match="data" mode="x">
<xsl:variable name="chromWidth">
	<xsl:apply-templates select=".." mode="width"/>
</xsl:variable>
<xsl:variable name="chromLength">
	<xsl:apply-templates select=".." mode="length"/>
</xsl:variable>

<xsl:value-of select="(number(@position) div number($chromLength)) * $chromWidth"/>
</xsl:template>

<xsl:template match="data" mode="y">
<xsl:value-of select="$height - (( (math:log(number(@p)) * -1 ) div $maxlog2value ) * $height )"/>
</xsl:template>


<!-- we cannot use sum if chromosome/@length is not defined -->
<xsl:template name="sumLengthChrom">
<xsl:param name="length"/>
<xsl:param name="node"/>

<xsl:variable name="chromlen">
	<xsl:apply-templates select="$node" mode="length"/>
</xsl:variable>

<xsl:choose>
<xsl:when test="count($node/following-sibling::chromosome)&gt;0">
	<xsl:call-template name="sumLengthChrom">
	  <xsl:with-param name="length" select="$length + number($chromlen)"/>
	  <xsl:with-param name="node" select="$node/following-sibling::chromosome[1]"/>
	</xsl:call-template>
</xsl:when>
<xsl:otherwise>
	<xsl:value-of select="$length + number($chromlen)"/>
</xsl:otherwise> 
</xsl:choose>
</xsl:template>
  
</xsl:stylesheet>
