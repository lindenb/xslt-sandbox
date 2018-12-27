<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/2000/svg"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  >
<xsl:output method="xml" indent="yes" encoding="UTF-8"/>

<xsl:key name="id2node" match="/osm/node" use="@id"/>
<xsl:key name="way2node" match="/osm/way" use="@id"/>
<xsl:variable name="minlat" select="number(/osm/bounds/@minlat)"/>
<xsl:variable name="maxlat" select="number(/osm/bounds/@maxlat)"/>
<xsl:variable name="minlon" select="number(/osm/bounds/@minlon)"/>
<xsl:variable name="maxlon" select="number(/osm/bounds/@maxlon)"/>
<xsl:variable name="width" select="number(1000)"/>
<xsl:variable name="height" select=" (($maxlat - $minlat) div ($maxlon - $minlon)) * $width"/>

<xsl:template match="osm">
<svg width="{$width}" height="{$height}">
	<xsl:attribute name="viewRect">
		<xsl:call-template name="lon2x">
			<xsl:with-param name="lon" select="$minlon"/>
		</xsl:call-template>
		<xsl:text> </xsl:text>
		<xsl:call-template name="lat2y">
			<xsl:with-param name="lat" select="$minlat"/>
		</xsl:call-template>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$width"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$height"/>
	</xsl:attribute>
<style>
path {
	fill:gray;
	fill-opacity:0.5;
	stroke:black;
	}
.water {
	fill:blue;
	}
.route {
	fill:brown;
	}
.building {
	fill:yellow;
	}
.grass {
	fill:green;
	}
</style>
<g>
<xsl:for-each select="way">
	<xsl:sort select="count(nd)" data-type="number" order="descending"/>
	<xsl:apply-templates select="."/>
</xsl:for-each>
</g>
</svg>
</xsl:template>


<xsl:template match="way">
<path>
	<xsl:attribute name="d">
	<xsl:for-each select="nd">
	<xsl:choose>
		<xsl:when test="position()=1">M </xsl:when>
		<xsl:otherwise> L </xsl:otherwise>
	</xsl:choose>
	<xsl:call-template name="node2xy">
		<xsl:with-param name="node" select="key('id2node',@ref)"/>
	</xsl:call-template>
	</xsl:for-each>
	<xsl:text> Z</xsl:text>
	</xsl:attribute>
	
	<xsl:choose>
		<xsl:when test="tag[@k='waterway'] or tag[@k='water']">
			<xsl:attribute name="class">water</xsl:attribute>
		</xsl:when>
		<xsl:when test="tag[@k='route'] or tag[@k='highway'] ">
			<xsl:attribute name="class">route</xsl:attribute>
		</xsl:when>
		<xsl:when test="tag[(@k='type' and @v='building') or contains(@k,'building') ]">
			<xsl:attribute name="class">building</xsl:attribute>
		</xsl:when>
		<xsl:when test="tag[@v='park']">
			<xsl:attribute name="class">grass</xsl:attribute>
		</xsl:when>
	</xsl:choose>
	
	<title>
	<xsl:choose>
		<xsl:when test="tag[@k='name']">
			<xsl:value-of select="tag[@k='name']/@v"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="@id"/>
		</xsl:otherwise>
	</xsl:choose>
	</title>
</path>
</xsl:template>

<xsl:template name="node2xy">
<xsl:param name="node"/>
<xsl:call-template name="lon2x">
	<xsl:with-param name="lon" select="$node/@lon"/>
</xsl:call-template>
<xsl:text> </xsl:text>
<xsl:call-template name="lat2y">
	<xsl:with-param name="lat" select="$node/@lat"/>
</xsl:call-template>
</xsl:template>


<xsl:template name="lat2y">
<xsl:param name="lat"/>
<xsl:value-of select="$height - ((number($lat) - $minlat) div ($maxlat - $minlat) ) * $height"/>
</xsl:template>

<xsl:template name="lon2x">
<xsl:param name="lon"/>
<xsl:value-of select="((number($lon) - $minlon) div ($maxlon - $minlon) )  * $width"/>
</xsl:template>


</xsl:stylesheet>
