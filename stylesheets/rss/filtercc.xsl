<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:media="http://search.yahoo.com/mrss/"
	xmlns:creativeCommons="http://backend.userland.com/creativeCommonsRssModule"
	version="1.0">
<xsl:output method="xml"/>

<xsl:template match="/">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="atom:entry">
<xsl:choose>
<xsl:when test="starts-with(atom:link[@rel='alternate']/@href,'http://www.flickr.com/photos/')">
<xsl:variable name="license" select="atom:link[@rel='license']/@href"/>
<xsl:choose>
	<xsl:when test="
		starts-with($license,'https://creativecommons.org/') and (
                $license = 'https://creativecommons.org/publicdomain/zero/1.0/deed.fr' or
		contains($license ,'/by/') or
		contains($license ,'/by-nc/') or
		contains($license ,'/by-nc-sa/') or
		contains($license ,'/by-sa/')
		)">
		<atom:entry>
			<xsl:apply-templates select="@*|node()"/>
		</atom:entry>
	</xsl:when>
	<xsl:otherwise>
		<xsl:comment>filtered out <xsl:value-of select="$license"/> </xsl:comment>
	</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
                <atom:entry>
                        <xsl:apply-templates select="@*|node()"/>
                </atom:entry>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="item">
<xsl:variable name="fromda" select="starts-with(../link/text(),'http://www.deviantart.com/')"/>
<xsl:variable name="license" select="creativeCommons:license/text()"/>
<xsl:choose>
	<xsl:when test="starts-with(media:category,'resources/stockart/')">
		<item>
			<xsl:apply-templates select="@*|node()"/>
		</item>
	</xsl:when>
	<xsl:when test="$fromda and ( (starts-with($license,'http://creativecommons.org/') and  contains($license,'-nd') ) or not(creativeCommons:license) )">
		<xsl:comment>filtered out <xsl:value-of select="link"/> </xsl:comment>
	</xsl:when>
	<xsl:otherwise>
		<item>
			<xsl:apply-templates select="@*|node()"/>
		</item>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
