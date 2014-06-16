<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:x="http://exslt.org/dates-and-times"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="x"
	version="1.1">
  <xsl:output method="html" omit-xml-declaration="yes" indent="no"/>
  <!--

Usage:
	xsltproc photo2html.xsl "http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=123&photo_id=1234&format=rest"

-->
  <xsl:template>
    <xsl:apply-templates select="rsp"/>
  </xsl:template>
  <xsl:template match="rsp">
    <xsl:if test="@stat!='ok'">
      <xsl:message terminate="yes">ERROR in XML <xsl:value-of select="err/@msg"/></xsl:message>
    </xsl:if>
    <xsl:apply-templates select="photo"/>
  </xsl:template>
  <xsl:template match="photo">
    <xsl:variable name="u">
      <xsl:value-of select="concat('http://www.flickr.com/photos/',owner/@nsid,'/',@id)"/>
    </xsl:variable>
    <div>
      <xsl:text>Source: </xsl:text>
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="$u"/>
        </xsl:attribute>
        <xsl:if test="string-length(normalize-space(title))&gt;0">
          <xsl:attribute name="title">
            <xsl:value-of select="title"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space(title))=0">
            <xsl:text>flickr</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="title"/>
            <xsl:text>"</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <xsl:text> by </xsl:text>
      <xsl:apply-templates select="owner"/>
      <xsl:text>. </xsl:text>
      <i>
        <xsl:text>(</xsl:text>
        <xsl:choose>
          <xsl:when test="@license='0'">All Rights Reserved</xsl:when>
          <xsl:when test="@license='4'">
            <a href="http://creativecommons.org/licenses/by/2.0/">Attribution License</a>
          </xsl:when>
          <xsl:when test="@license='6'">
            <a href="http://creativecommons.org/licenses/by-nd/2.0/">Attribution-NoDerivs License</a>
          </xsl:when>
          <xsl:when test="@license='3'">
            <a href="http://creativecommons.org/licenses/by-nc-nd/2.0/">Attribution-NonCommercial-NoDerivs License</a>
          </xsl:when>
          <xsl:when test="@license='2'">
            <a href="http://creativecommons.org/licenses/by-nc/2.0/">Attribution-NonCommercial License</a>
          </xsl:when>
          <xsl:when test="@license='1'">
            <a href="http://creativecommons.org/licenses/by-nc-sa/2.0/">Attribution-NonCommercial-ShareAlike License</a>
          </xsl:when>
          <xsl:when test="@license='5'">
            <a href="http://creativecommons.org/licenses/by-sa/2.0/">Attribution-ShareAlike License</a>
          </xsl:when>
          <xsl:when test="@license='7'">
            <a href="http://www.flickr.com/commons/usage/">No known copyright restrictions</a>
          </xsl:when>
          <xsl:when test="@license='8'">
            <a href="http://www.usa.gov/copyright.shtml">United States Government Work</a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@license"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>). </xsl:text>
        
        
      <xsl:value-of select="x:month-name()"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="x:day-in-month()"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="x:year()"/>
      <xsl:text>.</xsl:text>
      </i>
   </div>
<xsl:text>



</xsl:text>
<xsl:variable name="commontags">drawing sketch illustration gimp onedrawingaday portrait dessin femme fille art retrato face visage artwork</xsl:variable>
<xsl:comment>Common tags

<xsl:value-of select="$commontags"/>
<xsl:text>

</xsl:text>
<xsl:value-of select="translate($commontags,' ',',')"/>
<xsl:text>

</xsl:text>
</xsl:comment>

  </xsl:template>
  <xsl:template match="owner">
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="concat('http://www.flickr.com/people/',@nsid)"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="@nsid='78799297@N00'">
          <xsl:text>@homingpigen</xsl:text>
        </xsl:when>
        <xsl:when test="@nsid='71475737@N00'">
          <xsl:text>@malloreigh</xsl:text>
        </xsl:when>
         <xsl:when test="@nsid='95269120@N00'">
          <xsl:text>@gusgreeper</xsl:text>
        </xsl:when>
        <xsl:when test="@nsid='7706223@N02'">
          <xsl:text>@lu_lu</xsl:text>
        </xsl:when>
        <xsl:when test="@nsid='47864451@N00'">
          <xsl:text>@wigglewarily</xsl:text>
        </xsl:when>
         <xsl:when test="@nsid='65391539@N03'">
          <xsl:text>@Abitha_Arabella</xsl:text>
        </xsl:when>
         <xsl:when test="@nsid='41619721@N02'">
          <xsl:text>@ivanavasilj</xsl:text>
        </xsl:when>
        <xsl:when test="@nsid='46567414@N00'">
	  <xsl:text>@keoshi</xsl:text>
	</xsl:when>
        <xsl:when test="@username='todo'">
	  <xsl:text>@skinnyghost</xsl:text>
	</xsl:when>
	<xsl:when test="@username='emurray'">
	  <xsl:text>@ericmurray</xsl:text>
	</xsl:when>

	 <xsl:when test="@nsid='11536382@N03'">
		<xsl:text>@superchill</xsl:text>
	</xsl:when>

        <xsl:when test="string-length(@realname)&gt;0">
          <xsl:value-of select="@realname"/>
        </xsl:when>
        <xsl:when test="string-length(@username)&gt;0">
          <xsl:value-of select="@username"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@nsid"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
