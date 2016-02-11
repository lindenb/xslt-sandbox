<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:x="http://exslt.org/dates-and-times"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="x"
	version="1.1"
	>
<xsl:import  href="../util/mod.drawing.xsl"/>
 <xsl:output method="html" omit-xml-declaration="yes" indent="no"/>
<xsl:template match="/">
 <xsl:apply-templates select="html"/>
</xsl:template>




<xsl:template match="html">

<xsl:text>

</xsl:text>
<xsl:value-of select="$now"/>
<xsl:text>

</xsl:text>

<div>
<xsl:if test="number(x:month-in-year())=10">#inktober </xsl:if>
<xsl:text>Source: </xsl:text>
<xsl:element name="a">
<xsl:attribute name="href"><xsl:value-of select="head/link[@rel='canonical']/@href"/></xsl:attribute>
<xsl:text>instagram</xsl:text>
</xsl:element>
<xsl:text> by </xsl:text>
<xsl:element name="a">
<xsl:attribute name="href">
 <xsl:value-of select="concat('https://www.instagram.com/',substring-before(head/meta[@property='og:title']/@content,' '),'/')"/>
</xsl:attribute>
	<xsl:value-of select="concat('@',substring-before(head/meta[@property='og:title']/@content,' '))"/>
</xsl:element>
 <xsl:text>. </xsl:text>
 <xsl:value-of select="$today"/>
<xsl:text>.</xsl:text>
</div>
<xsl:call-template name="my-links"/>

<xsl:text>


</xsl:text>
<xsl:variable name="tags">
	<xsl:value-of select="$commontags"/>
	<xsl:text> instagram</xsl:text>
	<xsl:for-each select="//meta[@property='instapp:hashtags']">
	<xsl:text> </xsl:text>
	<xsl:value-of select="@content"/>
	</xsl:for-each>
</xsl:variable>
<xsl:value-of select="$tags"/><xsl:text>

</xsl:text>
<xsl:value-of select="translate($tags,' ',',')"/>
<xsl:text>

</xsl:text>

</xsl:template>



</xsl:stylesheet>
