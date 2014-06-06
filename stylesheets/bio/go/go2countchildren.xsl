<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:g='http://www.gexf.net/1.2draft'
	xmlns:go="http://www.geneontology.org/dtds/go.dtd#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        version='1.0'
        >
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Motivation:
      get the terminal nodes in GO/rdf+xml
Reference:
    https://www.biostars.org/p/102699/
Usage :
      curl  "http://archive.geneontology.org/latest-termdb/go_daily-termdb.rdf-xml.gz" |\
	gunzip -c |\
	xsltproc -\-novalid go2countchildren.xsl go.rdf > count.tsv
-->

<xsl:output method="text" />

<xsl:template match="/">
<xsl:variable name="total" select="count(//go:term)"/>
<xsl:text>#ACN	NAME	CHILDREN
</xsl:text>
  <xsl:for-each select="//go:term">
    
    <xsl:variable name="uri" select="@rdf:about"/>
    <xsl:message terminate="no"><xsl:value-of select="go:accession"/><xsl:text>	</xsl:text><xsl:value-of select="position()"/>/<xsl:value-of select="$total"/></xsl:message>
    <xsl:variable name="children" select="count(//go:term[go:is_a/@rdf:resource=$uri])"/>
    <xsl:value-of select="go:accession"/>
    <xsl:text>	</xsl:text>
    <xsl:value-of select="go:name"/>
    <xsl:text>	</xsl:text>
    <xsl:value-of select="$children"/>
    <xsl:text>
</xsl:text>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
