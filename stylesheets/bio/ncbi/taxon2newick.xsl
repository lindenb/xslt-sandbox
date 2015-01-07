<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
	>

<!--


Author:
   Pierre Lindenbaum PhD plindenbaum@yahoo.fr

Motivation:
	Efetch taxonomy to newick
	
Example:
	 xsltproc taxon2newick.xsl "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&id=9606,10090,9031,7227,562" 

-->
<xsl:output method='text' encoding="UTF-8"/>

<xsl:key name="taxonkeys" match="Taxon" use="TaxId" />
<xsl:key name="taxids" match="//LineageEx/Taxon" use="TaxId" />
<xsl:variable name="allnodes" match="//Taxon" />
 
<xsl:template match="/">
<xsl:apply-templates select="TaxaSet/Taxon[1]/LineageEx[1]/Taxon[1]" />
<xsl:text>;
</xsl:text>
</xsl:template>

<xsl:template match="Taxon">
<xsl:call-template name="recursive">
 <xsl:with-param name="parent" select="."/>
</xsl:call-template>
</xsl:template>

<xsl:template match="Taxon" mode="name">
<xsl:choose>
<xsl:when test="ScientificName">
  <xsl:value-of select="translate(ScientificName/text(),' ','_')"/>
</xsl:when>
<xsl:otherwise>
   <xsl:value-of select="TaxId/text()"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="recursive">
<xsl:param name="parent"/>
<xsl:variable name="parent_id" select="$parent/TaxId/text()"/>
<xsl:variable name="childstr">
<xsl:for-each select="//LineageEx/Taxon">

 <xsl:choose>
    <xsl:when test="count(./preceding-sibling::Taxon) + 1 = count(../Taxon) and TaxId = $parent_id">
    	<xsl:text>,</xsl:text>
    	<xsl:apply-templates select="../.." mode="name"/>
    </xsl:when>
    <xsl:when test="./preceding-sibling::Taxon[1]/TaxId/text() = $parent_id and  generate-id(.)=generate-id(key('taxids',TaxId))">
    	<xsl:text>,</xsl:text>
    	<xsl:call-template name="recursive">
 		<xsl:with-param name="parent" select="."/>
	</xsl:call-template>
    </xsl:when>
    
 </xsl:choose>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="childstr1" select="substring-after($childstr,',')"/>
<xsl:if test="string-length($childstr1)&gt;0">
<xsl:text>(</xsl:text>
<xsl:value-of select="$childstr1"/>
<xsl:text>)</xsl:text>
</xsl:if>
<xsl:apply-templates select="$parent" mode="name"/>
</xsl:template>



</xsl:stylesheet>
