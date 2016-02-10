<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns="http://www.w3.org/2005/Atom"
    xmlns:date="http://exslt.org/dates-and-times"

    exclude-result-prefixes="atom date"
	version="1.0" >
<xsl:output method="xml"/>

<xsl:template match="/">
<xsl:apply-templates select="rss"/>
</xsl:template>

<xsl:template match="rss">
<feed>
<xsl:apply-templates select="channel"/>
</feed>
</xsl:template>


<xsl:template match="channel">
	<title><xsl:apply-templates select="title/text()"/></title>
	<id><xsl:apply-templates select="link"/></id>
	<updated> <xsl:value-of select="date:date-time()"/></updated>
	<xsl:apply-templates select="item"/>
</xsl:template>


<xsl:template match="item">
<entry>
	<xsl:apply-templates select="guid"/>
	<xsl:apply-templates select="title"/>
	<xsl:apply-templates select="pubDate"/>
	<xsl:choose>
		<xsl:when test="description">
			<content type="html"><xsl:apply-templates select="description"/></content>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
</entry>
</xsl:template>

<xsl:template match="guid">
<id><xsl:value-of select="text()"/></id>
</xsl:template>

<xsl:template match="title">
<title><xsl:value-of select="text()"/></title>
</xsl:template>

<xsl:template match="pubDate">
<updated><xsl:value-of select="text()"/></updated>
</xsl:template>


</xsl:stylesheet>
