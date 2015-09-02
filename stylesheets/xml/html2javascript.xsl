<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns="http://www.w3.org/1999/xhtml"
	version='1.0'
	>

<xsl:output method="text" />


<xsl:template match="/">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="*" mode="var">
<xsl:value-of select="concat(name(.),'_',generate-id(.))"/>
</xsl:template>

<xsl:template match="td|th|a|i|b|u|div|span|li|caption">var <xsl:apply-templates select="." mode="var"/>= document.createElement("<xsl:value-of select="name(.)"/>");
<xsl:if test="count(ancestor::*)&gt;0"><xsl:apply-templates select=".." mode="var"/>.appendChild(<xsl:apply-templates select="." mode="var"/>);
</xsl:if>
<xsl:apply-templates select="@*"/>
<xsl:apply-templates select="*|text()"/>
</xsl:template>

<xsl:template match="table|thead|tr|tbody|ul|ol|embed|object|param">var <xsl:apply-templates select="." mode="var"/>= document.createElement("<xsl:value-of select="name(.)"/>");
<xsl:if test="count(ancestor::*)&gt;0"><xsl:apply-templates select=".." mode="var"/>.appendChild(<xsl:apply-templates select="." mode="var"/>);
</xsl:if>
<xsl:apply-templates select="@*"/>
<xsl:apply-templates select="*"/>
</xsl:template>


<xsl:template match="@*">
<xsl:apply-templates select=".." mode="var"/>.setAttribute("<xsl:call-template name="escape">
   <xsl:with-param name="s">
      <xsl:value-of select="name(.)"/>
   </xsl:with-param>
</xsl:call-template>","<xsl:call-template name="escape">
   <xsl:with-param name="s">
      <xsl:value-of select="."/>
   </xsl:with-param>
</xsl:call-template>");
</xsl:template>

<xsl:template match="text()">
<xsl:apply-templates select=".." mode="var"/>.appendChild(document.createTextNode("<xsl:call-template name="escape">
   <xsl:with-param name="s">
      <xsl:value-of select="."/>
   </xsl:with-param>
</xsl:call-template>"));
</xsl:template>


<xsl:template name="escape">
<xsl:param name="s"/><xsl:variable name="c"><xsl:value-of select="substring($s,1,1)"/></xsl:variable>
<xsl:choose>
 <xsl:when test="$c='&#xA;'">\n</xsl:when>
 <xsl:when test='$c="&#39;"'>\'</xsl:when>
 <xsl:when test="$c='&#34;'">\"</xsl:when>
 <xsl:when test="$c='\'">\\</xsl:when>
 <xsl:otherwise><xsl:value-of select="$c"/></xsl:otherwise>
</xsl:choose><xsl:if test="string-length($s) &gt;1"><xsl:call-template name="escape">
<xsl:with-param name="s"><xsl:value-of select="substring($s,2,string-length($s)-1)"/></xsl:with-param>
</xsl:call-template></xsl:if>
</xsl:template>


</xsl:stylesheet>

