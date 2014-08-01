<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns="http://www.w3.org/1999/xhtml"
	version='1.0'
	>
<!--

Author:
	Pierre Lindenbaum PhD
	plindenbaum@yahoo.fr

Motivation:
	This stylesheet transform xml/dom  to StAX (Streaming Java API for XML) statements

-->
<xsl:output method="text" />


<xsl:template match="/">
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

public class XML2StAX
{
public static void main(String args[])
	{
	try
		{
		XMLOutputFactory factory= XMLOutputFactory.newInstance();
		XMLStreamWriter w= factory.createXMLStreamWriter(System.out);
		w.writeStartDocument("UTF-8","1.0");
<xsl:apply-templates/>
		w.writeEndDocument();
		w.flush();
		}
	catch(Exception err)
		{
		err.printStackTrace();
		}
	}
}</xsl:template>

<xsl:template match="*">
<xsl:variable name="prefix" select="substring-before(name(.),':')"/>
<xsl:variable name="has_prefix" select="string-length(local-name(.)) &lt; string-length(name(.))"/>
<xsl:variable name="ns">
<xsl:apply-templates select="." mode="ns"/>
</xsl:variable>
<xsl:variable name="has_ns" select="string-length($ns) &gt; 0"/>
<xsl:variable name="has_child" select="count(node()) &gt; 0"/>

<xsl:apply-templates select="." mode="parent"/>

<xsl:choose>
<xsl:when test="$has_prefix and $has_ns and $has_child">
<xsl:text>w.writeStartElement(&quot;</xsl:text>
<xsl:value-of select="$prefix"/>
<xsl:text>&quot;,&quot;</xsl:text>
<xsl:value-of select="local-name(.)"/>
<xsl:text>&quot;,</xsl:text>
<xsl:value-of select="$ns"/>
<xsl:text>);
</xsl:text>
<xsl:apply-templates select="." mode="xmlnsdecl"/>
<xsl:apply-templates select="@*"/>
<xsl:apply-templates />
<xsl:text>w.writeEndElement();//</xsl:text>
<xsl:value-of select="name(.)"/>
<xsl:text>
</xsl:text>
</xsl:when>

<xsl:when test="$has_prefix and $has_ns">
<xsl:text>w.writeEmptyElement(&quot;</xsl:text>
<xsl:value-of select="$prefix"/>
<xsl:text>&quot;,&quot;</xsl:text>
<xsl:value-of select="local-name(.)"/>
<xsl:text>&quot;,</xsl:text>
<xsl:value-of select="$ns"/>
<xsl:text>);
</xsl:text>
<xsl:apply-templates select="." mode="xmlnsdecl"/>
<xsl:apply-templates select="@*"/>
</xsl:when>

<xsl:when test="not($has_prefix) and not($has_ns)">
<xsl:text>w.writeStartElement(&quot;</xsl:text>
<xsl:value-of select="name(.)"/>
<xsl:text>&quot;);
</xsl:text>
<xsl:apply-templates select="." mode="xmlnsdecl"/>
<xsl:apply-templates select="@*"/>
<xsl:apply-templates />
<xsl:text>w.writeEndElement();//</xsl:text>
<xsl:value-of select="name(.)"/>
<xsl:text>
</xsl:text>
</xsl:when>


<xsl:otherwise>
TODO elements
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="text()">
<xsl:text>w.writeCharacters("</xsl:text>
<xsl:call-template name="escape">
<xsl:with-param name="s"><xsl:value-of select="."/></xsl:with-param>
</xsl:call-template>
<xsl:text>");
</xsl:text>
</xsl:template>


<xsl:template match="@*">
<xsl:variable name="prefix" select="substring-before(name(.),':')"/>
<xsl:variable name="has_prefix" select="string-length(local-name(.)) &lt; string-length(name(.))"/>
<xsl:variable name="ns">
<xsl:apply-templates select="." mode="ns"/>
</xsl:variable>
<xsl:variable name="has_ns" select="string-length($ns) &gt; 0"/>

<xsl:choose>
<xsl:when test="$has_prefix and $has_ns">
<xsl:text>w.writeAttribute(&quot;</xsl:text>
<xsl:value-of select="$prefix"/>
<xsl:text>&quot;,&quot;</xsl:text>
<xsl:value-of select="local-name(.)"/>
<xsl:text>&quot;,</xsl:text>
<xsl:value-of select="$ns"/>
<xsl:text>,&quot;</xsl:text>
<xsl:call-template name="escape">
<xsl:with-param name="s"><xsl:value-of select="."/></xsl:with-param>
</xsl:call-template>
<xsl:text>&quot;);
</xsl:text>
</xsl:when>


<xsl:when test="not($has_prefix) and not($has_ns)">
<xsl:text>w.writeAttribute(&quot;</xsl:text>
<xsl:value-of select="name(.)"/>
<xsl:text>&quot;,&quot;</xsl:text>
<xsl:call-template name="escape">
<xsl:with-param name="s"><xsl:value-of select="."/></xsl:with-param>
</xsl:call-template>
<xsl:text>&quot;);
</xsl:text>
</xsl:when>

<xsl:otherwise>
<xsl:message>TODO</xsl:message>
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="*" mode="xmlnsdecl">
<xsl:for-each select="namespace::*">
<xsl:choose>
<xsl:when test="string-length(name()) = 0 and .!='http://www.w3.org/1999/xhtml'">
w.writeDefaultNamespace(<xsl:apply-templates select="." mode="ns"/>);
</xsl:when>
<xsl:when test="string-length(name()) &gt; 0 and .!='http://www.w3.org/1999/xhtml'">

</xsl:when>
</xsl:choose>
</xsl:for-each>
</xsl:template>

<xsl:template match="text()">
<xsl:text>w.writeCharacters("</xsl:text>
<xsl:call-template name="escape">
<xsl:with-param name="s"><xsl:value-of select="."/></xsl:with-param>
</xsl:call-template>
<xsl:text>");
</xsl:text>
</xsl:template>

<xsl:template match="*|@*" mode="parent">

</xsl:template>


<xsl:template match="*|@*" mode="ns">
<xsl:variable name="uri" select="namespace-uri(.)"/>
<xsl:choose>
	<xsl:when test="$uri =''"></xsl:when>
	<xsl:when test="$uri='http://www.w3.org/1999/XSL/Transform'">XSL.NS</xsl:when>
	<xsl:when test="$uri='http://www.w3.org/1999/xhtml'">HTML.NS</xsl:when>
	<xsl:when test="$uri='http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul'">XUL.NS</xsl:when>
	<xsl:when test="$uri='http://www.w3.org/2000/svg'">SVG.NS</xsl:when>
	<xsl:when test="$uri='http://www.w3.org/1999/xlink'">XLINK.NS</xsl:when>
	<xsl:when test="$uri='http://www.w3.org/1999/02/22-rdf-syntax-ns#'">RDF.NS</xsl:when>
	<xsl:when test="$uri='http://www.w3.org/2000/01/rdf-schema#'">RDFS.NS</xsl:when>
	<xsl:when test="starts-with($uri,'urn:oasis:names:tc:opendocument:xmlns:')">
		<xsl:value-of select="concat('OO_',translate(substring-before(substring-after($uri,'xmlns:'),':'),'abcdefghijklmnopqrstuvwxyz-','ABCDEFGHIJKLMNOPQRSTUVWXYZ_'))"/>
	</xsl:when>
	<xsl:when test="$uri='http://purl.org/dc/elements/1.1/'">PURL_ELEMENTS.NS</xsl:when>
	
	<xsl:otherwise>"<xsl:value-of select="$uri"/>"</xsl:otherwise>
</xsl:choose>
</xsl:template>



<xsl:template name="escape">
<xsl:param name="s"/><xsl:variable name="c"><xsl:value-of select="substring($s,1,1)"/></xsl:variable>
<xsl:choose>
 <xsl:when test="$c='&#xA;'">\n</xsl:when>
 <xsl:when test='$c="&#39;"'>\'</xsl:when>
 <xsl:when test="$c='&#34;'">\"</xsl:when>
 <xsl:otherwise><xsl:value-of select="$c"/></xsl:otherwise>
</xsl:choose><xsl:if test="string-length($s) &gt;1"><xsl:call-template name="escape">
<xsl:with-param name="s"><xsl:value-of select="substring($s,2,string-length($s)-1)"/></xsl:with-param>
</xsl:call-template></xsl:if>
</xsl:template>


</xsl:stylesheet>

