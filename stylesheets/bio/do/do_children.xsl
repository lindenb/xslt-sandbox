<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        xml:base="http://purl.obolibrary.org/obo/doid.owl"
        xmlns:obo="http://purl.obolibrary.org/obo/"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:doid="http://purl.obolibrary.org/obo/doid#"
        xmlns:owl="http://www.w3.org/2002/07/owl#"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:oboInOwl="http://www.geneontology.org/formats/oboInOwl#"
        version='1.0'
        >
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Motivation:
     print children under DO:id in http://disease-ontology.org/
Reference:
    https://www.biostars.org/p/128868/
    http://plindenbaum.blogspot.fr/2012/04/using-disease-ontology-do-to-map-genes.html
Usage :
     curl "http://www.berkeleybop.org/ontologies/doid.owl" |\
     xsltproc -\-stringparam ID "DOID:2914" do_children.xsl -

	
-->

<xsl:output method="text" />
<xsl:param name="ID"/>

<xsl:template match="/">
<xsl:text>#ID	LABEL	URI	DESCRIPTION
</xsl:text>
<xsl:apply-templates select="rdf:RDF/owl:Class[oboInOwl:id=$ID]"/>
</xsl:template>



<xsl:template match="owl:Class">
<xsl:variable name="about" select="@rdf:about"/>

<xsl:value-of select="oboInOwl:id"/>
<xsl:text>	</xsl:text>
<xsl:value-of select="rdfs:label"/>
<xsl:text>	</xsl:text>
<xsl:value-of select="rdfs:subClassOf/@rdf:resource"/>
<xsl:text>	</xsl:text>
<xsl:apply-templates select="obo:IAO_0000115[1]"/>
<xsl:text>
</xsl:text>
<xsl:apply-templates select="/rdf:RDF/owl:Class[rdfs:subClassOf/@rdf:resource=$about]"/>
</xsl:template>

<xsl:template match="obo:IAO_0000115">
<xsl:value-of select="normalize-space(text())"/>
</xsl:template>


</xsl:stylesheet>
