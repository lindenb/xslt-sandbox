<?xml version='1.0' encoding="UTF-8"?>
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
        twitter: @yokofakun
Motivation:
	  for @EricCharp
      transforms the xmloutput of genbank-xml to gtf
      Tested with a simple genbank file (Herpes virus). Looks fine in IGV

-->

<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.1'
	>
<xsl:output method="text"  encoding="UTF-8"/>


<xsl:template match="/">
<xsl:apply-templates select="INSDSet"/>
</xsl:template>


<xsl:template match="INSDSet">
<xsl:apply-templates select="INSDSeq"/>
</xsl:template>

<xsl:template match="INSDSeq">
<xsl:apply-templates select=".//INSDInterval"/>
</xsl:template>


<xsl:template match="INSDInterval[../../INSDFeature_key/text()='CDS']">
<xsl:value-of select="../../../../INSDSeq_locus/text()"/>
<xsl:text>	.	cds	</xsl:text>
<xsl:choose>
	<xsl:when test="number(INSDInterval_from) &lt;= number(INSDInterval_to)">
		<xsl:value-of select="INSDInterval_from"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="INSDInterval_to"/>
		<xsl:text>	.	+	</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="INSDInterval_to"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="INSDInterval_from"/>
		<xsl:text>	.	-	</xsl:text>
	</xsl:otherwise>
</xsl:choose>
<xsl:text>0	</xsl:text>
<xsl:apply-templates select="../../INSDFeature_quals"/>
<xsl:text>
</xsl:text>
</xsl:template>


<xsl:template match="INSDInterval[../../INSDFeature_key/text()='gene']">
<xsl:value-of select="../../../../INSDSeq_locus/text()"/>
<xsl:text>	.	gene	</xsl:text>
<xsl:choose>
	<xsl:when test="number(INSDInterval_from) &lt;= number(INSDInterval_to)">
		<xsl:value-of select="INSDInterval_from"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="INSDInterval_to"/>
		<xsl:text>	.	+	</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="INSDInterval_to"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="INSDInterval_from"/>
		<xsl:text>	.	-	</xsl:text>
	</xsl:otherwise>
</xsl:choose>
<xsl:text>0	gene_id "</xsl:text>
<xsl:value-of select="../../INSDFeature_quals/INSDQualifier[INSDQualifier_name='gene']/INSDQualifier_value"/>
<xsl:text>";
</xsl:text>


<xsl:value-of select="../../../../INSDSeq_locus/text()"/>
<xsl:text>	.	transcript	</xsl:text>
<xsl:choose>
	<xsl:when test="number(INSDInterval_from) &lt;= number(INSDInterval_to)">
		<xsl:value-of select="INSDInterval_from"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="INSDInterval_to"/>
		<xsl:text>	.	+	</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="INSDInterval_to"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="INSDInterval_from"/>
		<xsl:text>	.	-	</xsl:text>
	</xsl:otherwise>
</xsl:choose>
<xsl:text>0	gene_id "</xsl:text>
<xsl:value-of select="../../INSDFeature_quals/INSDQualifier[INSDQualifier_name='gene']/INSDQualifier_value"/>
<xsl:text>";
</xsl:text>

</xsl:template>



<xsl:template match="INSDInterval">
</xsl:template>


<xsl:template match="INSDFeature_quals">
<xsl:apply-templates select="INSDQualifier"/>
</xsl:template>


<xsl:template match="INSDQualifier[INSDQualifier_name='gene']">
<xsl:text>gene_id "</xsl:text>
<xsl:value-of select="INSDQualifier_value"/>
<xsl:text>"; transcript_id "</xsl:text>
<xsl:value-of select="INSDQualifier_value"/>
<xsl:text>";</xsl:text> 
</xsl:template>

<xsl:template match="INSDQualifier">
</xsl:template>


</xsl:stylesheet>
