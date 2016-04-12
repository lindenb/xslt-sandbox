<?xml version='1.0'  encoding="ISO-8859-1" ?>
<!DOCTYPE xsl:stylesheet [
	  <!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	  ]>
<xsl:stylesheet
	 xmlns:rdf="&rdf;"
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
	>
<!--
Author Pierre Lindenbaum PhD
http://plindenbaum.blogspot.com
-->
<xsl:import href="mod.rdf.xsl"/>

<xsl:output method="text"/>

<xsl:template match="/">
<xsl:apply-templates select="rdf:RDF"/>
</xsl:template>

<!-- emit a RDF statement -->

<xsl:template name="emit">
<xsl:param name="subject"/>
<xsl:param name="predicate"/>
<xsl:param name="value-is-uri"/>
<xsl:param name="value"/>

<xsl:text>&lt;</xsl:text>
<xsl:value-of select="$subject"/>
<xsl:text>&gt; &lt;</xsl:text>
<xsl:value-of select="$predicate"/>
<xsl:text>&gt; </xsl:text>
<xsl:choose>
	<xsl:when test="not($value-is-uri = 'true')">
		<xsl:text>"</xsl:text>
		<xsl:value-of select="$value"/>
		<xsl:text>"</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="$value"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:otherwise>
</xsl:choose>
<xsl:text> .
</xsl:text>
</xsl:template>

</xsl:stylesheet>

