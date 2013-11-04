<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
	>

<!--


Author:
   Pierre Lindenbaum PhD plindenbaum@yahoo.fr


-->
<xsl:output method='text' encoding="UTF-8"/>


<xsl:template match="/">

create table if not exists Journal
	(
	nlmUniqueID  TEXT UNIQUE NOT NULL,
	medlineTA TEXT
	);


create table if not exists PubmedArticle
	(
	pmid INT UNIQUE NOT NULL,
	title TEXT,
	abstract TEXT,
	nlmUniqueID TEXT,
	FOREIGN KEY(nlmUniqueID ) REFERENCES Journal(nlmUniqueID)
	);

create table if not exists Author
	(
	lastName TEXT,
	foreName TEXT,
	pmid INT NOT NULL,
	position INT,
	FOREIGN KEY(pmid ) REFERENCES PubmedArticle(pmid)
	);

create unique index if not exists Author2Article on Author(lastName,foreName,pmid);
begin transaction;
<xsl:apply-templates select="PubmedArticleSet"/>
commit transaction;
</xsl:template>

<xsl:template match="PubmedArticleSet">
<xsl:apply-templates select="PubmedArticle"/>
</xsl:template>


<xsl:template match="PubmedArticle">
<xsl:apply-templates select="MedlineCitation/MedlineJournalInfo"/>
<xsl:variable name="pmid"><xsl:value-of select="MedlineCitation/PMID"/></xsl:variable>

<xsl:text>insert or ignore into PubmedArticle(pmid,title,abstract,nlmUniqueID) values (</xsl:text>
<xsl:call-template name="quote">
	<xsl:with-param name="s" select="$pmid"/>
</xsl:call-template>
<xsl:text>,</xsl:text>
<xsl:call-template name="quote">
	<xsl:with-param name="s" select="MedlineCitation/Article/ArticleTitle"/>
</xsl:call-template>
<xsl:text>,</xsl:text>
<xsl:call-template name="quote">
	<xsl:with-param name="s" select="MedlineCitation/Article/Abstract/AbstractText"/>
</xsl:call-template>
<xsl:text>,</xsl:text>
<xsl:call-template name="quote">
	<xsl:with-param name="s" select="MedlineCitation/MedlineJournalInfo/NlmUniqueID"/>
</xsl:call-template>
<xsl:text>);
</xsl:text>

<xsl:for-each select="MedlineCitation/Article/AuthorList/Author">
<xsl:text>insert or ignore into Author(lastName,foreName,pmid,position) values (</xsl:text>
<xsl:call-template name="quote">
	<xsl:with-param name="s" select="LastName"/>
</xsl:call-template>
<xsl:text>,</xsl:text>
<xsl:call-template name="quote">
	<xsl:with-param name="s" select="ForeName"/>
</xsl:call-template>
<xsl:text>,</xsl:text>
<xsl:call-template name="quote">
	<xsl:with-param name="s" select="$pmid"/>
</xsl:call-template>
<xsl:text>,</xsl:text>
<xsl:value-of select="position()"/>
<xsl:text>);
</xsl:text>
</xsl:for-each>


</xsl:template>

<xsl:template match="MedlineJournalInfo">
<xsl:text>insert or ignore into Journal(nlmUniqueID,medlineTA) values (</xsl:text>
<xsl:call-template name="quote">
	<xsl:with-param name="s" select="NlmUniqueID"/>
</xsl:call-template>
<xsl:text>,</xsl:text>
<xsl:call-template name="quote">
	<xsl:with-param name="s" select="MedlineTA"/>
</xsl:call-template>
<xsl:text>);
</xsl:text>
</xsl:template>

<xsl:template name="quote">
<xsl:param name="s"/>
<xsl:text>'</xsl:text>
<xsl:call-template name="escape">
	<xsl:with-param name="s" select="$s"/>
</xsl:call-template>
<xsl:text>'</xsl:text>
</xsl:template>


<xsl:template name="escape">
 <xsl:param name="s" />
 <xsl:variable name="a">&apos;</xsl:variable>

 <xsl:choose>
 <xsl:when test="contains($s,$a)">
       <xsl:value-of select="substring-before($s,$a)"/>
       <xsl:value-of select="$a"/>
       <xsl:value-of select="$a"/>
       <xsl:call-template name="escape">
	<xsl:with-param name="s" select="substring-after($s,$a)"/>
	</xsl:call-template>
 </xsl:when>
 <xsl:otherwise>
   <xsl:value-of select="$s"/>
 </xsl:otherwise>
 </xsl:choose>
</xsl:template>


</xsl:stylesheet>
