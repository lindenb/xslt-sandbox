<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
<xsl:import href="../latex/escapeLaTeX.mod.xsl"/>

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
<xsl:choose>
	<xsl:when test="starts-with(@href,'#') and string-length(normalize-space(.))=0">
	</xsl:when>
	<xsl:when test="starts-with(@href,'#')">
		<xsl:text>\hyperlink{</xsl:text>
		 <xsl:call-template name="escapeLaTeX">
		  <xsl:with-param name="string">
			<xsl:value-of select="substring(@href,2)"/>
		  </xsl:with-param>
		</xsl:call-template>
		<xsl:text>}</xsl:text>
		<xsl:text>{</xsl:text>
		<xsl:apply-templates />
		<xsl:text>}</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>\href{</xsl:text>
		<xsl:apply-templates select="@href"/>
		<xsl:text>}</xsl:text>
		<xsl:text>{</xsl:text>
		<xsl:apply-templates />
		<xsl:text>}</xsl:text>
	</xsl:otherwise>
</xsl:choose>


</xsl:template> 

<xsl:template match="a[@name and not(@href)]">
<xsl:text>\hypertarget{</xsl:text>
<xsl:apply-templates select="@name"/>
<xsl:text>}{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="text()|@*">
<xsl:variable name="s">
 <xsl:call-template name="escapeLaTeX">
  <xsl:with-param name="string">
	<xsl:value-of select="."/>
  </xsl:with-param>
</xsl:call-template>
</xsl:variable>
<xsl:choose>
	<xsl:when test="ancestor::pre">
		<xsl:variable name="s2">
			<xsl:call-template name="latex-string-replace">
			  <xsl:with-param name="from"><xsl:text>	</xsl:text></xsl:with-param>
			  <xsl:with-param name="to"><xsl:text>\texttt{    }</xsl:text></xsl:with-param>
			  <xsl:with-param name="string" select="$s"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="latex-string-replace">
		  <xsl:with-param name="from"><xsl:text>
</xsl:text></xsl:with-param>
		  <xsl:with-param name="to">\newline </xsl:with-param>
		  <xsl:with-param name="string" select="$s2"/>
		</xsl:call-template>
	</xsl:when>
	<xsl:otherwise><xsl:value-of select="$s"/></xsl:otherwise>
</xsl:choose>
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

<xsl:template match="table[not(tbody)]">
<xsl:text>
\begin{tabular}{</xsl:text>
<xsl:for-each select="tr[1]/*">
<xsl:if test="position() &gt; 1"> | </xsl:if>
<xsl:text> l </xsl:text>
</xsl:for-each>
<xsl:text>}
</xsl:text>
<xsl:for-each select="tr[1]/*">
<xsl:if test="position() &gt; 1"> &amp; </xsl:if>
<xsl:apply-templates select="."/>
</xsl:for-each>
<xsl:text> \\
\hline
</xsl:text>

<xsl:for-each select="tr">
<xsl:if test="position() &gt; 1">
<xsl:for-each select="*">
<xsl:if test="position() &gt; 1"> &amp; </xsl:if>
<xsl:apply-templates select="."/>
</xsl:for-each>
<xsl:text> \\
</xsl:text>
</xsl:if>
</xsl:for-each>

\end{tabular}
</xsl:template>


<xsl:template match="img[@src]">
<xsl:text>\includegraphics{</xsl:text>
<xsl:apply-templates select="@src"/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="a[not(@href)]"></xsl:template>


</xsl:stylesheet>
