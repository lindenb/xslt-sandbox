<?xml version='1.0' encoding="UTF-8"?>
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Motivation:
      transforms the xmloutput of uniprot-xml to FASTA

Usage :
      xsltproc uniprot2fasta.xsl uniprot.xml > file.fa
-->

<xsl:stylesheet
	xmlns:u="http://uniprot.org/uniprot"
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
	>
<xsl:output method="text"  encoding="UTF-8" />

<xsl:param name="W">70</xsl:param>
<xsl:variable name="w" select="number($W)"/>

<xsl:template match="/">
<xsl:apply-templates select="GBSet"/>
</xsl:template>


<xsl:template match="/">
<xsl:apply-templates select="u:uniprot"/>
</xsl:template>


<xsl:template match="u:uniprot">
<xsl:apply-templates select="u:entry"/>
</xsl:template>

<xsl:template match="u:entry">
<xsl:text>&gt;tr|</xsl:text>
<xsl:apply-templates select="u:accession[1]"/>
<xsl:text>|</xsl:text>
<xsl:apply-templates select="u:name"/>
<xsl:apply-templates select="u:organism"/>

<xsl:apply-templates select="u:gene"/>

<xsl:call-template name="seq">
<xsl:with-param name="s" select="normalize-space(translate(u:sequence,'&#10; ',''))"/>
</xsl:call-template>
<xsl:text>
</xsl:text>
</xsl:template>



<xsl:template match="u:accession">
<xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="u:gene">
<xsl:text> GN=</xsl:text>
<xsl:apply-templates select="u:name"/>
</xsl:template>

<xsl:template match="u:organism">
<xsl:text> O=</xsl:text>
<xsl:apply-templates select="u:name"/>
</xsl:template>

<xsl:template match="u:protein">
<xsl:apply-templates select="u:submittedName"/>
</xsl:template>

<xsl:template match="u:submittedName">
<xsl:apply-templates select="u:fullName"/>
</xsl:template>


<xsl:template match="u:fullName">
<xsl:text>protein:</xsl:text>
<xsl:value-of select="normalize-space(.)"/>
<xsl:text>|</xsl:text>
</xsl:template>

<xsl:template match="u:name">
<xsl:value-of select="normalize-space(.)"/>
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
