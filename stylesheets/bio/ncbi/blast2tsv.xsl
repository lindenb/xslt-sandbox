<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">
<!--
Author
    Pierre Lindenbaum PhD
Mail:
    plindenbaum@yahoo.fr
Motivation:
    http://biostar.stackexchange.com/questions/7313
    transforms a blast xml result to TSV
Example:
    xsltproc -\-novalid blast2tsv.xsl blast.xml

-->
<!-- ========================================================================= -->
  <xsl:output method="text"/>
  <xsl:template match="/">
    <xsl:apply-templates select="BlastOutput"/>
  </xsl:template>
  <xsl:template match="BlastOutput">
    <xsl:variable name="queryDef" select="BlastOutput_query-def"/>
    <xsl:variable name="queryLen" select="BlastOutput_query-len"/>
    <xsl:for-each select="BlastOutput_iterations/Iteration/Iteration_hits/Hit">
      <xsl:variable name="hitDef" select="Hit-def"/>
      <xsl:variable name="hitLen" select="Hit-len"/>
      <xsl:for-each select="Hit_hsps/Hsp">
        <xsl:value-of select="$queryDef"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="$queryLen"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="$hitDef"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="$hitLen"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_bit-score"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_evalue"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_query-from"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_query-to"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_hit-from"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_hit-to"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_query-frame"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_hit-frame"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_identity"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_positive"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_gaps"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_align-len"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_qseq"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_hseq"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="Hsp_midline"/>
        <xsl:text>
</xsl:text>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>