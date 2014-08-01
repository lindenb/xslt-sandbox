<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:x="http://exslt.org/dates-and-times"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="x"
	version="1.1"
	>
 <xsl:output method="html" omit-xml-declaration="yes" indent="no"/>
<xsl:template match="/">
 <xsl:apply-templates select="html"/>
</xsl:template>




<xsl:template match="html">
<div>
 <xsl:text>Source: </xsl:text>
<xsl:element name="a">
<xsl:attribute name="href"><xsl:value-of select="head/meta[@property='og:url']/@content"/></xsl:attribute>
<xsl:value-of select="head/meta[@property='og:title']/@content"/>
</xsl:element>
<xsl:text> by </xsl:text>
<xsl:element name="a">
<xsl:attribute name="href">
	<xsl:value-of select="head/meta[@property='five_hundred_pixels:author']/@content"/>
	</xsl:attribute>

	<xsl:choose>
		<xsl:when test="head/meta[@property='twitter:creator']">
			<xsl:value-of select="concat('@',head/meta[@property='twitter:creator']/@value)"/>
		</xsl:when>
		<xsl:when test="head/meta[@property='twitter:creator']/@value">
			<xsl:value-of select="concat('@',head/meta[@property='twitter:creator']/@value)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="//a[@class='user_profile_link']"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:element>
 <xsl:text>. ( </xsl:text>
 <xsl:apply-templates select="//a[@data-bind='license']"/>
 <xsl:text>) </xsl:text>
       <xsl:value-of select="x:month-name()"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="x:day-in-month()"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="x:year()"/>
      <xsl:text>.</xsl:text>
</div>
    <div>
	<a href="http://tyeul.tumblr.com/">Tumblr</a><xsl:text> </xsl:text>
	<a href="http://yokofakun.deviantart.com/">DeviantArt</a><xsl:text> </xsl:text>
	<a href="https://www.facebook.com/kakaheska">Facebook</a><xsl:text> </xsl:text>
	<a href="https://www.flickr.com/photos/lindenb/">Flickr</a><xsl:text> </xsl:text>
	<a href="http://www.pinterest.com/yokofakun/drawings/">Pinterest</a>
    </div>

</xsl:template>

<xsl:template match="a[@data-bind='license']">
<a>
<xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
<xsl:value-of select="@data-tooltip"/>
</a>
</xsl:template>


</xsl:stylesheet>
