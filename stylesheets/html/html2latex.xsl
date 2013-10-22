<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
<xsl:import href="../latex/escapeLaTeX.mod.xsl"/>
<xsl:import href="html2latex.mod.xsl"/>
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


</xsl:stylesheet>
