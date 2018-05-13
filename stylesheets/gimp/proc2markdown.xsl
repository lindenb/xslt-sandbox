<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>
<xsl:output method="text"/>

<xsl:template match="/">
<xsl:apply-templates select="gimp-procedures"/>
</xsl:template>

<xsl:template match="gimp-procedures">

# Gimp Procedures

<xsl:apply-templates select="procedure"/>
</xsl:template>

<xsl:template match="procedure">
## (<xsl:value-of select="@name"/><xsl:for-each select="arguments/param"><xsl:text> </xsl:text><xsl:value-of select="name"/></xsl:for-each>)

<xsl:value-of select="long-desc"/>.
<xsl:if test="count(arguments/param) &gt; 0">
### Parameter(s)

| Name | Type | Description |
| --- | --- | --- |
<xsl:apply-templates select="arguments/param"/>

</xsl:if>

<xsl:if test="count(return/param) &gt; 0">
### Return

| Name | Type | Description |
| --- | --- | --- |
<xsl:apply-templates select="return/param"/>

</xsl:if>
---
</xsl:template>

<xsl:template match="param">
<xsl:text>| </xsl:text>
<xsl:value-of select="name"/>
<xsl:text> | </xsl:text>
<xsl:value-of select="type"/>
<xsl:text> | </xsl:text>
<xsl:value-of select="desc"/>
<xsl:text> |
</xsl:text>
</xsl:template>

</xsl:stylesheet>
