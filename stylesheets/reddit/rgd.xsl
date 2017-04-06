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
<xsl:value-of select="$commontags"/> redditgetsdrawn rgd
<xsl:text>

</xsl:text>
<xsl:value-of select="translate($commontags,' ',',')"/>,redditgetsdrawn,rgd
<xsl:text>

My drawing PASTEURL 

[IG](https://www.instagram.com/yokofakun/)|[TU](http://tyeul.tumblr.com/)|[DA](http://yokofakun.deviantart.com/)|[FB](https://www.facebook.com/kakaheska)|[PT](http://www.pinterest.com/yokofakun/drawings/)

</xsl:text>




</xsl:template>


</xsl:stylesheet>
