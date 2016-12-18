<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:x="http://www.ibm.com/xmlns/prod/2009/jsonx"
	version='1.0'
	>
<!--

Author:
	Pierre Lindenbaum PhD
	plindenbaum@yahoo.fr

Motivation:
	JSONX-schema to gjson
Usage:
	xsltproc  x
-->
<xsl:output method="text" />


<xsl:template match="/">
<xsl:apply-templates select="*" mode="leaf"/>
</xsl:template>

<xsl:template match="*" mode="leaf">
<xsl:choose>
	<xsl:when test="count(*) != 0">
		<xsl:apply-templates select="*" mode="leaf"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>root</xsl:text>
		<xsl:apply-templates select="." mode="up"/>
		<xsl:text>;
</xsl:text>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="*" mode="allup">
<xsl:if test="parent::*">
	<xsl:apply-templates select="parent::*" mode="up"/>
</xsl:if>
<xsl:choose>
	<xsl:when test="@name">.get("<xsl:value-of select="@name"/>")</xsl:when>
	<xsl:when test="local-name(..)='array'">.get(<xsl:value-of select="count(preceding-sibling::*)"/>)</xsl:when>
</xsl:choose>
</xsl:template>



<xsl:template match="x:object" mode="up">
<xsl:apply-templates select="." mode="allup"/>
<xsl:text>.getAsJsonObject()</xsl:text>
</xsl:template>

<xsl:template match="x:array" mode="up">
<xsl:apply-templates select="." mode="allup"/>
<xsl:text>.getAsJsonArray()</xsl:text>
</xsl:template>

<xsl:template match="x:string" mode="up">
<xsl:apply-templates select="." mode="allup"/>
<xsl:text>.getAsJsonPrimitive().getAsString() /* </xsl:text>
<xsl:value-of  select="text()"/>
<xsl:text> */</xsl:text>
</xsl:template>

<xsl:template match="x:number" mode="up">
<xsl:apply-templates select="." mode="allup"/>
<xsl:text>.getAsJsonPrimitive().getAsNumber() /* </xsl:text>
<xsl:value-of  select="text()"/>
<xsl:text> */</xsl:text>
</xsl:template>

<xsl:template match="x:boolean" mode="up">
<xsl:apply-templates select="." mode="allup"/>
<xsl:text>.getAsJsonPrimitive().getAsBoolean() /* </xsl:text>
<xsl:value-of  select="text()"/>
<xsl:text> */</xsl:text>
</xsl:template>


<xsl:template match="x:null" mode="up">
<xsl:apply-templates select="." mode="allup"/>
<xsl:text>.getAsJsonNull()</xsl:text>
</xsl:template>



</xsl:stylesheet>
