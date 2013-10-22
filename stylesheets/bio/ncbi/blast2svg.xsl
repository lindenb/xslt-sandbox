<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
 version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:svg="http://www.w3.org/2000/svg"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns:h="http://www.w3.org/1999/xhtml"
 >
<!--

This stylesheet transforms a blast xml result to XHTML+SVG

Author: Pierre Lindenbaum PhD plindenbaum@yahoo.fr


-->
<!-- ========================================================================= -->
<xsl:output method='xml' indent='yes' omit-xml-declaration="no"/>
<!-- we preserve the spaces in that element -->
<xsl:preserve-space elements="svg:style h:style" />

<!-- ========================================================================= -->
<!-- the width of the SVG -->
<xsl:variable name="svg-width">800</xsl:variable>
<!-- height of a HSP -->
<xsl:variable name="hsp-height">10</xsl:variable>
<!-- total number of Hits in first blast iteration -->
<xsl:variable name="hit-count"><xsl:value-of select="count(BlastOutput/BlastOutput_iterations/Iteration[1]/Iteration_hits/Hit)"/></xsl:variable>
<!-- total number of HSP in first blast iteration -->
<xsl:variable name="hsp-count"><xsl:value-of select="count(BlastOutput/BlastOutput_iterations/Iteration[1]/Iteration_hits/Hit/Hit_hsps/Hsp)"/></xsl:variable>
<!-- query length (bases or amino acids ) -->
<xsl:variable name="query-length"><xsl:value-of select="BlastOutput/BlastOutput_query-len"/></xsl:variable>
<!-- margin between two hits -->
<xsl:variable name="space-between-hits"><xsl:value-of select="3* $hsp-height"/></xsl:variable>
<!-- height of all hits -->
<xsl:variable name="hits-height"><xsl:value-of select="$hsp-count * $hsp-height + ($hit-count + 1) * $space-between-hits"/></xsl:variable>
<!-- size of the top header -->
<xsl:variable name="header-height">50</xsl:variable>

<!-- ========================================================================= -->

<!-- matching the root node -->
<xsl:template match="/">
<!-- start XHTML -->
<h:html>
<h:head>
	<h:style type="text/css">
	body	{
		font-size:10px;
		font-family:Helvetica; 
		background-color:rgb(150,150,150);
		color:white;
		}
	</h:style>
	<h:title><xsl:value-of select="BlastOutput/BlastOutput_query-def"/></h:title>
</h:head>
<h:body>
<h:h1>Blast Results</h:h1>
<h:div>
<h:h3>Parameters</h:h3>
  <h:table>
	<h:tr><h:th>Database</h:th><h:td><xsl:value-of select="BlastOutput/BlastOutput_db"/></h:td></h:tr>
	<h:tr><h:th>Query ID</h:th><h:td><xsl:value-of select="BlastOutput/BlastOutput_query-ID"/></h:td></h:tr>
	<h:tr><h:th>Query Def.</h:th><h:td><h:b><xsl:value-of select="BlastOutput/BlastOutput_query-def"/></h:b></h:td></h:tr>
	<h:tr><h:th>Query Length</h:th><h:td><h:b><xsl:value-of select="BlastOutput/BlastOutput_query-len"/></h:b></h:td></h:tr>
	<h:tr><h:th>Version</h:th><h:td><xsl:value-of select="BlastOutput/BlastOutput_version"/></h:td></h:tr>
	<h:tr><h:th>Reference</h:th><h:td><h:a href="http://www.ncbi.nlm.nih.gov/pubmed/9254694"><xsl:value-of select="BlastOutput/BlastOutput_reference"/></h:a></h:td></h:tr>
  </h:table>
</h:div>
<h:hr/>
<h:div style="text-align:center">

<!-- starts SVG figure -->
<xsl:element name="svg:svg">
<xsl:attribute name="version">1.0</xsl:attribute>
<xsl:attribute name="width"><xsl:value-of select="$svg-width"/></xsl:attribute>
<xsl:attribute name="height"><xsl:value-of select="$hits-height + $header-height "/></xsl:attribute>
<svg:title><xsl:value-of select="BlastOutput/BlastOutput_query-def"/></svg:title>
<svg:defs>
<svg:style type="text/css">
text.t1	{
	fill:black;
	font-size:<xsl:value-of select="$hsp-height - 2"/>px;
	font-family:Helvetica; 
	}
text.t2	{
	fill:blue;
	font-size:<xsl:value-of select="$space-between-hits - 2"/>px;
	font-family:Helvetica; 
	text-anchor:middle;
	}
text.title	{
	fill:white;
	stroke:black;
	font-size:12px;
	font-family:Helvetica; 
	text-anchor:middle;
	alignment-baseline:middle;
	}
line.grid	{
		stroke:lightgray;
		stroke-width:1.5px;
		}
		
rect.hit	{
	fill:none;
	stroke:darkgray;
	stroke-width:1px;
	}
</svg:style>

<svg:linearGradient x1="0%" y1="0%" x2="0%" y2="100%" id="score1">
	<svg:stop offset="5%" stop-color="red" />
	<svg:stop offset="50%" stop-color="whitesmoke" />
	<svg:stop offset="95%" stop-color="red" />
</svg:linearGradient>
<svg:linearGradient x1="0%" y1="0%" x2="0%" y2="100%" id="score2">
	<svg:stop offset="5%" stop-color="orange" />
	<svg:stop offset="50%" stop-color="whitesmoke" />
	<svg:stop offset="95%" stop-color="orange" />
</svg:linearGradient>
<svg:linearGradient x1="0%" y1="0%" x2="0%" y2="100%" id="score3">
	<svg:stop offset="5%" stop-color="green" />
	<svg:stop offset="50%" stop-color="whitesmoke" />
	<svg:stop offset="95%" stop-color="green" />
</svg:linearGradient>
<svg:linearGradient x1="0%" y1="0%" x2="0%" y2="100%" id="score4">
	<svg:stop offset="5%" stop-color="blue" />
	<svg:stop offset="50%" stop-color="whitesmoke" />
	<svg:stop offset="95%" stop-color="blue" />
</svg:linearGradient>
<svg:linearGradient x1="0%" y1="0%" x2="0%" y2="100%" id="score5">
	<svg:stop offset="5%" stop-color="black" />
	<svg:stop offset="50%" stop-color="whitesmoke" />
	<svg:stop offset="95%" stop-color="black" />
</svg:linearGradient>
</svg:defs>

  <xsl:element name="svg:rect">
    <xsl:attribute name="x">0</xsl:attribute>
    <xsl:attribute name="y">0</xsl:attribute>
    <xsl:attribute name="width"><xsl:value-of select="$svg-width - 1"/></xsl:attribute>
    <xsl:attribute name="height"><xsl:value-of select="$hits-height + $header-height "/></xsl:attribute>
    <xsl:attribute name="fill">whitesmoke</xsl:attribute>
    <xsl:attribute name="stroke">blue</xsl:attribute>
  </xsl:element>

  
 <xsl:apply-templates select="BlastOutput"/>
</xsl:element>
<!-- end SVG figure -->

</h:div>
<h:hr/>
 <xsl:apply-templates select="BlastOutput/BlastOutput_param/Parameters"/>
<h:hr/>
<h:p><h:b>SVG</h:b> figure generated with <h:a href="http://code.google.com/p/lindenb/source/browse/trunk/src/xsl/blast2svg.xsl">blast2svg</h:a>. <h:a href="http://plindenbaum.blogspot.com">Pierre Lindenbaum PhD</h:a> <h:i>( plindenbaum at yahoo dot fr )</h:i></h:p>

</h:body>
</h:html>
</xsl:template>
<!-- ========================================================================= -->
<!-- display parameters in a HTML table -->
<xsl:template match="Parameters">
<h:div>
<h:h3>Parameters</h:h3>
  <h:table>
	<h:tr><h:th>Expect</h:th><h:td><xsl:value-of select="Parameters_expect"/></h:td></h:tr>
	<h:tr><h:th>Sc-match</h:th><h:td><xsl:value-of select="Parameters_sc-match"/></h:td></h:tr>
	<h:tr><h:th>Sc-mismatch</h:th><h:td><xsl:value-of select="Parameters_sc-mismatch"/></h:td></h:tr>
	<h:tr><h:th>Gap-open</h:th><h:td><xsl:value-of select="Parameters_gap-open"/></h:td></h:tr>
	<h:tr><h:th>Gap-extend</h:th><h:td><xsl:value-of select="Parameters_gap-extend"/></h:td></h:tr>
	<h:tr><h:th>Filter</h:th><h:td><xsl:value-of select="Parameters_filter"/></h:td></h:tr>
  </h:table>
</h:div>
</xsl:template>


<!-- ========================================================================= -->
<xsl:template match="BlastOutput">
  <!-- paint header -->
  <svg:g>
	<xsl:element name="svg:rect">
	<xsl:attribute name="x">0</xsl:attribute>
	<xsl:attribute name="y">0</xsl:attribute>
	<xsl:attribute name="width"><xsl:value-of select="$svg-width - 1"/></xsl:attribute>
	<xsl:attribute name="height"><xsl:value-of select="$header-height - 2"/></xsl:attribute>
	<xsl:attribute name="fill">url(#score5)</xsl:attribute>
	<xsl:attribute name="stroke">black</xsl:attribute>
	</xsl:element>
	
	<xsl:element name="svg:text">
		<xsl:attribute name="x"><xsl:value-of select="$svg-width div 2"/></xsl:attribute>
		<xsl:attribute name="y"><xsl:value-of select="$header-height div 2"/></xsl:attribute>
		<xsl:attribute name="class">title</xsl:attribute>
		<xsl:value-of select="BlastOutput_query-def"/> (len=<xsl:value-of select="BlastOutput_query-len"/> )
	</xsl:element>
  </svg:g>
<xsl:apply-templates select="BlastOutput_iterations/Iteration[1]/Iteration_hits"/>
</xsl:template> 

<!-- ========================================================================= -->

<xsl:template match="Iteration_hits">
  <xsl:apply-templates select="Hit"/>
</xsl:template> 

<!-- ========================================================================= -->

<xsl:template match="Hit">
    <!-- count number of preceding hits -->
    <xsl:variable name="preceding-hits"><xsl:value-of select="count(preceding-sibling::Hit)"/></xsl:variable>
     <!-- count number of preceding hsp -->
    <xsl:variable name="preceding-hsp"><xsl:value-of select="count(preceding-sibling::Hit/Hit_hsps/Hsp)"/></xsl:variable>
    <!-- calculate hieght of this part -->
    <xsl:variable name="height"><xsl:value-of select="count(Hit_hsps/Hsp)*$hsp-height"/></xsl:variable>
    <!-- translate this part verticaly -->
    <xsl:element name="svg:g">
      <xsl:attribute name="transform">translate(0,<xsl:value-of select="$header-height + $preceding-hsp * $hsp-height + ($preceding-hits + 1) * $space-between-hits "/>)</xsl:attribute>
      <xsl:attribute name="id">hit-<xsl:value-of select="generate-id(.)"/></xsl:attribute>
	<xsl:element name="svg:text">
		<xsl:attribute name="x"><xsl:value-of select="$svg-width div 2"/></xsl:attribute>
		<xsl:attribute name="y"><xsl:value-of select="-2"/></xsl:attribute>
		<xsl:attribute name="class">t2</xsl:attribute>
		<xsl:value-of select="Hit_def"/>
	</xsl:element>
	<xsl:element name="svg:rect">
		<xsl:attribute name="x">0</xsl:attribute>
		<xsl:attribute name="y">0</xsl:attribute>
		<xsl:attribute name="width"><xsl:value-of select="$svg-width"/></xsl:attribute>
		<xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute>
		<xsl:attribute name="class">hit</xsl:attribute>
	</xsl:element>
	
	<xsl:call-template name="grid">
		<xsl:with-param name="x" select="0"/>
		<xsl:with-param name="d" select="20"/>
		<xsl:with-param name="W" select="$svg-width"/>
		<xsl:with-param name="H" select="$height"/>
	</xsl:call-template>
	
	<xsl:apply-templates select="Hit_hsps"/>
	
	
	
    </xsl:element>
</xsl:template>

<!-- ========================================================================= -->
<!-- draw vertical lines , recursive template -->
<xsl:template name="grid">
	<xsl:param name="x" select="0" />
	<xsl:param name="d" select="20" />
	<xsl:param name="W" select="0" />
	<xsl:param name="H" select="0" />
	<svg:line class="grid" x1="{$x}" x2="{$x}" y1="0" y2="{$H}"/>
	<xsl:if test="$d + $x &lt; $W">
		<xsl:call-template name="grid">
			<xsl:with-param name="x" select="$d + $x"/>
			<xsl:with-param name="d" select="$d"/>
			<xsl:with-param name="W" select="$W"/>
			<xsl:with-param name="H" select="$H"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!-- ========================================================================= -->

<xsl:template match="Hit_hsps">
  <xsl:apply-templates select="Hsp"/>
</xsl:template>


<!-- ========================================================================= -->
<xsl:template match="Hsp">
<!-- number of previous hsp in the same Hit -->
<xsl:variable name="preceding-hsp"><xsl:value-of select="count(preceding-sibling::Hsp)"/></xsl:variable>
<!-- get the 5' position of the hsp in the query -->
<xsl:variable name="hsp-left"><xsl:choose>
  <xsl:when test="Hsp_query-from &lt; Hsp_query-to"><xsl:value-of select="Hsp_query-from"/></xsl:when>
  <xsl:otherwise><xsl:value-of select="Hsp_query-to"/></xsl:otherwise>
</xsl:choose></xsl:variable>
<!-- get the 3' position of the hsp in the query -->
<xsl:variable name="hsp-right"><xsl:choose>
  <xsl:when test="Hsp_query-from &lt; Hsp_query-to"><xsl:value-of select="Hsp_query-to"/></xsl:when>
  <xsl:otherwise><xsl:value-of select="Hsp_query-from"/></xsl:otherwise>
</xsl:choose></xsl:variable>
<!-- 5' position on screen -->
<xsl:variable name="x1"><xsl:value-of select="($hsp-left div $query-length ) * $svg-width"/></xsl:variable>
<!-- 3' position on screen -->
<xsl:variable name="x2"><xsl:value-of select="($hsp-right div $query-length ) * $svg-width"/></xsl:variable>
<!-- label -->
<xsl:variable name="label"><xsl:value-of select="Hsp_hit-from"/> - <xsl:value-of select="Hsp_hit-to"/> (<xsl:choose>
  <xsl:when test="Hsp_query-from &lt; Hsp_query-to">+</xsl:when>
  <xsl:otherwise>-</xsl:otherwise></xsl:choose>) e=<xsl:value-of select="Hsp_evalue"/></xsl:variable>
  
  <!-- translate this Hsp verticaly in its Hit -->
   <xsl:element name="svg:g">
      <xsl:attribute name="transform">translate(0,<xsl:value-of select="$preceding-hsp * $hsp-height"/>)</xsl:attribute>
      <xsl:attribute name="id">hsp-<xsl:value-of select="generate-id(.)"/></xsl:attribute>
      <xsl:attribute name="title"><xsl:value-of select="Hsp_evalue"/></xsl:attribute>
      
         <!-- paint the Hsp Rectangle -->
	 <xsl:element name="svg:rect">
	   <xsl:attribute name="x"><xsl:value-of select="$x1"/></xsl:attribute>
	   <xsl:attribute name="y">2</xsl:attribute>
	   <xsl:attribute name="width"><xsl:value-of select="$x2 - $x1"/></xsl:attribute>
	   <xsl:attribute name="height"><xsl:value-of select="$hsp-height - 4"/></xsl:attribute>
	   <!-- choose a color according to the e-value -->
	   <xsl:attribute name="fill"><xsl:choose>
	       <xsl:when test="Hsp_evalue &lt; 1E-100">url(#score1)</xsl:when>
	       <xsl:when test="Hsp_evalue &lt; 1E-10">url(#score2)</xsl:when>
	       <xsl:when test="Hsp_evalue &lt; 0.1">url(#score3)</xsl:when>
	        <xsl:when test="Hsp_evalue &lt; 0">url(#score4)</xsl:when>
	       <xsl:otherwise>url(#score5)</xsl:otherwise>
	     </xsl:choose></xsl:attribute>
	 </xsl:element>
	 
	 <!-- paint the label according to the position of the Hsp on screen  -->
	 <xsl:choose>
	 	<xsl:when test="$x2 &lt; (0.75 * $svg-width)">
			<xsl:element name="svg:text">
			  <xsl:attribute name="class">t1</xsl:attribute>
			  <xsl:attribute name="x"><xsl:value-of select="$x2 + 10 "/></xsl:attribute>
			  <xsl:attribute name="y"><xsl:value-of select="$hsp-height -1"/></xsl:attribute>
			  <xsl:attribute name="text-anchor">start</xsl:attribute>
			  <xsl:value-of select="$label"/>
			</xsl:element>
		</xsl:when>
		<xsl:when test="$x1 &gt; (0.25 * $svg-width)">
			<xsl:element name="svg:text">
			  <xsl:attribute name="class">t1</xsl:attribute>
			  <xsl:attribute name="x"><xsl:value-of select="$x1 - 10 "/></xsl:attribute>
			  <xsl:attribute name="y"><xsl:value-of select="$hsp-height -1"/></xsl:attribute>
			  <xsl:attribute name="text-anchor">end</xsl:attribute>
			  <xsl:value-of select="$label"/>
			</xsl:element>
		</xsl:when>
		<xsl:otherwise>
			<xsl:element name="svg:text">
			  <xsl:attribute name="class">t1</xsl:attribute>
			  <xsl:attribute name="x"><xsl:value-of select="($x2 - $x1) div 2 "/></xsl:attribute>
			  <xsl:attribute name="y"><xsl:value-of select="$hsp-height -1"/></xsl:attribute>
			  <xsl:attribute name="text-anchor">middle</xsl:attribute>
			  <xsl:value-of select="$label"/>
			</xsl:element>
		</xsl:otherwise>
         </xsl:choose>
         
    </xsl:element>
</xsl:template>
<!-- ========================================================================= -->


</xsl:stylesheet>