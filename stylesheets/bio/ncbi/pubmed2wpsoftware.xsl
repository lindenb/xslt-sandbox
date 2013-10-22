<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
	>
<xsl:param name="layout">ref</xsl:param>
<!--


Author:
   Pierre Lindenbaum PhD plindenbaum@yahoo.fr

WWW:
   http://plindenbaum.blogspot.com

Motivation:
   creates a stub for an article about a http://en.wikipedia.org/wiki/Biological_database
See also:
      http://www.oxfordjournals.org/nar/database/cap/
      http://en.wikipedia.org/wiki/Template:Infobox_biodatabase
      http://en.wikipedia.org/wiki/Template:Citation

Usage:
   xsltproc pubmed4biodb.xsl "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=19846593&retmode=xml

-->
<xsl:output method='text' encoding="UTF-8"/>


<xsl:template match="/">
&lt;!-- 
Generated with pubmed2wpsoftware.xsl
Author: Pierre Lindenbaum PhD.
plindenbaum@yahoo.fr 
http://en.wikipedia.org/wiki/User:Plindenbaum
--&gt;
<xsl:text>



</xsl:text>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="PubmedArticleSet">
<xsl:apply-templates select="PubmedArticle"/>
</xsl:template>

<xsl:template match="PubmedArticle">
{{Orphan}}
<xsl:apply-templates select="." mode="infobox"/>
<xsl:value-of select="MedlineCitation/Article/Abstract/AbstractText"/>
<xsl:apply-templates select="." mode="cite"/>
<xsl:text>
==References==
&lt;references/&gt;
</xsl:text>
<xsl:if test="MedlineCitation/MeshHeadingList/MeshHeading/DescriptorName[@MajorTopicYN='Y']">
<xsl:text>
==See also==</xsl:text>
<xsl:for-each select="MedlineCitation/MeshHeadingList/MeshHeading/DescriptorName[@MajorTopicYN='Y']">
<xsl:text>
* [[</xsl:text>
<xsl:value-of select="."/>
<xsl:text>]]</xsl:text>
</xsl:for-each>
</xsl:if>
<xsl:text>
==External links==
* </xsl:text><xsl:call-template name="url"><xsl:with-param name="s" select="MedlineCitation/Article/Abstract/AbstractText"/></xsl:call-template><xsl:text>

{{Software-stub}}

[[Category:Bioinformatics algorithms]]
[[Category:Computational phylogenetics]]
[[Category:Bioinformatics software]]
[[Category:Laboratory software]]
[[Category:Public domain software]]


{{Wikiproject MCB|class=Stub|importance=low}}
{{WikiProject Computational Biology|importance=low|class=stub}}
</xsl:text>

</xsl:template>

<xsl:template match="PubmedArticle" mode="infobox">{{Infobox software
|title = <xsl:value-of select="MedlineCitation/Article/ArticleTitle"/>
|logo = | screenshot = | caption = | collapsible =
|description = <xsl:value-of select="MedlineCitation/Article/ArticleTitle"/>
|author = <xsl:value-of select="MedlineCitation/Article/AuthorList/Author[1]/ForeName"/><xsl:text> </xsl:text> <xsl:value-of select="MedlineCitation/Article/AuthorList/Author[1]/LastName"/>
|developer=
|released = <xsl:value-of select="MedlineCitation/Article/ArticleDate/Year"/>
| discontinued=
| latest release version = 
| latest release date    = <!-- {{Start date and age|YYYY|MM|DD|df=yes/no}} -->
| latest preview version = 
| latest preview date    = <!-- {{Start date and age|YYYY|MM|DD|df=yes/no}} -->
| frequently updated     = <!-- DO NOT include this parameter unless you know what it does -->
| programming language   = 
| operating system       = 
| platform               = 
| size                   = 
| language               = 
| status                 = 
| genre                  = 
| license                = 
| website = <xsl:call-template name="url"><xsl:with-param name="s" select="MedlineCitation/Article/Abstract/AbstractText"/></xsl:call-template>
}}</xsl:template>

<xsl:template match="PubmedArticle" mode="cite">
<xsl:text>&lt;ref name="pmid</xsl:text>
<xsl:value-of select="MedlineCitation/PMID"/>
<xsl:text>"&gt;{{cite journal | quotes = yes</xsl:text>
<xsl:apply-templates select="MedlineCitation/Article/AuthorList"/>
<xsl:apply-templates select="MedlineCitation/Article/Journal/JournalIssue/PubDate"/>
<xsl:apply-templates select="MedlineCitation/Article/ArticleTitle"/>
<xsl:text>|journal = </xsl:text>
<xsl:choose>
   <xsl:when test="MedlineCitation/Article/Journal/ISOAbbreviation">
      <xsl:apply-templates select="MedlineCitation/Article/Journal/ISOAbbreviation"/>
   </xsl:when>
   <xsl:otherwise>
      <xsl:apply-templates select="MedlineCitation/Article/Journal/Title"/>
   </xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="MedlineCitation/Article/Journal/JournalIssue"/>
<xsl:apply-templates select="MedlineCitation/Article/Pagination"/>
<xsl:text>|publisher= |location = </xsl:text>
<xsl:value-of  select="MedlineCitation/MedlineJournalInfo/Country"/>
<xsl:text>| issn = </xsl:text>
<xsl:value-of select="MedlineCitation/Article/Journal/ISSN[@IssnType=&apos;Print&apos;]"/>
<xsl:apply-templates select="MedlineCitation/PMID"/>
<xsl:apply-templates select="PubmedData/ArticleIdList/ArticleId[@IdType=&apos;doi&apos;]"/>
<xsl:text>| bibcode = | oclc =| id = | url = | </xsl:text>
<xsl:if test="PubmedData/ArticleIdList/ArticleId/@IdType='pmc'">
<xsl:variable name="pmc" select="PubmedData/ArticleIdList/ArticleId[@IdType='pmc']"/>
<xsl:variable name="pmc2">
<xsl:choose>
	<xsl:when test="starts-with($pmc,'PMC')">
		<xsl:value-of select="substring($pmc,4)"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="$pmc"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:value-of select="concat('pmc =',$pmc2,' |')"/>
</xsl:if>
<xsl:text>language = </xsl:text>
<xsl:value-of name="lang" select="MedlineCitation/Article/Language"/>
<xsl:text>| format = | accessdate = | laysummary = | laysource = | laydate = | quote = }}&lt;/ref&gt;</xsl:text>
 </xsl:template>



<xsl:template match="PMID">
<xsl:text>| pmid = </xsl:text>
<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="ArticleId[@IdType=&apos;doi&apos;]">
<xsl:text>|doi = </xsl:text><xsl:value-of select="."/>
</xsl:template>

<xsl:template match="AuthorList">
<xsl:if test="count(Author)&gt;0">
<xsl:text>|last=</xsl:text>
<xsl:value-of select="Author[1]/LastName"/>
<xsl:text>|first=</xsl:text>
<xsl:value-of select="Author[1]/ForeName"/>
<xsl:text>|authorlink=</xsl:text>
</xsl:if>
<xsl:if test="count(Author)&gt;1">
<xsl:text>|coauthors=</xsl:text>
<xsl:for-each select="Author">
   <xsl:if test="position()&gt;1">
      <xsl:value-of select="LastName"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="ForeName"/>
      <xsl:if test="position()!=last()">
         <xsl:text>, </xsl:text>
      </xsl:if>
   </xsl:if>
</xsl:for-each>
</xsl:if>
</xsl:template>

<xsl:template match="PubDate">
<xsl:text>|year=</xsl:text>
<xsl:value-of select="Year"/>
<xsl:text>|month=</xsl:text>
<xsl:value-of select="Month"/>
</xsl:template>


<xsl:template match="ArticleTitle">
<xsl:text>|title=</xsl:text>
<xsl:choose>
   <xsl:when test="substring(.,string-length(.))='.'">
      <xsl:value-of select="substring(.,1,string-length(.)-1)"/>
   </xsl:when>
   <xsl:otherwise>
     <xsl:value-of select="."/>
   </xsl:otherwise>
</xsl:choose>
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


<xsl:template name="url">
<xsl:param name="s"/>
<xsl:if test="contains($s,'http://')">
  <xsl:variable name="s1" select="concat('http://',substring-after($s,'http://'))"/>
  <xsl:variable name="s2" select="translate($s1,'),;','   ')"/>
  <xsl:variable name="s3">
     <xsl:choose>
       <xsl:when test="contains($s2,' ')">
          <xsl:value-of select="substring-before($s2,' ')"/>
       </xsl:when>
       <xsl:otherwise>
          <xsl:value-of select="$s2"/>
       </xsl:otherwise>
     </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$s3"/>
</xsl:if>
</xsl:template>

</xsl:stylesheet>
