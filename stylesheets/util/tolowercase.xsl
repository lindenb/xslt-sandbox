<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>

<xsl:template name="tolowercase">
 <xsl:param name="s"/>
 <xsl:value-of select="translate($s,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
</xsl:template>

</xsl:stylesheet>
