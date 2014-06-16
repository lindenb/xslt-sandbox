<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
	>

<!--


Author:
   Pierre Lindenbaum PhD plindenbaum@yahoo.fr

Motivation:
	Efetch taxonomy to graphiz dot
	
Example:
	 xsltproc taxon2dot.xsl "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&id=9606,9913,30521,562,2157"

-->
<xsl:output method='text' encoding="UTF-8"/>

<xsl:key name="taxonkeys" match="Taxon" use="TaxId" />
<xsl:key name="links" match="LineageEx/Taxon" use="TaxId" />

 
<xsl:template match="/">
<xsl:text>digraph G {
</xsl:text>
<xsl:apply-templates select="TaxaSet"/>

<xsl:text>}
</xsl:text>
</xsl:template>

<xsl:template match="TaxaSet">
<xsl:apply-templates select="Taxon" />
<xsl:apply-templates select="Taxon/LineageEx"/>
</xsl:template>

<xsl:template match="Taxon">
<xsl:apply-templates select="." mode="node"/>
<xsl:value-of select="concat('n',TaxId,' -> n',LineageEx/Taxon[position()=last()]/TaxId,';')"/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="Taxon" mode="node">
<xsl:if test="generate-id(.)=generate-id(key('taxonkeys',TaxId))">
<xsl:value-of select="concat('n',TaxId,'[label=&quot;',ScientificName,'&quot;];')"/>
<xsl:text>
</xsl:text>
</xsl:if>
</xsl:template>


<xsl:template match="LineageEx">
<xsl:for-each select="Taxon">
<xsl:if test="generate-id(../..)!=generate-id(key('taxonkeys',TaxId))">
<xsl:apply-templates select="." mode="node"/>
</xsl:if>


<xsl:if test="position()&gt;1 and generate-id(.)=generate-id(key('links',TaxId))">
<xsl:value-of select="concat('n',TaxId,' -> n',preceding-sibling::Taxon[1]/TaxId,';')"/>
<xsl:text>
</xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
