<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:x="http://www.ibm.com/xmlns/prod/2009/jsonx"
	version='1.0'
	>
<!--


-->
<xsl:output method="html" />


<xsl:template match="/">
<html>
<head>
<style>
</style>
</head>
<body>
<xsl:apply-templates select="//x:object[x:array[@name='thumbnail_resources']]"/>
</body></html>
</xsl:template>

<xsl:template match="x:object[x:array[@name='thumbnail_resources']]">
<xsl:variable name="F1" select="x:array[@name='thumbnail_resources']/x:object[1]"/>
<span>
<a>
<xsl:attribute name="href">https://www.instagram.com/p/<xsl:value-of select="x:string[@name='shortcode']"/></xsl:attribute>
<xsl:attribute name="title">
	<xsl:value-of select="normalize-space(x:object[@name='edge_media_to_caption']//x:string[@name='text']/text())"/>
</xsl:attribute>
<img>
	<xsl:attribute name="src">
		<xsl:value-of select="$F1/x:string[@name='src']/text()"/>
	</xsl:attribute>
	<xsl:attribute name="width">
		<xsl:value-of select="$F1/x:number[@name='config_width']/text()"/>
	</xsl:attribute>
	<xsl:attribute name="height">
		<xsl:value-of select="$F1/x:number[@name='config_height']/text()"/>
	</xsl:attribute>
</img>
</a>
</span>
</xsl:template>
</xsl:stylesheet>

