<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.1'
	>

<!--

Usage:
	xsltproc photo2html.xsl "http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=123&photo_id=1234&format=rest"

-->

<xsl:template>
 <xsl:apply-templates select="rsp"/>
</xsl:template>


<xsl:template match="rsp">
	<xsl:if test="@stat!='ok'">
		<xsl:message terminate="yes">ERROR in XML <xsl:value-of select="err/@msg"/></xsl:message>
	</xsl:if>
<xsl:apply-templates select="photo"/>
</xsl:template>


<xsl:template match="photo">
<xsl:variable name="u">
<xsl:value-of select="concat('http://www.flickr.com/photos/',owner/@nsid,'/',@id)"/>
</xsl:variable>
<div>
<xsl:element name="a">
<xsl:attribute name="href">
	<xsl:value-of select="$u"/>
</xsl:attribute>

<xsl:if test="string-length(normalize-space(title))&gt;0">
	<xsl:attribute name="title">
		<xsl:value-of select="title"/>
	</xsl:attribute>
</xsl:if>


<xsl:choose>
	<xsl:when test="string-length(normalize-space(title))=0">
		<xsl:value-of select="$u"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="title"/>
		<xsl:text>&quot;</xsl:text>
	</xsl:otherwise>
</xsl:choose>

</xsl:element>

<xsl:text> by </xsl:text>


<xsl:apply-templates select="owner"/>

<i>
<xsl:text> License:</xsl:text>
<xsl:choose>
<xsl:when test="@license='0'">All Rights Reserved</xsl:when>
<xsl:when test="@license='4'"><a href="http://creativecommons.org/licenses/by/2.0/">Attribution License</a></xsl:when>
<xsl:when test="@license='6'"><a href="http://creativecommons.org/licenses/by-nd/2.0/">Attribution-NoDerivs License</a></xsl:when>
<xsl:when test="@license='3'"><a href="http://creativecommons.org/licenses/by-nc-nd/2.0/">Attribution-NonCommercial-NoDerivs License</a></xsl:when>
<xsl:when test="@license='2'"><a href="http://creativecommons.org/licenses/by-nc/2.0/">Attribution-NonCommercial License</a></xsl:when>
<xsl:when test="@license='1'"><a href="http://creativecommons.org/licenses/by-nc-sa/2.0/">Attribution-NonCommercial-ShareAlike License</a></xsl:when>
<xsl:when test="@license='5'"><a href="http://creativecommons.org/licenses/by-sa/2.0/">Attribution-ShareAlike License</a></xsl:when>
<xsl:when test="@license='7'"><a href="http://www.flickr.com/commons/usage/">No known copyright restrictions</a></xsl:when>
<xsl:when test="@license='8'"><a href="http://www.usa.gov/copyright.shtml">United States Government Work</a></xsl:when>
<xsl:otherwise>
	<xsl:value-of select="@license"/>
</xsl:otherwise>
</xsl:choose>
</i>
</div>
</xsl:template>


<xsl:template match="owner">
<xsl:element name="a">
<xsl:attribute name="href">
	<xsl:value-of select="concat('http://www.flickr.com/photos/',@nsid)"/>
</xsl:attribute>
<xsl:choose>
	<xsl:when test="@realname"><xsl:value-of select="@realname"/></xsl:when>
	<xsl:when test="@username"><xsl:value-of select="@username"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="@nsid"/></xsl:otherwise>
</xsl:choose>
</xsl:element>
</xsl:template>


</xsl:stylesheet>
