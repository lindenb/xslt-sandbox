<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:g="http://www.gexf.net/1.1draft"
	xmlns:viz="http://www.gexf.net/1.1draft/viz"
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:h='http://www.w3.org/1999/xhtml'
        version='1.0'
        >
<xsl:output method="xml" indent="yes"/>
<xsl:variable name="width" select="number(100)"/>
<xsl:variable name="height" select="number(150)"/>

<xsl:template match="/">
<xsl:apply-templates select="layouts"/>
</xsl:template>

<xsl:template match="layouts">
<layouts>
<xsl:apply-templates select="layout"/>
</layouts>
</xsl:template>

<xsl:template match="layout">


<xsl:copy-of select="."/> 

<layout>
<xsl:attribute name="id">
<xsl:value-of select="concat(@id,'.v')"/>
</xsl:attribute>
<xsl:apply-templates select="panel"/>
</layout>
</xsl:template>

<xsl:template match="panel">

<xsl:variable name="h">
    <xsl:for-each select="../panel">
	<xsl:sort select="number(@height) + number(@y)" data-type="number" order="descending"/>
	 <xsl:if test="position() = 1"><xsl:value-of select="(number(@height) + number(@y))"/></xsl:if>
    </xsl:for-each>
</xsl:variable>

<panel>
    <xsl:copy-of select="@x" />
	<xsl:attribute name="y">
		<xsl:value-of select="($h - number(@y) - number(@height))"/>
	</xsl:attribute>
	<xsl:copy-of select="@width" />
    <xsl:copy-of select="@height" />
</panel>
</xsl:template>


</xsl:stylesheet>

