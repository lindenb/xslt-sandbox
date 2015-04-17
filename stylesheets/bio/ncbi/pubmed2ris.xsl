<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
	>

<!--


Author:
   Pierre Lindenbaum PhD plindenbaum@yahoo.fr
Motivation:
	convert pubmed XML to RIS http://www.researcherid.com/resources/html/help_upload.htm

-->
<xsl:output method='text' encoding="UTF-8"/>


<xsl:template match="/">
<xsl:apply-templates select="PubmedArticleSet"/>
</xsl:template>

<xsl:template match="PubmedArticleSet">
<xsl:apply-templates select="PubmedArticle"/>
</xsl:template>


<xsl:template match="PubmedArticle">

<xsl:text>TY  - JOUR
</xsl:text>
<xsl:apply-templates select="MedlineCitation/Article/AuthorList/Author"/>
<xsl:apply-templates select="MedlineCitation/Article/ArticleTitle"/>
<xsl:apply-templates select="MedlineCitation/Article/Journal/JournalIssue/PubDate/Year"/>
<xsl:apply-templates select="MedlineCitation/Article/Journal/Title"/>
<xsl:text>ER  -

</xsl:text>
</xsl:template>



<xsl:template match="ArticleTitle">
<xsl:text>T1  - </xsl:text>
<xsl:value-of select="normalize-space(text())"/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="Author">
<xsl:text>A1  - </xsl:text>
<xsl:value-of select="LastName"/>
<xsl:text>,</xsl:text>
<xsl:value-of select="ForeName"/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="Volume">
<xsl:text>VL  - </xsl:text>
<xsl:value-of select="normalize-space(text())"/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="Title">
<xsl:text>JO  - </xsl:text>
<xsl:value-of select="normalize-space(text())"/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="Year">
<xsl:text>Y1  - </xsl:text>
<xsl:value-of select="normalize-space(text())"/>
<xsl:text>
</xsl:text>
</xsl:template>


</xsl:stylesheet>
