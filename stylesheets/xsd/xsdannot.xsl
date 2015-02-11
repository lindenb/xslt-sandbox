<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns="http://www.w3.org/1999/xhtml"
	version='1.0'
	>
<!--

Author:
	Pierre Lindenbaum PhD
	plindenbaum@yahoo.fr

Motivation:
	This stylesheet add the xs:annotation, xs:documentation to the elements
Usage:
	xsltproc xsdannot file.xsd > file2.xsd
-->
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>


<xsl:template match="/">
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="*|text()|@*">

<xsl:copy>
<xsl:apply-templates select="@*"/>
<xsl:if test="((local-name(.) = 'element' and (starts-with(@type,'xs:') or starts-with(@type,'xsd:'))) or local-name(.) = 'attribute' or local-name(.) = 'simpleType' or local-name(.) = 'complexType') and count(xs:annotation)=0">
  <xs:annotation>
    <xs:documentation xml:lang="en">Documentation for <xsl:value-of select="@name"/></xs:documentation>
  </xs:annotation>
</xsl:if>
<xsl:apply-templates select="*|text()"/>
</xsl:copy>
</xsl:template>

</xsl:stylesheet>

