<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        version='1.0'
        xmlns:xalan="http://xml.apache.org/xalan"
        xmlns:str="xalan://com.github.lindenb.xslt.strings.Strings"
        exclude-result-prefixes="xalan str"
        >
<xsl:output method="text" />

<xsl:template match="/">
<xsl:for-each select="//c">

<xsl:choose>
<xsl:when test="str:strcmp(s1,s2) &lt; 0">
	xalan:<xsl:value-of select="s1"/> &lt; <xsl:value-of select="s2"/>;
</xsl:when>
<xsl:when test="str:strcmp(s1,s2) &gt; 0">
	xalan:<xsl:value-of select="s2"/> &lt; <xsl:value-of select="s1"/>;
</xsl:when>
<xsl:otherwise>
	xalan:ERROR;
</xsl:otherwise>
</xsl:choose>


<xsl:choose>
<xsl:when test="s1/text() &lt; s2/text()">
	native:<xsl:value-of select="s1"/> &lt; <xsl:value-of select="s2"/>;
</xsl:when>
<xsl:when test="s2/text() &lt; s1/text()">
	native:<xsl:value-of select="s2"/> &lt; <xsl:value-of select="s1"/>;
</xsl:when>
<xsl:otherwise>
	native:ERROR;
</xsl:otherwise>
</xsl:choose>


</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
