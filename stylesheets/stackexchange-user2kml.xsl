<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns='http://www.opengis.net/kml/2.2'
	xmlns:h="http://www.w3.org/1999/xhtml"
	xmlns:x="http://exslt.org/dates-and-times"
        version='1.0'
        >
<xsl:output method="xml" indent="yes" cdata-section-elements="description"/>
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Params:
   * anonymous
   * title
Usage :
   xsltproc -\-stringparam title BioStar  stackexchange-user2kml.xsl Users.xml

-->
<xsl:param name="anonymous">false</xsl:param>
<xsl:param name="title">StackExchange-Users</xsl:param>
<xsl:template match="/">
<kml>
<Document>
<name>
   <xsl:value-of select="$title"/>
   <xsl:if test="$anonymous!='false'">
      <xsl:text> (anonymized)</xsl:text>
   </xsl:if>
   <xsl:if test="function-available('x:date-time')">
       <xsl:text> </xsl:text>
        <xsl:value-of select="x:date-time()"/>
   </xsl:if>
</name>
<xsl:apply-templates select="Users"/>
</Document>
</kml>
</xsl:template>

<xsl:template match="Users">
<xsl:for-each select="row[LastLoginIP]"><!-- for limit: [position()&gt;0 and position()&lt;2] -->
<xsl:sort data-type="number" order="descending" select="Reputation"/>
<xsl:apply-templates select="."/>
</xsl:for-each>
</xsl:template>


<xsl:template match="row">
<xsl:element name="Placemark">
  <xsl:variable name="desc">
   <xsl:text>&lt;h3&gt;</xsl:text>
      <xsl:value-of select="DisplayName"/>
   <xsl:text>&lt;/h3&gt;</xsl:text>
   <xsl:text>&lt;dl&gt;</xsl:text>
      <xsl:apply-templates select="Reputation"/>
      <xsl:apply-templates select="CreationDate"/>
      <xsl:apply-templates select="RealName"/>
      <xsl:apply-templates select="WebsiteUrl"/>
      <xsl:apply-templates select="Email"/>
   <xsl:text>&lt;/dl&gt;</xsl:text>
  </xsl:variable>
  <xsl:choose>
   <xsl:when test="$anonymous='false'">
      <name><xsl:value-of select="DisplayName"/></name>
      <description><xsl:value-of select="$desc"/></description>
   </xsl:when>
   <xsl:otherwise>
      <name><xsl:value-of select="generate-id(.)"/></name>
      <description><xsl:value-of select="generate-id(.)"/></description>
   </xsl:otherwise>
 </xsl:choose>
 <TimeStamp>
   <when><xsl:value-of select="CreationDate"/></when>
 </TimeStamp>
   <xsl:variable name="url" select="concat('http://freegeoip.appspot.com/xml/',LastLoginIP)"/>
   <xsl:message terminate="no">Downloading <xsl:value-of select="$url"/> ...</xsl:message>
   <xsl:apply-templates select="document($url,/Response)" mode="geo"/>
</xsl:element>
</xsl:template>

<xsl:template match="Response" mode="geo">
   <Point>
      <coordinates>
	<xsl:value-of select="Longitude"/>
	<xsl:text>,</xsl:text>
	<xsl:value-of select="Latitude"/>
       </coordinates>
    </Point>
</xsl:template>

<xsl:template match="Email">
<xsl:text>&lt;dt&gt;</xsl:text>
<xsl:text>Mail</xsl:text>
<xsl:text>&lt;/dt&gt;</xsl:text>
<xsl:text>&lt;dd&gt;</xsl:text>
<xsl:text>&lt;a href=&apos;</xsl:text>
<xsl:value-of select="concat('mailto:',.)"/>
<xsl:text>&apos;&gt;</xsl:text>
<xsl:value-of select="."/>
<xsl:text>&lt;/a&gt;</xsl:text>
<xsl:text>&lt;/dd&gt;</xsl:text>
</xsl:template>




<xsl:template match="WebsiteUrl">
<xsl:text>&lt;dt&gt;</xsl:text>
<xsl:text>WWW</xsl:text>
<xsl:text>&lt;/dt&gt;</xsl:text>
<xsl:text>&lt;dd&gt;</xsl:text>
<xsl:text>&lt;a href=&apos;</xsl:text>
<xsl:value-of select="."/>
<xsl:text>&apos;&gt;</xsl:text>
<xsl:value-of select="."/>
<xsl:text>&lt;/a&gt;</xsl:text>
<xsl:text>&lt;/dd&gt;</xsl:text>
</xsl:template>

<xsl:template match="Reputation|CreationDate|RealName">
<xsl:text>&lt;dt&gt;</xsl:text>
<xsl:value-of select="name(.)"/>
<xsl:text>&lt;/dt&gt;</xsl:text>
<xsl:text>&lt;dd&gt;</xsl:text>
<xsl:value-of select="."/>
<xsl:text>&lt;/dd&gt;</xsl:text>
</xsl:template>

</xsl:stylesheet>

