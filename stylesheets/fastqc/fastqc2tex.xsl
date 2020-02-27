<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="zzz"
	xmlns:date="http://exslt.org/dates-and-times"
	>
  <xsl:output method="text"/>
  <xsl:param name="title">TITLE</xsl:param>

<xsl:template match="html">\documentclass[11pt,twoside,a4paper]{article}
\usepackage{graphicx}
\usepackage{lscape}
\title{<xsl:value-of select="$title"/>}
\author{Pierre Lindenbaum}
\date{<xsl:value-of select="date:date-time()"/>}

\begin{document}
\maketitle
<xsl:apply-templates select="body/div/div[@class='module' and h2/text() = 'Basic Statistics']"/>
<xsl:call-template name="module">
	<xsl:with-param name="m" select="body/div/div[@class='module' and h2/text() = 'Per base sequence quality']"/>
	<xsl:with-param name="png">per_base_quality.png</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="module">
	<xsl:with-param name="m" select="body/div/div[@class='module' and h2/text() = 'Per tile sequence quality']"/>
	<xsl:with-param name="png">per_tile_quality.png</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="module">
	<xsl:with-param name="m" select="body/div/div[@class='module' and h2/text() = 'Per sequence quality scores']"/>
	<xsl:with-param name="png">per_sequence_quality.png</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="module">
	<xsl:with-param name="m" select="body/div/div[@class='module' and h2/text() = 'Per base sequence content']"/>
	<xsl:with-param name="png">per_base_sequence_content.png</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="module">
	<xsl:with-param name="m" select="body/div/div[@class='module' and h2/text() = 'Per sequence GC content']"/>
	<xsl:with-param name="png">per_sequence_gc_content.png</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="module">
	<xsl:with-param name="m" select="body/div/div[@class='module' and h2/text() = 'Per base N content']"/>
	<xsl:with-param name="png">per_base_n_content.png</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="module">
	<xsl:with-param name="m" select="body/div/div[@class='module' and h2/text() = 'Sequence Length Distribution']"/>
	<xsl:with-param name="png">sequence_length_distribution.png</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="module">
	<xsl:with-param name="m" select="body/div/div[@class='module' and h2/text() = 'Sequence Duplication Levels']"/>
	<xsl:with-param name="png">duplication_levels.png</xsl:with-param>
</xsl:call-template>


<xsl:apply-templates select="body/div/div[@class='module' and h2/text() = 'Overrepresented sequences']"/>

<xsl:call-template name="module">
	<xsl:with-param name="m" select="body/div/div[@class='module' and h2/text() = 'Adapter Content']"/>
	<xsl:with-param name="png">adapter_content.png</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="module">
	<xsl:with-param name="m" select="body/div/div[@class='module' and h2/text() = 'Kmer Content']"/>
	<xsl:with-param name="png">kmer_profiles.png</xsl:with-param>
</xsl:call-template>

\end{document}
</xsl:template>



<xsl:template match="div[@class='module']">
\section{<xsl:apply-templates select="h2/text()"/>}


	<xsl:apply-templates select="p/img|table|p"/>

</xsl:template>

<xsl:template name="module">
<xsl:param name="m"/>
<xsl:param name="png"/>
<xsl:if test="$m">
\begin{landscape}
\section{<xsl:apply-templates select="$m/h2/text()"/> <xsl:if test="$m/h2/img/@alt"> <xsl:value-of select="$m/h2/img/@alt"/></xsl:if>} 

\includegraphics[width=400px]{Images/<xsl:value-of select="$png"/>}
</xsl:if>
\end{landscape}
<xsl:apply-templates select="$m//table"/>
</xsl:template>


<xsl:template match="p|div">
<xsl:text>
</xsl:text>
<xsl:apply-templates/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="table">
<xsl:text>
\begin{tabular}{</xsl:text>
<xsl:for-each select="thead/tr/th"><xsl:if test="position()&gt;1">|</xsl:if>l</xsl:for-each>
<xsl:text>}
</xsl:text>
        <xsl:for-each select="thead/tr/th">
		<xsl:if test="position()&gt;1"> &amp; </xsl:if>
      		<xsl:apply-templates select="text()"/>
        </xsl:for-each>
<xsl:text>\\\hline
</xsl:text>
        <xsl:for-each select="tbody/tr">
	<xsl:for-each select="td">
		<xsl:if test="position()&gt;1"> &amp; </xsl:if>
      		<xsl:apply-templates select="text()"/>
        </xsl:for-each>
<xsl:text>\\
</xsl:text>
       </xsl:for-each>\end{tabular}
</xsl:template>

<xsl:template match="text()">
<xsl:value-of select="translate(.,'_%','  ')"/>
</xsl:template>

</xsl:stylesheet>
