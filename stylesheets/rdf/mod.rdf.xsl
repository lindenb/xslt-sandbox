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
<xsl:output method='xml' indent="yes"/>





<xsl:template match="rdf:RDF">
<xsl:element name="rdf:RDF">
<xsl:for-each select="*">

<xsl:call-template name="parseStatement">
<xsl:with-param name="node" select="."/>
</xsl:call-template>

</xsl:for-each>
</xsl:element>
</xsl:template>

<xsl:template name="parseStatement">
<xsl:param name="node"/>
<xsl:variable name="subject">
	<xsl:call-template name="subjectURI">
		<xsl:with-param name="node" select="$node"/>
	</xsl:call-template>
</xsl:variable>

<xsl:choose>
	<xsl:when test="namespace-uri($node)='&rdf;' and local-name($node)='Description'">
		
	</xsl:when>
	<xsl:otherwise>
		<xsl:call-template name="emit">
			<xsl:with-param name="subject"><xsl:value-of select="$subject"/></xsl:with-param>
			<xsl:with-param name="predicate">&rdf;type</xsl:with-param>
			<xsl:with-param name="value-is-uri">true</xsl:with-param>
			<xsl:with-param name="value"><xsl:value-of select="namespace-uri($node)"/><xsl:value-of select="local-name($node)"/></xsl:with-param>
		</xsl:call-template>
	</xsl:otherwise>
</xsl:choose>

<xsl:for-each select="$node/@*">
		<xsl:if test="not(namespace-uri(.)='&rdf;' and (local-name(.)='about' or local-name(.)='ID' or local-name(.)='nodeID'))">
		<xsl:call-template name="emit">
			<xsl:with-param name="subject"><xsl:value-of select="$subject"/></xsl:with-param>
			<xsl:with-param name="predicate"><xsl:value-of select="namespace-uri(.)"/><xsl:value-of select="local-name(.)"/></xsl:with-param>
			<xsl:with-param name="value-is-uri">false</xsl:with-param>
			<xsl:with-param name="value"><xsl:value-of select="."/></xsl:with-param>
		</xsl:call-template>
		</xsl:if>
</xsl:for-each>

<xsl:for-each select="$node/*">
	<xsl:call-template name="parsePredicate">
		<xsl:with-param name="subject"><xsl:value-of select="$subject"/></xsl:with-param>
		<xsl:with-param name="node" select="$node"/>
	</xsl:call-template>
</xsl:for-each>


</xsl:template>

<xsl:template name="parsePredicate">
 <xsl:param name="subject"/>
 <xsl:param name="node"/>

<xsl:for-each select="$node/*">
<xsl:variable name="predicate"><xsl:value-of select="namespace-uri(.)"/><xsl:value-of select="local-name(.)"/></xsl:variable>
<xsl:choose>
	<xsl:when test="@rdf:parseType='Resource'">
			<xsl:variable name="ANode">_:anode<xsl:value-of select="generate-id($node)"/></xsl:variable>
			<xsl:call-template name="emit">
				<xsl:with-param name="subject"><xsl:value-of select="$subject"/></xsl:with-param>
				<xsl:with-param name="predicate"><xsl:value-of select="$predicate"/></xsl:with-param>
				<xsl:with-param name="value-is-uri">true</xsl:with-param>
				<xsl:with-param name="value"><xsl:value-of select="$ANode"/></xsl:with-param>
			</xsl:call-template>
			<xsl:for-each select="$node/*">
				<xsl:call-template name="parsePredicate">
					<xsl:with-param name="subject"><xsl:value-of select="$ANode"/></xsl:with-param>
					<xsl:with-param name="node" select="."/>
				</xsl:call-template>
			</xsl:for-each>
	</xsl:when>
	<xsl:when test="@rdf:parseType='Literal'">
		<xsl:message terminate="no">
			WARNING @rdf:parseType='Literal' not fully implemented
		</xsl:message>
		<xsl:call-template name="emit">
			<xsl:with-param name="subject"><xsl:value-of select="$subject"/></xsl:with-param>
			<xsl:with-param name="predicate"><xsl:value-of select="$predicate"/></xsl:with-param>
			<xsl:with-param name="value-is-uri">false</xsl:with-param>
			<xsl:with-param name="value"><xsl:call-template name="deepcopy"><xsl:with-param name="node" select="."/></xsl:call-template></xsl:with-param>
		</xsl:call-template>
	</xsl:when>
	<xsl:when test="@rdf:parseType='Collection'">
		<xsl:message terminate="no">
			WARNING @rdf:parseType='Collection' not fully implemented
		</xsl:message>
		<xsl:variable name="ANode">_:coll<xsl:value-of select="generate-id($node)"/></xsl:variable>
		
		<xsl:call-template name="emit">
			<xsl:with-param name="subject"><xsl:value-of select="$subject"/></xsl:with-param>
			<xsl:with-param name="predicate"><xsl:value-of select="$predicate"/></xsl:with-param>
			<xsl:with-param name="value-is-uri">true</xsl:with-param>
			<xsl:with-param name="value"><xsl:value-of select="concat($ANode,'_1')"/></xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="*">
			<xsl:call-template name="emit">
				<xsl:with-param name="subject"><xsl:value-of select="concat($ANode,'_',position())"/></xsl:with-param>
				<xsl:with-param name="predicate"><xsl:value-of select="$predicate"/></xsl:with-param>
				<xsl:with-param name="value-is-uri">true</xsl:with-param>
				<xsl:with-param name="value"><xsl:value-of select="@rdf:about"/></xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="position()=last()">
					<xsl:call-template name="emit">
						<xsl:with-param name="subject"><xsl:value-of select="concat($ANode,'_',position())"/></xsl:with-param>
						<xsl:with-param name="predicate">&rdf;rest</xsl:with-param>
						<xsl:with-param name="value-is-uri">true</xsl:with-param>
						<xsl:with-param name="value">&rdf;nil</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="emit">
						<xsl:with-param name="subject"><xsl:value-of select="concat($ANode,'_',position())"/></xsl:with-param>
						<xsl:with-param name="predicate">&rdf;rest</xsl:with-param>
						<xsl:with-param name="value-is-uri">true</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="concat($ANode,'_',(1+position()))"/></xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:when>
	<xsl:when test="@rdf:resource">
		<xsl:call-template name="emit">
			<xsl:with-param name="subject"><xsl:value-of select="$subject"/></xsl:with-param>
			<xsl:with-param name="predicate"><xsl:value-of select="$predicate"/></xsl:with-param>
			<xsl:with-param name="value-is-uri">true</xsl:with-param>
			<xsl:with-param name="value"><xsl:value-of select="@rdf:resource"/></xsl:with-param>
		</xsl:call-template>
	</xsl:when>
	<xsl:when test="count(*)=0">
		<xsl:call-template name="emit">
			<xsl:with-param name="subject"><xsl:value-of select="$subject"/></xsl:with-param>
			<xsl:with-param name="predicate"><xsl:value-of select="$predicate"/></xsl:with-param>
			<xsl:with-param name="value-is-uri">false</xsl:with-param>
			<xsl:with-param name="value"><xsl:value-of select="."/></xsl:with-param>
		</xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
		<xsl:for-each select="*">
			<xsl:variable name="value-uri">
				<xsl:call-template name="subjectURI">
					<xsl:with-param name="node" select="."/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="emit">
				<xsl:with-param name="subject"><xsl:value-of select="$subject"/></xsl:with-param>
				<xsl:with-param name="predicate"><xsl:value-of select="$predicate"/></xsl:with-param>
				<xsl:with-param name="value-is-uri">true</xsl:with-param>
				<xsl:with-param name="value"><xsl:value-of select="$value-uri"/></xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="parseStatement">
				<xsl:with-param name="node" select="."/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:otherwise>
</xsl:choose>

</xsl:for-each>
</xsl:template>



<!-- get the ID of a subject node -->
<xsl:template name="subjectURI">
 <xsl:param name="node"/>
	<xsl:choose>
		<xsl:when test="$node/@rdf:about"><xsl:value-of select="$node/@rdf:about"/></xsl:when>
		<xsl:when test="$node/@rdf:ID"><xsl:value-of select="$node/@rdf:ID"/></xsl:when>
		<xsl:when test="$node/@rdf:nodeID"><xsl:value-of select="$node/@rdf:nodeID"/></xsl:when>
		<xsl:otherwise>_:<xsl:value-of select="generate-id($node)"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- sub-string -->
<xsl:template name="escape">
 <xsl:param name="s"/>
 	<xsl:choose>
 	<xsl:when test='contains($s,"&apos;")'>
		<xsl:value-of select='substring-before($s,"&apos;")'/>
		<xsl:text>\"</xsl:text>
		<xsl:call-template name="escape">
			<xsl:with-param name="s" select='substring-after($s,"&apos;")'/>
		</xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select='$s'/>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- deep copy -->
<xsl:template name="deepcopy">
<xsl:param name="node"/>
<xsl:apply-templates select="$node/*|$node/text()" mode="literal"/>
</xsl:template>

<xsl:template match="*" mode="literal">
<xsl:text>&lt;</xsl:text><xsl:value-of select="name(.)"/>

<xsl:for-each select="@*">
<xsl:text> </xsl:text><xsl:value-of select="name(.)"/><xsl:text>="</xsl:text><xsl:value-of select="." disable-output-escaping="no"/><xsl:text>"</xsl:text>
</xsl:for-each>

<xsl:choose>
<xsl:when test="count(child::node())= 0">
	<xsl:text>/&gt;</xsl:text>
</xsl:when>
<xsl:otherwise>
	<xsl:text>&gt;</xsl:text>
	<xsl:apply-templates select="*|text()" mode="literal"/>
	<xsl:text>&lt;/</xsl:text><xsl:value-of select="name(.)"/><xsl:text>&gt;</xsl:text>
</xsl:otherwise>
</xsl:choose>


</xsl:template>

<xsl:template match="text()" mode="literal">
<xsl:value-of select="." disable-output-escaping="yes"/>
</xsl:template>




</xsl:stylesheet>
