<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:x="http://exslt.org/dates-and-times"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="x"
	version="1.0">

<xsl:variable name="now">
<xsl:value-of select="x:year()"/>
<xsl:if test="number(x:month-in-year())&lt;10">0</xsl:if>
<xsl:value-of select="x:month-in-year()"/>
<xsl:if test="number(x:day-in-month())&lt;10">0</xsl:if>
<xsl:value-of select="x:day-in-month()"/>
<xsl:if test="number(x:hour-in-day())&lt;10">0</xsl:if>
<xsl:value-of select="x:hour-in-day()"/>
<xsl:if test="number(x:minute-in-hour())&lt;10">0</xsl:if>
<xsl:value-of select="x:minute-in-hour()"/>
</xsl:variable>

<xsl:variable name="today">
  <xsl:value-of select="x:day-in-month()"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="x:month-name()"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="x:year()"/>
</xsl:variable>

<xsl:template name="my-links">
    <div>
	<a href="https://www.instagram.com/yokofakun/">Instagram</a>
	<xsl:text> </xsl:text>
	<a href="http://tyeul.tumblr.com/">Tumblr</a>
	<xsl:text> </xsl:text>
	<a href="http://yokofakun.deviantart.com/">DeviantArt</a>
	<xsl:text> </xsl:text>
	<a href="https://www.facebook.com/kakaheska">Facebook</a>
	<xsl:text> </xsl:text>
	<a href="https://www.flickr.com/photos/lindenb/">Flickr</a>
	<xsl:text> </xsl:text>
	<a href="http://www.pinterest.com/yokofakun/drawings/">Pinterest</a>
    </div>
</xsl:template>


<xsl:variable name="commontags">drawing sketch illustration gimp onedrawingaday portrait dessin femme fille art retrato face visage artwork draw sketchaday dailydrawing sketch_daily<xsl:if test="number(x:month-in-year())=10"> inktober inktober<xsl:value-of select="x:year()"/></xsl:if></xsl:variable>

</xsl:stylesheet>
