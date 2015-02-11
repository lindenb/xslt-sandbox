<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>

<xsl:template name="titleize">
 <xsl:param name="s"/>
 <xsl:call-template name="touppercase">
   <xsl:with-param name="s" select="substring($s,1,1)"/>
 </xsl:call-template>
 <xsl:value-of select="substring($s,2)"/>
</xsl:template>


</xsl:stylesheet>
