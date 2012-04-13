<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.1'
	>

<xsl:template>
 <xsl:apply-templates select="rsp"/>
</xsl:template>


<xsl:template match="rsp">
  <xsl:choose>
    <xsl:when test="@stat='ok'">
      <xsl:apply-templates select="." mode="html"/>
    </xsl:when>
    <xsl:when test="err">
      <xsl:message>
        <xsl:text>start=&quot;</xsl:text>
         <xsl:value-of select="@stat"/>
         <xsl:text>&quot; </xsl:text>
      </xsl:message>
      <xsl:apply-templates select="err"/>
    </xsl:when>
    <xsl:otherwise>
    	<xsl:message terminate="yes">Error in tag &lt;rsp/&gt;</xsl:message>
    </xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="err">
  <xsl:message terminate="yes">
    <xsl:text>ERROR(</xsl:text>
    <xsl:value-of select="@code"/>
    <xsl:text>) &quot;</xsl:text>
    <xsl:value-of select="@msg"/>
    <xsl:text>&quot;
    </xsl:text>
  </xsl:message>
</xsl:template>

<xsl:template match="rsp" mode="html">
<html>
<body>
<xsl:apply-templates/>
</body>
</html>
</xsl:template>

<xsl:template match="photos">
<div>
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="photo">
<div>
<xsl:element name="a">
<xsl:attribute name="href"><xsl:apply-templates select="." mode="page.url"/></xsl:attribute>
<xsl:element name="img">
<xsl:attribute name="alt"><xsl:value-of select="@title"/></xsl:attribute>
<xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute>
<xsl:attribute name="src"><xsl:apply-templates select="." mode="source.url"/></xsl:attribute>
</xsl:element>
</xsl:element>
<br/>
<p>
<xsl:value-of select="@title"/>
<xsl:text> License:</xsl:text>
<xsl:value-of select="@license"/>
</p>
</div>
</xsl:template>



<xsl:template match="photo" mode="source.url">
<xsl:choose>
  <xsl:when test="@url_m">
  	<xsl:value-of select="@url_m"/>
  </xsl:when>
  <xsl:when test="@url_n">
  	<xsl:value-of select="@url_n"/>
  </xsl:when>
   <xsl:when test="@url_z">
  	<xsl:value-of select="@url_z"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="concat('http://farm',@farm,'.staticflickr.com/',@server,'/',@id,'_',@secret,'.jpg')"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="photo" mode="page.url">
  <xsl:value-of select="concat('http://www.flickr.com/photos/',@owner,'/',@id)"/>
</xsl:template>


</xsl:stylesheet>
