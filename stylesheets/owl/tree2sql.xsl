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
     print all parent for any children (ontology normalization from bioportal.org)
   	 and create mysql tables 
   	 see https://github.com/lindenb/xslt-sandbox/wiki/ReasoningWithSequenceOntology

Example:
	 curl -Ls "http://purl.obolibrary.org/obo/so.owl" |xsltproc stylesheets/owl/tree2sql.xsl  - 

-->
<xsl:import href="../util/escapesql.xsl"/>
<xsl:output method="text" />


<xsl:param name="table">term</xsl:param>
<xsl:key name="uri2class" match="/rdf:RDF/owl:Class" use="@rdf:about"/>

<xsl:template match="/">
CREATE TABLE IF NOT EXISTS <xsl:value-of select="$table"/>
	(
	id  INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
	acn varchar(<xsl:for-each select="rdf:RDF/owl:Class/obo:IAO_id">
		  <xsl:sort select="string-length(text())" order="descending" data-type="number"/>
			  <xsl:if test="position() = 1">
				 <xsl:value-of select="string-length(.) + 1"/>
			  </xsl:if>
	</xsl:for-each>) NOT NULL UNIQUE,
	label varchar(<xsl:for-each select="rdf:RDF/owl:Class/rdfs:label">
		  <xsl:sort select="string-length(.)" order="descending" data-type="number"/>
			  <xsl:if test="position() = 1">
				 <xsl:value-of select="string-length(.) + 1"/>
			  </xsl:if>
	</xsl:for-each>) NOT NULL 
) ENGINE=InnoDB, DEFAULT CHARSET=utf8 ;

truncate <xsl:value-of select="$table"/>;

CREATE TABLE IF NOT EXISTS `<xsl:value-of select="$table"/>_rel`
	(
	id  INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
	parent_id int not null REFERENCES <xsl:value-of select="$table"/>(id),
	child_id  int not null REFERENCES <xsl:value-of select="$table"/>(id),
	} ENGINE=InnoDB, DEFAULT CHARSET=utf8 ;

truncate <xsl:value-of select="$table"/>_rel;

BEGIN TRANSATION;

<xsl:apply-templates select="rdf:RDF/owl:Class[not(owl:deprecated = 'true') and obo:IAO_id]" mode="insertclass"/>
<xsl:apply-templates select="rdf:RDF/owl:Class[not(owl:deprecated = 'true') and obo:IAO_id]" mode="insertrel"/>

COMMIT;
</xsl:template>


<xsl:template match="owl:Class" mode="class_id">
<xsl:value-of select="count(preceding-sibling::owl:Class)"/>
</xsl:template>

<xsl:template match="owl:Class" mode="insertclass">INSERT IGNORE INTO <xsl:value-of select="$table"/> (id,acn,label) VALUES (<xsl:apply-templates select="." mode="class_id"/>,<xsl:apply-templates select="obo:IAO_id/text()" mode="quote.sql"/>,<xsl:apply-templates select="rdfs:label" mode="quote.sql"/>);
</xsl:template>

<xsl:template match="owl:Class" mode="insertrel">
<xsl:call-template name="recurs">
	<xsl:with-param name="child_id"><xsl:apply-templates select="." mode="class_id"/></xsl:with-param>
	<xsl:with-param name="node" select="."/>
</xsl:call-template>
</xsl:template>

<xsl:template name="recurs">
<xsl:param name="child_id"/>
<xsl:param name="node"/>INSERT INTO <xsl:value-of select="$table"/>_rel (parent_id,child_id) VALUES (<xsl:apply-templates select="$node" mode="class_id"/>,<xsl:value-of select="$child_id" />);
<xsl:for-each select="$node/rdfs:subClassOf[@rdf:resource]">
	<xsl:call-template name="recurs">
		<xsl:with-param name="child_id"><xsl:value-of select="$child_id"/></xsl:with-param>
		<xsl:with-param name="node" select="key('uri2class',@rdf:resource)"/>
	</xsl:call-template>
</xsl:for-each>
</xsl:template>




</xsl:stylesheet>

