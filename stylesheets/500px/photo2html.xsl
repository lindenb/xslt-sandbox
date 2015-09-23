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
 <xsl:text>. (</xsl:text>
 <xsl:apply-templates select="//a[@data-bind='license']"/>
  <xsl:apply-templates select="//script"/>
 <xsl:text>). </xsl:text>
 <xsl:value-of select="$today"/>
<xsl:text>.</xsl:text>
</div>
<xsl:call-template name="my-links"/>

<xsl:text>


</xsl:text>
<xsl:value-of select="$commontags"/><xsl:text> 500px

</xsl:text>
<xsl:value-of select="translate($commontags,' ',',')"/>
<xsl:text>,500px

</xsl:text>

</xsl:template>

<xsl:template match="a[@data-bind='license']">
<a>
<xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
<xsl:value-of select="@data-tooltip"/>
</a>
</xsl:template>

<xsl:template match="script">
<xsl:choose>
<xsl:when test="contains(.,',&quot;license_type&quot;:0,')">
<xsl:text>Standard 500px License</xsl:text>
</xsl:when>
<xsl:when test="contains(.,',&quot;license_type&quot;:1,')">
<xsl:text>Creative Commons License Non Commercial Attribution</xsl:text>
</xsl:when>
<xsl:when test="contains(.,',&quot;license_type&quot;:2,')">
<xsl:text>Creative Commons License Non Commercial No Derivatives</xsl:text>
</xsl:when>
<xsl:when test="contains(.,',&quot;license_type&quot;:3,')">
<xsl:text>Creative Commons License Non Commercial Share Alike</xsl:text>
</xsl:when>
<xsl:when test="contains(.,',&quot;license_type&quot;:4,')">
<xsl:text>Creative Commons License Attribution</xsl:text>
</xsl:when>
<xsl:when test="contains(.,',&quot;license_type&quot;:5,')">
<xsl:text>Creative Commons License No Derivatives</xsl:text>
</xsl:when>
<xsl:when test="contains(.,',&quot;license_type&quot;:6,')">
<xsl:text>Creative Commons License Share Alike</xsl:text>
</xsl:when>

</xsl:choose>
</xsl:template>

</xsl:stylesheet>
