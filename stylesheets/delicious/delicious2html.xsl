<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:str='http://exslt.org/strings'
        extension-element-prefixes="str"
	version='1.0'
	>
<!--

Author:
	Pierre Lindenbaum PhD
	plindenbaum@yahoo.fr

Motivation:
	Delicous To HTML
	curl "https://api.del.icio.us/v1/posts/all?tag=todraw"

-->
<xsl:output method="html" />


<xsl:variable name="numposts" select="count(/posts/post)"/>


<xsl:template match="/">
<html><body>
<xsl:apply-templates/>
</body></html>
</xsl:template>


<xsl:template match="posts">
<div>
<h1><xsl:value-of select="@tag"/></h1>
<xsl:apply-templates select="post"/>
</div>
</xsl:template>

<xsl:template match="post">
<xsl:message terminate="no"> <xsl:value-of select="count(preceding-sibling::*)+1"/> / <xsl:value-of select="$numposts"/></xsl:message>
<p><b><xsl:value-of select="@description"/></b> : <a>
	<xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
<xsl:value-of select="@href"/></a> (<xsl:value-of select="@time"/>)






<xsl:if test=" starts-with(@href,'http://www.flickr.com/photos/') or  starts-with(@href,'https://www.flickr.com/photos/')">
<xsl:variable name="u2" select="substring-before(substring-after(substring-after(@href,'/photos/'),'/'),'/')"/>
<xsl:if test="string-length($u2) &gt;0">
<a  target="_blank">
	<xsl:attribute name="href">https://delicious.com/lindenb/search/<xsl:value-of select="$u2"/></xsl:attribute>
<xsl:text>[delicious] </xsl:text>
</a>
</xsl:if>
</xsl:if>

<xsl:if test=" starts-with(@href,'http://500px.com/photo/')">
<xsl:variable name="u2" select="substring-before(substring-after(@href,'/photo/'),'/')"/>
<xsl:if test="string-length($u2) &gt;0">
<a  target="_blank">
	<xsl:attribute name="href">https://delicious.com/lindenb/search/<xsl:value-of select="$u2"/></xsl:attribute>
<xsl:text>[delicious] </xsl:text>
</a>
</xsl:if>
</xsl:if>

</p>
<xsl:apply-templates/>

</xsl:template>



<xsl:template match="photo" mode="rsp">
<div>
<xsl:text> by </xsl:text>

<xsl:value-of select="owner/@username"/>
<xsl:text> / </xsl:text>
<xsl:value-of select="owner/@realname"/>
<br/>
<a>
<xsl:attribute name="href">
<xsl:value-of select="concat('http://www.flickr.com/photos/',owner/@nsid,'/',@id)"/>
</xsl:attribute>
<img width="75px" height="75px">
<xsl:attribute name="title"><xsl:value-of select="title"/></xsl:attribute>
<xsl:attribute name="src">
<xsl:value-of select="concat('http://farm',@farm,'.staticflickr.com/',@server,'/',@id,'_',@secret,'_s.jpg')"/>
</xsl:attribute>
</img>
</a>
<br/>
</div>
</xsl:template>

</xsl:stylesheet>

