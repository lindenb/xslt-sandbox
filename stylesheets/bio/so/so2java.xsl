<?xml version="1.0" encoding="ASCII"?>
<xsl:stylesheet
 version="1.0"
 	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 	
     xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
     xmlns:owl="http://www.w3.org/2002/07/owl#"
     xmlns:oboInOwl="http://www.geneontology.org/formats/oboInOwl#"
     xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
     xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
     xmlns:so="http://purl.obolibrary.org/obo/so#"
     xmlns:obo="http://purl.obolibrary.org/obo/">


<xsl:output method='text'/>

<xsl:template match="/">
<xsl:apply-templates select="rdf:RDF"/>
</xsl:template>

<xsl:template match="rdf:RDF">
<xsl:apply-templates select="owl:Class" mode="nodes"/>

</xsl:template>

<xsl:template match="owl:Class[owl:deprecated/text() = 'true']" mode="nodes">
<!-- ignore deprecated -->
</xsl:template>

<xsl:template match="owl:Class" mode="nodes">
<xsl:text>newTerm("</xsl:text>
<xsl:value-of select="oboInOwl:id/text()"/>
<xsl:text>","</xsl:text>
<xsl:value-of select="rdfs:label/text()"/>
<xsl:text>"</xsl:text>
<xsl:for-each select="rdfs:subClassOf[@rdf:resource]">
  <xsl:variable name="rsrc" select="@rdf:resource"/>
   <xsl:text>,"</xsl:text>
   <xsl:value-of select="/rdf:RDF/owl:Class[@rdf:about = $rsrc]/oboInOwl:id/text()"/>
   <xsl:text>"</xsl:text>
</xsl:for-each>
<xsl:text>);
</xsl:text>
</xsl:template>

<xsl:template match="owl:Class[owl:deprecated/text() = 'true']" mode="bind">
<!-- ignore deprecated -->
</xsl:template>




</xsl:stylesheet>


