<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
<!--
Author
    Pierre Lindenbaum PhD
Mail:
    plindenbaum@yahoo.fr
Motivation:
    https://www.biostars.org/p/14913/
    transforms a blast xml result to FASTA
Example:
    xsltproc -\-novalid blast2fasta.xsl blast.xml

-->
<!-- ========================================================================= -->
<xsl:output method="text"/>

<xsl:template match="/">
<xsl:apply-templates select="BlastOutput"/>
</xsl:template>

<xsl:template match="BlastOutput">
<xsl:for-each select="BlastOutput_iterations/Iteration/Iteration_hits/Hit">
<xsl:variable name="hitDef" select="Hit_def"/>
<xsl:variable name="hitLen" select="Hit_len"/>
<xsl:for-each select="Hit_hsps/Hsp">
<xsl:text>&gt;</xsl:text>
<xsl:value-of select="$hitDef"/>
<xsl:text>|len:</xsl:text>
<xsl:choose>
<xsl:when test="number(Hsp_hit-from) &gt; number(Hsp_hit-to)">
    <xsl:value-of select="number(Hsp_hit-from) - number(Hsp_hit-to)"/>
</xsl:when>
<xsl:otherwise>
    <xsl:value-of select="number(Hsp_hit-to) - number(Hsp_hit-from)"/>
</xsl:otherwise>
</xsl:choose>
<xsl:text>|ident:</xsl:text>
<xsl:value-of select="Hsp_identity"/>
<xsl:text>
</xsl:text>
<xsl:value-of select="translate(Hsp_hseq,' -','')"/>
<xsl:text>
</xsl:text>
</xsl:for-each>
</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
