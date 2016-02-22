<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:rgd="https://www.reddit.com/r/redditgetsdrawn/"
        version='1.0'
        >
<xsl:output method="xml" indent="yes"/>
  
<xsl:template match="/">
<rdf:RDF
	xmlns:rgd="https://www.reddit.com/r/redditgetsdrawn/"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	>
	<xsl:apply-templates select="//p[starts-with(.,'Submitter ') and count(a) = 3]"/>
</rdf:RDF>
</xsl:template>


<xsl:template match="p">
<rgd:Submission>
	
	<xsl:attribute name="rdf:about">
		<xsl:text>https://www.reddit.com/r/redditgetsdrawn/comments/</xsl:text>
		<xsl:value-of select="substring-before(substring-after(a[3]/@href,'/comments/'),'/')"/>
	</xsl:attribute>
	<rgd:image>
		<foaf:Image>
			<xsl:attribute name="rdf:about">
				<xsl:apply-templates select="a[1]" mode="imgur"/>
			</xsl:attribute>		
		</foaf:Image>
	</rgd:image>
	<xsl:apply-templates select="//div[@class='linkinfo']//time[1]" mode="dcdate" />
	<dc:author>
		<xsl:apply-templates select="a[1]" mode="foaf"/>
	</dc:author>
	<rgd:drawn>
		<rgd:Drawing>
				<xsl:attribute name="rdf:about">
					<xsl:apply-templates select="a[2]" mode="imgur"/>
				</xsl:attribute>		
		<rgd:image>
			<foaf:Image>
				<xsl:attribute name="rdf:about">
					<xsl:apply-templates select="a[2]" mode="imgur"/>
				</xsl:attribute>		
			</foaf:Image>
		</rgd:image>
		<dc:author>
		  <xsl:apply-templates select="a[2]" mode="foaf"/>
		</dc:author>
		<xsl:apply-templates select="preceding-sibling::p[strong and starts-with(.,'Selections from ')][1]" mode="favedby"/>
		</rgd:Drawing>
	</rgd:drawn>
</rgd:Submission>		
</xsl:template>

<xsl:template match="a" mode="foaf">
	<foaf:Person>
		<xsl:attribute name="rdf:about">https://www.reddit.com/user/<xsl:value-of select="text()"/></xsl:attribute>
		<foaf:name><xsl:value-of select="text()"/></foaf:name>
	</foaf:Person>
</xsl:template>

<xsl:template match="time" mode="dcdate">
<dc:date><xsl:value-of select="@datetime"/></dc:date>
</xsl:template>

<xsl:template match="strong" mode="favedby">
<xsl:variable name="n" select="substring-before(substring-after(.,' from '),':')"/>
<rgd:faved_by>
	<foaf:Person>
		<xsl:attribute name="rdf:about">https://www.reddit.com/user/<xsl:value-of select="$n"/></xsl:attribute>
		<foaf:name><xsl:value-of select="$n"/></foaf:name>
	</foaf:Person>
</rgd:faved_by>
</xsl:template>

<xsl:template match="a" mode="imgur">
<xsl:choose>
  <xsl:when test="contains(@href,'imgur.com/')">
	<xsl:variable name="a">
		<xsl:choose>
        	  <xsl:when test="starts-with(@href,'https://i.imgur')">
			<xsl:text>https://</xsl:text>
	                <xsl:value-of select="substring-after(@href,'i.')"/>
		  </xsl:when>
  		  <xsl:otherwise><xsl:value-of select="@href"/></xsl:otherwise>
		</xsl:choose>
        </xsl:variable>
	<xsl:choose>
		<xsl:when test="contains($a,'.jpg')">
	          <xsl:value-of select="substring($a,1,string-length($a) - 4)"/>
		</xsl:when>
		<xsl:when test="contains($a,'.png')">
	          <xsl:value-of select="substring($a,1,string-length($a) - 4)"/>
		</xsl:when>
		<xsl:otherwise>
	          <xsl:value-of select="$a"/>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:when>
  <xsl:otherwise>
   <xsl:value-of select="@href"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
