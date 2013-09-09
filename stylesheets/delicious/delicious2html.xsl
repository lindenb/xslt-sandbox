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
<xsl:param name="flickr_api_key"></xsl:param>

<xsl:variable name="numposts" select="count(/posts/post)"/>


<xsl:template match="/">
<html><body>
<xsl:apply-templates/>
</body></html>
</xsl:template>


<xsl:template match="posts">
<div>
<h1><xsl:value-of select="@tag"/></h1>
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="post">
<xsl:message terminate="no"> <xsl:value-of select="count(preceding-sibling::*)+1"/> / <xsl:value-of select="$numposts"/></xsl:message>
<p><b><xsl:value-of select="@description"/></b> : <a>
	<xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
<xsl:value-of select="@href"/></a> (<xsl:value-of select="@time"/>)<xsl:if test="string-length($flickr_api_key) &gt;0 and starts-with(@href,'http://www.flickr.com/photos/')">

<a>
<xsl:attribute name="href"><xsl:value-of select="concat('https://api.delicious.com/v1/posts/add?shared=no&amp;replace=true&amp;tags=drawn&amp;url=',str:encode-uri(@href,true()),'&amp;extended=',str:encode-uri(@extended,true()),'&amp;description=',str:encode-uri(@description,true()))"/></xsl:attribute>
[drawn]
</a>

<a>
<xsl:attribute name="href"><xsl:value-of select="concat('https://api.delicious.com/v1/posts/delete?url=',str:encode-uri(@href,true()))"/></xsl:attribute>
[delete]
</a>


<xsl:variable name="u2" select="substring-before(substring-after(substring-after(@href,'/photos/'),'/'),'/')"/>

<xsl:if test="string-length($u2) &gt;0">
<xsl:variable name="u3" select="concat('http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&amp;api_key=',$flickr_api_key,'&amp;format=rest&amp;photo_id=',$u2)"/>
<xsl:message terminate="no"><xsl:value-of select="$u3"/></xsl:message>
<xsl:apply-templates select="document($u3)/rsp/photo" mode="rsp"/>
</xsl:if>
</xsl:if></p>
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

