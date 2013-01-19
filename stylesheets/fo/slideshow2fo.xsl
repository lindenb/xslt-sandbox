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
         width="{$pagewidth}px" height="{$pageheight}px" background-color="white"
         >
         <fo:block text-align="center" font-family="Helvectica, Arial, sans-serif" font-size="8pt">
      <xsl:apply-templates/>
       </fo:block>
         
         <fo:block/>
       </fo:block-container>
   </fo:flow>
 </fo:page-sequence>
</xsl:template>

<xsl:template match="sl:slide[count(*)=3 and sl:title]">
<xsl:variable name="margin" select="number(20)"/>
<xsl:variable name="nodesbuttitle" select="./*[not(self::sl:title)]"/>
<xsl:variable name="width" select=" ( number($pagewidth) - ( (count($nodesbuttitle)+1)*$margin ) ) div count($nodesbuttitle) "/>

<fo:page-sequence master-reference="main">
   <fo:flow flow-name="xsl-region-body">
   	<xsl:call-template name="archetype.onetitle">
   		<xsl:with-param name="pageX" select="$margin"/>
   		<xsl:with-param name="pageY" select="$margin"/>
   		<xsl:with-param name="pageWidth" select="number($pagewidth ) - 2.0 * $margin"/>
   		<xsl:with-param name="pageHeight" select="number(100)"/>
   		<xsl:with-param name="node" select="sl:title"/>
   	</xsl:call-template>
   	
   	
   	<xsl:for-each select="$nodesbuttitle">
		<xsl:variable name="recX" select="$margin + (position() - 1) * $width"/>
		<xsl:variable name="recY" select="number(100) + $margin"/>
		<xsl:variable name="recWidth" select="$width - number($margin)"/>
		<xsl:variable name="recHeight" select="number($pageheight) - (number(100) + 2.0 * $margin)"/>
   		<xsl:choose>
   			<xsl:when test="local-name(.)='pre'">
		   		<xsl:call-template name="archetype.pre">
			   		<xsl:with-param name="pageX" select="$recX"/>
			   		<xsl:with-param name="pageY" select="$recY"/>
			   		<xsl:with-param name="pageWidth" select="$recWidth"/>
			   		<xsl:with-param name="pageHeight" select="$recHeight"/>
			   		<xsl:with-param name="node" select="."/>
			   	</xsl:call-template>
	   		</xsl:when>
	   		<xsl:when test="local-name(.)='image'">
		   		<xsl:call-template name="archetype.oneimage">
			   		<xsl:with-param name="pageX" select="$recX"/>
			   		<xsl:with-param name="pageY" select="$recY"/>
			   		<xsl:with-param name="pageWidth" select="$recWidth"/>
			   		<xsl:with-param name="pageHeight" select="$recHeight"/>
			   		<xsl:with-param name="node" select="."/>
			   	</xsl:call-template>
	   		</xsl:when>
	   	</xsl:choose>
   	</xsl:for-each>
   </fo:flow>
 </fo:page-sequence>
</xsl:template>

<xsl:template match="sl:slide[count(*)=1 and sl:title]">
<xsl:variable name="fontH" select="number(72)"/>
<fo:page-sequence master-reference="main">
   <fo:flow flow-name="xsl-region-body">
   	<xsl:call-template name="archetype.onetitle">
   		<xsl:with-param name="pageX" select="number(0)"/>
   		<xsl:with-param name="pageY" select="number(0)"/>
   		<xsl:with-param name="pageWidth" select="number($pagewidth )"/>
   		<xsl:with-param name="pageHeight" select="number($pageheight )"/>
   		<xsl:with-param name="node" select="sl:title"/>
   	</xsl:call-template>
   </fo:flow>
 </fo:page-sequence>
</xsl:template>

<xsl:template match="sl:slide[count(*)=1 and sl:image]">
<xsl:variable name="margin" select="number(20)"/>
<fo:page-sequence master-reference="main">
   <fo:flow flow-name="xsl-region-body">
	<xsl:call-template name="archetype.oneimage">
   		<xsl:with-param name="pageX" select="number($margin)"/>
   		<xsl:with-param name="pageY" select="number($margin)"/>
   		<xsl:with-param name="pageWidth" select="number($pagewidth ) - 2 * $margin"/>
   		<xsl:with-param name="pageHeight" select="number($pageheight ) - 2 * $margin"/>
   		<xsl:with-param name="node" select="sl:image"/>
   	</xsl:call-template>
   </fo:flow>
 </fo:page-sequence>
</xsl:template>

<xsl:template match="sl:slide[count(*)=1 and sl:pre]">

<xsl:variable name="margin" select="number(20)"/>
<fo:page-sequence master-reference="main">
   <fo:flow flow-name="xsl-region-body">
       <xsl:call-template name="archetype.pre">
   		<xsl:with-param name="pageX" select="$margin"/>
   		<xsl:with-param name="pageY" select="$margin"/>
   		<xsl:with-param name="pageWidth" select="number($pagewidth) - 2 * $margin"/>
   		<xsl:with-param name="pageHeight" select="number($pageheight) - $margin * 2.0 "/>
   		<xsl:with-param name="node" select="sl:pre"/>
   	</xsl:call-template>
   </fo:flow>
 </fo:page-sequence>
</xsl:template>


<xsl:template name="archetype.pre">
<xsl:param name="pageX"/>
<xsl:param name="pageY"/>
<xsl:param name="pageWidth"/>
<xsl:param name="pageHeight"/>
<xsl:param name="node"/>

<xsl:variable name="fontH">
	<xsl:choose>
	 	<xsl:when test="$node/@font-size"><xsl:value-of select="number($node/@font-size)"/></xsl:when>
	 	<xsl:otherwise><xsl:value-of select="number(42)"/></xsl:otherwise>
	 </xsl:choose>
</xsl:variable>

<fo:block-container
         absolute-position="fixed"
         left="{$pageX}px"
         top="{$pageY}px"
         width="{$pageWidth}px"
         height="{$pageHeight}px"
         background-color="lightgray"
         font-size="{$fontH}pt"
         >
         <fo:block
          text-align="left"
          font-family="monospace"
       	  linefeed-treatment="preserve"
          white-space-treatment="preserve"
          white-space-collapse="false"
          wrap-option="no-wrap "
          >
       	<xsl:apply-templates/>
       </fo:block>
       </fo:block-container>
</xsl:template>

<xsl:template name="archetype.oneimage">
<xsl:param name="pageX"/>
<xsl:param name="pageY"/>
<xsl:param name="pageWidth"/>
<xsl:param name="pageHeight"/>
<xsl:param name="node"/>

<xsl:variable name="url">
   <xsl:value-of select="concat('url(&quot;',$node/@href,'&quot;)')"/>
</xsl:variable>


<xsl:variable name="imageWidth">
	<xsl:choose>
	 	<xsl:when test="$node/@width"><xsl:value-of select="number($node/@width)"/></xsl:when>
	 	<xsl:when test="$node/@height"><xsl:value-of select="number($node/@height)"/></xsl:when>
	 	<xsl:otherwise><xsl:value-of select="number(100)"/></xsl:otherwise>
	 </xsl:choose>
</xsl:variable>

<xsl:variable name="imageHeight">
	<xsl:choose>
		<xsl:when test="$node/@height"><xsl:value-of select="number($node/@height)"/></xsl:when>
	 	<xsl:when test="$node/@width"><xsl:value-of select="number($node/@width)"/></xsl:when>
	 	<xsl:otherwise><xsl:value-of select="$imageWidth"/></xsl:otherwise>
	 </xsl:choose>
</xsl:variable>

<fo:block-container absolute-position="fixed">
<xsl:attribute name="width"><xsl:value-of select="concat($pageWidth,'px')"/></xsl:attribute>
<xsl:attribute name="height"><xsl:value-of select="concat($pageHeight,'px')"/></xsl:attribute>
 <xsl:choose>
  	<xsl:when test="$imageWidth &gt; $imageHeight">
  		<xsl:variable name="ratio" select="$pageWidth div $imageWidth"/>
  		<xsl:variable name="w" select="$pageWidth"/>
  		<xsl:variable name="h" select="$imageHeight * $ratio"/>
  		
		<xsl:attribute name="left"><xsl:value-of select="concat($pageX,'px')"/></xsl:attribute>
  		<xsl:attribute name="top"><xsl:value-of select="concat($pageY + ( $pageHeight - $h ) div 2.0,'px')"/></xsl:attribute>
		 <fo:block>
		  <fo:external-graphic  scaling="uniform" content-width="scale-to-fit" content-height="scale-to-fit" >
		   <xsl:attribute name="src"><xsl:value-of select="$url"/></xsl:attribute>
  		   <xsl:attribute name="width"><xsl:value-of select="concat($w,'px')"/></xsl:attribute>
  		   <xsl:attribute name="height"><xsl:value-of select="concat($h,'px')"/></xsl:attribute>
	  	  </fo:external-graphic>
		</fo:block>

  	</xsl:when>
  	<xsl:otherwise>
  		<xsl:variable name="ratio" select="$pageHeight div $imageHeight"/>
  		<xsl:variable name="h" select="number($pageheight)"/>
  		<xsl:variable name="w" select="$imageWidth * $ratio"/>
  		
		<xsl:attribute name="top"><xsl:value-of select="concat($pageY,'px')"/></xsl:attribute>
  		<xsl:attribute name="left"><xsl:value-of select="concat($pageX + ( $pageWidth - $w ) div 2.0,'px')"/></xsl:attribute>
		 <fo:block>
		  <fo:external-graphic  scaling="uniform" content-width="scale-to-fit" content-height="scale-to-fit" >
		   <xsl:attribute name="src"><xsl:value-of select="$url"/></xsl:attribute>
  		   <xsl:attribute name="width"><xsl:value-of select="concat($w,'px')"/></xsl:attribute>
  		   <xsl:attribute name="height"><xsl:value-of select="concat($h,'px')"/></xsl:attribute>
	  	  </fo:external-graphic>
		</fo:block>
  	</xsl:otherwise>
  </xsl:choose>
</fo:block-container>
</xsl:template>


<!-- =============================================================================== -->

<xsl:template name="archetype.onetitle">
<xsl:param name="pageX"/>
<xsl:param name="pageY"/>
<xsl:param name="pageWidth"/>
<xsl:param name="pageHeight"/>
<xsl:param name="node"/>
<xsl:variable name="fontH">
	<xsl:choose>
	 	<xsl:when test="$node/@font-size"><xsl:value-of select="number($node/@font-size)"/></xsl:when>
	 	<xsl:otherwise><xsl:value-of select="number(36)"/></xsl:otherwise>
	 </xsl:choose>
</xsl:variable>

	<fo:block-container
	 absolute-position="fixed"
	 top="{$pageY + $pageHeight div 2.0 - $fontH div 2.0 }px"
	 left="{$pageX}px"
	 width="{$pageWidth}px"
	 height="{$pageHeight}px" 
	 >
	 <fo:block text-align="center" font-size="{$fontH}pt" >
	 	<xsl:attribute name="font-family">
		 	<xsl:choose>
			 	<xsl:when test="$node/@font-family"><xsl:value-of select="$node/@font-family"/></xsl:when>
			 	<xsl:otherwise>Helvectica, Arial, sans-serif</xsl:otherwise>
			 </xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="text-align">
		 	<xsl:choose>
			 	<xsl:when test="$node/@center"><xsl:value-of select="$node/@center"/></xsl:when>
			 	<xsl:otherwise>center</xsl:otherwise>
			 </xsl:choose>
		</xsl:attribute>
		<xsl:apply-templates select="$node"/>
	</fo:block>
	</fo:block-container>

</xsl:template>

</xsl:stylesheet>
