<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:x="http://www.w3.org/1999/XSL/TransformAlias"
	>
<xsl:output method="xml" indent="yes"/>
<xsl:namespace-alias stylesheet-prefix="x" result-prefix="xsl"/>

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
<x:stylesheet version="1.0">
<x:variable name="genomeLength">
	<xsl:attribute name="select">
	<xsl:text>number(0</xsl:text>
	<xsl:for-each select="build/contig">
	<xsl:text> + </xsl:text>
	<xsl:value-of select="@length"/>
	</xsl:for-each>
	<xsl:text>)</xsl:text>
	</xsl:attribute>
</x:variable>
<xsl:apply-templates select="build" />
</x:stylesheet>
</xsl:template>

<xsl:template match="build" >


<x:template name="contigsize">
<x:param name="name"/>
<x:choose>
	<xsl:for-each select="contig">
	<x:when>
		<xsl:attribute name="test">$name = '<xsl:value-of select="."/>'</xsl:attribute>
		<x:value-of>
			<xsl:attribute name="select">
				<xsl:text>number(</xsl:text>
				<xsl:value-of select="@length"/>
				<xsl:text>)</xsl:text>
			</xsl:attribute>
		</x:value-of>
	</x:when>
	</xsl:for-each>
	<x:otherwise>
		<x:message terminate="true">Unknow contig name '<x:value-of select="$name"/>'.</x:message>
	</x:otherwise>
</x:choose>
</x:template>

<x:template name="contigindex">
<x:param name="name"/>
<x:choose>
	<xsl:for-each select="contig">
	<x:when>
		<xsl:attribute name="test">$name = '<xsl:value-of select="."/>'</xsl:attribute>
		<x:value-of>
			<xsl:attribute name="select">
				<xsl:text>number(</xsl:text>
				<xsl:value-of select="position() - 1"/>
				<xsl:text>)</xsl:text>
			</xsl:attribute>
		</x:value-of>
	</x:when>
	</xsl:for-each>
	<x:otherwise>
		<x:message terminate="true">Unknow contig name '<x:value-of select="$name"/>'.</x:message>
	</x:otherwise>
</x:choose>
</x:template>


<x:template name="contigname">
<x:param name="tid"/>
<x:choose>
	<xsl:for-each select="contig">
	<x:when>
		<xsl:attribute name="test">number($tid) = <xsl:value-of select="position() - 1"/></xsl:attribute>
		<x:text><xsl:value-of select="."/></x:text>
	</x:when>
	</xsl:for-each>
	<x:otherwise>
		<x:message terminate="true">Unknow contig tid '<x:value-of select="$tid"/>'.</x:message>
	</x:otherwise>
</x:choose>
</x:template>


<x:template name="contigoffset">
<x:param name="name"/>
<x:param name="pos"/>
<x:choose>
	<xsl:for-each select="contig">
	<x:when>
		<xsl:attribute name="test">$name = '<xsl:value-of select="."/>'</xsl:attribute>
		<x:value-of>
			<xsl:attribute name="select">
				<xsl:text>number(0</xsl:text>
				<xsl:for-each select="preceding-sibling::contig">
				<xsl:text> + </xsl:text>
				<xsl:value-of select="@length"/>
				</xsl:for-each>
				<xsl:text>) + number($pos)</xsl:text>
			</xsl:attribute>
		</x:value-of>
	</x:when>
	</xsl:for-each>
	<x:otherwise>
		<x:message terminate="true">Unknow contig name '<x:value-of select="$name"/>'.</x:message>
	</x:otherwise>
</x:choose>
</x:template>



</xsl:template>

</xsl:stylesheet>
