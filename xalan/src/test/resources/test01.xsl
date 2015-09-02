<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        version='1.0'
        xmlns:xalan="http://xml.apache.org/xalan"
        xmlns:img="xalan://com.github.lindenb.xslt.img.Image"
        exclude-result-prefixes="xalan img"
        >
<xsl:output method="html" />

<xsl:template match="/">
<html><body>
<xsl:for-each select="//img">

<xsl:variable name="i" select="img:info(@src,'scale(100%,50%);flip-vertical')"/>
<img>
    <xsl:attribute name="title"><xsl:value-of select="$i/@title"/></xsl:attribute>
	<xsl:attribute name="width"><xsl:value-of select="$i/@width"/></xsl:attribute>
	<xsl:attribute name="height"><xsl:value-of select="$i/@height"/></xsl:attribute>
	<xsl:attribute name="src">data:image/<xsl:value-of select="$i/@format"/>;base64,<xsl:value-of select="$i/@base64"/></xsl:attribute>
</img>
</xsl:for-each>
</body></html>
</xsl:template>



</xsl:stylesheet>
