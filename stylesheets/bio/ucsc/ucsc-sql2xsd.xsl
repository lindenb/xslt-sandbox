<?xml version='1.0' encoding="UTF-8"?>
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Motivation:
      transform the xmloutput of mysql of UCSC to XSD


mysqldump -\-user=genome -\-host=genome-mysql.cse.ucsc.edu -d -X -\-skip-lock-tables  hg19 knownGene snp135

-->

<xsl:stylesheet
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:jaxb="http://java.sun.com/xml/ns/jaxb"
	version='1.0'
	>
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


<xsl:template match="/">
<xs:schema 
    jaxb:version="2.0"
    version="1.0"
    elementFormDefault="qualified"
    targetNamespace="http://genome.ucsc.edu/"
    attributeFormDefault="qualified"
    >
 <xs:annotation><xs:documentation>XML Structures for the UCSC.</xs:documentation></xs:annotation
>
<xsl:apply-templates/>

</xs:schema>
</xsl:template>

<!-- ========================================== -->
<xsl:template match="mysqldump">

<xs:complexType name="ChromStartEnd">
  <xs:sequence>
  	<xs:element name="chrom" type="xs:string"/>
  	<xs:element name="chromStart" type="xs:int"/>
  	<xs:element name="chromEnd" type="xs:int"/>
  </xs:sequence>
</xs:complexType>

<xs:complexType name="Exon">
  <xs:sequence>
  	<xs:element name="start" type="xs:int"/>
  	<xs:element name="end" type="xs:int"/>
  </xs:sequence>
</xs:complexType>

<xsl:apply-templates select="database"/>
</xsl:template>

<!-- ========================================== -->
<xsl:template match="database">
<xsl:apply-templates select="table_structure"/>
</xsl:template>

<!-- ========================================== -->
<xsl:template match="table_structure">
<xs:complexType>
<xsl:attribute name="name">
<xsl:value-of select="concat(../@name,'-',@name)"/>
</xsl:attribute>
 <xs:annotation><xs:documentation></xs:documentation></xs:annotation>

<xs:sequence>
<xsl:apply-templates select="field"/>
</xs:sequence>
</xs:complexType>
</xsl:template>
<!-- ========================================== -->


<xsl:template match="field[@Field='cdsStart]" >
</xsl:template>
<!-- ========================================== -->


<xsl:template match="field" >
<xs:element>
<xsl:attribute name="name">
<xsl:value-of select="@Field"/>
</xsl:attribute>

<xsl:attribute name="type">
<xsl:choose>
<xsl:when test="starts-with(@Type,'int(') or starts-with(@Type,'smallint(') ">
	<xsl:text>xs:int</xsl:text>
</xsl:when>
<xsl:when test="starts-with(@Type,'float(')">
	<xsl:text>xs:double</xsl:text>
</xsl:when>
<xsl:otherwise>
	<xsl:text>xs:string</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:attribute>


<xsl:attribute name="minOccurs">
<xsl:choose>
<xsl:when test="@Null='NO'">
  <xsl:text>1</xsl:text>
</xsl:when>
<xsl:otherwise>
  <xsl:text>0</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:attribute>

<xsl:attribute name="maxOccurs">
<xsl:text>1</xsl:text>
</xsl:attribute>


 <xs:annotation><xs:documentation><xsl:value-of select="@Field"/></xs:documentation></xs:annotation>

</xs:element>

</xsl:template>



</xsl:stylesheet>
