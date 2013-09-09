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
An \href{http://download.eclipse.org/modeling/emf/emf/javadoc/2.5.0/org/eclipse/emf/ecore/EPackage.html}{EPackage} named \textbf{<xsl:value-of select="@name"/>} is created. The package contains <xsl:value-of select="count(ecore:EPackage)"/> EClass and 
<xsl:value-of select="count(eClassifiers[@xsi:type='ecore:EEnum'])"/> EEnum(s). The EPackage \textbf{<xsl:value-of select="@name"/>}  is defined as below:\\

\begin{center}
\begin{tabular}{ r | l}
Key &amp; Value\\
\hline
<xsl:apply-templates select="@name|@nsURI|@nsPrefix" mode="tr"/>\end{tabular}
\end{center}


<xsl:apply-templates select="eClassifiers"/>
</xsl:template>

<xsl:template match="eClassifiers[@xsi:type='ecore:EEnum']">
Create a new \href{http://download.eclipse.org/modeling/emf/emf/javadoc/2.5.0/org/eclipse/emf/ecore/EEnum.html}{EEnum} named "\textbf{<xsl:value-of select="@name"/>}". In the tree view, right click on the node <xsl:value-of select="local-name(..)"/> "<xsl:value-of select="../@name"/>" and create a new EEnum. Name this EEnum "<xsl:value-of select="@name"/>". Right click on the node for the EEnum "<xsl:value-of select="@name"/>" and add the following <xsl:value-of select="count(eLiterals)"/> eLiterals:

\begin{center}
\begin{tabular}{ r | l | l}
Name &amp; Literal &amp; Value\\
\hline
<xsl:apply-templates select="eLiterals" mode="tr"/>\end{tabular}
\end{center}

</xsl:template>


<xsl:template match="eClassifiers[@xsi:type='ecore:EClass']">
Create a new \href{http://download.eclipse.org/modeling/emf/emf/javadoc/2.5.0/org/eclipse/emf/ecore/EClass.html}{EClass} named "\textbf{<xsl:value-of select="@name"/>}".

<xsl:apply-templates select="eStructuralFeatures" mode="table"/>
</xsl:template>


<xsl:template match="eStructuralFeatures" mode="table">
Create a new \href{http://download.eclipse.org/modeling/emf/emf/javadoc/2.5.0/org/eclipse/emf/ecore/EClass.html}{<xsl:value-of select="xsi:type"/>} named "\textbf{<xsl:value-of select="@name"/>}".

\begin{center}
\begin{tabular}{ r | l}
Key &amp; Value\\
\hline
<xsl:apply-templates select="@*" mode="tr"/>\end{tabular}
\end{center}
</xsl:template>


<xsl:template match="@*" mode="tr">
<xsl:text>\textbf{</xsl:text>
<xsl:value-of select="local-name()"/>
<xsl:text>} &amp; </xsl:text>
<xsl:value-of select="translate(.,'#','-')"/>
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


</xsl:stylesheet>
