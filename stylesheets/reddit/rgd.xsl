<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        version='1.0'
        >
<xsl:import href="../util/mod.drawing.xsl"/>
 <xsl:output method="html" omit-xml-declaration="yes" indent="no"/>
  
<xsl:template match="/">
<xsl:text>

</xsl:text>
<xsl:value-of select="$now"/><xsl:text>

</xsl:text>

<div>Source: <a><xsl:attribute name="href"><xsl:value-of select="/html/head/link[@rel='shorturl']/@href"/></xsl:attribute><xsl:attribute name="title"><xsl:value-of select="/html/head/meta[@property='twitter:title']/@content"/></xsl:attribute>RGD</a>. (<i><xsl:value-of select="$today"/></i>)</div>
<xsl:call-template name="my-links"/>

<xsl:text>

</xsl:text>
<xsl:value-of select="$commontags"/> redditgetsdrawn
<xsl:text>

</xsl:text>
<xsl:value-of select="translate($commontags,' ',',')"/>,redditgetsdrawn
<xsl:text>

My drawing PASTEURL :  tracing, uni-pin &amp; uni-prockey markers, scanning, coloring with gimp. 
My sites : [tumblr](http://tyeul.tumblr.com/), [deviantart](http://yokofakun.deviantart.com/), [facebook](https://www.facebook.com/kakaheska), [flickr](https://www.flickr.com/photos/lindenb/), [pinterest](http://www.pinterest.com/yokofakun/drawings/) </xsl:text>



</xsl:template>


</xsl:stylesheet>
