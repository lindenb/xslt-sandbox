<?xml version="1.0"?>
<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:h="http://www.w3.org/1999/xhtml"
  >
  
<xsl:template match="h:b">
	<fo:inline font-weight="bold">
		<xsl:apply-templates/>
	</fo:inline>
</xsl:template>

<xsl:template match="h:i">
	<fo:inline font-style="italic">
		<xsl:apply-templates/>
	</fo:inline>
</xsl:template>

<xsl:template match="h:em">
	<fo:inline xsl:use-attribute-sets="em">
		<xsl:apply-templates/>
	</fo:inline>
</xsl:template>

<xsl:template match="h:u">
	<fo:inline text-decoration="underline">
		<xsl:apply-templates/>
	</fo:inline>
</xsl:template>

<xsl:template match="h:br">
		<fo:block/>
</xsl:template>


<xsl:template match="h:a[@href]">
	<fo:basic-link>
		<xsl:if test="starts-with(@href,'#')">
			<xsl:attribute name="internal-destination">
				<xsl:value-of select="substring-after(@href,'#')"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="starts-with(@href,'#')=false">
			<xsl:attribute name="external-destination">
				<xsl:value-of select="@href"/>
			</xsl:attribute>
			<fo:inline>
				<xsl:variable name="anchor-texts">
					<xsl:apply-templates/>
				</xsl:variable>
				<xsl:apply-templates/>
				<xsl:if test="@href!=$anchor-texts">
					<fo:inline>
						<xsl:text>(</xsl:text>
						<xsl:value-of select="@href"/>
						<xsl:text>)</xsl:text>
					</fo:inline>
				</xsl:if>
			</fo:inline>
		</xsl:if>
	</fo:basic-link>
</xsl:template>

<xsl:template match="h:a[@name]">
	<fo:inline id="{@name}">
		<xsl:apply-templates/>
	</fo:inline>
</xsl:template>

	
<xsl:template match="h:span">
	<fo:inline>
		<xsl:apply-templates/>
	</fo:inline>
</xsl:template>

<xsl:template match="h:pre">
	<fo:block xsl:use-attribute-sets="program">
		<xsl:apply-templates select="text()"/>
	</fo:block>
</xsl:template>

<xsl:template match="h:p">
	<fo:block xsl:use-attribute-sets="p">
		<xsl:if test="@type='continue'">
			<xsl:attribute name="text-indent">inherit</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates/>
	</fo:block>
</xsl:template>

<xsl:template match="h:div">
	<fo:block>
		<xsl:apply-templates/>
	</fo:block>
</xsl:template>


</xsl:stylesheet>	
	

