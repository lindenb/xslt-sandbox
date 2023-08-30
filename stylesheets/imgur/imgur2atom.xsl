<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet 
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:a="http://www.w3.org/2005/Atom"
	xmlns:h='http://www.w3.org/1999/xhtml'
	xmlns:date="http://exslt.org/dates-and-times"
	exclude-result-prefixes="a h date"
	version='1.0'>
<xsl:output method="xml" ident="yes"/>

<xsl:template match="/">
<feed xmlns="http://www.w3.org/2005/Atom">
<title><xsl:value-of select="normalize-space(html/head/title)"/></title>
<updated><xsl:value-of select="date:date-time()"/></updated>
<xsl:apply-templates select="//a[@href and img/@src]"/>
</feed>
</xsl:template>

<xsl:template match="a">
<entry  xmlns="http://www.w3.org/2005/Atom">
<id><xsl:value-of select="@href"/></id>
<link><xsl:value-of select="@href"/></link>
<updated><xsl:value-of select="date:date-time()"/></updated>
<content type="xhtml">
 <div xmlns="http://www.w3.org/1999/xhtml">
 	<a target="_blank">
 		<xsl:attribute name="href">https://imgur.com<xsl:value-of select="@href"/></xsl:attribute>
	 	<img>
	 		<xsl:attribute name="src">https:<xsl:value-of select="img/@src"/></xsl:attribute>
	 	</img>
 	</a>
 </div>
</content>
</entry>
</xsl:template>

</xsl:stylesheet>
