<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:x="http://www.ibm.com/xmlns/prod/2009/jsonx"
	version='1.0'
	>
<!--

Author:
	Pierre Lindenbaum PhD
	plindenbaum@yahoo.fr

Motivation:
	JSONX-schema from http://jsonschema.net/reboot/#/ to AVRO
Usage:
	xsltproc  x
-->
<xsl:output method="xml" />


<xsl:template match="/">
<xsl:apply-templates select="x:object" mode="root"/>
</xsl:template>

<xsl:template match="x:object" mode="root">
<x:object>
  <x:string name="name">TODO</x:string>
 <xsl:choose>
 	<xsl:when test="x:object[@name='properties']">
 		 
 		<xsl:apply-templates select="." mode='object'/>
 	</xsl:when>
 	<xsl:when test="x:string[@name='type']='array'">
 		 <x:string name="type">array</x:string>
 		<xsl:apply-templates select="." mode="field"/>
 	</xsl:when>
 </xsl:choose>
</x:object>


        
	 

</xsl:template>

<xsl:template match="x:object" mode="object">
<x:string name="type">record</x:string>
<xsl:apply-templates select="x:object[@name='properties']" mode='properties'/>
</xsl:template>

<xsl:template match="x:object" mode="properties">
<x:array name="fields">
	 <xsl:apply-templates select="x:object" mode="field"/>
</x:array>
</xsl:template>


<xsl:template match="x:object" mode="field">
<xsl:variable name="type" select="x:string[@name='type']/text()"/>
<xsl:variable name="optional" select="x:boolean[@name='required'] = 'false'"/>
<x:object>
	 <xsl:apply-templates select="x:string[@name='id']" mode="fieldid"/>
	 <xsl:choose>
	 	<xsl:when test="$type = 'string'">
	 		<xsl:choose>
	 			<xsl:when test='$optional'>
	 				<x:array name="type">
	 					<x:null/>
	 					<x:string><xsl:value-of select="$type"/></x:string>
	 				</x:array>
	 			</xsl:when>
		 		<xsl:otherwise>
		 			<x:string name="type"><xsl:value-of select="$type"/></x:string>
		 		</xsl:otherwise>
	 		</xsl:choose>
	 	</xsl:when>
	 	<xsl:when test="$type = 'integer'">
	 		<xsl:choose>
	 			<xsl:when test='$optional'>
	 				<x:array name="type">
	 					<x:null/>
	 					<x:string>int</x:string>
	 				</x:array>
	 			</xsl:when>
		 		<xsl:otherwise>
		 			<x:string name="type">int</x:string>
		 		</xsl:otherwise>
	 		</xsl:choose>

	 	</xsl:when>
	 	<xsl:when test="$type = 'array' ">
	 		<xsl:variable name="subtype" select="x:object[@name='items']/x:string[@name='type']/text()"/>
	 		<x:string name="type">array</x:string>
			 <xsl:choose>
			 	<xsl:when test="$subtype = 'string' ">
			 		<x:string name="items">
			 		 <xsl:value-of select="$type"/>
			 		</x:string>
			 	</xsl:when>
			 	<xsl:when test="$subtype = 'integer' ">
			 		<x:string name="type">int</x:string>
			 	</xsl:when>
			 	<xsl:when test="$subtype = 'object' ">
			 		<x:object name="items">
			 		<xsl:apply-templates select="x:string[@name='id']" mode="fieldid"/>
			 		<xsl:apply-templates select="x:object[@name='items']" mode="object"/>
			 		</x:object>
			 	</xsl:when>
			 	<xsl:otherwise>
			 		<xsl:message terminate='yes'>BOUM <xsl:value-of select="$subtype"/></xsl:message>
			 	</xsl:otherwise>
			 </xsl:choose>
	 	</xsl:when>
	 	<xsl:otherwise>
	 		<xsl:message terminate='yes'>BOUM <xsl:value-of select="$type"/></xsl:message>
	 	</xsl:otherwise>
	 </xsl:choose>
</x:object>
</xsl:template>

<xsl:template match="x:string" mode="fieldid">
	<x:string name="name">
	<xsl:value-of select="substring(.,2)"/>
	</x:string>
</xsl:template>


</xsl:stylesheet>

