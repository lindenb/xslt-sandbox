<?xml version='1.0'  encoding="ISO-8859-1" ?>
<xsl:stylesheet
	xmlns:h="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
	>
<xsl:output method="text" encoding="UTF-8" />

<xsl:template match="/documentation">
<xsl:text>
|| *Title* || *Description* ||
</xsl:text>
<xsl:for-each select="page">
<xsl:text>|| [</xsl:text>
<xsl:value-of select="@title"/>
<xsl:text>] || </xsl:text>
<xsl:value-of select="@desc"/>
<xsl:text> ||
</xsl:text>
</xsl:for-each>
<xsl:text>
</xsl:text>
<xsl:apply-templates select="page"/>
</xsl:template> 

<xsl:template match="page">
<xsl:variable name="filename" select="@title"/>
<xsl:message>Generating <xsl:value-of select="concat(@title,'.wiki')"/>
</xsl:message>
<xsl:document href="{$filename}.wiki" method="text">
<xsl:text>#summary </xsl:text>
<xsl:choose>
<xsl:when test="@desc">
  <xsl:value-of select="@desc"/>
</xsl:when>
<xsl:otherwise>
  <xsl:value-of select="@title"/>
</xsl:otherwise>
</xsl:choose>
<xsl:text>
</xsl:text>
<xsl:if test="@labels">
<xsl:text>#labels </xsl:text>
<xsl:value-of select="@labels"/>
<xsl:text>
</xsl:text>
</xsl:if>

<xsl:if test="count(//h3)&gt;0">
<xsl:text>&lt;wiki:toc max_depth="1" /&gt;
</xsl:text>
</xsl:if>

<xsl:apply-templates/>

<xsl:text>


&lt;g:plusone size="medium"&gt;&lt;/g:plusone&gt;

</xsl:text>
</xsl:document>
</xsl:template> 


<xsl:template match="cite">
<xsl:text>      </xsl:text>
<xsl:value-of select="."/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="br">
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="pmid">
<xsl:value-of select="concat('[http://www.ncbi.nlm.nih.gov/pubmed/',.,' pmid:',.,']')"/>
</xsl:template>

<xsl:template match="url">
<xsl:value-of select="concat('[',.,' ',.,']')"/>
</xsl:template>


<xsl:template match="a[@href]">
<xsl:text>[</xsl:text>
<xsl:value-of select="@href"/>
<xsl:text> </xsl:text>
<xsl:value-of select="."/>
<xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="img">
<xsl:text>
</xsl:text>
<xsl:value-of select="@src"/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="pre">
<xsl:text>
{{{
</xsl:text>
<xsl:value-of select="."/>
<xsl:text>
}}}
</xsl:text>
</xsl:template>

<xsl:template match="span">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="div">
<xsl:text>
</xsl:text>
<xsl:apply-templates/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="ul">
<xsl:for-each select="li">
<xsl:text>  * </xsl:text>
<xsl:apply-templates/>
<xsl:text>
</xsl:text>
</xsl:for-each>
</xsl:template>

<xsl:template match="code">
<xsl:text>`</xsl:text>
<xsl:value-of select="."/>
<xsl:text>`</xsl:text>
</xsl:template>

<xsl:template match="b">
<xsl:text>*</xsl:text>
<xsl:value-of select="."/>
<xsl:text>*</xsl:text>
</xsl:template>

<xsl:template match="i">
<xsl:text>_</xsl:text>
<xsl:value-of select="."/>
<xsl:text>_</xsl:text>
</xsl:template>

<xsl:template match="strike">
<xsl:text>~~</xsl:text>
<xsl:value-of select="."/>
<xsl:text>~~</xsl:text>
</xsl:template>

<xsl:template match="h1">
<xsl:text>
=</xsl:text>
<xsl:value-of select="."/>
<xsl:text>=
</xsl:text>
</xsl:template>

<xsl:template match="h2">
<xsl:text>
==</xsl:text>
<xsl:value-of select="."/>
<xsl:text>==
</xsl:text>
</xsl:template>

<xsl:template match="h3">
<xsl:text>
===</xsl:text>
<xsl:value-of select="."/>
<xsl:text>===
</xsl:text>
</xsl:template>

<xsl:template match="h4">
<xsl:text>
====</xsl:text>
<xsl:value-of select="."/>
<xsl:text>====
</xsl:text>
</xsl:template>


<xsl:template match="h5">
<xsl:text>
=====</xsl:text>
<xsl:value-of select="."/>
<xsl:text>=====
</xsl:text>
</xsl:template>


<xsl:template match="h6">
<xsl:text>
======</xsl:text>
<xsl:value-of select="."/>
<xsl:text>======
</xsl:text>
</xsl:template>

</xsl:stylesheet>
