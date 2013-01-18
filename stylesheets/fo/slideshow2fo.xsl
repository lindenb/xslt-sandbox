<?xml version="1.0"?>
<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:sl="https://github.com/lindenb/xslt-sandbox/tree/master/stylesheets/fo/slide/"
  >
<!--

Motivation:
	slideshow using XSL-FO
Author:
	Pierre Lindenbaum PhD 
WWW:
	http://plindenbaum.blogspot.com
Mail:
         plindenbaum@yahoo.fr
Usage:


-->
<xsl:import href="xhtml2fo.xsl"/>

<xsl:output method="xml"
	version="1.0"
	encoding="UTF-8" indent="yes"
	
	/>



<xsl:variable name="pagewidth" select="number(1200)"/>
<xsl:variable name="pageheight" select="number(840)"/>


<xsl:template match="/">
<xsl:apply-templates select="sl:slideshow"/>
</xsl:template>


<xsl:template match="sl:slideshow">
<fo:root>
<xsl:comment>Created with slideshow2fo Pierre Lindenbaum http://plindenbaum.blogspot.com.</xsl:comment>
 <fo:layout-master-set>

  <fo:simple-page-master master-name="main"
	margin-top="1px"
	margin-bottom="1px"
	margin-left="1px"
	margin-right="1px"
	page-width="{$pagewidth}px"
	page-height="{$pageheight}px"
	>
   <fo:region-body	   
	font-family="Helvetica"
	margin-bottom="0px"
	margin-right="0px"
	background-color="white"
   	/>
  </fo:simple-page-master>
 </fo:layout-master-set>
 <xsl:apply-templates select="sl:slide"/>
</fo:root>
</xsl:template>


<xsl:template match="sl:slide">
<fo:page-sequence master-reference="main">
   <fo:flow flow-name="xsl-region-body">
       <fo:block-container
         absolute-position="fixed" top="0px" left="0px"
         width="{$pagewidth}px" height="{$pageheight}px" background-color="yellow"
         >
         <fo:block text-align="center" font-family="Helvectica, Arial, sans-serif" font-size="8pt">
       EMPTY
       </fo:block>
         
         <fo:block/>
       </fo:block-container>
   </fo:flow>
 </fo:page-sequence>
</xsl:template>

<xsl:template match="sl:slide[count(*)=1 and sl:title]">
<xsl:variable name="fontH" select="number(72)"/>
<fo:page-sequence master-reference="main">
   <fo:flow flow-name="xsl-region-body">
       <fo:block-container
         absolute-position="fixed"
         top="{$pageheight div 2.0 - $fontH div 2.0 }px"
         left="0px"
         width="{$pagewidth}px"
         height="{$pageheight}px" 
         >
         <fo:block text-align="center" font-family="Helvectica, Arial, sans-serif" font-size="{$fontH}pt" >
       <xsl:apply-templates/>
       </fo:block>
       </fo:block-container>
   </fo:flow>
 </fo:page-sequence>
</xsl:template>

<xsl:template match="sl:slide[count(*)=1 and sl:image]">
<xsl:variable name="url">
   <xsl:value-of select="concat('url(&quot;',sl:image/@href,'&quot;)')"/>
</xsl:variable>
<fo:page-sequence master-reference="main">
   <fo:flow flow-name="xsl-region-body">
       
          <xsl:attribute name="src"><xsl:value-of select="$url"/></xsl:attribute>
	    <xsl:choose>
	  	<xsl:when test="number(sl:image/@width)>number(sl:image/@height)">
	  		<xsl:variable name="ratio" select="number($pagewidth) div number(sl:image/@width)"/>
	  		<xsl:variable name="w" select="number($pagewidth)"/>
	  		<xsl:variable name="h" select="number(sl:image/@height) * $ratio"/>
	  		<fo:block-container
			 absolute-position="fixed"
			 width="{$pagewidth}px"
			 height="{$pageheight}px" 
			 >
	  		<xsl:attribute name="left">0px</xsl:attribute>
	  		<xsl:attribute name="top"><xsl:value-of select="concat( ( $pageheight - $h ) div 2.0,'px')"/></xsl:attribute>
			 <fo:block>
			  <fo:external-graphic  scaling="uniform" content-width="scale-to-fit" content-height="scale-to-fit" >
			   <xsl:attribute name="src"><xsl:value-of select="$url"/></xsl:attribute>
	  		<xsl:attribute name="width"><xsl:value-of select="concat($w,'px')"/></xsl:attribute>
	  		<xsl:attribute name="height"><xsl:value-of select="concat($h,'px')"/></xsl:attribute>
		  	  </fo:external-graphic>
			</fo:block>
			</fo:block-container>
	  	</xsl:when>
	  	<xsl:otherwise>
	  		 <xsl:variable name="ratio" select="number($pageheight) div number(sl:image/@height)"/>
	  		<xsl:variable name="h" select="number($pageheight)"/>
	  		<xsl:variable name="w" select="number(sl:image/@width) * $ratio"/>
	  		<fo:block-container
			 absolute-position="fixed"
			 width="{$pagewidth}px"
			 height="{$pageheight}px" 
			 >
			<xsl:attribute name="top">0px</xsl:attribute>
	  		<xsl:attribute name="left"><xsl:value-of select="concat( ( $pagewidth - $w ) div 2.0,'px')"/></xsl:attribute>
			 <fo:block>
			  <fo:external-graphic  scaling="uniform" content-width="scale-to-fit" content-height="scale-to-fit" >
			   <xsl:attribute name="src"><xsl:value-of select="$url"/></xsl:attribute>
	  		   <xsl:attribute name="width"><xsl:value-of select="concat($w,'px')"/></xsl:attribute>
	  		   <xsl:attribute name="height"><xsl:value-of select="concat($h,'px')"/></xsl:attribute>
		  	  </fo:external-graphic>
			</fo:block>
			</fo:block-container>
	  	</xsl:otherwise>
	  </xsl:choose>
	  
       
   </fo:flow>
 </fo:page-sequence>
</xsl:template>

<xsl:template match="sl:slide[count(*)=1 and sl:pre]">
<xsl:variable name="fontH" select="number(42)"/>
<xsl:variable name="margin" select="number(20)"/>
<fo:page-sequence master-reference="main">
   <fo:flow flow-name="xsl-region-body">
       <fo:block-container
         absolute-position="fixed"
         top="{$margin}px"
         left="{$margin}px"
         width="{$pagewidth - 2 * $margin }px"
         height="{$pageheight - $margin * 2.0 }px"
         background-color="lightgray"
         >
         <fo:block
          text-align="left"
          font-family="monospace"
          font-size="{$fontH}pt"
       	  linefeed-treatment="preserve"
          white-space-treatment="preserve"
          white-space-collapse="false"
          wrap-option="no-wrap "
          >   
       	<xsl:apply-templates/>
       </fo:block>
       </fo:block-container>
   </fo:flow>
 </fo:page-sequence>
</xsl:template>


</xsl:stylesheet>
