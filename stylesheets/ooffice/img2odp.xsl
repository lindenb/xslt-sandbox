<?xml version="1.0"?>
<xsl:stylesheet 
  version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
	xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
	xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
	xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0"
	xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
	xmlns:ooo="http://openoffice.org/2004/office"
	xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0"
	xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0"
	xmlns:grddl="http://www.w3.org/2003/g/data-view#"
	xmlns:officeooo="http://openoffice.org/2009/office"
	xmlns:drawooo="http://openoffice.org/2010/draw"
	xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:crypto="http://exslt.org/crypto"
  >
<xsl:include href="openoffice.part.xsl"/>

<xsl:output method="text" version="1.0" encoding="UTF-8" />

<xsl:param name="out.dir">tmp.dir</xsl:param>
<xsl:param name="pagewidth" select="number(30)"/>
<xsl:param name="pageheight" select="number(21)"/>

<xsl:template name="make.metainf.manifest.odp">
<manifest:manifest  manifest:version="1.2">
  <manifest:file-entry manifest:full-path="/" manifest:version="1.2" manifest:media-type="application/vnd.oasis.opendocument.presentation"/>
  <manifest:file-entry manifest:full-path="meta.xml" manifest:media-type="text/xml"/>
  <manifest:file-entry manifest:full-path="settings.xml" manifest:media-type="text/xml"/>
  <manifest:file-entry manifest:full-path="content.xml" manifest:media-type="text/xml"/>
  <manifest:file-entry manifest:full-path="Thumbnails/thumbnail.png" manifest:media-type="image/jpg"/>
  <manifest:file-entry manifest:full-path="Configurations2/accelerator/current.xml" manifest:media-type=""/>
  <manifest:file-entry manifest:full-path="Configurations2/" manifest:media-type="application/vnd.sun.xml.ui.configuration"/>
  <manifest:file-entry manifest:full-path="styles.xml" manifest:media-type="text/xml"/>
  <xsl:for-each select="//xhtml:img[@href]" >
   <manifest:file-entry manifest:media-type="image/png">
   	<xsl:attribute name="manifest:full-path">
   	<xsl:apply-templates select="." mode="filepath"/> 
   	</xsl:attribute>
   </manifest:file-entry>
  </xsl:for-each>
</manifest:manifest>
</xsl:template>


<xsl:template match="/">
<xsl:document href="{$out.dir}/Makefile" method="text">
#Makefile
.PHONY=all unzip images
IMAGES= 
empty.dirs= \
	Configurations2 \
	Configurations2/statusbar \
	Configurations2/toolpanel \
	Configurations2/menubar \
	Configurations2/floater \
	Configurations2/images \
	Configurations2/images/Bitmaps \
	Configurations2/progressbar \
	Configurations2/popupmenu \
	Configurations2/toolbar
	

all: ${IMAGES}
	$(MAKE) $(IMAGES)
	$(foreach D,$(empty.dirs),mkdir -p $(D);)
	mkdir -p Thumbnails
	<xsl:call-template name="make.thumbnail"/>
	mkdir -p Configurations2/accelerator
	touch Configurations2/accelerator/current.xml
	zip -u slides.odp \
		${IMAGES} \
		mimetype \
		meta.xml \
		settings.xml \
		content.xml \
		Thumbnails/thumbnail.png \
		$(empty.dirs) \
		Configurations2/accelerator/current.xml \
		styles.xml \
		META-INF/manifest.xml \
		
unzip: slides.odp
	unzip -o $&lt;
<xsl:apply-templates select="//xhtml:img[@width][@href][@height]" mode="make"/>		
	
</xsl:document>
 
<xsl:document href="{$out.dir}/META-INF/manifest.xml" method="xml"> 
<xsl:call-template name="make.metainf.manifest.odp"/>
</xsl:document>

<xsl:document href="{$out.dir}/content.xml" method="xml" indent="yes">
<xsl:apply-templates select="/" mode="oodoc"/>
</xsl:document>

<xsl:document href="{$out.dir}/meta.xml" method="xml"> 
<xsl:call-template name="make.document.meta"/>
</xsl:document>

<xsl:document href="{$out.dir}/settings.xml" method="xml"> 
<xsl:call-template name="make.settings"/>
</xsl:document>

<xsl:document href="{$out.dir}/styles.xml" method="xml"> 
<xsl:call-template name="make.styles"/>
</xsl:document>

<xsl:document href="{$out.dir}/mimetype" method="text"> 
<xsl:text>application/vnd.oasis.opendocument.presentation</xsl:text>
</xsl:document>



</xsl:template>

<xsl:template match="/" mode="oodoc">
<office:document-content office:version="1.2">
  <office:body>
    <office:presentation>
    	<xsl:apply-templates select="//xhtml:img" mode="oodoc"/>
     </office:presentation>
  </office:body>
</office:document-content>
</xsl:template>   
    
<xsl:template match="xhtml:img[@width][@href][@height]" mode="oodoc">
<xsl:variable name="filename" select="crypto:md5(@href)"/>
      <draw:page draw:master-page-name="">
        <draw:frame presentation:style-name=""
          svg:width="25.199cm"
          svg:height="3.506cm"
          svg:x="1.4cm"
          svg:y="0.837cm"
          presentation:class="title"
          >
          <xsl:choose>
          	<xsl:when test="number(@width)>number(@height)">
          		<xsl:variable name="ratio" select="number($pagewidth) div number(@width)"/>
          		<xsl:variable name="w" select="number($pagewidth)"/>
          		<xsl:variable name="h" select="number(@height) * $ratio"/>
          		<xsl:attribute name="svg:width"><xsl:value-of select="concat($w,'cm')"/></xsl:attribute>
          		<xsl:attribute name="svg:height"><xsl:value-of select="concat($h,'cm')"/></xsl:attribute>
          		<xsl:attribute name="svg:x">0cm</xsl:attribute>
          		<xsl:attribute name="svg:y"><xsl:value-of select="concat( ( $pageheight - $h ) div 2.0,'cm')"/></xsl:attribute>
          	</xsl:when>
          	<xsl:otherwise>
          		<xsl:variable name="ratio" select="number($pageheight) div number(@height)"/>
          		<xsl:variable name="h" select="number($pageheight)"/>
          		<xsl:variable name="w" select="number(@width) * $ratio"/>
          		<xsl:attribute name="svg:width"><xsl:value-of select="concat($w,'cm')"/></xsl:attribute>
          		<xsl:attribute name="svg:height"><xsl:value-of select="concat($h,'cm')"/></xsl:attribute>
          		<xsl:attribute name="svg:y">0cm</xsl:attribute>
          		<xsl:attribute name="svg:x"><xsl:value-of select="concat( ( $pagewidth - $w ) div 2.0,'cm')"/></xsl:attribute>
          	</xsl:otherwise>
          </xsl:choose>
          <draw:image xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
          	<xsl:attribute name="xlink:href">
          		<xsl:apply-templates select="." mode="filepath"/>
          	</xsl:attribute>
            <text:p><xsl:value-of select="@href"/></text:p>
          </draw:image>
        </draw:frame>
      </draw:page>
</xsl:template>


<xsl:template match="xhtml:img[@width][@href][@height]" mode="make">
IMAGES+=<xsl:apply-templates select="." mode="filepath"/> 
#
<xsl:apply-templates select="." mode="filepath"/> :
	mkdir -p $(dir $@) <xsl:choose>
	<xsl:when test="starts-with(@href,'http://')">
	curl -o $@ &quot;<xsl:value-of select="@href"/>&quot;
	</xsl:when>
	<xsl:otherwise>
	cp <xsl:value-of select="@href"/> $@
	</xsl:otherwise>
	</xsl:choose>

</xsl:template>

<xsl:template match="xhtml:img" mode="oodoc">
<xsl:message terminate="no">[WARNING] cannot one image (width/height/href...).</xsl:message>
</xsl:template>

<xsl:template match="xhtml:img[@href]" mode="filepath">
<xsl:variable name="extension">.jpg</xsl:variable>
<xsl:value-of select="concat('Pictures/',crypto:md5(@href),$extension)"/>
</xsl:template>


</xsl:stylesheet>
