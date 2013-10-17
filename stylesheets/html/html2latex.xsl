<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
<xsl:import href="../latex/escapeLaTeX.mod.xsl"/>
<xsl:output method="text"/>

<xsl:template match="/">
<xsl:apply-templates select="html"/>
</xsl:template> 
 
<xsl:template match="html">\documentclass{article}
\usepackage[utf8]{inputenc}
\usepackage{hyperref}
\usepackage{graphicx}
\usepackage{listings}
\usepackage{amssymb}
\usepackage{color}
\usepackage{xcolor}
\usepackage{indentfirst}
\usepackage{makeidx}
\date{\today}
<xsl:if test="head/title">
<xsl:text>\title{</xsl:text>
<xsl:apply-templates select="head/title"/>
<xsl:text>}
</xsl:text>
</xsl:if>

<xsl:apply-templates select="body"/>
</xsl:template> 

<xsl:template match="body">
\begin{document}
<xsl:if test="../head/title">
\maketitle
</xsl:if>

<xsl:apply-templates/>
\end{document}
</xsl:template> 

<xsl:template match="h1">
<xsl:text>\section{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}
</xsl:text>
</xsl:template>

<xsl:template match="h2">
<xsl:text>\subsection{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}
</xsl:text>
</xsl:template>

<xsl:template match="h3">
<xsl:text>\subsubsection{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}
</xsl:text>
</xsl:template>

<xsl:template match="pre">
\begin{lstlisting}
<xsl:value-of select="."/>
\end{lstlisting}
</xsl:template> 

<xsl:template match="ul">
\begin{itemize}
<xsl:apply-templates select="li"/>
\end{itemize}
</xsl:template> 


<xsl:template match="ol">
\begin{itemize}
<xsl:apply-templates select="li"/>
\end{itemize}
</xsl:template> 

<xsl:template match="div">
<xsl:text>

</xsl:text>
<xsl:apply-templates/>
<xsl:text>

</xsl:text>
</xsl:template> 


<xsl:template match="br">
<xsl:text>

</xsl:text>
</xsl:template> 

<xsl:template match="hr">
<xsl:text>
\newpage
</xsl:text>
</xsl:template> 

<xsl:template match="span">
<xsl:apply-templates/>
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

<xsl:template match="u">
<xsl:text>\underline{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>


<xsl:template match="cite">
<xsl:text>\emph{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="code">
<xsl:text>\texttt{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="a[@href]">
<xsl:text>\href{</xsl:text>
<xsl:apply-templates select="@href"/>
<xsl:text>}{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template> 

<xsl:template match="text()|@*">
 <xsl:call-template name="escapeLaTeX">
  <xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
</xsl:call-template>
</xsl:template> 

<xsl:template match="li">
<xsl:text>
\item </xsl:text>
<xsl:apply-templates/>
</xsl:template>




<xsl:template match="script">
</xsl:template>

<xsl:template match="table">
<xsl:text>
\begin{tabular}{</xsl:text>
<xsl:for-each select="thead/tr/*">
<xsl:if test="position() &gt; 1"> | </xsl:if>
<xsl:text> l </xsl:text>
</xsl:for-each>
<xsl:text>}
</xsl:text>
<xsl:for-each select="thead/tr/*">
<xsl:if test="position() &gt; 1"> &amp; </xsl:if>
<xsl:apply-templates select="."/>
</xsl:for-each>
<xsl:text> \\
\hline
</xsl:text>

<xsl:for-each select="tbody/tr">
<xsl:for-each select="*">
<xsl:if test="position() &gt; 1"> &amp; </xsl:if>
<xsl:apply-templates select="."/>
</xsl:for-each>
<xsl:text> \\
</xsl:text>
</xsl:for-each>


<xsl:if test="tfoot">
<xsl:text>
\hline
</xsl:text>
<xsl:for-each select="tfoot/tr/*">
<xsl:if test="position() &gt; 1"> &amp; </xsl:if>
<xsl:apply-templates select="."/>
</xsl:for-each>
<xsl:text> \\
</xsl:text>
</xsl:if>

\end{tabular}
</xsl:template>

<xsl:template match="img[@src]">
<xsl:text>\includegraphics{</xsl:text>
<xsl:apply-templates select="@src"/>
<xsl:text>}</xsl:text>
</xsl:template>


</xsl:stylesheet>
