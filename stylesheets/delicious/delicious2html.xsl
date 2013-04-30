<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
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
<p><b><xsl:value-of select="@description"/></b> : <a>
	<xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
<xsl:value-of select="@href"/></a> (<xsl:value-of select="@time"/>)</p>
<xsl:apply-templates/>

</xsl:template>
</xsl:stylesheet>

