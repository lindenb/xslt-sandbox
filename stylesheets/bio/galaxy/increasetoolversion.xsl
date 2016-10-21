<?xml version="1.0" encoding="UTF-8"?>
<!-- this stylesheet increase the micro version of a galaxy tool/@version attribute .e.g: "0.0.1" = "0.0.2" -->
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	>
<xsl:output method="xml" encoding="UTF-8"  indent="no" />

<xsl:template match="/">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*">
<xsl:copy select="."/>
</xsl:template>


<xsl:template match="*">
<xsl:copy select=".">
<xsl:apply-templates select="@*"/>
<xsl:apply-templates select="*|text()"/>
</xsl:copy>
</xsl:template>


<xsl:template match="tool[@version]">
<xsl:copy select=".">
<xsl:apply-templates select="@*[name(.)!='version']"/>
<xsl:variable name="v0" select="@version"/>
<xsl:attribute name="version">
	<xsl:choose>
		<xsl:when test="contains($v0,'.')">
			<xsl:variable name="v1" select="substring-after($v0,'.')"/>
			<xsl:choose>
				<xsl:when test="contains($v1,'.')">
					<xsl:variable name="v2" select="substring-after($v1,'.')"/>
					<xsl:choose>
						<xsl:when test="number($v2)&gt;=0"><xsl:value-of select="substring-before($v0,'.')"/>.<xsl:value-of select="substring-before($v1,'.')"/>.<xsl:value-of select="number($v2) + 1"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="number($v0)"/></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$v0"/></xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise><xsl:value-of select="$v0"/></xsl:otherwise>
	</xsl:choose>
</xsl:attribute>

<xsl:apply-templates select="*|text()"/>
</xsl:copy>
</xsl:template>

</xsl:stylesheet>
