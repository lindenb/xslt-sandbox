<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns="http://www.w3.org/1999/xhtml"
	version='1.0'
	>
<!--

Author:
	Pierre Lindenbaum PhD
	plindenbaum@yahoo.fr

Motivation:
	This stylesheet transform xml/dom  to libxml writer
Usage:
	xsltproc  xml2libxml-writer.xsl  file.xml > xml.c
-->
<xsl:output method="text" />


<xsl:template match="/">
<xsl:apply-templates select="xsd:schema"/>
</xsl:template>

<xsl:template match="xsd:schema">
public class StaxReader
	{
	<xsl:apply-templates select="xsd:complexType"/>
	}
</xsl:template>

<xsl:template match="xsd:complexType">
	<xsl:variable name="type1"><xsl:apply-templates select="@name"  mode="javaName"/></xsl:variable>
	public <xsl:value-of select="$type1"/> parse<xsl:value-of select="$type1"/>(
		StartElement start
		in
		)
		{
		
		<xsl:variable name="var"><xsl:value-of select="generate-id(.)"/></xsl:variable>
		<xsl:value-of select="$type1"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$var"/>
		<xsl:text>=new </xsl:text>
		<xsl:value-of select="$type1"/>();
		<xsl:choose>
		<xsl:when test="xsd:sequence">
		
		<xsl:for-each select="xsd:sequence/xsd:element">
		<xsl:if test="@minOccurs and @minOccurs!=0">
		int <xsl:value-of select="concat('count_',@name)"/>=0;
		</xsl:if>
		</xsl:for-each>
		
		while(in.hasNext())
			{
			XMLEvent evt=in.nextEvent();
			if(evt.isStartElement())
				{
				StartElement start2=evt.asStartElement();
				String localName=start.getName().getLocalName();

				
				<xsl:for-each select="xsd:sequence/xsd:element">
				<xsl:if test="position()&gt;1">else </xsl:if>if(localName.equals(&quot;<xsl:value-of select="@name"/>&quot;))
					{

					<xsl:variable name="var2"><xsl:value-of select="generate-id(.)"/></xsl:variable>
					<xsl:variable name="method1"><xsl:apply-templates select="@name" mode="javaName"/></xsl:variable>
					<xsl:variable name="setter">
						<xsl:choose>
						  <xsl:when test="number(@maxOccurs)&gt;1 or @maxOccurs='unbounded'">
						   	<xsl:value-of select="concat('get',$method1,'().add')"/>
						  </xsl:when>
						  <xsl:otherwise>
						  	<xsl:value-of select="concat('set',$method1)"/>
						  </xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:variable name="type2">
						<xsl:choose>
						  <xsl:when test="@type='xsd:string'">String</xsl:when>
						  <xsl:when test="@type='xsd:int'">Integer</xsl:when>
						  <xsl:when test="@type='xsd:double'">Double</xsl:when>
						  <xsl:when test="@type='xsd:bool'">Boolean</xsl:when>
						  <xsl:otherwise>
						  <xsl:call-template name="titleize">
							<xsl:with-param name="name" select="substring-after(@type,':')"/>
						   </xsl:call-template>
						  </xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					

					
					<xsl:choose>
						<xsl:when test="@type">	
					 		<xsl:value-of select="concat($type2,' ',$var2)"/>=parse<xsl:value-of select="$type2"/>(start2,in);
					 	</xsl:when>
					 	<xsl:otherwise>
					 		/* TODO */
					 	</xsl:otherwise>
					</xsl:choose>
					
					<xsl:value-of select="$var"/>.<xsl:value-of select="$setter"/>(<xsl:value-of select="$var2"/>);
					
					<xsl:if test="@minOccurs and @minOccurs!=0">
					<xsl:value-of select="concat('++count_',@name,';')"/>
					</xsl:if>
					}
				</xsl:for-each>
				else
					{
					throw new XmlStreamException("Unexpected element "+localName);
					}
				}
			else if(evt.isEndElement())
				{
				break;
				}
			}
		<xsl:for-each select="xsd:sequence/xsd:element">
		<xsl:if test="@minOccurs and @minOccurs!=0">
		if(<xsl:value-of select="concat('count_',@name)"/>&lt;<xsl:value-of select="@minOccurs"/>)
			{
			throw new XmlStreamException("Illegal number of element in "+localName);
			}
		</xsl:if>
		<xsl:if test="@maxOccurs and @maxOccurs!='unbounded'">
		if(<xsl:value-of select="concat('count_',@name)"/>&gt;<xsl:value-of select="@maxOccurs"/>)
			{
			throw new XmlStreamException("Illegal number of element in "+localName);
			}
		</xsl:if>
		<xsl:if test="not(@maxOccurs)">
		if(<xsl:value-of select="concat('count_',@name)"/>==0)
			{
			throw new XmlStreamException("Illegal number of element in "+localName);
			}
		</xsl:if>
		</xsl:for-each>
		
		</xsl:when>
		</xsl:choose>
		return <xsl:apply-templates select="@name"/>;
		}

</xsl:template>

<xsl:template match="@*" mode="javaName">
	<xsl:call-template name="titleize">
		<xsl:with-param name="name" select="."/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="titleize">
 <xsl:param name="name"/>
 <xsl:value-of select="translate(substring($name,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
 <xsl:value-of select="substring($name,2)"/>
</xsl:template>





</xsl:stylesheet>

