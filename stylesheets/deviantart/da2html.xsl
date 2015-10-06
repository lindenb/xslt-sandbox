<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:x="http://exslt.org/dates-and-times"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="x"
	version="1.1"
	>
<xsl:import href="../util/mod.drawing.xsl"/>
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
 <xsl:apply-templates select="head"/>

 <xsl:apply-templates select="//div[@class='cc_license_text']"/>

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
<xsl:text>


</xsl:text>
<xsl:value-of select="$commontags"/><xsl:text> deviantart

</xsl:text>
<xsl:value-of select="translate($commontags,' ',',')"/>
<xsl:text>,deviantart

</xsl:text>

</xsl:template>


<xsl:template match="head">
<xsl:if test="number(x:month-in-year())=10">#inktober </xsl:if>
<xsl:text>Source: </xsl:text>
<xsl:element name="a">
<xsl:attribute name="href"><xsl:value-of select="meta[@property='og:url']/@content"/></xsl:attribute>
<xsl:value-of select="meta[@property='og:title']/@content"/>
</xsl:element>
<xsl:text> by </xsl:text>
<xsl:element name="a">
<xsl:attribute name="href">
	<xsl:value-of select="concat('http://',substring-before(substring-after(meta[@property='og:url']/@content,'http://'),'/'))"/>
	</xsl:attribute>
    <xsl:value-of select="substring-before(substring-after(meta[@property='og:url']/@content,'http://'),'.deviantart.com')"/>
</xsl:element>
<xsl:text>. </xsl:text>
</xsl:template>

<xsl:template match="div[@class='cc_license_text']">
<xsl:text>(</xsl:text>
<a>
<xsl:attribute name="href"><xsl:value-of select="a/@href"/></xsl:attribute>
<xsl:value-of select="a/text()"/>
</a>
<xsl:text>). </xsl:text>
</xsl:template>





</xsl:stylesheet>
