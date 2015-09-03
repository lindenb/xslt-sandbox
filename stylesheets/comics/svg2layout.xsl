<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:x="http://www.w3.org/1999/XSL/TransformAlias"
	version="1.0">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="layoutid">UNDEFINED</xsl:param>
<xsl:namespace-alias stylesheet-prefix="x" result-prefix="xsl" />

<xsl:template match="/">
<x:stylesheet version="1.0">
<x:output method="xml"/>
<xsl:apply-templates select="svg:svg"/>
</x:stylesheet>
</xsl:template>



<xsl:template match="svg:svg">
<x:template match="page[@layout='{$layoutid}']" mode="width">
<x:value-of>
	<xsl:attribute name="select">number(<xsl:value-of select="round(@width)"/>)</xsl:attribute>
</x:value-of>
</x:template>

<x:template match="page[@layout='{$layoutid}']" mode="height">
<x:value-of>
	<xsl:attribute name="select">number(<xsl:value-of select="round(@height)"/>)</xsl:attribute>
</x:value-of>
</x:template>

<x:template match="page[@layout='{$layoutid}']" mode="scenes">
<x:value-of>
	<xsl:attribute name="select">number(<xsl:value-of select="count(svg:g/svg:rect)"/>)</xsl:attribute>
</x:value-of>
</x:template>

<x:template match="scene[../@layout='{$layoutid}']" mode="width">
<x:variable name="pos" select="count(preceding-sibling::scene)"/>
<x:choose>
	<xsl:for-each select="svg:g/svg:rect">
		<x:when>
			<xsl:attribute name="select">$pos = <xsl:value-of select="position() - 1"/></xsl:attribute>
			<xsl:text>number(</xsl:text>
			<xsl:value-of select="round(@width)"/>
			<xsl:text>)</xsl:text>
		</x:when>
	</xsl:for-each>
	<x:otherwise><x:message terminate="yes">BOUM</x:message></x:otherwise>
</x:choose>
</x:template>

<x:template match="scene[../@layout='{$layoutid}']" mode="height">
<x:variable name="pos" select="count(preceding-sibling::scene)"/>
<x:choose>
	<xsl:for-each select="svg:g/svg:rect">
		<x:when>
			<xsl:attribute name="select">$pos = <xsl:value-of select="position() - 1"/></xsl:attribute>
			<xsl:text>number(</xsl:text>
			<xsl:value-of select="round(@height)"/>
			<xsl:text>)</xsl:text>
		</x:when>
	</xsl:for-each>
	<x:otherwise><x:message terminate="yes">BOUM</x:message></x:otherwise>
</x:choose>
</x:template>

<x:template match="scene[../@layout='{$layoutid}']" mode="x">
<x:variable name="pos" select="count(preceding-sibling::scene)"/>
<x:choose>
	<xsl:for-each select="svg:g/svg:rect">
		<x:when>
			<xsl:attribute name="select">$pos = <xsl:value-of select="position() - 1"/></xsl:attribute>
			<xsl:text>number(</xsl:text>
			<xsl:value-of select="round(@x)"/>
			<xsl:text>)</xsl:text>
		</x:when>
	</xsl:for-each>
	<x:otherwise><x:message terminate="yes">BOUM</x:message></x:otherwise>
</x:choose>
</x:template>

<x:template match="scene[../@layout='{$layoutid}']" mode="y">
<x:variable name="pos" select="count(preceding-sibling::scene)"/>
<x:choose>
	<xsl:for-each select="svg:g/svg:rect">
		<x:when>
			<xsl:attribute name="select">$pos = <xsl:value-of select="position() - 1"/></xsl:attribute>
			<xsl:text>number(</xsl:text>
			<xsl:value-of select="round(@y)"/>
			<xsl:text>)</xsl:text>
		</x:when>
	</xsl:for-each>
	<x:otherwise><x:message terminate="yes">BOUM</x:message></x:otherwise>
</x:choose>
</x:template>

<x:template  name="layout_{$layoutid}_css">
.layout_<xsl:value-of select="$layoutid"/>_page {
       width:  <xsl:value-of select="round(@width)"/>px;
       height: <xsl:value-of select="round(@height)"/>px;
       border: 3px solid black;
       background: white;
       margin: 8px;
       display: inline-block;
       position: relative;
      }
<xsl:for-each select="svg:g/svg:rect">
.layout_<xsl:value-of select="$layoutid"/>_scene<xsl:value-of select="position()"/> {
       width:  <xsl:value-of select="round(@width)"/>px;
       height: <xsl:value-of select="round(@height)"/>px;
       border: 3px solid black;
       background: white;
       margin: 8px;
       display: inline-block;
       position: relative;
      }    
</xsl:for-each>
  
</x:template>


</xsl:template>
 
   
</xsl:stylesheet>
