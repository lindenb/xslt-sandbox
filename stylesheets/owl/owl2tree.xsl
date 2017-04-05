<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:oboInOwl="http://www.geneontology.org/formats/oboInOwl#"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:obo="http://purl.obolibrary.org/obo/"
        version='1.0'
        >
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Motivation:
	print a OWL-OBO file as an ascii tree
	

-->

<xsl:output method="text" />


<xsl:param name="table">term</xsl:param>
<xsl:key name="uri2class" match="/rdf:RDF/owl:Class" use="@rdf:about"/>

<xsl:template match="/">
<xsl:apply-templates select="//owl:Class" mode="findroot"/>
</xsl:template>

<xsl:template match="owl:Class" mode="findroot">
<xsl:variable name="acn" select="@rdf:about"/>
<xsl:if test="not(rdfs:subClassOf) and not(owl:deprecated/text() = 'true')">
<xsl:message>Found root <xsl:value-of select="rdfs:label/text()"/></xsl:message>
<xsl:call-template name="recurse">
<xsl:with-param name="root" select="."/>
<xsl:with-param name="depth"><xsl:text> </xsl:text></xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>


<xsl:template name="recurse">
<xsl:param name="depth"></xsl:param>
<xsl:param name="root"/>
<xsl:variable name="acn" select="$root/@rdf:about"/>
<xsl:variable name="children" select="//owl:Class[rdfs:subClassOf/@rdf:resource = $acn and not(owl:deprecated/text() = 'true')] "/>

<xsl:value-of select="$depth"/>
<xsl:choose>
	<xsl:when test="count($children)=0">-</xsl:when>
	<xsl:otherwise>+</xsl:otherwise>
</xsl:choose>
<xsl:text> </xsl:text>
<xsl:value-of select="$root/rdfs:label/text()"/>
<xsl:text>
</xsl:text>
<xsl:for-each select="$children">
<xsl:call-template name="recurse">
	<xsl:with-param name="root" select="."/>
	<xsl:with-param name="depth"><xsl:value-of select="$depth"/><xsl:text>  </xsl:text></xsl:with-param>
</xsl:call-template>
</xsl:for-each>


</xsl:template>


</xsl:stylesheet>

