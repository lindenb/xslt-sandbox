<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
 version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 >
<!--


Author:
   Pierre Lindenbaum PhD plindenbaum@yahoo.fr

Date:
   2014

Motivation:
   Add NCBI Taxonomy to Blast XML https://www.biostars.org/p/107224
   tag Hit_id must starts with "gi|123456789|"
   This stylesheet transforms a blast xml result to XHTML+SVG
   Tested with 'blastp'


-->

<xsl:output method='xml' indent="yes"/>


<xsl:variable name="program">
<xsl:value-of select="/BlastOutput/BlastOutput_program/text()"/>
</xsl:variable>

<xsl:variable name="db">
<xsl:choose>
<xsl:when test=" $program ='blastp'">protein</xsl:when>
<xsl:otherwise>nucleotide</xsl:otherwise>
</xsl:choose>
</xsl:variable>


<xsl:template match="/">
<xsl:apply-templates select="*"/>
</xsl:template>



<xsl:template match="*|text()|@*">
<xsl:copy>
<xsl:apply-templates select="*|text()|@*"/>
</xsl:copy>
</xsl:template>


<xsl:template match="Hit_id">
<xsl:variable name="gi1" select="."/>
<Hit_id><xsl:value-of select="."/></Hit_id>
<xsl:variable name="gi" select="substring-before(substring-after(.,'gi|'),'|')"/>
<xsl:if test="number($gi) &gt; 0">
<xsl:variable name="url1" select="concat('http://www.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=',$db,'&amp;retmode=xml&amp;id=',$gi)"/>
<xsl:message terminate="no">Downloading <xsl:value-of select="$url1"/></xsl:message>
<xsl:apply-templates select="document($url1)" mode="summary"/>
</xsl:if>
</xsl:template>

<xsl:template match="eSummaryResult" mode="summary">
<xsl:if test="DocSum/Item[@Name='TaxId']">
<xsl:variable name="taxid1" select="DocSum/Item[@Name='TaxId']"/>
<xsl:if test="number($taxid1) &gt; 0">
<xsl:variable name="url2" select="concat('http://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&amp;retmode=xml&amp;id=',$taxid1)"/>
<xsl:message terminate="no">Downloading <xsl:value-of select="$url2"/></xsl:message>
<xsl:apply-templates select="document($url2)/TaxaSet/Taxon"/>
</xsl:if>
</xsl:if>

</xsl:template>



</xsl:stylesheet>
