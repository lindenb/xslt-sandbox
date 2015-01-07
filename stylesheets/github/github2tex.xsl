<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

<!-- 

transforms github pages to LaTeX


-->

<xsl:import href="../latex/escapeLaTeX.mod.xsl"/>
<xsl:import href="../html/html2latex.mod.xsl"/>
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
\lstset{frame=single,backgroundcolor=\color{yellow},numbers=left,breaklines=true,breakautoindent=true,basicstyle=\small}
<xsl:if test="head/title">
<xsl:text>\title{</xsl:text>
<xsl:apply-templates select="head/title"/>
<xsl:text>}
</xsl:text>
</xsl:if>

<xsl:apply-templates select="body"/>
</xsl:template> 



<xsl:template match="title">
<xsl:apply-templates/>
</xsl:template> 

<xsl:template match="body">
\begin{document}
<xsl:if test="../head/title">
\maketitle
</xsl:if>
<xsl:apply-templates select="//div[@class='markdown-body']"/>

\end{document}
</xsl:template> 

<xsl:template match="div[@class='markdown-body']">
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="span[@class='na']">
<xsl:text>{\color[RGB]{0,128,128}</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="div[@class='highlight']">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="span[@class='o']">
<xsl:text>{\bf </xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='highlight']">
<xsl:text>{\bf </xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='s']">
<xsl:text>{\color[RGB]{221, 17, 68}</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='n']">
<xsl:text>{\color[RGB]{221, 17, 68}</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='mi']">
<xsl:text>{\color[RGB]{0, 153, 153}</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='mf']">
<xsl:text>{\color[RGB]{0, 153, 153}</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='se']">
<xsl:text>{\color[RGB]{221, 17, 68}</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='nv']">
<xsl:text>{\color[RGB]{0,128,128}</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='m']">
<xsl:text>{\color[RGB]{0, 153, 153}</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>


<xsl:template match="span[@class='s1']">
<xsl:text>{\color[RGB]{221, 17, 68}</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='s2']">
<xsl:text>{\color[RGB]{221, 17, 68}</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='nf']">
<xsl:text>{\color[RGB]{153, 0, 0}{\bf </xsl:text>
<xsl:apply-templates/>
<xsl:text>}}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='mo']">
<xsl:text>{\color[RGB]{0, 153, 153}</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>


<xsl:template match="span[@class='o']">
<xsl:text>{\bf </xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='nt']">
<xsl:text>{\color[RGB]{0,0,128}</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='ni']">
<xsl:text>{\color[RGB]{128,0,128}</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>


<xsl:template match="span[@class='c']">
<xsl:text>{\color[RGB]{153, 153, 136}{\it </xsl:text>
<xsl:apply-templates/>
<xsl:text>}}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='c1']">
<xsl:text>{\color[RGB]{153, 153, 136}{\it </xsl:text>
<xsl:apply-templates/>
<xsl:text>}}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='cp']">
<xsl:text>{\color[RGB]{153, 153, 153}{\bf </xsl:text>
<xsl:apply-templates/>
<xsl:text>}}</xsl:text>
</xsl:template>

<xsl:template match="span[@class='nb']">
<xsl:text>{\color[RGB]{0, 134, 179}</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>


<xsl:template match="span[@class='p']">
<xsl:text>

</xsl:text>
<xsl:apply-templates/>
<xsl:text>

</xsl:text>
</xsl:template>

<xsl:template match="span[@class='k']">
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="code|kbd|samp">
<xsl:text>{\tt </xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>


<xsl:template match="a[@href and starts-with(@href,'/')]">
<xsl:text>\href{https://github.com</xsl:text>
<xsl:apply-templates select="@href"/>
<xsl:text>}</xsl:text>
<xsl:text>{</xsl:text>
<xsl:apply-templates />
<xsl:text>}</xsl:text>
</xsl:template>


</xsl:stylesheet>
