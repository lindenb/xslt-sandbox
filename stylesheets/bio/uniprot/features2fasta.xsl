<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:u="http://uniprot.org/uniprot"
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0' 
	> 
<xsl:output method="text"/>
<xsl:template match="/">
<xsl:apply-templates select="u:uniprot/u:entry[u:sequence]"/>
</xsl:template>

<xsl:template match="u:entry">
<xsl:apply-templates select="u:feature"/>
</xsl:template>

<xsl:template match="u:feature[u:location]">
<xsl:apply-templates select="u:feature"/>
</xsl:template>

<xsl:template match="u:feature[u:location/u:position]">
<xsl:apply-templates select="." mode="name"/>
<xsl:value-of select="substring(translate(../u:sequence,'&#10; ',''),number(u:location/u:position/@position),1)"/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="u:feature[u:location/u:begin]">
<xsl:variable name="start" select="number(u:location/u:begin/@position)"/>
<xsl:apply-templates select="." mode="name"/>
<xsl:value-of select="substring(translate(../u:sequence,'&#10; ',''),$start,1 + number(u:location/u:end/@position)- $start)"/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="u:feature" mode='name'>
<xsl:text>&gt;</xsl:text>
<xsl:value-of select="../u:accession[1]"/>
<xsl:if test="@type">
<xsl:text>|type=</xsl:text>
<xsl:value-of select="@type"/>
</xsl:if>
<xsl:if test="@description">
<xsl:text>|description=</xsl:text>
<xsl:value-of select="@description"/>
</xsl:if>
<xsl:if test="@id">
<xsl:text>|id=</xsl:text>
<xsl:value-of select="@id"/>
</xsl:if>
<xsl:text>
</xsl:text>
</xsl:template>

</xsl:stylesheet>

