<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>

<xsl:template match="@*|*|text()" mode="quote.sql">
<xsl:text>&apos;</xsl:text>
<xsl:call-template name="escape.sql">
  <xsl:with-param name="s" select="."/>
</xsl:call-template>
<xsl:text>&apos;</xsl:text>
</xsl:template>

<xsl:template name="escape.sql">
<xsl:param name="s"/>
<xsl:variable name="apostrophe">&apos;</xsl:variable>
<xsl:choose>
<xsl:when test="contains($s,$apostrophe)">
	<xsl:value-of select="substring-before($s,$apostrophe)"/>
	<xsl:text>&apos;&apos;</xsl:text>
	<xsl:call-template name="escape.sql">
	  <xsl:with-param name="s" select="substring-after($s,$apostrophe)"/>
	</xsl:call-template>
</xsl:when>
<xsl:otherwise>
 <xsl:value-of select="$s"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
