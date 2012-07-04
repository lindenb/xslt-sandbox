<?xml version='1.0'  encoding="ISO-8859-1" ?>
<xsl:stylesheet
	xmlns:h="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
	>
<xsl:output method="text" encoding="UTF-8" />

<xsl:template match="/documentation">
<xsl:text>\documentclass[12pt]{article}
\usepackage{hyperref}
\usepackage{graphicx}
\usepackage{color}
\title{The Variation Toolkit}
\author{Pierre Lindenbaum PhD.
\\
\\Institut du Thorax\\INSERM UMR-915\\44000 Nantes - France\\
\\
\texttt{plindenbaum@yahoo.fr}\\ \url{http://plindenbaum.blogspot.com}\\ \url{https://twitter.com/yokofakun}
\\
}
\date{\today}



\begin{document}
\maketitle

%%\begin{abstract}
%%C++ tools for the interpretations of NGS data.
%%\end{abstract}
\cleardoublepage
</xsl:text>
<xsl:apply-templates select="page"/>
\bibliographystyle{abbrv}
\bibliography{varkit}

\end{document}
</xsl:template> 

<xsl:template match="page">
<xsl:text>
\section{</xsl:text>
<xsl:apply-templates select="@title"/>
<xsl:text>}
</xsl:text>
<xsl:if test="@desc">
<xsl:apply-templates select="@desc"/><xsl:text>\\
</xsl:text>
</xsl:if>
<xsl:apply-templates/>
</xsl:template> 

<xsl:template match="@*">
<xsl:call-template name="escapetex">
 <xsl:with-param name="s" select="."/>
</xsl:call-template>
</xsl:template>

<xsl:template match="text()">
<xsl:call-template name="escapetex">
 <xsl:with-param name="s" select="."/>
</xsl:call-template>
</xsl:template>

<xsl:template match="cite">
<xsl:text>      </xsl:text>
<xsl:value-of select="."/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="br">
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="pmid">
<xsl:value-of select="concat('[http://www.ncbi.nlm.nih.gov/pubmed/',.,' pmid:',.,']')"/>
</xsl:template>

<xsl:template match="url">
<xsl:value-of select="concat('[',.,' ',.,']')"/>
</xsl:template>

<xsl:template match="img">
<xsl:value-of select="concat('[',@src,']')"/>
</xsl:template>

<xsl:template match="pre">
<xsl:text>
\begin{quote}
\begin{verbatim}
</xsl:text>
<xsl:value-of select="."/>
<xsl:text>
\end{verbatim}
\end{quote}
</xsl:text>
</xsl:template>

<xsl:template match="span">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="div">
<xsl:text>
</xsl:text>
<xsl:apply-templates/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="ul">
<xsl:text>
\begin{itemize}
</xsl:text>
<xsl:for-each select="li">
<xsl:text>\item</xsl:text>
<xsl:apply-templates/>
<xsl:text>
</xsl:text>
</xsl:for-each>
<xsl:text>
\end{itemize}
</xsl:text>
</xsl:template>

<xsl:template match="code">
<xsl:text>`</xsl:text>
<xsl:value-of select="."/>
<xsl:text>`</xsl:text>
</xsl:template>

<xsl:template match="b">
<xsl:text>\textbf{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="i">
<xsl:text>\textit{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="strike">
<xsl:text>~~</xsl:text>
<xsl:value-of select="."/>
<xsl:text>~~</xsl:text>
</xsl:template>

<xsl:template match="h1">
<xsl:text>
=</xsl:text>
<xsl:value-of select="."/>
<xsl:text>=
</xsl:text>
</xsl:template>

<xsl:template match="h2">
<xsl:text>
==</xsl:text>
<xsl:value-of select="."/>
<xsl:text>==
</xsl:text>
</xsl:template>

<xsl:template match="h3">
<xsl:text>
===</xsl:text>
<xsl:value-of select="."/>
<xsl:text>===
</xsl:text>
</xsl:template>

<xsl:template match="h4">
<xsl:text>
====</xsl:text>
<xsl:value-of select="."/>
<xsl:text>====
</xsl:text>
</xsl:template>


<xsl:template match="h5">
<xsl:text>
=====</xsl:text>
<xsl:value-of select="."/>
<xsl:text>=====
</xsl:text>
</xsl:template>


<xsl:template match="h6">
<xsl:text>
======</xsl:text>
<xsl:value-of select="."/>
<xsl:text>======
</xsl:text>
</xsl:template>

<xsl:template name="escapetex">
<xsl:param name="s"/>
<xsl:message>Escape <xsl:value-of select="$s"/></xsl:message>

<xsl:variable name="result1">
 <xsl:choose>
 <xsl:when test="contains($s, '\')">

   <xsl:call-template name="replace-string">
    <xsl:with-param name="replace" select="'\'"/>
    <xsl:with-param name="with" select="'\textbackslash '"/>
    <xsl:with-param name="text" select="normalize-space($string)"/>
   </xsl:call-template>
 </xsl:when>
 <xsl:otherwise>
   <xsl:value-of select="$s"/>
 </xsl:otherwise>

 </xsl:choose>
</xsl:variable>

<xsl:variable name="result2">
 <xsl:choose>
 <xsl:when test="contains($result1, '$')">
   <xsl:call-template name="replace-string">
    <xsl:with-param name="replace" select="'$'"/>
    <xsl:with-param name="with" select="'\$'"/>
    <xsl:with-param name="text" select="$result1"/>

   </xsl:call-template>
 </xsl:when>
 <xsl:otherwise>
   <xsl:value-of select="$result1"/>
 </xsl:otherwise>
 </xsl:choose>
</xsl:variable>

<xsl:variable name="result3">
 <xsl:choose>

 <xsl:when test="contains($result2, '{')">
   <xsl:call-template name="replace-string">
    <xsl:with-param name="replace" select="'{'"/>
    <xsl:with-param name="with" select="'\{'"/>
    <xsl:with-param name="text" select="$result2"/>
   </xsl:call-template>
 </xsl:when>
 <xsl:otherwise>
   <xsl:value-of select="$result2"/>

 </xsl:otherwise>
 </xsl:choose>
</xsl:variable>

<xsl:variable name="result4">
 <xsl:choose>
 <xsl:when test="contains($result3, '}')">
   <xsl:call-template name="replace-string">
    <xsl:with-param name="replace" select="'}'"/>
    <xsl:with-param name="with" select="'\}'"/>

    <xsl:with-param name="text" select="$result3"/>
   </xsl:call-template>
 </xsl:when>
 <xsl:otherwise>
   <xsl:value-of select="$result3"/>
 </xsl:otherwise>
 </xsl:choose>
</xsl:variable>

<!-- The '[' and ']' characters don't, in general, need to be
  escaped.  But there are times when it is ambiguous whether
  [ is the beginning of an optional argument or a literal '['.
  Hence, it is safer to protect the literal ones with {}. -->

<xsl:variable name="result5">
 <xsl:choose>
 <xsl:when test="contains($result4, '[')">
   <xsl:call-template name="replace-string">
    <xsl:with-param name="replace" select="'['"/>
    <xsl:with-param name="with" select="'{[}'"/>
    <xsl:with-param name="text" select="$result4"/>
   </xsl:call-template>
 </xsl:when>

 <xsl:otherwise>
   <xsl:value-of select="$result4"/>
 </xsl:otherwise>
 </xsl:choose>
</xsl:variable>

<xsl:variable name="result6">
 <xsl:choose>
 <xsl:when test="contains($result5, ']')">
   <xsl:call-template name="replace-string">

    <xsl:with-param name="replace" select="']'"/>
    <xsl:with-param name="with" select="'{]}'"/>
    <xsl:with-param name="text" select="$result5"/>
   </xsl:call-template>
 </xsl:when>
 <xsl:otherwise>
   <xsl:value-of select="$result5"/>
 </xsl:otherwise>
 </xsl:choose>

</xsl:variable>

<xsl:variable name="result7">
 <xsl:choose>
 <xsl:when test="contains($result6, '&quot;')">
   <xsl:call-template name="replace-string">
    <xsl:with-param name="replace" select="'&quot;'"/>
    <xsl:with-param name="with" select="'\texttt{&quot;}'"/>
    <xsl:with-param name="text" select="$result6"/>
   </xsl:call-template>

 </xsl:when>
 <xsl:otherwise>
   <xsl:value-of select="$result6"/>
 </xsl:otherwise>
 </xsl:choose>
</xsl:variable>


    <xsl:call-template name="replace-string">
    <xsl:with-param name="replace" select="'_'"/>

    <xsl:with-param name="with" select="'\_'"/>
    <xsl:with-param name="text">
      <xsl:call-template name="replace-string">
      <xsl:with-param name="replace" select="'#'"/>
      <xsl:with-param name="with" select="'\#'"/>
      <xsl:with-param name="text">
        <xsl:call-template name="replace-string">
        <xsl:with-param name="replace" select="'%'"/>
        <xsl:with-param name="with" select="'\%'"/>

        <xsl:with-param name="text">
          <xsl:call-template name="replace-string">
          <xsl:with-param name="replace" select="'&gt;'"/>
          <xsl:with-param name="with" select="'\textgreater{}'"/>
          <xsl:with-param name="text">
            <xsl:call-template name="replace-string">
            <xsl:with-param name="replace" select="'&lt;'"/>
            <xsl:with-param name="with" select="'\textless{}'"/>
            <xsl:with-param name="text">

              <xsl:call-template name="replace-string">
              <xsl:with-param name="replace" select="'~'"/>
              <xsl:with-param name="with" select="'\textasciitilde{}'"/>
              <xsl:with-param name="text">
                <xsl:call-template name="replace-string">
                <xsl:with-param name="replace" select="'^'"/>
                <xsl:with-param name="with" select="'\^{}'"/>
                <xsl:with-param name="text">
                    <xsl:call-template name="replace-string">

                    <xsl:with-param name="replace" select="'&amp;'"/>
                    <xsl:with-param name="with" select="'\&amp;'"/>
                    <xsl:with-param name="text" select="$result7"/>
                    </xsl:call-template>
                </xsl:with-param>
                </xsl:call-template>
              </xsl:with-param>
              </xsl:call-template>
            </xsl:with-param>

            </xsl:call-template>
          </xsl:with-param>
          </xsl:call-template>
        </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
      </xsl:call-template>
    </xsl:with-param>
    </xsl:call-template>


</xsl:template>


<xsl:template name="replace-string">
  <xsl:param name="text"/>
  <xsl:param name="replace"/>

  <xsl:param name="with"/>
    
  <xsl:choose>
    <xsl:when test="not(contains($text,$replace))">
      <xsl:value-of select="$text"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="substring-before($text,$replace)"/>
      <xsl:value-of select="$with"/>
      <xsl:call-template name="replace-string">

        <xsl:with-param name="text" select="substring-after($text,$replace)"/>
        <xsl:with-param name="replace" select="$replace"/>
        <xsl:with-param name="with" select="$with"/>
       </xsl:call-template>
     </xsl:otherwise>
   </xsl:choose>
</xsl:template>


</xsl:stylesheet>
