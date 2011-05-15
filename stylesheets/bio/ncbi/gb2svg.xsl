<?xml version='1.0' encoding="UTF-8"?>
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Motivation:
      transform the xmloutput of genbank-xml to SVG
Reference:
     
Params:
   * width
   * height
   * build
Usage :
      xsltproc ucsc-sql2svg.xsl sequence.gbc.xml > file.svg
-->

<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:svg="http://www.w3.org/2000/svg"
        xmlns:xlink="http://www.w3.org/1999/xlink"
	version='1.0'
	>
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

<xsl:param name="feature-height" select="number(20)"/>
<xsl:param name="title-height" select="2 * $feature-height"/>
<xsl:param name="width" select="number(900)"/>
<xsl:param name="height" select="(count(/INSDSet/INSDSeq/INSDSeq_feature-table/INSDFeature/INSDFeature_intervals/INSDInterval) * $feature-height)+number(1)+ count(/INSDSet/INSDSeq)*$title-height"/>
<xsl:param name="left-margin" select="number(10)"/>
<xsl:param name="right-margin" select="number(10)"/>

<xsl:template match="/">
<xsl:apply-templates select="INSDSet"/>
</xsl:template>

<xsl:template match="INSDSet">
<xsl:element name="svg:svg">
<xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute>
<xsl:attribute name="width"><xsl:value-of select="$width + $left-margin + $right-margin"/></xsl:attribute>
<xsl:attribute name="style">stroke-width:1px;</xsl:attribute>
<svg:title>
  <xsl:choose>
  	<xsl:when test="count(INSDSeq)=1">
  		<xsl:value-of select="INSDSeq/INSDSeq_definition"/>
  	</xsl:when>
  	<xsl:otherwise>
  		<xsl:value-of select="concat(count(INSDSeq),' sequences')"/>
  	</xsl:otherwise>
  </xsl:choose>
</svg:title>
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
<xsl:apply-templates select="INSDSeq"/>
</svg:g>
</xsl:element>
</xsl:template>


<!-- ===================================

 INSDSeq
 
 ======================================= -->
<xsl:template match="INSDSeq">
<xsl:variable name="seqy" select="$feature-height * count(preceding-sibling::INSDSeq/INSDSeq_feature-table/INSDFeature/INSDFeature_intervals/INSDInterval) + $title-height*count(preceding-sibling::INSDSeq)"/>

<xsl:variable name="seqheight" select="$feature-height * count(INSDSeq_feature-table/INSDFeature/INSDFeature_intervals/INSDInterval) + $title-height"/>


<xsl:variable name="seqmin">
  <xsl:for-each select="INSDSeq_feature-table/INSDFeature/INSDFeature_intervals/INSDInterval/INSDInterval_from">
    <xsl:sort select="." data-type="number" order="ascending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="number(text())" />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="seqmax">
  <xsl:for-each select="INSDSeq_feature-table/INSDFeature/INSDFeature_intervals/INSDInterval/INSDInterval_to">
    <xsl:sort select="." data-type="number" order="descending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="number(text())" />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:element name="svg:g">
<xsl:attribute name="transform">
<xsl:value-of select="concat('translate(0,',$seqy,')')"/>
</xsl:attribute>


<xsl:element name="svg:rect">
        <xsl:attribute name="x">0</xsl:attribute>
        <xsl:attribute name="y">0</xsl:attribute>
        <xsl:attribute name="width"><xsl:value-of select="$width + $left-margin + $right-margin"/></xsl:attribute>
        <xsl:attribute name="height"><xsl:value-of select="$seqheight"/></xsl:attribute>
        <xsl:attribute name="fill">url(#vertical_body_gradient)</xsl:attribute>
        <xsl:attribute name="stroke">black</xsl:attribute>
</xsl:element>

<xsl:element name="svg:text">
<xsl:attribute name="style">color:red;font-size:<xsl:value-of select="$title-height -5"/>px;</xsl:attribute>
<xsl:attribute name="x"><xsl:value-of select="$left-margin"/></xsl:attribute>
<xsl:attribute name="y"><xsl:value-of select="$title-height -5"/></xsl:attribute>
<xsl:value-of select="INSDSeq_definition"/>
</xsl:element>


<xsl:for-each select="INSDSeq_feature-table/INSDFeature/INSDFeature_intervals/INSDInterval">
<xsl:element name="svg:g">


<xsl:variable name="fleft">
  <xsl:choose>
    <xsl:when test="INSDInterval_point">
      <xsl:value-of select="$left-margin + (( number(INSDInterval_point) - $seqmin )  div ($seqmax - $seqmin) ) * $width "/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$left-margin + (( number(INSDInterval_from) - $seqmin )  div ($seqmax - $seqmin) ) * $width "/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>


<xsl:variable name="fright">
  <xsl:choose>
    <xsl:when test="INSDInterval_point">
      <xsl:value-of select="$fleft + 1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$left-margin + (( number(INSDInterval_to) - $seqmin )  div ($seqmax - $seqmin) ) * $width "/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="fy">
   <xsl:value-of select="$title-height + ((position() - 1) * $feature-height)"/>
</xsl:variable>

<xsl:variable name="fmid">
   <xsl:value-of select="$fy + ( $feature-height div 2.0 )"/>
</xsl:variable>

<xsl:element name="svg:rect">
  <xsl:attribute name="x"><xsl:value-of select="$fleft"/></xsl:attribute>
  <xsl:attribute name="y"><xsl:value-of select="$fy"/></xsl:attribute>
  <xsl:attribute name="width"><xsl:value-of select="$fright - $fleft"/></xsl:attribute>
  <xsl:attribute name="height"><xsl:value-of select="$feature-height - 2"/></xsl:attribute>
  <xsl:attribute name="style">fill:url(#grad);stroke:black;</xsl:attribute>
</xsl:element>



<xsl:element name="svg:text">
   <xsl:attribute name="y"><xsl:value-of select="$fmid + 4"/></xsl:attribute>
   <xsl:choose>
      <xsl:when test="$fleft &gt; ($width div 10.0)">
         <xsl:attribute name="x">
            <xsl:value-of select="$fleft - 2"/>
         </xsl:attribute>
         <xsl:attribute name="text-anchor">end</xsl:attribute>
      </xsl:when>
      <xsl:when test="$fright &lt; ($width * 0.9)">
         <xsl:attribute name="x">
            <xsl:value-of select="$fright + 2"/>
         </xsl:attribute>
         <xsl:attribute name="text-anchor">start</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
         <xsl:attribute name="x">
            <xsl:value-of select="($fright + $fleft) div 2.0"/>
         </xsl:attribute>
         <xsl:attribute name="text-anchor">middle</xsl:attribute>
      </xsl:otherwise>
   </xsl:choose>
<svg:tspan style="font-weight:bold;">
<xsl:apply-templates select="../../INSDFeature_key"/>
</svg:tspan>
<xsl:apply-templates select="../../INSDFeature_quals"/>
</xsl:element>


</xsl:element><!-- g -->
</xsl:for-each>

<xsl:element name="svg:rect">
  <xsl:attribute name="x">0</xsl:attribute>
        <xsl:attribute name="y">0</xsl:attribute>
        <xsl:attribute name="width"><xsl:value-of select="$width + $left-margin + $right-margin"/></xsl:attribute>
        <xsl:attribute name="height"><xsl:value-of select="$seqheight"/></xsl:attribute>
        <xsl:attribute name="fill">none</xsl:attribute>
        <xsl:attribute name="stroke">black</xsl:attribute>
</xsl:element>

</xsl:element><!-- svg:g -->

</xsl:template>

<xsl:template match="INSDFeature_quals">
<xsl:apply-templates select="INSDQualifier"/>
</xsl:template>


<xsl:template match="INSDQualifier">
  <xsl:text> </xsl:text>
  <svg:tspan font-weight="bold">
  <xsl:value-of select="INSDQualifier_name"/>
  </svg:tspan>
  <xsl:text>:</xsl:text>
  <xsl:value-of select="INSDQualifier_value"/>
</xsl:template>

<xsl:template match="INSDQualifier[INSDQualifier_name='note' or INSDQualifier_name='db_xref' or INSDQualifier_name='transl_table' or INSDQualifier_name='translation'  or INSDQualifier_name='inference' or INSDQualifier_name='gene_synonym']">
</xsl:template>


</xsl:stylesheet>
