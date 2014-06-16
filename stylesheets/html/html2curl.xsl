<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:str="http://exslt.org/strings"
	version="1.0">

<xsl:output method="text"/>

<xsl:template match="/">
<xsl:text>'</xsl:text>
<xsl:apply-templates select="//input[@name and @value]|textarea[@name]"/>
<xsl:text>'
</xsl:text>
</xsl:template> 
 
<xsl:template match="input[@name and @value]">
<xsl:text>&amp;</xsl:text>
<xsl:value-of select="str:encode-uri(@name,'UTF-8')"/>
<xsl:text>=</xsl:text>
<xsl:value-of select="str:encode-uri(@value,'UTF-8')"/>
</xsl:template> 

<xsl:template match="textarea[@name]">
<xsl:text>&amp;</xsl:text>
<xsl:value-of select="str:encode-uri(@name,'UTF-8')"/>
<xsl:text>=</xsl:text>
<xsl:value-of select="str:encode-uri(.,'UTF-8')"/>
</xsl:template> 


</xsl:stylesheet>
