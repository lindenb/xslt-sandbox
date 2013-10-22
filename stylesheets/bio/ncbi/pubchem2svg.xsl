<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
 version="1.0"
 xmlns:c="http://www.ncbi.nlm.nih.gov"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:svg="http://www.w3.org/2000/svg"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns:h="http://www.w3.org/1999/xhtml"
 >
 
 <!--

Motivation:
	transforms a pubchem xml result to SVG
Author
	Pierre Lindenbaum PhD plindenbaum@yahoo.fr
	http://plindenbaum.blogspot.com
Parameters:
	scale :=scale factor
	show-bounds := (true/false) 
	xradius := scale factor for atoms
-->

<!-- ========================================================================= -->
<xsl:output method='xml' indent='yes' omit-xml-declaration="no"/>

<!-- ========================================================================= -->
<!-- the margin of the SVG -->
<xsl:param name="margin">100</xsl:param>
<!-- the scale factor -->
<xsl:param name="scale">30</xsl:param>
<!-- the scale factor for atom radius-->
<xsl:param name="xradius">1</xsl:param>
<!-- show/hide bounds ? -->
<xsl:param name="show-bounds">true</xsl:param>


<!-- number of atoms-->
<xsl:variable name="count"><xsl:value-of select="count(/c:PC-Compound/c:PC-Compound_atoms/c:PC-Atoms/c:PC-Atoms_aid/c:PC-Atoms_aid_E)"/></xsl:variable>
<!-- number of bounds -->
<xsl:variable name="count-bounds"><xsl:value-of select="count(/c:PC-Compound/c:PC-Compound_bonds/c:PC-Bonds/c:PC-Bonds_aid1/c:PC-Bonds_aid1_E)"/></xsl:variable>

<!-- array of atoms -->
<xsl:variable name="a_array" select="/c:PC-Compound/c:PC-Compound_atoms/c:PC-Atoms/c:PC-Atoms_element"/>
<xsl:variable name="conformers" select="/c:PC-Compound/c:PC-Compound_coords/c:PC-Coordinates/c:PC-Coordinates_conformers/c:PC-Conformer"/>

<xsl:variable name="x_array" select="$conformers/c:PC-Conformer_x"/>
<xsl:variable name="y_array" select="$conformers/c:PC-Conformer_y"/>
<xsl:variable name="z_array" select="$conformers/c:PC-Conformer_z"/>

<!-- array of bound -->
<xsl:variable name="b_array" select="/c:PC-Compound/c:PC-Compound_bonds/c:PC-Bonds"/>
<xsl:variable name="bound1_array" select="$b_array/c:PC-Bonds_aid1"/>
<xsl:variable name="bound2_array" select="$b_array/c:PC-Bonds_aid2"/>
<xsl:variable name="link_array" select="$b_array/c:PC-Bonds_order"/>

<xsl:variable name="min-x">
  <xsl:for-each select="$x_array/c:PC-Conformer_x_E">
    <xsl:sort select="." data-type="number" order="ascending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="." />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="max-x">
  <xsl:for-each select="$x_array/c:PC-Conformer_x_E">
    <xsl:sort select="." data-type="number" order="descending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="." />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="min-y">
  <xsl:for-each select="$y_array/c:PC-Conformer_y_E">
    <xsl:sort select="." data-type="number" order="ascending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="." />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="max-y">
  <xsl:for-each select="$y_array/c:PC-Conformer_y_E">
    <xsl:sort select="." data-type="number" order="descending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="." />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="min-z">
  <xsl:for-each select="$z_array/c:PC-Conformer_z_E">
    <xsl:sort select="." data-type="number" order="ascending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="." />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="max-z">
  <xsl:for-each select="$z_array/c:PC-Conformer_z_E">
    <xsl:sort select="." data-type="number" order="descending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="." />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="length-x" select="$max-x - $min-x"/>
<xsl:variable name="length-y" select="$max-y - $min-y"/>
<xsl:variable name="length-z" select="$max-z - $min-z"/>


<xsl:variable name="frame-width" select="($margin * 2 )+ ($length-x * $scale)"/>
<xsl:variable name="frame-height" select="($margin * 2 )+ ($length-y * $scale)"/>

<xsl:template match="/">
<xsl:apply-templates select="c:PC-Compound"/>
</xsl:template>


<xsl:template match="c:PC-Compound">
 <xsl:element name="svg:svg">
 <xsl:attribute name="version">1.0</xsl:attribute>
 <xsl:attribute name="width"><xsl:value-of select="$frame-width"/></xsl:attribute>
 <xsl:attribute name="height"><xsl:value-of select="$frame-height"/></xsl:attribute>
 <svg:title><xsl:value-of select="c:PC-Compound_id/c:PC-CompoundType/c:PC-CompoundType_id/c:PC-CompoundType_id_cid"/></svg:title>
 <xsl:comment>
	Made with http://code.google.com/p/lindenb/source/browse/trunk/src/xsl/pubchem2svg.xsl 	
 	Author: Pierre Lindenbaum PhD plindenbaum@yahoo.fr
	http://plindenbaum.blogspot.com
</xsl:comment>
 
  <!-- DEFINITIONS -->
 <xsl:element name="svg:defs">
 
 <xsl:call-template name="gradient">
   <xsl:with-param name="gid">o</xsl:with-param>
   <xsl:with-param name="start">white</xsl:with-param>
   <xsl:with-param name="end">blue</xsl:with-param>
   <xsl:with-param name="r">18</xsl:with-param>
 </xsl:call-template>
 
 <xsl:call-template name="gradient">
   <xsl:with-param name="gid">c</xsl:with-param>
   <xsl:with-param name="start">white</xsl:with-param>
   <xsl:with-param name="end">black</xsl:with-param>
   <xsl:with-param name="r">16</xsl:with-param>
 </xsl:call-template> 
 
 <xsl:call-template name="gradient">
   <xsl:with-param name="gid">h</xsl:with-param>
   <xsl:with-param name="start">lightgray</xsl:with-param>
   <xsl:with-param name="end">gray</xsl:with-param>
   <xsl:with-param name="r">10</xsl:with-param>
 </xsl:call-template>
 
 <xsl:call-template name="gradient">
   <xsl:with-param name="gid">UN</xsl:with-param>
   <xsl:with-param name="start">green</xsl:with-param>
   <xsl:with-param name="end">red</xsl:with-param>
   <xsl:with-param name="r">10</xsl:with-param>
 </xsl:call-template>


  </xsl:element><!-- defs -->
 
<xsl:element name="svg:rect">
 <xsl:attribute name="style">stroke:lightgray;fill:white;</xsl:attribute>
 <xsl:attribute name="x">0</xsl:attribute>
 <xsl:attribute name="y">0</xsl:attribute>
 <xsl:attribute name="width"><xsl:value-of select="$frame-width - 1"/></xsl:attribute>
 <xsl:attribute name="height"><xsl:value-of select="$frame-height - 1"/></xsl:attribute>
</xsl:element>
	
	<xsl:element name="svg:g">

	<xsl:if test="$show-bounds = &apos;true&apos;">
	<xsl:comment>BEGIN BOUNDS</xsl:comment>
	  <xsl:element name="svg:g">
		<xsl:call-template name="bound">
			<xsl:with-param name="idx" select="1"/>
		</xsl:call-template>
	  </xsl:element>
	<xsl:comment>END BOUNDS</xsl:comment>
	</xsl:if>

	<xsl:comment>BEGIN ATOMS</xsl:comment>
	  <xsl:element name="svg:g">
		<xsl:call-template name="xyz">
			<xsl:with-param name="index" select="1"/>
		</xsl:call-template>
	  </xsl:element>
	<xsl:comment>END ATOMS</xsl:comment>
	</xsl:element>


 </xsl:element><!-- svg -->
</xsl:template>

<xsl:template name="xyz">
<xsl:param name="index" select="1"/>
  <xsl:if test="$index &lt;= $count">
  	<xsl:variable name="s"><xsl:value-of select="$a_array/c:PC-Element[$index]/@value"/></xsl:variable>
  	
  	<xsl:element name="svg:use">
	
  	  <xsl:attribute name="xlink:href">#atom<xsl:choose>
		<xsl:when test="$s=&apos;o&apos; or $s=&apos;c&apos; or $s=&apos;h&apos;"><xsl:value-of select="$s"/></xsl:when>
		<xsl:otherwise>UN</xsl:otherwise>
		</xsl:choose></xsl:attribute>
  	  <xsl:attribute name="x"><xsl:call-template name="coord-x"><xsl:with-param name="index" select="$index"/></xsl:call-template></xsl:attribute>
  	  <xsl:attribute name="y"><xsl:call-template name="coord-y"><xsl:with-param name="index" select="$index"/></xsl:call-template></xsl:attribute>
	  <xsl:attribute name="title"><xsl:value-of select="$s"/><xsl:text> </xsl:text><xsl:value-of select="$index"/></xsl:attribute>
  	</xsl:element>
  	
   	<xsl:call-template name="xyz">
 		<xsl:with-param name="index" select="1 + $index"/>
 	</xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template name="bound">
  <xsl:param name="idx"/>
  <xsl:if test="$idx &lt;= $count-bounds">
 
  	<xsl:element name="svg:line">

	<xsl:variable name="first"  select="number($bound1_array/c:PC-Bonds_aid1_E[$idx])"/>
	<xsl:variable name="second" select="number($bound2_array/c:PC-Bonds_aid2_E[$idx])"/>

	  <xsl:attribute name="style">stroke-linecap:butt;stroke:black;stroke-opacity:0.8;stroke-width:<xsl:value-of select="number($link_array/c:PC-BondType[$idx])*2"/>px;</xsl:attribute>
  	  <xsl:attribute name="x1"><xsl:call-template name="coord-x"><xsl:with-param name="index" select="$first"/></xsl:call-template></xsl:attribute>
  	  <xsl:attribute name="y1"><xsl:call-template name="coord-y"><xsl:with-param name="index" select="$first"/></xsl:call-template></xsl:attribute>
  	  <xsl:attribute name="x2"><xsl:call-template name="coord-x"><xsl:with-param name="index" select="$second"/></xsl:call-template></xsl:attribute>
  	  <xsl:attribute name="y2"><xsl:call-template name="coord-y"><xsl:with-param name="index" select="$second"/></xsl:call-template></xsl:attribute>
  	</xsl:element>
  	
   	<xsl:call-template name="bound">
 		<xsl:with-param name="idx" select="1 + $idx"/>
 	</xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template name="gradient">
<xsl:param name="gid">did</xsl:param>
<xsl:param name="start">rgb(200,200,200)</xsl:param>
<xsl:param name="end">rgb(0,0,255)</xsl:param>
<xsl:param name="r">0</xsl:param>
<xsl:element name="svg:radialGradient">
  <xsl:attribute name="id">radial<xsl:value-of select="$gid"/></xsl:attribute>
  <xsl:attribute name="cx">50%</xsl:attribute>
  <xsl:attribute name="cy">50%</xsl:attribute>
  <xsl:attribute name="r">50%</xsl:attribute>
  <xsl:attribute name="fx">30%</xsl:attribute>
  <xsl:attribute name="fy">30%</xsl:attribute>
  <xsl:element name="svg:stop">
  	<xsl:attribute name="offset">0%</xsl:attribute>
  	<xsl:attribute name="style">stop-color:<xsl:value-of select="$start"/>;stop-opacity:0.8;</xsl:attribute>
  </xsl:element>
  <xsl:element name="svg:stop">
  	<xsl:attribute name="offset">100%</xsl:attribute>
  	<xsl:attribute name="style">stop-color:<xsl:value-of select="$end"/>;stop-opacity:1;</xsl:attribute>
  </xsl:element>  
</xsl:element>


<xsl:element name="svg:circle">
	<xsl:attribute name="id">atom<xsl:value-of select="$gid"/></xsl:attribute>
	<xsl:attribute name="r"><xsl:value-of select="number($r) * $xradius"/></xsl:attribute>
	<xsl:attribute name="style">stroke:black;fill:url(#radial<xsl:value-of select="$gid"/>);</xsl:attribute>
</xsl:element>

</xsl:template>

<xsl:template name="coord-x">
<xsl:param name="index"/>
<xsl:variable name="x" select="$x_array/c:PC-Conformer_x_E[$index]"/>
<xsl:value-of select="$margin + ($x - $min-x) * $scale"/>
</xsl:template>


<xsl:template name="coord-y">
<xsl:param name="index"/>
<xsl:variable name="y" select="$y_array/c:PC-Conformer_y_E[$index]"/>
<xsl:value-of select="$margin + ($y - $min-y) * $scale"/>
</xsl:template>



</xsl:stylesheet>
