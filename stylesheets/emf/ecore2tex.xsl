<?xml version="1.0"?>
<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:ecore="http://www.eclipse.org/emf/2002/Ecore"
  >

<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes" />

<xsl:template match="/">
<xsl:apply-templates select="ecore:EPackage"/>
</xsl:template>

<xsl:template match="ecore:EPackage">

\newcommand{\docECore}[1]{\href{http://download.eclipse.org/modeling/emf/emf/javadoc/2.5.0/org/eclipse/emf/ecore/#1.html}{#1}}

An \docECore{EPackage} named \textbf{<xsl:value-of select="@name"/>} is created. The package contains <xsl:value-of select="count(eClassifiers[@xsi:type='ecore:EClass'])"/> \docECore{EClass} and 
<xsl:value-of select="count(eClassifiers[@xsi:type='ecore:EEnum'])"/> \docECore{EEnum}(s). The \docECore{EPackage} \textbf{<xsl:value-of select="@name"/>}  is defined as below:\\

\begin{center}
\begin{tabular}{ r | l}
Key &amp; Value\\
\hline
<xsl:apply-templates select="@name|@nsURI|@nsPrefix" mode="tr"/>\end{tabular}
\end{center}

Next, were going to create the \docECore{EEnum} and the \docECore{EClass}:
\begin{itemize}
<xsl:apply-templates select="eClassifiers" mode="create"/>
\end{itemize}

Then, we add each complete the structure of the classifiers:\\
<xsl:apply-templates select="eClassifiers"/>
</xsl:template>

<xsl:template match="eClassifiers" mode="create">
\item  In the tree view right click on the node <xsl:value-of select="local-name(..)"/> "\textbf{<xsl:value-of select="../@name"/>}" , create a new \docECore{<xsl:value-of select="substring-after(@xsi:type,':')"/>} and set the name property to "\textbf{<xsl:value-of select="@name"/>}". 
</xsl:template>


<xsl:template match="eClassifiers[@xsi:type='ecore:EEnum']">
\begin{section}{<xsl:value-of select="@name"/>}
In the tree view, right-click on the node\docECore{EEnum} "\textbf{<xsl:value-of select="@name"/>}"  and add the following <xsl:value-of select="count(eLiterals)"/> eLiterals:

\begin{center}
\begin{tabular}{ r | l | l}
Name &amp; Literal &amp; Value\\
\hline
<xsl:apply-templates select="eLiterals" mode="tr"/>\end{tabular}
\end{center}
\end{section}
</xsl:template>


<xsl:template match="eClassifiers[@xsi:type='ecore:EClass']">
\begin{section}{<xsl:value-of select="@name"/>}
In the tree view, select the node  \docECore{EClass} "\textbf{<xsl:value-of select="../@name"/>}" and set the following properties:\\

\begin{center}
\begin{tabular}{ r | l}
Key &amp; Value\\
\hline
<xsl:apply-templates select="@*" mode="tr"/>\end{tabular}
\end{center}

Add some structural features to the  \docECore{EClass} "\textbf{<xsl:value-of select="../@name"/>}":\\
<xsl:apply-templates select="eStructuralFeatures" mode="table"/>
\end{section}
</xsl:template>


<xsl:template match="eStructuralFeatures" mode="table">
\begin{section}{<xsl:value-of select="../@name"/>:<xsl:value-of select="@name"/>}
In the tree view, right click on the node \docECore{EClass} "\textbf{<xsl:value-of select="../@name"/>}"
Create a new \docECore{<xsl:value-of select="substring-after(@xsi:type,':')"/>} named "\textbf{<xsl:value-of select="@name"/>}" and set its properties:\\

\begin{center}
\begin{tabular}{ r | l}
Key &amp; Value\\
\hline
<xsl:apply-templates select="@*" mode="tr"/>\end{tabular}
\end{center}
\end{section}
</xsl:template>


<xsl:template match="@*" mode="tr">
<xsl:text>\textbf{</xsl:text>
<xsl:value-of select="local-name()"/>
<xsl:text>} &amp; </xsl:text>
<xsl:choose>
<xsl:when test="name(.)='eType' and starts-with(.,'ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//')">
<xsl:text>\href{http://download.eclipse.org/modeling/emf/emf/javadoc/2.7.0/org/eclipse/emf/ecore/EcorePackage.Literals.html}{</xsl:text>
<xsl:value-of select="substring(.,57)"/>
<xsl:text>}</xsl:text>
</xsl:when>
<xsl:when test="name(.)='upperBound' and .='-1'">
<xsl:text>-1 (unbounded)</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="translate(.,'#','-')"/>
</xsl:otherwise>
</xsl:choose>
<xsl:text>\\
</xsl:text>
</xsl:template>

<xsl:template match="eLiterals" mode="tr">
<xsl:text>\textbf{</xsl:text>
<xsl:value-of select="@name"/>
<xsl:text>} &amp; </xsl:text>
<xsl:value-of select="@literal"/>
<xsl:text> &amp; </xsl:text>
<xsl:value-of select="@value"/>
<xsl:text>\\
</xsl:text>
</xsl:template>



<xsl:template match="@xsi:type" mode="tr"/>



</xsl:stylesheet>
