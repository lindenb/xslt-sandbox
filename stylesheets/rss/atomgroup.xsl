<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:media="http://search.yahoo.com/mrss/"
	xmlns:a="http://www.w3.org/2005/Atom"
	xmlns:h='http://www.w3.org/1999/xhtml'
	exclude-result-prefixes="a media"
	version='1.1'
	>
<!-- merge feeds into one item if content/@type="xhtml" and contains at least one img -->
<xsl:output method="xml" indent="yes"/>


<xsl:template match="/">
<xsl:apply-templates select="a:feed"/>
</xsl:template>

<xsl:template match="a:feed">
<xsl:variable name="items" select="a:entry[a:content/@type='xhtml' and count(a:content//h:img) &gt; 0]"/>
<feed xmlns="http://www.w3.org/2005/Atom">
<xsl:apply-templates select="a:updated|a:id|a:icon|a:link|a:logo|a:title|a:subtite" mode="cp"/>
<xsl:if test="count($items) &gt; 0">
<entry>
<author>
	<name><xsl:value-of select="a:title"/></name>
	<uri><xsl:value-of select="a:link[@rel='alternate']/@href"/></uri>
</author>
 <updated><xsl:value-of select="$items[1]/a:updated/text()"/></updated>
 <id><xsl:value-of select="$items[1]/a:id/text()"/></id>
 <link><xsl:attribute name="href"><xsl:value-of select="a:link[@rel='alternate']/@href"/></xsl:attribute></link>
 <content type="xhtml">
 <div xmlns="http://www.w3.org/1999/xhtml">
   <xsl:apply-templates select="$items"/>
 </div>
 </content>
</entry>
</xsl:if>
</feed>
</xsl:template>

<xsl:template match="a:entry">
<xsl:apply-templates select=".//h:img"/>
</xsl:template>

<xsl:template match="h:img">
<a xmlns="http://www.w3.org/1999/xhtml" target="_blank">
<xsl:attribute name="href"><xsl:value-of select="./ancestor::a:entry/a:link/@href"/></xsl:attribute>
<xsl:apply-templates select="." mode="cp"/>
</a>
</xsl:template>


<xsl:template match="@*|node()" mode="cp">
	<xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="cp"/>
     </xsl:copy>
</xsl:template>


</xsl:stylesheet>
