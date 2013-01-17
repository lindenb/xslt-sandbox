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
  >
<xsl:include href="../../ooffice/openoffice.part.xsl"/>

<xsl:output method="text" version="1.0" encoding="UTF-8" />

<xsl:param name="out.dir">tmp.dir</xsl:param>

<xsl:template match="/">
<xsl:document href="{$out.dir}/Makefile" method="text">
<xsl:text>#Makefile
.PHONY=all unzip
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
	Configurations2/toolbar \
	

all:
	$(foreach D,$(empty.dirs),mkdir -p $(D);)
	</xsl:text><xsl:call-template name="make.thumbnail"/><xsl:text>
	mkdir -p Configurations2/accelerator
	touch Configurations2/accelerator/current.xml
	zip -u slides.odp \
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
		
</xsl:text>		
</xsl:document>
 
<xsl:document href="{$out.dir}/META-INF/manifest.xml" method="xml"> 
<xsl:call-template name="make.metainf.manifest.odp"/>
</xsl:document>

<xsl:document href="{$out.dir}/content.xml" method="xml" indent="yes">
<xsl:apply-templates select="PubmedArticleSet" mode="oodoc"/>
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

<xsl:template match="PubmedArticleSet" mode="oodoc">
<office:document-content office:version="1.2">
  <office:body>
    <office:presentation>
    	<xsl:apply-templates select="PubmedArticle" mode="oodoc"/>
     </office:presentation>
  </office:body>
</office:document-content>
</xsl:template>   
    
<xsl:template match="PubmedArticle" mode="oodoc">
      <draw:page draw:master-page-name="">
        <draw:frame presentation:style-name="" svg:width="25.199cm"
          svg:height="3.506cm" svg:x="1.4cm" svg:y="0.837cm" presentation:class="title">
          <draw:text-box>
            <text:p><xsl:value-of select="MedlineCitation/Article/ArticleTitle"/></text:p>
          </draw:text-box>
        </draw:frame>
        <draw:frame presentation:style-name="" svg:width="24.639cm"
          svg:height="12.178cm" svg:x="1.4cm" svg:y="4.914cm" presentation:class="subtitle">
          <draw:text-box>
            <text:p><xsl:value-of select="MedlineCitation/Article/Journal/Title"/></text:p>
          </draw:text-box>
        </draw:frame>
      </draw:page>
</xsl:template> 


</xsl:stylesheet>
