<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
 version="1.0"
 xmlns:PDBx="http://pdbml.pdb.org/schema/pdbx-v50.xsd"
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

<!-- array of atoms -->
<xsl:variable name="a_array" select="/PDBx:datablock/PDBx:atom_siteCategory/PDBx:atom_site"/>
<!-- number of atoms-->
<xsl:variable name="count"><xsl:value-of select="count($a_array)"/></xsl:variable>



<xsl:variable name="x_array" select="$a_array/PDBx:Cartn_x"/>
<xsl:variable name="y_array" select="$a_array/PDBx:Cartn_y"/>
<xsl:variable name="z_array" select="$a_array/PDBx:Cartn_z"/>


<xsl:variable name="min-x">
  <xsl:for-each select="$a_array/PDBx:Cartn_x">
    <xsl:sort select="." data-type="number" order="ascending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="." />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="max-x">
  <xsl:for-each select="$a_array/PDBx:Cartn_x">
    <xsl:sort select="." data-type="number" order="descending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="." />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="min-y">
  <xsl:for-each select="$a_array/PDBx:Cartn_y">
    <xsl:sort select="." data-type="number" order="ascending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="." />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="max-y">
  <xsl:for-each select="$a_array/PDBx:Cartn_y">
    <xsl:sort select="." data-type="number" order="descending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="." />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="min-z">
  <xsl:for-each select="$a_array/PDBx:Cartn_z">
    <xsl:sort select="." data-type="number" order="ascending" />
    <xsl:if test="position() = 1">
      <xsl:value-of select="." />
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="max-z">
  <xsl:for-each select="$a_array/PDBx:Cartn_z">
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
<xsl:apply-templates select="PDBx:datablock"/>
</xsl:template>



<xsl:template match="PDBx:datablock">
 <xsl:element name="svg:svg">
 <xsl:attribute name="version">1.0</xsl:attribute>
 <xsl:attribute name="width"><xsl:value-of select="$frame-width"/></xsl:attribute>
 <xsl:attribute name="height"><xsl:value-of select="$frame-height"/></xsl:attribute>
 <svg:title><xsl:value-of select="@datablockName"/></svg:title>
 <xsl:comment>
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

	<xsl:comment>BEGIN ATOMS</xsl:comment>
      <xsl:element name="svg:g">
      <xsl:apply-templates select="PDBx:atom_siteCategory/PDBx:atom_site"/>
	  </xsl:element>
	<xsl:comment>END ATOMS</xsl:comment>
	</xsl:element>


 </xsl:element><!-- svg -->
</xsl:template>

<xsl:template match="PDBx:atom_site">

  	<xsl:variable name="s"><xsl:value-of select="PDBx:auth_atom_id"/></xsl:variable>
  	
  	<xsl:element name="svg:use">
	
  	  <xsl:attribute name="xlink:href">#atom<xsl:choose>
		<xsl:when test="$s=&apos;o&apos; or $s=&apos;c&apos; or $s=&apos;h&apos;"><xsl:value-of select="$s"/></xsl:when>
		<xsl:otherwise>UN</xsl:otherwise>
		</xsl:choose></xsl:attribute>
  	  <xsl:attribute name="x"><xsl:call-template name="coord-x"><xsl:with-param name="atom" select="."/></xsl:call-template></xsl:attribute>
  	  <xsl:attribute name="y"><xsl:call-template name="coord-y"><xsl:with-param name="atom" select="."/></xsl:call-template></xsl:attribute>
	  <xsl:attribute name="title"><xsl:value-of select="$s"/></xsl:attribute>
  	</xsl:element>
  	
   
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
<xsl:param name="atom"/>
<xsl:variable name="x" select="$atom/PDBx:Cartn_x"/>
<xsl:value-of select="$margin + ($x - $min-x) * $scale"/>
</xsl:template>


<xsl:template name="coord-y">
<xsl:param name="atom"/>
<xsl:variable name="y" select="$atom/PDBx:Cartn_y"/>
<xsl:value-of select="$margin + ($y - $min-y) * $scale"/>
</xsl:template>



</xsl:stylesheet>
