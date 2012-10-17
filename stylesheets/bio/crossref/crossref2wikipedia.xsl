<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:x="http://exslt.org/dates-and-times"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="x"
	version='1.0'
	>
<xsl:param name="layout">ref</xsl:param>
<!--


Author:
   Pierre Lindenbaum PhD plindenbaum@yahoo.fr

WWW:
   http://plindenbaum.blogspot.com


Usage:
	curl -L  -H   "Accept: application/unixref+xml" "http://dx.doi.org/10.1038/nature11543" |\
	xsltproc crossref2wikipedia.xsl -
	
-->
<xsl:output method='text' encoding="UTF-8"/>


<xsl:template match="/">

<xsl:text>



</xsl:text>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="doi_records">
<xsl:apply-templates select="doi_record"/>
</xsl:template>

<xsl:template match="doi_record">
<xsl:apply-templates select="crossref/journal/journal_article"/>
</xsl:template>


<xsl:template match="journal_article">
<xsl:text>

==Genetics==
The genome of ''{{PAGENAME}}''' was sequenced in </xsl:text>
<xsl:value-of select="publication_date/year"/>
<xsl:text>.&lt;ref&gt;</xsl:text>
<xsl:apply-templates select="." mode="cite"/>
<xsl:text>.&lt;/ref&gt;{{Expand section|date=</xsl:text>
<xsl:value-of select="x:month-name()"/>
<xsl:text> </xsl:text>
<xsl:value-of select="x:year()"/>
<xsl:text>}}


[[Category:Sequenced genomes]]


</xsl:text>

</xsl:template>

<xsl:template match="journal_article" mode="cite">
<xsl:text>{{cite journal |quotes = yes</xsl:text>
<xsl:apply-templates select="contributors"/>
<xsl:apply-templates select="publication_date[position()=last()]"/>
<xsl:apply-templates select="titles/title[1]"/>
<xsl:text>|journal = </xsl:text>
<xsl:apply-templates select="../journal_metadata/full_title"/>
<xsl:text>|publisher= |location = </xsl:text>
<xsl:text>|issn = </xsl:text>
<xsl:value-of select="../journal_metadata/issn[1]"/>
<xsl:apply-templates select="doi_data/doi"/>
<xsl:text>|url =</xsl:text>
<xsl:apply-templates select="doi_data/resource"/>
<xsl:text>|language = </xsl:text>
<xsl:text>|format = | accessdate = </xsl:text>
<xsl:value-of select="../../../../doi_record/@timestamp"/>
<xsl:text>}}</xsl:text>
 </xsl:template>




<xsl:template match="doi">
<xsl:text>|doi = </xsl:text>
<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="contributors">
<xsl:for-each select="person_name[@sequence='first']">
<xsl:text>|last=</xsl:text>
<xsl:value-of select="surname"/>
<xsl:text>|first=</xsl:text>
<xsl:value-of select="given_name"/>
<xsl:text>|authorlink=</xsl:text>
</xsl:for-each>
<xsl:text>|coauthors=</xsl:text>
<xsl:for-each select="person_name[@sequence='additional' and  @contributor_role='author']">
<xsl:value-of select="surname"/>
<xsl:text> </xsl:text>
<xsl:value-of select="given_name"/>
<xsl:if test="position()!=last()">
 <xsl:text>, </xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:template>


<xsl:template match="publication_date">
<xsl:text>|year=</xsl:text>
<xsl:value-of select="year"/>
<xsl:text>|month=</xsl:text>
<xsl:value-of select="month"/>
</xsl:template>


<xsl:template match="title">
<xsl:text>|title=</xsl:text>
<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="JournalIssue">
<xsl:text>|volume=</xsl:text>
<xsl:value-of select="Volume"/>
<xsl:text>|issue=</xsl:text>
<xsl:value-of select="Issue"/>
</xsl:template>


<xsl:template match="Pagination">
<xsl:text>|pages=</xsl:text>
<xsl:value-of select="MedlinePgn"/>
</xsl:template>



</xsl:stylesheet>
