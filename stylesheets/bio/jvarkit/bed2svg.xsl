<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
 version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:h="http://www.w3.org/1999/xhtml"
 xmlns="http://www.w3.org/2000/svg"
 xmlns:math="http://exslt.org/math"
 extension-element-prefixes="math"
 >


<xsl:variable name="radius">1000</xsl:variable>
<xsl:variable name="PI" select="number(3.14159265359)"/>



<!-- matching the root node -->
<xsl:template match="/">
<xsl:apply-templates select="bed"/>
</xsl:template>

<xsl:template match="bed">
<svg width="{$radius * 2.0}" height="{$radius * 2.0}">

<g>
<xsl:apply-templates select="body"/>
<rect x="0" y="0" width="{$radius * 2}" height="{$radius * 2}" style="stroke:red;fill:none;"/>
</g>
</svg>
</xsl:template>

<xsl:template match="body">
<g>
<xsl:attribute name="transform">
<xsl:text>translate(</xsl:text>
<xsl:value-of select="$radius"/>
<xsl:text>,</xsl:text>
<xsl:value-of select="$radius"/>
<xsl:text>)</xsl:text>
</xsl:attribute>
<xsl:apply-templates select=".//rec"/>
</g>
</xsl:template>


<xsl:template match="rec">
<path style="stroke:green;fill:gray;">
	<xsl:attribute name="d">
		<xsl:call-template name="arc">
			<xsl:with-param name="f1">
				<xsl:value-of select="number(@f1)"/>
			</xsl:with-param>
			<xsl:with-param name="f2">
				<xsl:value-of select="number(@f2)"/>
			</xsl:with-param>
			<xsl:with-param name="outer_radius">
				<xsl:value-of select="number($radius)"/>
			</xsl:with-param>
			<xsl:with-param name="inner_radius">
				<xsl:value-of select="number($radius) * 0.95"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:attribute>
	<title><xsl:value-of select="@contig"/>.<xsl:value-of select="name"/></title>
</path>
</xsl:template>

<xsl:template name="arc">
<xsl:param name="f1"/>
<xsl:param name="f2"/>
<xsl:param name="outer_radius"/>
<xsl:param name="inner_radius"/>

<xsl:text>M </xsl:text>

<xsl:call-template name="toPoint">
	<xsl:with-param name="f">
		<xsl:value-of select="$f1"/>
	</xsl:with-param>
	<xsl:with-param name="r">
		<xsl:value-of select="$inner_radius"/>
	</xsl:with-param>
</xsl:call-template>

<xsl:text> L </xsl:text>

<xsl:call-template name="toPoint">
	<xsl:with-param name="f">
		<xsl:value-of select="$f1"/>
	</xsl:with-param>
	<xsl:with-param name="r">
		<xsl:value-of select="$outer_radius"/>
	</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="arcTo">
	<xsl:with-param name="r">
		<xsl:value-of select="$outer_radius"/>
	</xsl:with-param>
	<xsl:with-param name="f1">
		<xsl:value-of select="$f1"/>
	</xsl:with-param>
	<xsl:with-param name="f2">
		<xsl:value-of select="$f2"/>
	</xsl:with-param>
</xsl:call-template>

<xsl:text> L </xsl:text>

<xsl:call-template name="toPoint">
	<xsl:with-param name="f">
		<xsl:value-of select="$f2"/>
	</xsl:with-param>
	<xsl:with-param name="r">
		<xsl:value-of select="$inner_radius"/>
	</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="arcTo">
	<xsl:with-param name="r">
		<xsl:value-of select="$inner_radius"/>
	</xsl:with-param>
	<xsl:with-param name="f1">
		<xsl:value-of select="$f2"/>
	</xsl:with-param>
	<xsl:with-param name="f2">
		<xsl:value-of select="$f1"/>
	</xsl:with-param>
</xsl:call-template>

</xsl:template>


<xsl:template name="toPoint">
<xsl:param name="f"/>
<xsl:param name="r"/>
<xsl:variable name="angle" select="(($PI * 2) * number($f)) - ($PI div 2)" />
<xsl:value-of select="number($r)*math:cos($angle)"/>
<xsl:text> </xsl:text>
<xsl:value-of select="number($r)*math:sin($angle)"/>
</xsl:template>

<xsl:template name="arcTo">
<xsl:param name="r"/>
<xsl:param name="f1"/>
<xsl:param name="f2"/>

<xsl:text> A </xsl:text>
<xsl:value-of select="$r"/>
<xsl:text> </xsl:text>
<xsl:value-of select="$r"/>
<xsl:text> 0 0 </xsl:text>
<xsl:choose>
	<xsl:when test="number($f1) &lt; number($f2) ">
		<xsl:text>1 </xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>0 </xsl:text>
	</xsl:otherwise>
</xsl:choose>

<xsl:call-template name="toPoint">
	<xsl:with-param name="f">
		<xsl:value-of select="$f2"/>
	</xsl:with-param>
	<xsl:with-param name="r">
		<xsl:value-of select="$r"/>
	</xsl:with-param>
</xsl:call-template>

</xsl:template>

<xsl:template name="x">
<xsl:variable name="angle" select="(($PI * 2) * number($f)) - ($PI div 2)" />
<xsl:value-of select="number($r)*math:cos($angle)"/>
<xsl:text> </xsl:text>
<xsl:value-of select="number($r)*math:sin($angle)"/>
</xsl:template>

</xsl:stylesheet>
