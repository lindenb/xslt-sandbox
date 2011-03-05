<?xml version="1.0"?>
<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  >
<!--

Motivation:
	transforms twitter status to XSL-FO
Author:
	Pierre Lindenbaum PhD 
WWW:
	http://plindenbaum.blogspot.com
Mail:
         plindenbaum@yahoo.fr
Usage:
        curl "http://api.twitter.com/1/statuses/show/[status-id].xml" > status.xml
        fop  -xml status.xml -xsl mysql2fo.xsl -pdf result.pdf

-->


<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

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
<fo:root>
<xsl:comment>Created with twitter2fo Pierre Lindenbaum http://plindenbaum.blogspot.com from tweet ID: <xsl:value-of select="id"/></xsl:comment>
 <fo:layout-master-set>

  <fo:simple-page-master master-name="main"
	margin-top="1px"
	margin-bottom="1px"
	margin-left="1px"
	margin-right="1px"
	page-width="980pt"
	page-height="615pt"
	>
   <xsl:element name="fo:region-body">
      <xsl:attribute name="font-family">Helvetica</xsl:attribute>
      <xsl:attribute name="margin-bottom">0px</xsl:attribute>
      <xsl:attribute name="margin-right">0px</xsl:attribute>
      <xsl:attribute name="background-color">
         <xsl:apply-templates select="user/profile_background_color"/>
      </xsl:attribute>
      <xsl:attribute name="color">
         <xsl:apply-templates select="user/profile_text_color"/>
      </xsl:attribute>
      
      <xsl:if test="user/profile_background_image_url and string-length(user/profile_background_image_url)&gt;0 and user/profile_use_background_image='true'">
               <xsl:attribute name="background-position-horizontal">left</xsl:attribute>
               <xsl:attribute name="background-position-vertical">top</xsl:attribute>
               <xsl:apply-templates select="user/profile_background_tile"/>
               <xsl:attribute name="background-image">
                  <xsl:apply-templates select="user/profile_background_image_url"/>
               </xsl:attribute>
       </xsl:if>
      
   </xsl:element>
  </fo:simple-page-master>
 </fo:layout-master-set>

 <fo:page-sequence master-reference="main">
   <xsl:element name="fo:flow">
      <xsl:attribute name="flow-name">xsl-region-body</xsl:attribute>

       <xsl:comment>white area</xsl:comment>
       <fo:block-container
         absolute-position="fixed" top="140px" left="140px"
         width="700px" height="333px" background-color="white"
         >
         <fo:block/>
       </fo:block-container>

      <xsl:apply-templates select="user/profile_image_url"/>
      <xsl:apply-templates select="user/screen_name"/>
      <xsl:apply-templates select="user/name"/>
      <xsl:apply-templates select="created_at"/>
      <xsl:apply-templates select="text"/>
   </xsl:element>
 </fo:page-sequence>

</fo:root>
</xsl:template>
<!-- =================================================================== -->
<xsl:template match="text">
<xsl:variable name="color">
   <xsl:apply-templates select="../user/profile_text_color"/>
</xsl:variable>
 <fo:block-container
         absolute-position="fixed"
         left="230px" top="250px" right="230px"
         
         background-color="white"
         
         >
       <fo:block font-size="30px" color="{$color}">
      <xsl:value-of select="normalize-space(text())"/>
      </fo:block>
      </fo:block-container>
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
  <xsl:attribute name="background-repeat">
      <xsl:choose>
         <xsl:when test="text() = 'false' ">
            <xsl:text>no-repeat</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>repeat</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:attribute>
</xsl:template>
<!-- =================================================================== -->
<xsl:template match="profile_image_url">
<xsl:variable name="url">
   <xsl:value-of select="concat('url(&quot;',text(),'&quot;)')"/>
</xsl:variable>
<xsl:comment>User's icon</xsl:comment>
<fo:block-container
         absolute-position="fixed"
         left="230px" top="190px"
         width="48px" height="48px"
         background-image="{$url}"
         >
       <fo:block/>
</fo:block-container>
</xsl:template>
<!-- =================================================================== -->
<xsl:template match="name">
<xsl:variable name="color">
   <xsl:apply-templates select="../profile_text_color"/>
</xsl:variable>
<xsl:comment>User name</xsl:comment>
<fo:block-container
         absolute-position="fixed"
         left="290px" top="220px"
         right="230px"
         color="{$color}"
         background-color="white"
         >
       <fo:block font-size="16px">
         <xsl:choose>
            <xsl:when test="../url and string-length(../url)&gt;0">
                <xsl:element name="fo:basic-link">
                  <xsl:attribute name="external-destination">
                     <xsl:value-of select="../url"/>
                  </xsl:attribute>
                  <xsl:attribute name="color">
                     <xsl:apply-templates select="../profile_link_color"/>
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
       </fo:block>
</fo:block-container>
</xsl:template>

<!-- =================================================================== -->
<xsl:template match="screen_name">
<xsl:variable name="color">
   <xsl:apply-templates select="../profile_text_color"/>
</xsl:variable>
<xsl:comment>Screen name</xsl:comment>
<fo:block-container
         absolute-position="fixed"
         left="290px" top="190px"
         right="230px"
         color="{$color}"
         background-color="white"
         >
       <fo:block font-size="28px">
         <xsl:element name="fo:basic-link">
            <xsl:attribute name="external-destination">
               <xsl:value-of select="concat('http://twitter.com/#!/',text())"/>
            </xsl:attribute>
            <xsl:attribute name="color">
               <xsl:apply-templates select="../profile_link_color"/>
            </xsl:attribute>
             <fo:inline font-weight="bold" font-family="Helvetica">
            <xsl:value-of select="concat('@',text())"/>
            </fo:inline>
         </xsl:element>
       </fo:block>
</fo:block-container>
</xsl:template>

<!-- =================================================================== -->
<xsl:template match="created_at">
<xsl:variable name="color">
   <xsl:apply-templates select="../user/profile_text_color"/>
</xsl:variable>
<xsl:comment>Creation date</xsl:comment>
<fo:block-container
         absolute-position="fixed"
         left="230px" top="430px"
         right="230px" 
         background-color="white"
         color="{$color}"
         >
       <fo:block font-size="22px">
         <xsl:element name="fo:basic-link">
            <xsl:attribute name="external-destination">
               <xsl:value-of select="concat('http://twitter.com/#!/',../user/screen_name,'/status/',../id)"/>
            </xsl:attribute>
            <xsl:attribute name="color">
               <xsl:apply-templates select="../user/profile_link_color"/>
            </xsl:attribute>
            <xsl:value-of select="text()"/>
         </xsl:element>
       </fo:block>
</fo:block-container>
</xsl:template>



</xsl:stylesheet>
