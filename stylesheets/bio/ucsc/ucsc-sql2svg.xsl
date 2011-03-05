<?xml version='1.0' encoding="UTF-8"?>
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Motivation:
      transform the xmloutput of mysql of UCSC to SVG
Reference:
      http://biostar.stackexchange.com/questions/6149/batch-viewing-of-ucsc-browser-graphic
Params:
   * width
   * height
   * build
Usage :
      mysql  -h  genome-mysql.cse.ucsc.edu -A -u genome -D hg19  -e 'select * from knownGene where chrom="chr22" limit 5,15' -X > sql.xml
      xsltproc ucsc-sql2svg.xsl sql.xml > file.svg
-->

<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:svg="http://www.w3.org/2000/svg"
        xmlns:xlink="http://www.w3.org/1999/xlink"
	version='1.0'
	>
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:param name="feature-height" select="number(20)"/>
<xsl:param name="width" select="number(900)"/>
<xsl:param name="height" select="(count(/resultset/row) * $feature-height)+number(1)"/>
<xsl:param name="build">hg19</xsl:param>

<xsl:template match="/">
<svg:svg width="{$width}" height="{$height}" style="stroke-width:1px;">
<svg:title><xsl:value-of select="resultset/@statement"/></svg:title>
<svg:defs>

<svg:linearGradient x1="0%" y1="0%" x2="0%" y2="100%" id="grad">
        <svg:stop offset="5%" stop-color="black" />
        <svg:stop offset="50%" stop-color="whitesmoke" />
        <svg:stop offset="95%" stop-color="black" />
</svg:linearGradient>

<svg:linearGradient x1="0%" y1="0%" x2="0%" y2="100%" id="vertical_body_gradient">
        <svg:stop offset="5%" stop-color="white" />
        <svg:stop offset="95%" stop-color="lightgray" />
</svg:linearGradient>
</svg:defs>
<svg:style type="text/css">
</svg:style>
<svg:g>
<xsl:element name="svg:rect">
        <xsl:attribute name="x">0</xsl:attribute>
        <xsl:attribute name="y">0</xsl:attribute>
        <xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute>
        <xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute>
        <xsl:attribute name="fill">url(#vertical_body_gradient)</xsl:attribute>
        <xsl:attribute name="stroke">black</xsl:attribute>
</xsl:element>

<xsl:apply-templates select="resultset[row]"/>

<xsl:element name="svg:rect">
        <xsl:attribute name="x">0</xsl:attribute>
        <xsl:attribute name="y">0</xsl:attribute>
        <xsl:attribute name="width"><xsl:value-of select="$width -1"/></xsl:attribute>
        <xsl:attribute name="height"><xsl:value-of select="$height -1"/></xsl:attribute>
        <xsl:attribute name="fill">none</xsl:attribute>
        <xsl:attribute name="stroke">black</xsl:attribute>
</xsl:element>
</svg:g>
</svg:svg>
</xsl:template>

<xsl:template match="resultset">
<xsl:variable name="R" select="row[1]"/>
<xsl:choose>
   <xsl:when test="$R/field[@name='name'] and $R/field[@name='chrom'] and $R/field[@name='txStart'] and $R/field[@name='txEnd'] and $R/field[@name='cdsStart'] and $R/field[@name='cdsEnd'] and $R/field[@name='exonStarts'] and $R/field[@name='exonEnds']">
      <xsl:apply-templates select="." mode="knownGenes"/>
   </xsl:when>
   <xsl:otherwise>
      <xsl:message>Sorry I don't know how to process this kind of query.</xsl:message>
   </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="resultset" mode="knownGenes">

<xsl:variable name="min">
  <xsl:for-each select="row/field[@name='txStart']">
    <xsl:sort select="." data-type="number" order="ascending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="number(text())" />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="max">
  <xsl:for-each select="row/field[@name='txEnd']">
    <xsl:sort select="." data-type="number" order="descending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="number(text())" />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:for-each select="row">
<xsl:variable name="y">
   <xsl:value-of select="((position() - 1) * $feature-height)"/>
</xsl:variable>

<xsl:variable name="mid">
   <xsl:value-of select="$y + ($feature-height div 2.0)"/>
</xsl:variable>

<xsl:variable name="left"  select="((number(field[@name='txStart']) - $min ) div  ($max - $min)) * $width"/>
<xsl:variable name="right" select="((number(field[@name='txEnd']) - $min ) div  ($max - $min)) * $width"/>


<xsl:element name="svg:g">
<xsl:attribute name="title">
   <xsl:value-of select="field[@name='name']"/>
</xsl:attribute>



<xsl:element name="svg:a">
<xsl:attribute name="target">_blank</xsl:attribute>
<xsl:attribute name="xlink:href">
   <xsl:value-of select="concat('http://genome.ucsc.edu/cgi-bin/hgTracks?db=',$build,'&amp;position=',field[@name='name'])"/>
</xsl:attribute>


<xsl:element name="svg:line">
   <xsl:attribute name="style">stroke:black;stroke-width:1px;</xsl:attribute>
   <xsl:attribute name="x1">
      <xsl:value-of select="$left"/>
   </xsl:attribute>
   <xsl:attribute name="y1">
      <xsl:value-of select="$mid"/>
   </xsl:attribute>
   <xsl:attribute name="x2">
      <xsl:value-of select="$right"/>
   </xsl:attribute>
   <xsl:attribute name="y2">
       <xsl:value-of select="$mid"/>
   </xsl:attribute>
</xsl:element>
</xsl:element>



<xsl:element name="svg:line">
   <xsl:attribute name="style">stroke:blue;stroke-width:3px;</xsl:attribute>
   <xsl:attribute name="x1">
      <xsl:value-of select="((number(field[@name='cdsStart']) - $min ) div  ($max - $min)) * $width"/>
   </xsl:attribute>
   <xsl:attribute name="y1">
      <xsl:value-of select="$mid"/>
   </xsl:attribute>
   <xsl:attribute name="x2">
      <xsl:value-of select="((number(field[@name='cdsEnd']) - $min ) div  ($max - $min)) * $width"/>
   </xsl:attribute>
   <xsl:attribute name="y2">
       <xsl:value-of select="$mid"/>
   </xsl:attribute>
</xsl:element>

<xsl:element name="svg:text">
<xsl:attribute name="y"><xsl:value-of select="$mid + 4"/></xsl:attribute>

   <xsl:choose>
      <xsl:when test="$left &gt; ($width div 10.0)">
         <xsl:attribute name="x">
            <xsl:value-of select="$left - 2"/>
         </xsl:attribute>
         <xsl:attribute name="text-anchor">end</xsl:attribute>
      </xsl:when>
      <xsl:when test="$right &lt; ($width * 0.9)">
         <xsl:attribute name="x">
            <xsl:value-of select="$right + 2"/>
         </xsl:attribute>
         <xsl:attribute name="text-anchor">start</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
         <xsl:attribute name="x">
            <xsl:value-of select="($right + $left) div 2.0"/>
         </xsl:attribute>
         <xsl:attribute name="text-anchor">middle</xsl:attribute>
      </xsl:otherwise>
   </xsl:choose>
<xsl:value-of select="field[@name='name']"/>
</xsl:element>


<xsl:call-template name="exons">
   <xsl:with-param name="count" select="number(field[@name='exonCount'])"/>
   <xsl:with-param name="index" select="number(1)"/>
   <xsl:with-param name="starts" select="field[@name='exonStarts']"/>
   <xsl:with-param name="ends" select="field[@name='exonEnds']"/>
   <xsl:with-param name="min" select="$min"/>
   <xsl:with-param name="max" select="$max"/>
   <xsl:with-param name="y" select="$y"/>
</xsl:call-template>

</xsl:element><!-- svg:g -->

</xsl:for-each>

</xsl:template>


<xsl:template name="exons">
   <xsl:param name="count"/>
   <xsl:param name="index"/>
   <xsl:param name="starts"/>
   <xsl:param name="ends" />
   <xsl:param name="min"/>
   <xsl:param name="max"/>
   <xsl:param name="y"/>
   <xsl:if test="$index &lt;= $count">
   
      <xsl:variable name="exonStart">
         <xsl:choose>
            <xsl:when test="contains($starts,',')">
               <xsl:value-of select="number(substring-before($starts,','))"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="number($starts)"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="exonEnd">
         <xsl:choose>
            <xsl:when test="contains($ends,',')">
               <xsl:value-of select="number(substring-before($ends,','))"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="number($ends)"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
   
      <xsl:element name="svg:rect">
         <xsl:attribute name="style">stroke:black;fill:url(#grad);</xsl:attribute>
      
         <xsl:attribute name="x">
            <xsl:value-of select="(($exonStart - $min ) div  ($max - $min)) * $width"/>
         </xsl:attribute>
         
         <xsl:attribute name="width">
            <xsl:value-of select="(($exonEnd - $exonStart ) div  ($max - $min)) * $width"/>
         </xsl:attribute>
         
         <xsl:attribute name="y">
            <xsl:value-of select="$y +2"/>
         </xsl:attribute>
         
          <xsl:attribute name="height">
            <xsl:value-of select="$feature-height -4"/>
         </xsl:attribute>
         
      </xsl:element>
   
      <xsl:call-template name="exons">
         <xsl:with-param name="count" select="$count"/>
         <xsl:with-param name="index" select="$index+ 1"/>
         <xsl:with-param name="starts" select="substring-after($starts,',')"/>
         <xsl:with-param name="ends" select="substring-after($ends,',')"/>
         <xsl:with-param name="min" select="$min"/>
         <xsl:with-param name="max" select="$max"/>
         <xsl:with-param name="y" select="$y"/>
      </xsl:call-template>
   </xsl:if>
</xsl:template>





</xsl:stylesheet>
