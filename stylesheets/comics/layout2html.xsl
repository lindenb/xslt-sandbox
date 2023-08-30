<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:g="http://www.gexf.net/1.1draft"
	xmlns:viz="http://www.gexf.net/1.1draft/viz"
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:h='http://www.w3.org/1999/xhtml'
        version='1.0'
        >
<xsl:output method="xml" indent="yes"/>
<xsl:variable name="width" select="number(100)"/>
<xsl:variable name="height" select="number(150)"/>

<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml">
<body>
<div style="display: grid; grid-template-columns:1fr 1fr 1fr 1fr 1fr 1fr 1fr ;grid-gap: 20px;">
<xsl:apply-templates select="layouts/layout"/>
</div>
</body>
</html>
</xsl:template>

<xsl:template match="layout">
<span>
<b><xsl:value-of select="@id"/></b>
<svg>
	<xsl:attribute name="width" select="$width + 1"/>
	<xsl:attribute name="height" select="$height + 1"/>
<style>
.layout {fill:yellow;}
.panel {fill:gray;stroke:black;}
</style>
<g>
	<rect class="layout">

	<xsl:attribute name="width">
		<xsl:value-of select="$width"/>
	</xsl:attribute>


	<xsl:attribute name="height">
		<xsl:value-of select="$height"/>
	</xsl:attribute>


	</rect>
	<xsl:apply-templates select="panel"/>

</g>
</svg>
</span>
</xsl:template>

<xsl:template match="panel">
	<xsl:variable name="w">
		<xsl:call-template name="maxX">
			<xsl:with-param name="node" select=".."/>
		</xsl:call-template>
	</xsl:variable>


	<xsl:variable name="h">
		<xsl:call-template name="maxY">
			<xsl:with-param name="node" select=".."/>
		</xsl:call-template>
	</xsl:variable>

<rect class="panel">
	<xsl:attribute name="x">
		<xsl:value-of select="$width * (number(@x) div $w)"/>
	</xsl:attribute>
	<xsl:attribute name="y">
		<xsl:value-of select="$height * (number(@y) div $h)"/>
	</xsl:attribute>
	<xsl:attribute name="width">
		<xsl:value-of select="$width * (number(@width) div $w)"/>
	</xsl:attribute>
	<xsl:attribute name="height">
		<xsl:value-of select="$height * (number(@height) div $h)"/>
	</xsl:attribute>

</rect>
</xsl:template>

<xsl:template name="maxX">
<xsl:param name="node"/>
	<xsl:for-each select="$node/panel">
		<xsl:sort select="number(@width) + number(@x)" data-type="number" order="descending"/>
		 <xsl:if test="position() = 1"><xsl:value-of select="(number(@width) + number(@x))"/></xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template name="maxY">
<xsl:param name="node"/>
	<xsl:for-each select="$node/panel">
		<xsl:sort select="number(@height) + number(@y)" data-type="number" order="descending"/>
		 <xsl:if test="position() = 1"><xsl:value-of select="(number(@height) + number(@y))"/></xsl:if>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>

