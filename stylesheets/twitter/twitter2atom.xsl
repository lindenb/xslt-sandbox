<?xml version="1.0"?>
<xsl:stylesheet 
  version="1.0" 
   xmlns:a="http://www.w3.org/2005/Atom"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
  >
<!--

Motivation:
	transforms twitter status to XSL-FO
Author:
	Pierre Lindenbaum PhD 
WWW:
	http://plindenbaum.blogspot.com
Mail:
         plindenbaum@yahoo.fr
Usage:
        curl "http://api.twitter.com/1/statuses/show/[status-id].xml" > status.xml
        fop  -xml status.xml -xsl mysql2fo.xsl -pdf result.pdf

-->


<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

<xsl:template match="/">
<a:feed>
	<a:title><xsl:apply-templates select="html/head/title"/></a:title>
	<a:subtitle><xsl:apply-templates select="html/head/title"/></a:subtitle>
	<a:link><xsl:apply-templates select="html/head/link[@rel='canonical']/@href"/></a:link>
<xsl:apply-templates select="//div[@class='content' and div[@class='stream-item-header']]"/>
</a:feed>
</xsl:template>

<xsl:template match="div">
<a:entry>
<xsl:apply-templates select=".//a[@data-conversation-id]"/>
<a:title><xsl:value-of select=".//p"/></a:title>
<a:summary><xsl:value-of select=".//p"/></a:summary>
</a:entry>
</xsl:template>

<xsl:template match="a">
<a:link>https://twitter.com/<xsl:value-of select="@href"/></a:link>
<a:id>https://twitter.com/<xsl:value-of select="@data-conversation-id"/></a:id>
<a:updated><xsl:value-of select="date:add('1970-01-01T00:00:00Z', date:duration(span/@data-time ))"/></a:updated>
</xsl:template>


</xsl:stylesheet>
