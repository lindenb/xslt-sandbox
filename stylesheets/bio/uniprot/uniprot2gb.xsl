<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:u="http://uniprot.org/uniprot"
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0' 
	> 
<xsl:output method="xml" encoding="ISO-8859-1" indent="yes" />

<xsl:template match="/">
<xsl:apply-templates select="u:uniprot"/>
</xsl:template>


<xsl:template match="u:uniprot">
<GBSet>
<xsl:apply-templates select="u:entry"/>
</GBSet>
</xsl:template>

<xsl:template match="u:entry">
<GBSeq>
<GBSeq_length><xsl:value-of select="u:sequence/@length"/></GBSeq_length>
<GBSeq_definition><xsl:value-of select="u:name"/></GBSeq_definition>
<GBSeq_other-seqids>
<xsl:apply-templates select="u:accession"/>
</GBSeq_other-seqids>
<GBSeq_feature-table>
<xsl:apply-templates select="u:feature"/>
</GBSeq_feature-table>
<xsl:apply-templates select="u:sequence"/>
</GBSeq>
</xsl:template>



<xsl:template match="u:sequence">
<GBSeq_sequence>
<xsl:value-of select="translate(normalize-space(.),' ','')"/>
</GBSeq_sequence>
</xsl:template>

<xsl:template match="u:accession">
<GBSeqid>
<xsl:value-of select="concat('uniprot|',.)"/>
</GBSeqid>
</xsl:template>


<xsl:template match="u:feature">
<GBFeature>



      <GBFeature_key><xsl:value-of select="@type"/></GBFeature_key>
      <xsl:choose>
	 <xsl:when test="u:location/u:begin">
	      <GBFeature_location><xsl:value-of select="u:location/u:begin/@position"/>..<xsl:value-of select="u:location/u:end/@position"/></GBFeature_location>
	      <GBFeature_intervals>
		<GBInterval>
		  <GBInterval_from><xsl:value-of select="u:location/u:begin/@position"/></GBInterval_from>
		  <GBInterval_to><xsl:value-of select="u:location/u:end/@position"/></GBInterval_to>
		</GBInterval>
	      </GBFeature_intervals>
	 </xsl:when>
	 <xsl:otherwise>
	      <GBFeature_location><xsl:value-of select="u:location/u:position/@position"/></GBFeature_location>
	      <GBFeature_intervals>
		<GBInterval>
		  <GBInterval_point><xsl:value-of select="u:location/u:position/@position"/></GBInterval_point>
		</GBInterval>
	      </GBFeature_intervals>
	 </xsl:otherwise>
   </xsl:choose>
   <GBFeature_quals>
   <xsl:if test="@description">
   	<GBQualifier>
          <GBQualifier_name>description</GBQualifier_name>
          <GBQualifier_value><xsl:value-of select="@description"/></GBQualifier_value>
        </GBQualifier>
   </xsl:if>
   <xsl:if test="@ref">
   	<GBQualifier>
          <GBQualifier_name>ref</GBQualifier_name>
          <GBQualifier_value><xsl:value-of select="@ref"/></GBQualifier_value>
        </GBQualifier>
   </xsl:if>
    <xsl:if test="@status">
   	<GBQualifier>
          <GBQualifier_name>status</GBQualifier_name>
          <GBQualifier_value><xsl:value-of select="@status"/></GBQualifier_value>
        </GBQualifier>
   </xsl:if>
   <xsl:if test="@id">
   	<GBQualifier>
          <GBQualifier_name>db_xref</GBQualifier_name>
          <GBQualifier_value><xsl:value-of select="@id"/></GBQualifier_value>
        </GBQualifier>
   </xsl:if>
   <xsl:apply-templates select="u:original|u:variation"/>
   </GBFeature_quals>

</GBFeature>
</xsl:template>


<xsl:template match="u:original|u:variation">
	<GBQualifier>
          <GBQualifier_name><xsl:value-of select="local-name(.)"/></GBQualifier_name>
          <GBQualifier_value><xsl:value-of select="."/></GBQualifier_value>
        </GBQualifier>
</xsl:template>


<xsl:template match="*">
</xsl:template>


</xsl:stylesheet>

