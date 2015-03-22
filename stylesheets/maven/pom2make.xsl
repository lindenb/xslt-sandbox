<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        xmlns:date="http://exslt.org/dates-and-times" 
        xmlns:xi="http://www.w3.org/2001/XInclude"
        xmlns:pom="http://maven.apache.org/POM/4.0.0"
		version='1.0'
		exclude-result-prefixes="date xi"
        >
<!--
Author:
        Pierre Lindenbaum @yokofakun
        http://plindenbaum.blogspot.com

Motivation:
	generate Makefile for simple use-case with apache maven
	
Example:
	xsltproc pom2make.xsl "http://central.maven.org/maven2/org/eclipse/jetty/jetty-server/9.3.0.M2/jetty-server-9.3.0.M2.pom"  |\
		make -f - 


-->
<xsl:output method="text"/>

<xsl:template match="/">
<xsl:text>
lib.dir=lib
all.jars = $(addprefix ${lib.dir}/,$(sort </xsl:text>
<xsl:apply-templates select="pom:project" mode="make"/>
<xsl:text>))

.PHONY:all

all: ${all.jars}
${all.jars} : 
	mkdir -p $(dir $@) &amp;&amp; curl -o $@ "http://central.maven.org/maven2/$(patsubst ${lib.dir}/%,%,$@)"
</xsl:text>
</xsl:template>

<xsl:template match="pom:project" mode="make">

<xsl:text> </xsl:text>
<xsl:apply-templates select="." mode="jar.path"/>

<xsl:for-each select="pom:dependencies/pom:dependency[not(pom:scope/text() ='test')]">
<xsl:apply-templates select="." mode="make"/>
</xsl:for-each>
</xsl:template>


<xsl:template match="pom:dependency" mode="make">
<xsl:variable name="groupId">
	<xsl:apply-templates select="." mode="groupId"/>
</xsl:variable>
<xsl:variable name="artifactId">
	<xsl:apply-templates select="." mode="artifactId"/>
</xsl:variable>
<xsl:variable name="version">
	<xsl:apply-templates select="." mode="version"/>
</xsl:variable>

<xsl:variable name="url">
		 <xsl:value-of select="concat('http://central.maven.org/maven2/',translate($groupId,'.','/'),'/',$artifactId,'/',$version,'/',$artifactId,'-',$version,'.pom')"/>
</xsl:variable>

<xsl:message>Getting POM: <xsl:value-of select="$url"/></xsl:message>
<xsl:apply-templates select="document($url,/)/pom:project" mode="make"/>
</xsl:template>


<xsl:template match="pom:project" mode="version">
 <xsl:choose>
 	<xsl:when test="pom:version"><xsl:value-of select="pom:version/text()"/></xsl:when>
 	<xsl:otherwise><xsl:value-of select="pom:parent/pom:version/text()"/></xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="pom:project" mode="groupId">
 <xsl:choose>
 	<xsl:when test="pom:groupId"><xsl:value-of select="pom:groupId/text()"/></xsl:when>
 	<xsl:otherwise><xsl:value-of select="pom:parent/pom:groupId/text()"/></xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="pom:project" mode="artifactId">
 <xsl:value-of select="pom:artifactId/text()"/>
</xsl:template>

<xsl:template match="pom:dependency" mode="groupId">
 <xsl:value-of select="pom:groupId"/>
</xsl:template>

<xsl:template match="pom:dependency" mode="artifactId">
 <xsl:value-of select="pom:artifactId"/>
</xsl:template>

<xsl:template match="pom:dependency" mode="version">
	<xsl:choose>
		<xsl:when test="string-length(pom:version/text()) = 0">
			<xsl:variable name="groupId">
				<xsl:apply-templates select="." mode="groupId"/>
			</xsl:variable>
			<xsl:variable name="artifactId">
				<xsl:apply-templates select="." mode="artifactId"/>
			</xsl:variable>
			<xsl:variable name="url">
			 <xsl:value-of select="concat('http://central.maven.org/maven2/',translate($groupId,'.','/'),'/',$artifactId,'/maven-metadata.xml')"/>
			</xsl:variable>
			<xsl:message>Downloading metadata <xsl:value-of select="$url"/> to get release version</xsl:message>
			<xsl:value-of select="document($url,/)/metadata/versioning/release/text()"/>
		</xsl:when>
		<xsl:when test="pom:version/text() = '${project.version}'">
			<xsl:apply-templates select="../.." mode="version"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="pom:version/text()"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="pom:dependency|pom:project" mode="jar.path">
<xsl:variable name="groupId">
	<xsl:apply-templates select="." mode="groupId"/>
</xsl:variable>
<xsl:variable name="artifactId">
	<xsl:apply-templates select="." mode="artifactId"/>
</xsl:variable>
<xsl:variable name="version">
	<xsl:apply-templates select="." mode="version"/>
</xsl:variable>
<xsl:value-of select="concat(translate($groupId,'.','/'),'/',$artifactId,'/',$version,'/',$artifactId,'-',$version,'.jar')"/>
</xsl:template>

</xsl:stylesheet>
