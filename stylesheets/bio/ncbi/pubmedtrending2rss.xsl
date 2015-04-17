<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
 version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:date="http://exslt.org/dates-and-times" 
 xmlns:dc="http://purl.org/dc/elements/1.1/"
 xmlns:h="http://www.w3.org/1999/xhtml"
 >


<!--
Author:
	Pierre Lindenbaum
Motivation:
	NCBI pubmed trending as RSS

-->



<xsl:output method='xml' indent="yes" encoding="UTF-8"/>

<xsl:template match="/">
<rss version="2.0" xml:base="http://www.ncbi.nlm.nih.gov">
	<channel>
		<title><xsl:value-of select="/html/head/title"/></title>
		<link>http://www.ncbi.nlm.nih.gov/pubmed/trending/</link>
 		<description><xsl:value-of select="/html/head/title"/></description>
		<pubDate><xsl:value-of select="date:date-time()"/></pubDate>
		<lastBuildDate><xsl:value-of select="date:date-time()"/></lastBuildDate>
		<generator>http://www.ncbi.nlm.nih.gov</generator>
	  <xsl:apply-templates select="/html//div[@class='rslt']"/>
	</channel>
</rss>
</xsl:template>

<xsl:template match="div[@class='rslt']">
<xsl:variable name="url" select="concat('http://www.ncbi.nlm.nih.gov',p[@class='title']/a/@href)"/>
  <item>
    <title><xsl:value-of select="p[@class='title']"/></title>
    <link><xsl:value-of select="$url"/>/</link>
    <pubDate><xsl:value-of select="normalize-space(substring-before(substring-after(.//p[@class='details'],'.'),'.'))"/></pubDate>
    <author><xsl:value-of select=".//p[@class='desc']"/></author>
    <guid isPermaLink="true"><xsl:value-of select="$url"/></guid>
    <description>
  	<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
  		<xsl:copy-of select="*"/>
  	<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
    </description>
  </item>
</xsl:template>


</xsl:stylesheet>
