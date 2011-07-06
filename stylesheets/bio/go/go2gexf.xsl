<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:g='http://www.gexf.net/1.2draft'
	xmlns:go="http://www.geneontology.org/dtds/go.dtd#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns='http://www.gexf.net/1.2draft'
	xmlns:viz="http://www.gexf.net/1.1draft/viz"
        version='1.0'
        >
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Motivation:
      transforms GeneOntology (rdf/XML) of gexf ( see www.gephi.org )
Reference:
    http://biostar.stackexchange.com/questions/9955
Usage :
      xsltproc go2gexf.xsl go.rdf > go.gexf
-->

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
<gexf xmlns="http://www.gexf.net/1.2draft" version="1.2">
    <meta>
        <creator>Pierre Lindenbaum</creator>
        <description>Gene Ontology</description>
    </meta>
    <attributes class="node">
            <attribute id="0" title="definition" type="string"/>
    </attributes>
    <graph mode="static" defaultedgetype="directed">
    <nodes>
      <xsl:apply-templates select="//go:term[not(starts-with(go:is_a/@rdf:resource,'http://www.geneontology.org/go#obsolete'))]" mode="node"/>
    </nodes>
    <edges>
	
      <xsl:apply-templates select="//go:term" mode="edge"/>
    </edges>
    </graph>
</gexf>
</xsl:template>

<xsl:template match="go:term" mode="node">
  <xsl:element name="node">
    <xsl:attribute name="id">
      <xsl:value-of select="substring-after(@rdf:about,'#')"/>
    </xsl:attribute>

    <xsl:attribute name="label">
      <xsl:value-of select="go:name"/>
    </xsl:attribute>

    <attvalues>
            <attvalue for="0">
		    <xsl:attribute name="value">
		      <xsl:value-of select="go:definition"/>
		    </xsl:attribute>
            </attvalue>
     </attvalues>
  </xsl:element>
</xsl:template>

<xsl:template match="go:term" mode="edge">
<xsl:variable name="acn">
      <xsl:value-of select="substring-after(@rdf:about,'#')"/>
</xsl:variable>
<xsl:for-each select="go:is_a/@rdf:resource">
 <xsl:if test="not(starts-with(.,'http://www.geneontology.org/go#obsolete'))">
 <xsl:element name="edge">
    <xsl:attribute name="id">
      <xsl:value-of select="generate-id(.)"/>
    </xsl:attribute>
    <xsl:attribute name="source">
      <xsl:value-of select="$acn"/>
    </xsl:attribute>
    <xsl:attribute name="target">
      <xsl:value-of select="substring-after(.,'#')"/>
    </xsl:attribute>
  </xsl:element>
</xsl:if>
</xsl:for-each>
</xsl:template>


</xsl:stylesheet>
