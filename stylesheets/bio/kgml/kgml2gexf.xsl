<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:g='http://www.gexf.net/1.2draft'
	xmlns='http://www.gexf.net/1.2draft'
	xmlns:viz="http://www.gexf.net/1.1draft/viz"
        version='1.0'
        >
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Motivation:
      transforms KGML of gexf ( see www.gephi.org )
Reference:
    http://www.biostars.org/p/85763/
Usage :
      xsltproc kgml2gexf.xsl \
      	"http://kgmlreader.googlecode.com/svn/trunk/KGMLReader/testData/kgml/metabolic/organisms/eco/eco00010.xml" > eco00010.gexf
-->

<xsl:output method="xml" indent="yes"/>




<xsl:template match="/">
<gexf xmlns="http://www.gexf.net/1.2draft" version="1.2">
    <meta>
        <creator>Pierre Lindenbaum</creator>
        <description>KGML</description>
    </meta>
    <attributes class="node">
            <attribute id="0" title="gene" type="string"/>
            <attribute id="1" title="url" type="string"/>
    </attributes>
    <attributes class="edge">
            <attribute id="10" title="type" type="string"/>
    </attributes>
    <graph mode="static" defaultedgetype="directed">
    <nodes>
      <xsl:apply-templates select="/pathway/entry"/>
    </nodes>
    <edges>
	
      <xsl:apply-templates select="/pathway/relation"/>
    </edges>
    </graph>
</gexf>
</xsl:template>

<xsl:template match="entry">
  <xsl:element name="node">
    <xsl:attribute name="id">
      <xsl:value-of select="@id"/>
    </xsl:attribute>

    <xsl:attribute name="label">
      <xsl:value-of select="@name"/>
    </xsl:attribute>

    <attvalues>
            <attvalue for="0">
		    <xsl:attribute name="value">
		      <xsl:value-of select="@type"/>
		    </xsl:attribute>
            </attvalue>
             <attvalue for="1">
		    <xsl:attribute name="value">
		      <xsl:value-of select="@link"/>
		    </xsl:attribute>
            </attvalue>
     </attvalues>
  </xsl:element>
</xsl:template>

<xsl:template match="relation">
 <xsl:element name="edge">
    <xsl:attribute name="id">
      <xsl:value-of select="generate-id(.)"/>
    </xsl:attribute>
    <xsl:attribute name="source">
      <xsl:value-of select="@entry1"/>
    </xsl:attribute>
    <xsl:attribute name="target">
      <xsl:value-of select="@entry2"/>
    </xsl:attribute>
        <attvalues>
            <attvalue for="10">
		    <xsl:attribute name="value">
		      <xsl:value-of select="@type"/>
		    </xsl:attribute>
            </attvalue>
     </attvalues>
  </xsl:element>
</xsl:template>


</xsl:stylesheet>
