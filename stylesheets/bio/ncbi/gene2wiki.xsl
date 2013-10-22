<?xml version='1.0'  encoding="ISO-8859-1" ?>
<xsl:stylesheet
    xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
    version='1.0'
    >
<!--
Author:
    Pierre Lindenbaum PhD
Contact:
    http://plindenbaum.blogspot.com
    plindenbaum@yahoo.fr
Motivation:
    transforms ncbi gene to wiki
    
    
    
-->
<xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" />
<xsl:param name="ns"></xsl:param>
<xsl:param name="printinteractions">true</xsl:param>
<xsl:param name="printgo">true</xsl:param>
<xsl:param name="templatePrefix">Template:NcbiGene</xsl:param>
<xsl:variable name="nsPrefix">
	<xsl:choose>
		<xsl:when test="string-length($ns)&gt;0">
			<xsl:value-of select="concat($ns,':')"/>
		</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:variable>
<xsl:template match="/">
<xsl:apply-templates/>
</xsl:template>




<xsl:template match="Entrezgene-Set">
<xsl:apply-templates select="Entrezgene"/>
</xsl:template>

<xsl:template match="Entrezgene">
<xsl:variable name="geneId" select="Entrezgene_track-info/Gene-track/Gene-track_geneid"/>
<xsl:variable name="locus" select="Entrezgene_gene/Gene-ref/Gene-ref_locus"/>

<xsl:text>'''</xsl:text>
<xsl:value-of select="$locus"/>
<xsl:text>''' is a human gene. </xsl:text>
<xsl:value-of select="Entrezgene_summary"/>

<xsl:text>

==References==
</xsl:text>

<xsl:text>

==External links==
</xsl:text>

<xsl:text>* [</xsl:text>
<xsl:value-of select="concat('http://www.ncbi.nlm.nih.gov/gene/',$geneId)"/>
<xsl:text> NCBI Gene]
</xsl:text>

<xsl:apply-templates select="Entrezgene_gene"/>
<xsl:apply-templates select="Entrezgene_source"/>
<xsl:apply-templates select="Entrezgene_locus"/>

</xsl:template>



<xsl:template match="Entrezgene_gene">
<xsl:apply-templates select="Gene-ref"/>
</xsl:template>

<xsl:template match="Gene-ref">
<xsl:apply-templates select="Gene-ref_desc|Gene-ref_maploc|Gene-ref_syn|Gene-ref_db"/>
</xsl:template>

<xsl:template match="Gene-ref_desc">
<dt><xsl:text>Full Name</xsl:text></dt>
<dd><xsl:value-of select="."/></dd>
</xsl:template>

<xsl:template match="Gene-ref_maploc">
<dt><xsl:text>Location</xsl:text></dt>
<dd><xsl:value-of select="."/></dd>
</xsl:template>

<xsl:template match="Gene-ref_syn">
<dt><xsl:text>Other Names</xsl:text></dt>
<dd><xsl:for-each select="Gene-ref_syn_E">
<xsl:if test="position()&gt;1">
<xsl:text>, </xsl:text>
</xsl:if>
<xsl:value-of select="."/>
</xsl:for-each></dd>
</xsl:template>


<xsl:template match="Gene-ref_db">
<dt><xsl:text>Related</xsl:text></dt>
<dd><xsl:apply-templates select="Dbtag"/></dd>
</xsl:template>

<xsl:template match="Dbtag[Dbtag_db='HGNC']">
<xsl:for-each select="Dbtag_tag/Object-id/Object-id_id">
<xsl:text> [</xsl:text>
<xsl:value-of select="concat('http://www.genenames.org/data/hgnc_data.php?hgnc_id=',.)"/>
<xsl:text> </xsl:text>
<xsl:value-of select="concat('HGNC:',.)"/>
<xsl:text>]</xsl:text>
</xsl:for-each>
</xsl:template>

<xsl:template match="Dbtag[Dbtag_db='Ensembl']">
<xsl:for-each select="Dbtag_tag/Object-id/Object-id_id">
<xsl:text> [</xsl:text>
<xsl:value-of select="concat('http://www.ensembl.org/Homo_sapiens/geneview?gene=',.)"/>
<xsl:text> </xsl:text>
<xsl:value-of select="concat('Ensembl:',.)"/>
<xsl:text>]</xsl:text>
</xsl:for-each>
</xsl:template>

<xsl:template match="Dbtag[Dbtag_db='HPRD']">
<xsl:for-each select="Dbtag_tag/Object-id/Object-id_id">
<xsl:text> [</xsl:text>
<xsl:value-of select="concat('http://www.hprd.org/protein/',.)"/>
<xsl:text> </xsl:text>
<xsl:value-of select="concat('HPRD:',.)"/>
<xsl:text>]</xsl:text>
</xsl:for-each>

</xsl:template>

<xsl:template match="Dbtag[Dbtag_db='MIM']">
<xsl:for-each select="Dbtag_tag/Object-id/Object-id_id">
<xsl:text> [</xsl:text>
<xsl:value-of select="concat('http://www.ncbi.nlm.nih.gov/entrez/dispomim.cgi?id=',.)"/>
<xsl:text> </xsl:text>
<xsl:value-of select="concat('MIM:',.)"/>
<xsl:text>]</xsl:text>
</xsl:for-each>
</xsl:template>



<xsl:template match="Dbtag[Dbtag_db='Vega']">
<xsl:for-each select="Dbtag_tag/Object-id/Object-id_id">
<xsl:text> [</xsl:text>
<xsl:value-of select="concat('http://vega.sanger.ac.uk/id/',.)"/>
<xsl:text> </xsl:text>
<xsl:value-of select="concat('Vega',.)"/>
<xsl:text>]</xsl:text>
</xsl:for-each>
</xsl:template>


<xsl:template match="Dbtag">
<xsl:variable name="dbtag_db" select="Dbtag_db"/>
<xsl:for-each select="Dbtag_tag/Object-id/*">
<xsl:text> </xsl:text>
<xsl:value-of select="concat($dbtag_db,':',.)"/>
</xsl:for-each>
</xsl:template>





<xsl:template match="Entrezgene_locus">
<dt><xsl:text>Locus</xsl:text></dt>
<xsl:apply-templates select="Gene-commentary[Gene-commentary_type/@value='genomic']"/>
</xsl:template>


<xsl:template match="Gene-commentary">
<xsl:if test="Gene-commentary_accession">
<xsl:variable name="chromacn" select="Gene-commentary_accession"/>
<xsl:variable name="chrom">
	<xsl:apply-templates select="Gene-commentary_accession" mode="chromosome"/>
</xsl:variable>
<xsl:for-each select="Gene-commentary_seqs/Seq-loc/Seq-loc_int/Seq-interval">
	<xsl:variable name="chromStart" select="number(Seq-interval_from)+1"/>
	<xsl:variable name="chromEnd" select="number(Seq-interval_to)+1"/>
	<dd>
	<xsl:choose>
		<xsl:when test="string-length($chrom)=0">
			<xsl:value-of select="$chromacn"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="$chromStart"/>
			<xsl:text>-</xsl:text>
			<xsl:value-of select="$chromEnd"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>[http://genome.ucsc.edu/cgi-bin/hgTracks?org=Human&amp;db=hg19&amp;position=chr</xsl:text>
			<xsl:value-of select="$chrom"/>
			<xsl:text>%3A</xsl:text>
			<xsl:value-of select="$chromStart"/>
			<xsl:text>-</xsl:text>
			<xsl:value-of select="$chromEnd"/>
			<xsl:text> </xsl:text>
			
			<xsl:text>chr</xsl:text>
			<xsl:value-of select="$chrom"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="$chromStart"/>
			<xsl:text>-</xsl:text>
			<xsl:value-of select="$chromEnd"/>
			<xsl:text>]</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	</dd>
</xsl:for-each>

</xsl:if>

</xsl:template>


<xsl:template match="Gene-commentary_accession" mode="chromosome">
<xsl:choose>
	<xsl:when test="starts-with(.,'NC_000023')">
		<xsl:text>X</xsl:text>
	</xsl:when>
	<xsl:when test="starts-with(.,'NC_000024')">
		<xsl:text>Y</xsl:text>
	</xsl:when>
	<xsl:when test="starts-with(.,'NC_0000')">
		<xsl:value-of select="number(substring-after(.,'_'))"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text></xsl:text>
	</xsl:otherwise>
</xsl:choose>	
</xsl:template>


<xsl:template match="Gene-commentary" mode="pagego">
<xsl:if test="$printgo='true'">
<xsl:text>
==Gene Ontology==
</xsl:text>
<xsl:for-each select="Gene-commentary_comment/Gene-commentary/Gene-commentary_comment/Gene-commentary/Gene-commentary_source[Other-source/Other-source_src/Dbtag/Dbtag_db='GO']">
<xsl:if test="position()&gt;1"><xsl:text>, </xsl:text></xsl:if>
<xsl:text>[[:Category:GO:</xsl:text>
<xsl:call-template name="gopadding">
<xsl:with-param name="s" select="Other-source/Other-source_src/Dbtag/Dbtag_tag/Object-id/Object-id_id"/>
</xsl:call-template>
<xsl:text>|</xsl:text>
<xsl:value-of select="Other-source/Other-source_anchor"/>
<xsl:text>]]</xsl:text>
</xsl:for-each>
<xsl:text>.
</xsl:text>
</xsl:if>
</xsl:template>


<xsl:template match="Gene-commentary" mode="go">
<xsl:for-each select="Gene-commentary_comment/Gene-commentary/Gene-commentary_comment/Gene-commentary/Gene-commentary_source">
<xsl:if test="Other-source/Other-source_src/Dbtag/Dbtag_db='GO'">
<xsl:text>
[[Category:GO:</xsl:text>
<xsl:call-template name="gopadding">
<xsl:with-param name="s" select="Other-source/Other-source_src/Dbtag/Dbtag_tag/Object-id/Object-id_id"/>
</xsl:call-template>
<xsl:text>]]</xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:template>

<xsl:template match="Gene-commentary" mode="ppi">
<xsl:variable name="interactors" select="Gene-commentary_comment//Gene-commentary/Gene-commentary_source/Other-source[Other-source_src/Dbtag/Dbtag_db='GeneID']"/>
<xsl:if test="count($interactors)&gt;0 and $printinteractions='true'">
<xsl:text>
==Interactions==
</xsl:text>
<xsl:element name="span">
<xsl:if test="count($interactors)&gt;10">
<xsl:attribute name="style">font-size: smaller;</xsl:attribute>
</xsl:if>
<xsl:for-each select="$interactors">
<xsl:sort select="Other-source_anchor"/>
<xsl:choose>
  <xsl:when test="position()=1 and position()=last()"/>
  <xsl:when test="position()=last()">
     <xsl:text> and </xsl:text>
  </xsl:when>
  <xsl:when test="position()=1"/>
  <xsl:otherwise>
  	<xsl:text>, </xsl:text>
  </xsl:otherwise>
</xsl:choose>

<xsl:text>[[</xsl:text>
<xsl:value-of select="concat($nsPrefix,Other-source_anchor)"/>
<xsl:text>|</xsl:text>
<xsl:value-of select="Other-source_anchor"/>
<xsl:text>]]</xsl:text>
</xsl:for-each>
</xsl:element>
</xsl:if>
</xsl:template>

<xsl:template name="gopadding">
<xsl:param name="s"/>
<xsl:choose>
	<xsl:when test="string-length($s) &lt; 7">
		<xsl:call-template name="gopadding">
			<xsl:with-param name="s" select="concat('0',$s)"/>
		</xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="$s"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>

