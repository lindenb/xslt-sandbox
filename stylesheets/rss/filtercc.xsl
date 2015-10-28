<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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

<xsl:template match="item">
<xsl:variable name="fromda" select="starts-with(../link/text(),'http://www.deviantart.com/')"/>
<xsl:variable name="license" select="creativeCommons:license/text()"/>
<xsl:choose>
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
