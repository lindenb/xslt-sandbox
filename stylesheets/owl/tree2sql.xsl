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
     print all parent for any children (ontology normalization) and create mysql tables
     see https://github.com/lindenb/xslt-sandbox/wiki/ReasoningWithSequenceOntology

	
-->

<xsl:output method="text" />
<xsl:param name="table">T</xsl:param>
<xsl:key name="uri2class" match="/rdf:RDF/owl:Class" use="@rdf:about"/>

<xsl:template match="/">




<xsl:text>CREATE TABLE IF NOT EXISTS `<xsl:value-of select="$table"/>`
	(
	id  INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
	acn varchar(</xsl:text>

	<xsl:for-each select="rdf:RDF/owl:Class/@rdf:about">
		  <xsl:sort select="string-length(.)" order="descending" data-type="number"/>
			  <xsl:if test="position() = 1">
				 <xsl:value-of select="string-length(.) + 1"/>
			  </xsl:if>
	</xsl:for-each>

	<xsl:text>) NOT NULL UNIQUE,
	label varchar(</xsl:text>
	<xsl:for-each select="rdf:RDF/owl:Class/rdfs:label">
		  <xsl:sort select="string-length(.)" order="descending" data-type="number"/>
			  <xsl:if test="position() = 1">
				 <xsl:value-of select="string-length(.) + 1"/>
			  </xsl:if>
	</xsl:for-each>) NOT NULL 
) ENGINE=InnoDB, DEFAULT CHARSET=utf8 ;

CREATE TABLE IF NOT EXISTS `<xsl:value-of select="$table"/>_rel`
	(
	id  INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
	parent_id int not null REFERENCES <xsl:value-of select="$table"/>(id),
	child_id  int not null REFERENCES <xsl:value-of select="$table"/>(id),
	} ENGINE=InnoDB, DEFAULT CHARSET=utf8 ;

<xsl:apply-templates select="rdf:RDF/owl:Class[not(owl:deprecated = 'true')]" mode="insertclass"/>
<xsl:apply-templates select="rdf:RDF/owl:Class[not(owl:deprecated = 'true')]" mode="insertrel"/>

</xsl:template>



<xsl:template match="owl:Class" mode="insertclass">
INSERT INTO <xsl:value-of select="$table"/> (acn,label) VALUES (<xsl:value-of select="@rdf:about"/>,<xsl:apply-templates select="rdfs:label"/>);
</xsl:template>

<xsl:template match="owl:Class" mode="insertrel">
INSERT INTO <xsl:value-of select="$table"/>_rel (parent_id,child_id) VALUES (<xsl:value-of select="@rdf:resource"/>,<xsl:apply-templates select="@rdf:resource"/>);

<xsl:for-each select="rdfs:subClassOf">
<xsl:variable name="parentid" select="@rdf:resource"/>
<xsl:apply-templates select="key('uri2class',$parentid)" mode="insertrel"/>
</xsl:for-each>

</xsl:template>




</xsl:stylesheet>

