<?xml version="1.0"?>
<xsl:stylesheet 
  version="1.0" 
  xmlns:fo="http://www."
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  >
<!--

Motivation:
	transforms twitter status to HTML
Author:
	Pierre Lindenbaum PhD 
WWW:
	http://plindenbaum.blogspot.com
Mail:
         plindenbaum@yahoo.fr
Usage:
        curl "http://api.twitter.com/1/statuses/show/[status-id].xml" > status.xml
        xsltproc status2html.xsl status.xml

-->


<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" />

<xsl:template match="/">
<xsl:apply-templates select="status|hash"/>
</xsl:template>

<xsl:template match="hash">
<xsl:message terminate="yes">
   <xsl:value-of select="request"/>
   <xsl:text> </xsl:text>
   <xsl:value-of select="error"/>
</xsl:message>
</xsl:template>

<xsl:template match="status">
<html>
<head>
<xsl:comment>Created with twitter2html Pierre Lindenbaum http://plindenbaum.blogspot.com from tweet ID: <xsl:value-of select="id"/></xsl:comment>
<title>
<xsl:value-of select="concat('Tweet ID.',id)"/>
</title>
</head>
<body style="background-color:black;margin:5px;">
<xsl:element name="div">
<xsl:attribute name="style">
<xsl:text>padding:10px;background-color:</xsl:text>
<xsl:apply-templates select="user/profile_background_color"/>
<xsl:text>;</xsl:text>

<xsl:text>color:</xsl:text>
   <xsl:apply-templates select="user/profile_text_color"/>
<xsl:text>;</xsl:text>


<xsl:if test="user/profile_background_image_url and string-length(user/profile_background_image_url)&gt;0 and user/profile_use_background_image='true'">
<xsl:text>background-position:50% 50%;</xsl:text>

 <xsl:apply-templates select="user/profile_background_tile"/>

<xsl:text>background-image:</xsl:text>
   <xsl:apply-templates select="user/profile_background_image_url"/>
<xsl:text>;</xsl:text>
</xsl:if>

</xsl:attribute>

<xsl:element name="div">
      <xsl:attribute name="style">border-radius:15px;-moz-border-radius: 15px;margin-left:auto;margin-right:auto;
width:400px;height:233px;background-color:white; border: 1px solid black;margin-top:30px;margin-bottom:30px;padding:15px;
      </xsl:attribute>
      <div style="position:relative;">
       <xsl:apply-templates select="user/profile_image_url"/>
       <xsl:apply-templates select="user/screen_name"/>
       <xsl:apply-templates select="user/name"/>
       <xsl:apply-templates select="text"/>
       <xsl:apply-templates select="created_at"/>
      </div>
</xsl:element>
      
</xsl:element>
</body>
</html>
</xsl:template>
<!-- =================================================================== -->
<xsl:template match="text">
<xsl:variable name="color">
   <xsl:apply-templates select="../user/profile_text_color"/>
</xsl:variable>
<xsl:element name="div">
<xsl:attribute name="style">
<xsl:text>font-size:28px;position:absolute;background-color:white;left:9px;top:72px;color:</xsl:text>
<xsl:value-of select="$color"/>
<xsl:text>;</xsl:text>
</xsl:attribute>
<xsl:value-of select="normalize-space(text())"/>
</xsl:element>
</xsl:template>
<!-- =================================================================== -->
<xsl:template match="profile_background_color|profile_text_color|profile_link_color|profile_text_color">
   <xsl:value-of select="concat('#',.)"/>
</xsl:template>
<!-- =================================================================== -->
<xsl:template match="profile_background_image_url">
   <xsl:value-of select="concat('url(&quot;',.,'&quot;)')"/>
</xsl:template>
<!-- =================================================================== -->
<xsl:template match="profile_background_tile">
  <xsl:text>background-repeat:</xsl:text>
      <xsl:choose>
         <xsl:when test="text() = 'false' ">
            <xsl:text>no-repeat</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>repeat</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:text>;</xsl:text>
</xsl:template>
<!-- =================================================================== -->
<xsl:template match="profile_image_url">
<xsl:variable name="url">
   <xsl:value-of select="concat('url(&quot;',text(),'&quot;)')"/>
</xsl:variable>
<xsl:comment>User's icon</xsl:comment>
<xsl:element name="div">
<xsl:attribute name="style">
<xsl:text>clear:right;position:relative;left=5px;top:5px;width:48px;height:48px;background-image:</xsl:text>
<xsl:value-of select="$url"/>
<xsl:text>;</xsl:text>
</xsl:attribute>
</xsl:element>
</xsl:template>
<!-- =================================================================== -->
<xsl:template match="name">
<xsl:variable name="color">
   <xsl:apply-templates select="../profile_text_color"/>
</xsl:variable>
<xsl:comment>User name</xsl:comment>

<xsl:element name="div">
<xsl:attribute name="style">
<xsl:text>font-size:14px;position:absolute;left:60px;top:35px;</xsl:text>
</xsl:attribute>

   <xsl:choose>
      <xsl:when test="../url and string-length(../url)&gt;0">
            <xsl:element name="a">
            <xsl:attribute name="href">
               <xsl:value-of select="../url"/>
            </xsl:attribute>
            <xsl:attribute name="style">
               <xsl:text>color:</xsl:text>
               <xsl:apply-templates select="../profile_link_color"/>
               <xsl:text>;</xsl:text>
            </xsl:attribute>
               <xsl:value-of select="text()"/>
         </xsl:element>
      </xsl:when>
      <xsl:otherwise>
            <xsl:value-of select="text()"/>
      </xsl:otherwise>
   </xsl:choose>

    <xsl:if test="../location and string-length(../location)&gt;0">
            <xsl:text> , </xsl:text>
            <xsl:value-of select="../location"/>
    </xsl:if>

</xsl:element>


</xsl:template>

<!-- =================================================================== -->
<xsl:template match="screen_name">
<xsl:variable name="color">
   <xsl:apply-templates select="../profile_text_color"/>
</xsl:variable>
<xsl:comment>Screen name</xsl:comment>

<xsl:element name="div">
<xsl:attribute name="style">
<xsl:text>font-size:28px;position:absolute;left:60px;top:0px;</xsl:text>
</xsl:attribute>
 <xsl:element name="a">
   <xsl:attribute name="href">
      <xsl:value-of select="concat('http://twitter.com/#!/',text())"/>
   </xsl:attribute>
   <xsl:attribute name="color">
      <xsl:apply-templates select="../profile_link_color"/>
   </xsl:attribute>
   <xsl:value-of select="concat('@',text())"/>
</xsl:element>

</xsl:element>

</xsl:template>

<!-- =================================================================== -->
<xsl:template match="created_at">
<xsl:variable name="color">
   <xsl:apply-templates select="../user/profile_text_color"/>
</xsl:variable>
<xsl:comment>Creation date</xsl:comment>

<xsl:element name="div">
<xsl:attribute name="style">
<xsl:text>font-size:14px;position:absolute;left:0px;top:220px;</xsl:text>
</xsl:attribute>

   <xsl:element name="a">
      <xsl:attribute name="href">
         <xsl:value-of select="concat('http://twitter.com/#!/',../user/screen_name,'/status/',../id)"/>
      </xsl:attribute>
      <xsl:attribute name="style">
         <xsl:text>color:</xsl:text>
         <xsl:apply-templates select="../user/profile_link_color"/>
         <xsl:text>;</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="text()"/>
   </xsl:element>

</xsl:element>
</xsl:template>



</xsl:stylesheet>
