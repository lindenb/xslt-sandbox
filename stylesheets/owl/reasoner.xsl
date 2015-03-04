<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
		 xmlns:obo="http://purl.obolibrary.org/obo/"
		 xmlns:obo2="http://data.bioontology.org/metadata/obo/"
		 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		 xmlns:owl="http://www.w3.org/2002/07/owl#"
		 xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
		 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		 xmlns:metadata="http://data.bioontology.org/metadata/"
        version='1.0'
        >
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Motivation:
     print all parent for any children (ontology normalization)

	
-->

<xsl:output method="xml" indent="yes"/>
<xsl:param name="rootid"></xsl:param>

<xsl:template match="/">
<rdf:RDF>
<xsl:choose>
<xsl:when test="string-length($rootid)&gt;0">
<xsl:apply-templates select="rdf:RDF/owl:Class[@rdf:about=$rootid]"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="rdf:RDF/owl:Class[not(owl:deprecated = 'true')]"/>
</xsl:otherwise>
</xsl:choose>
</rdf:RDF>
</xsl:template>



<xsl:template match="owl:Class">
<owl:Class>
<xsl:attribute name="rdf:about"><xsl:value-of select="@rdf:about"/></xsl:attribute>
<xsl:apply-templates select="rdfs:label"/>
<xsl:apply-templates select="." mode="printparents"/>
</owl:Class>
</xsl:template>

<xsl:template match="rdfs:label">
<rdfs:label><xsl:value-of select="./text()"/></rdfs:label>
</xsl:template>


<xsl:template match="owl:Class" mode="printparents">
<rdfs:subClassOf>
	<xsl:attribute name="rdf:resource">
		<xsl:value-of select="@rdf:about"/>
	</xsl:attribute>
</rdfs:subClassOf>
<xsl:if test="@rdf:about != $rootid">
<xsl:for-each select="rdfs:subClassOf">
<xsl:variable name="parentid" select="@rdf:resource"/>
<xsl:apply-templates select="/rdf:RDF/owl:Class[@rdf:about=$parentid]" mode="printparents"/>
</xsl:for-each>
</xsl:if>
</xsl:template>




</xsl:stylesheet>

