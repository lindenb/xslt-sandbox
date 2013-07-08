<?xml version='1.0' encoding="UTF-8"?>
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Motivation:
      transforms the xmloutput of genbank-xml to FASTA

Usage :
      xsltproc db2fasta.xsl sequence.gb.xml > file.fa
-->

<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
	>
<xsl:output method="text"  encoding="UTF-8" />

<xsl:param name="W">70</xsl:param>
<xsl:variable name="w" select="number($W)"/>

<xsl:template match="/">
<xsl:apply-templates select="GBSet"/>
</xsl:template>


<xsl:template match="GBSet">
<xsl:apply-templates select="GBSeq"/>
</xsl:template>

<xsl:template match="GBSeq">
<xsl:text>&gt;</xsl:text>
<xsl:apply-templates select="GBSeq_other-seqids/GBSeqid"/>
<xsl:choose>
	<xsl:when test="GBSeq_accession-version">
		<xsl:apply-templates select="GBSeq_accession-version"/>
		<xsl:text>|</xsl:text>
	</xsl:when>
	<xsl:when test="GBSeq_primary-accession">
		<xsl:apply-templates select="GBSeq_primary-accession"/>
		<xsl:text>|</xsl:text>
	</xsl:when>
</xsl:choose>
<xsl:apply-templates select="GBSeq_definition"/>
<xsl:call-template name="seq">
<xsl:with-param name="s" select="normalize-space(GBSeq_sequence)"/>
</xsl:call-template>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="GBSeq_definition|GBSeq_accession-version|GBSeq_primary-accession">
<xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="GBSeqid">
<xsl:value-of select="."/>
<xsl:if test=" substring(., string-length(.)  ) !='|' "><xsl:text>|</xsl:text></xsl:if>
</xsl:template>


<xsl:template name="seq">
<xsl:param name="s"/>
<xsl:text>
</xsl:text>
<xsl:choose>
	<xsl:when test="string-length($s)&lt; $w">
		<xsl:value-of select="$s"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="substring($s,1,$w)"/>
		<xsl:call-template name="seq">
			<xsl:with-param name="s" select="substring($s,$w + 1 )"/>
		</xsl:call-template>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
