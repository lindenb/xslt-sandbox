<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
 version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:date="http://exslt.org/dates-and-times" 
 xmlns:dc="http://purl.org/dc/elements/1.1/"
 >


<!--

#!/bin/sh
APIKEY=12345678910
TAGS=`echo ${QUERY_STRING}|tr "?&" "\n" | egrep '^tags=' | cut -d '=' -f 2 | sed 's/,/%2C/g'`
TEXT=`echo ${QUERY_STRING}|tr "?&" "\n" | egrep '^text=' | cut -d '=' -f 2 | tr " " "+"`

echo "Content-Type: application/rss+xml"
echo 

curl  -s "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=${APIKEY}&tags=${TAGS}&format=rest&extras=url_s,date_upload,date_taken,icon_server,owner_name&tag_mode=all&per_page=20&license=2,4,1,5,7&text=${TEXT}" |
xsltproc -\-novalid -\-stringparam title "${TAGS} ${TEXT}" flickr2rss.xsl -

-->



<xsl:output method='xml' indent="yes" encoding="UTF-8"/>

<xsl:param name="title">No Title</xsl:param>


<xsl:template match="/">
<rss version="2.0"

	    >
	<channel>

		<title><xsl:value-of select="$title"/></title>
		<link>http://www.flickr.com</link>
 		<description><xsl:value-of select="$title"/></description>
		<pubDate><xsl:value-of select="date:date-time()"/></pubDate>
		<lastBuildDate><xsl:value-of select="date:date-time()"/></lastBuildDate>
		<generator>http://www.flickr.com/</generator>
	<xsl:apply-templates select="rsp/photos/photo"/>
	</channel>
</rss>
</xsl:template>

  <xsl:template match="photo">
    <item>
      <title><xsl:value-of select="@title"/> : <xsl:value-of select="$title"/></title>
      <link>http://www.flickr.com/photos/<xsl:value-of select="@owner"/>/<xsl:value-of select="@id"/>/</link>
      <pubDate><xsl:value-of select="@datetaken"/></pubDate>
	
      <author>
	<xsl:choose>
		<xsl:when test="@ownername"><xsl:value-of select="@ownername"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="@owner"/></xsl:otherwise>
	</xsl:choose>
       </author>
      <guid isPermaLink="false">http://www.flickr.com/photos/<xsl:value-of select="@owner"/>/<xsl:value-of select="@id"/>/</guid>
      <description>
	<xsl:text>&lt;p&gt;&lt;img </xsl:text>
	<xsl:choose>
		<xsl:when test="@height_s and @width_s">
			<xsl:text> width='</xsl:text>
			<xsl:value-of select="@width_s"/>
			<xsl:text>' height='</xsl:text>
			<xsl:value-of select="@height_s"/>
			<xsl:text>' </xsl:text>
		</xsl:when>
		<xsl:when test="@height_m and @width_m">
			<xsl:text> width='</xsl:text>
			<xsl:value-of select="@width_m"/>
			<xsl:text>' height='</xsl:text>
			<xsl:value-of select="@height_m"/>
			<xsl:text>' </xsl:text>
		</xsl:when>
	</xsl:choose>
	<xsl:text> src='</xsl:text>
		<xsl:choose>
			<xsl:when test="@url_s"><xsl:value-of select="@url_s"/></xsl:when>
			<xsl:otherwise>http://farm<xsl:value-of select="@farm"/>.staticflickr.com/<xsl:value-of select="@server"/>/<xsl:value-of select="@id"/>_<xsl:value-of select="@secret"/>_s.jpg</xsl:otherwise>
		</xsl:choose>
	<xsl:text>' /&gt;&lt;/p&gt;</xsl:text>
      </description>
    </item>
  </xsl:template>

</xsl:stylesheet>
