<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:media="http://search.yahoo.com/mrss/"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:creativeCommons="http://backend.userland.com/creativeCommonsRssModule"
	exclude-result-prefixes="creativeCommons atom media"
	version='1.1'
	>
<xsl:output method="xml" indent="yes"/>


<xsl:template match="/">
<html>
<head>
	<title>Atom merger</title>
</head>
<body>
 <xsl:apply-templates select="atom:feed"/>
</body>
</html>
</xsl:template>

<xsl:template match="atom:feed">
<dl>
 <xsl:apply-templates select="atom:entry"/>
</dl>
</xsl:template>





<xsl:template match="atom:entry">
<dt>
<a>
<xsl:attribute name="href">
<xsl:value-of select="atom:link/@href"/>
</xsl:attribute>
<xsl:value-of select="atom:title/text()"/>
</a>
<xsl:text> (</xsl:text>
<xsl:value-of select="atom:updated/text()"/>
<xsl:text>)</xsl:text>
</dt>
<dd>
<xsl:choose>
	<xsl:when test="atom:content/@type='html'">
		<xsl:value-of select="atom:content" disable-output-escaping="yes"/>
	</xsl:when>
	<xsl:choose>
		<xsl:value-of select="atom:content"/>
	</xsl:choose>
</xsl:choose>
</dd>
</xsl:template>



</xsl:stylesheet>
