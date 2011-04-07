<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
 version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:svg="http://www.w3.org/2000/svg"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns="http://www.w3.org/1999/xhtml"
 >
<!--
Author
	Pierre Lindenbaum PhD
Mail:
	plindenbaum@yahoo.fr
Motivation:
	transforms a blast xml result to HTML
Example:
	xsltproc -\-novalid blast2html.xsl blast.xml
Reference:
	http://biostar.stackexchange.com/questions/6658

-->
<!-- ========================================================================= -->
<xsl:output method='xml' indent='no' omit-xml-declaration="no"/>


<xsl:variable name="fastaLength" select="60"/>
<xsl:variable name="fill"><xsl:text>                                           </xsl:text></xsl:variable>
<xsl:template match="/">
<html>
<xsl:apply-templates select="BlastOutput"/>
</html>
</xsl:template>

<xsl:template match="BlastOutput">
<head>
	<title>
	<xsl:value-of select="BlastOutput_query-def"/>
	</title>
</head>
<body>
<div>
<h1>
<xsl:text>Blast Results</xsl:text>
</h1>
<xsl:comment>Generated with blast2html (c) Pierre Lindenbaum PhD http://plindenbaum.blogspot.com</xsl:comment>
<dl>
	<dt>Program</dt>
	<dd><xsl:value-of select="BlastOutput_program"/></dd>
	<dt>Version</dt>
	<dd><xsl:value-of select="BlastOutput_version"/></dd>
	<dt>Reference</dt>
	<dd><xsl:value-of select="BlastOutput_reference"/></dd>
	<dt>Database</dt>
	<dd><xsl:value-of select="BlastOutput_db"/></dd>
	<dt>Query-Id</dt>
	<dd><xsl:value-of select="BlastOutput_query-ID"/></dd>
	<dt>Query-Def</dt>
	<dd><xsl:value-of select="BlastOutput_query-def"/></dd>
	<dt>Query-Length</dt>
	<dd><xsl:value-of select="BlastOutput_query-len"/></dd>
</dl>
<xsl:apply-templates select="BlastOutput_iterations" mode="table"/>
<xsl:apply-templates select="BlastOutput_iterations"/>
</div>
</body>
</xsl:template>

<xsl:template match="BlastOutput_iterations" mode="table">
<div>
<h2>Descriptions</h2>
<table>
<tr>
	<th>Accession</th>
	<th>Def</th>
	<th>e-value</th>
</tr>
<xsl:for-each select="Iteration/Iteration_hits/Hit">
<xsl:variable name="acn" select="Hit_accession"/>
<xsl:variable name="def" select="Hit_def"/>
<xsl:for-each select="Hit_hsps/Hsp">
<tr>
	<td><xsl:value-of select="$acn"/></td>
	<td><xsl:value-of select="$def"/></td>
	<td>
		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:value-of select="concat('#',generate-id(.))"/></xsl:attribute>
			<xsl:value-of select="Hsp_evalue"/>
		</xsl:element>
	</td>
</tr>
</xsl:for-each>
</xsl:for-each>
</table>
</div>
</xsl:template>

<xsl:template match="BlastOutput_param">
<xsl:apply-templates select="Parameters"/>
</xsl:template>

<xsl:template match="BlastOutput_iterations">
<div>
<h2>Alignments</h2>
<xsl:for-each select="Iteration/Iteration_hits/Hit">
<div>
<div><xsl:text>&gt;</xsl:text>
<xsl:value-of select="Hit_id"/>
<xsl:text>|</xsl:text>
<xsl:value-of select="Hit_accession"/>
<xsl:text>|</xsl:text>
<xsl:value-of select="Hit_def"/>
<br/>
<xsl:text>Length=</xsl:text>
<xsl:value-of select="Hit_len"/>
</div>
<xsl:for-each select="Hit_hsps/Hsp">
<div>
<xsl:element name="a">
	<xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
</xsl:element>
<xsl:text>Score = </xsl:text>
<xsl:value-of select="Hsp_bit-score"/>
<xsl:text> bits (</xsl:text>
<xsl:value-of select="Hsp_score"/>
<xsl:text>), Expect = </xsl:text>
<xsl:value-of select="Hsp_evalue"/>
<br/>
<xsl:text>Identities = </xsl:text>
<xsl:value-of select="Hsp_identity"/>
<xsl:text>/</xsl:text>
<xsl:value-of select="Hsp_align-len"/>
<xsl:text> (</xsl:text>
<xsl:value-of select="100.0 * (number(Hsp_identity) div number(Hsp_align-len))"/>
<xsl:text>%), Gaps = </xsl:text>
<xsl:value-of select="Hsp_gaps"/>
<xsl:text>/</xsl:text>
<xsl:value-of select="Hsp_align-len"/>
<xsl:text> (</xsl:text>
<xsl:value-of select="100.0 * (number(Hsp_gaps) div number(Hsp_align-len))"/>
<xsl:text>%)</xsl:text>
<br/>
<xsl:text>Strand = </xsl:text>
<xsl:choose>
	<xsl:when test="number(Hsp_hit-from) &lt; number(Hsp_hit-to)">
		<xsl:text>Plus/Plus</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>Plus/Minus</xsl:text>
	</xsl:otherwise>
</xsl:choose>
<pre>
<xsl:call-template name="print">
	<xsl:with-param name="node" select="."/>
	<xsl:with-param name="index" select="number(1)"/>
	<xsl:with-param name="q" select="number(Hsp_query-from)"/>
	<xsl:with-param name="h" select="number(Hsp_hit-from)"/>
	<xsl:with-param name="orient">
		<xsl:choose>
			<xsl:when test="number(Hsp_hit-from) &lt; number(Hsp_hit-to)">
				<xsl:text>+</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>-</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:with-param>
</xsl:call-template>
</pre>
</div>
</xsl:for-each>
</div>
</xsl:for-each>
</div>
</xsl:template>

<xsl:template match="BlastOutput_param">
<xsl:apply-templates select="Parameters"/>
</xsl:template>





<xsl:template name="print">
<xsl:param name="node" />
<xsl:param name="index"/>
<xsl:param name="q"/>
<xsl:param name="h"/>
<xsl:param name="orient"/>
<xsl:if test="$index  &lt; number($node/Hsp_align-len)">

<xsl:variable name="qS" select="substring($node/Hsp_qseq,$index,$fastaLength)"/>
<xsl:variable name="qL" select="string-length(translate($qS,' -',''))"/>
<xsl:variable name="hS" select="substring($node/Hsp_hseq,$index,$fastaLength)"/>
<xsl:variable name="hL" select="string-length(translate($hS,' -',''))"/>
<xsl:variable name="mS" select="substring($node/Hsp_midline,$index,$fastaLength)"/>

<br/>
<xsl:text>Query </xsl:text>
<xsl:value-of select="$q"/>
<xsl:value-of select="substring($fill,1,9 - string-length($q))"/>
<xsl:value-of select="$qS"/>
<xsl:text> </xsl:text>
<xsl:value-of select="$q + $qL - 1"/>
<br/>
<xsl:text>      </xsl:text>
<xsl:value-of select="substring($fill,1,9)"/>
<xsl:value-of select="$mS"/>
<br/>
<xsl:text>Sbjct </xsl:text>
<xsl:value-of select="$h"/>
<xsl:value-of select="substring($fill,1,9 - string-length($h))"/>
<xsl:value-of select="$hS"/>
<xsl:text> </xsl:text>
<xsl:choose>
	<xsl:when test="$orient='+'">
		<xsl:value-of select="$h + $hL -1"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="$h - $hL +1"/>
	</xsl:otherwise>
</xsl:choose>
<br/>

<xsl:call-template name="print">
	<xsl:with-param name="node" select="."/>
	<xsl:with-param name="q" select="$q + $qL  "/>
	<xsl:with-param name="h">
		<xsl:choose>
			<xsl:when test="$orient='+'">
				<xsl:value-of select="$h + $hL  "/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$h - $hL  "/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:with-param>
	<xsl:with-param name="index" select="$index+ $fastaLength "/>
	<xsl:with-param name="orient" select="$orient"/>
</xsl:call-template>
</xsl:if>
</xsl:template>


<xsl:template match="Parameters">
<div>
<dl>
	<dt>Expect</dt>
	<dd><xsl:value-of select="Parameters_expect"/></dd>
	<dt>Score-Match</dt>
	<dd><xsl:value-of select="Parameters_sc-match"/></dd>
	<dt>Score-Mismatch</dt>
	<dd><xsl:value-of select="Parameters_sc-mismatch"/></dd>
	<dt>Gap-Open</dt>
	<dd><xsl:value-of select="Parameters_gap-open"/></dd>
	<dt>Gap-Extend</dt>
	<dd><xsl:value-of select="Parameters_gap-extend"/></dd>
	<dt>Filter</dt>
	<dd><xsl:value-of select="Parameters_filter"/></dd>
</dl>
</div>
</xsl:template>

</xsl:stylesheet>