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
	This stylesheet transform xml/dom  to libxml writer
Usage:
	xsltproc  xml2libxml-writer.xsl  file.xml > xml.c
-->
<xsl:output method="text" />


<xsl:template match="/">
/** 
 * Compilation:
 * 	 gcc xml.c `xml2-config  --cflags --libs`
 */
#include &lt;stdio.h&gt;
#include &lt;stdlib.h&gt;
#include &lt;libxml/encoding.h&gt;
#include &lt;libxml/xmlwriter.h&gt;
#define ENCODING "ISO-8859-1"

#define THROW(a) do { fprintf(stderr,"%s:%d:%s\n",__FILE__,__LINE__,a); exit(EXIT_FAILURE);} while(0)
#define XSL_NS "http://www.w3.org/1999/XSL/Transform"
#define HTML_NS "http://www.w3.org/1999/xhtml"
#define XUL_NS "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
#define SVG_NS "http://www.w3.org/2000/svg"
#define XLINK_NS "http://www.w3.org/1999/xlink"
#define RDF_NS "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
#define RDFS_NS "http://www.w3.org/2000/01/rdf-schema#"
#define XSLT_NS "http://www.w3.org/1999/XSL/Transform"

int main(int argc,char** argv)
	{
	int ret;
	LIBXML_TEST_VERSION
	xmlTextWriterPtr w= xmlNewTextWriterFilename("-", 0);
	if(w==NULL)
		{
        	THROW("Error creating the xml writer");
		}
	ret = xmlTextWriterStartDocument(w, NULL, ENCODING, NULL);
	if(ret&lt;0)
		{
        	THROW("Error xmlTextWriterStartDocument");
		}
	<xsl:apply-templates/>
	xmlFreeTextWriter(w);
	xmlCleanupParser();
	xmlMemoryDump();
	return EXIT_SUCCESS;
	}
</xsl:template>

<xsl:template match="node()">
<xsl:variable name="ns">
   <xsl:call-template name="namespace">
      <xsl:with-param name="uri">
         <xsl:value-of select="namespace-uri(.)"/>
      </xsl:with-param>
   </xsl:call-template>
</xsl:variable>


   <xsl:text>if(</xsl:text>
   <xsl:choose>
   	<xsl:when test="string-length($ns)&gt;0">
   	  <xsl:text>xmlTextWriterStartElementNS(w,BAD_CAST &quot;</xsl:text>
   	  <xsl:value-of select="substring-before(name(.),':')"/>
   	  <xsl:text>",BAD_CAST "</xsl:text>
   	  <xsl:value-of select="local-name(.)"/>
   	  <xsl:text>",BAD_CAST </xsl:text>
   	  <xsl:value-of select="$ns"/>
   	  <xsl:text>)</xsl:text>
   	</xsl:when>
   	<xsl:otherwise>
   	  <xsl:text>xmlTextWriterStartElement(w, BAD_CAST &quot;</xsl:text>
   	  <xsl:value-of select="name(.)"/>
   	  <xsl:text>&quot;)</xsl:text>
   	</xsl:otherwise>
   </xsl:choose>
   <xsl:text>&lt;0)
   	{
   	THROW("xmlTextWriterStartElement failed.");
   	}
   </xsl:text>
   <xsl:call-template name="atts"><xsl:with-param name="node" select="."/></xsl:call-template>
   
   <xsl:apply-templates select="*|text()"/>
   <xsl:text>if(xmlTextWriterEndElement(w)&lt;0)/* </xsl:text><xsl:value-of select="name(.)"/>
   <xsl:text> */
   	{
   	THROW("xmlTextWriterEndElement failed.");
   	}
   </xsl:text>
</xsl:template>


<xsl:template name="atts">

<xsl:param name="node"/>



<xsl:for-each select="$node/@*">

<xsl:choose>
   <xsl:when test="namespace-uri(.)=''">
      <xsl:text>if(xmlTextWriterWriteAttribute(w, BAD_CAST "</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>",BAD_CAST "</xsl:text>
      <xsl:call-template name="escape">
         <xsl:with-param name="s">
            <xsl:value-of select="."/>
         </xsl:with-param>
      </xsl:call-template>
      <xsl:text>")&lt;0)
      	{
      	THROW("xmlTextWriterWriteAttribute failed.");
      	}
</xsl:text>
   </xsl:when>
   <xsl:otherwise>
  
      <xsl:text>if(xmlTextWriterWriteAttributeNS(w, BAD_CAST "</xsl:text>
      <xsl:value-of select="substring-before(name(.),':')"/>
      <xsl:text>",BAD_CAST "</xsl:text>
      	     <xsl:value-of select="local-name(.)"/>
	   
            <xsl:text>",BAD_CAST "</xsl:text>
            
             <xsl:call-template name="namespace">
		<xsl:with-param name="uri">
		    <xsl:value-of select="namespace-uri(.)"/>
		</xsl:with-param>
            </xsl:call-template>
            <xsl:text>,BAD_CAST "</xsl:text>
            <xsl:call-template name="escape">
               <xsl:with-param name="s">
                  <xsl:value-of select="."/>
               </xsl:with-param>
            </xsl:call-template>
            <xsl:text>")&lt;0)
            {
            THROW("xmlTextWriterWriteAttributeNS failed.");
            }
</xsl:text>
            </xsl:otherwise>
</xsl:choose><xsl:text>
</xsl:text>
</xsl:for-each>
</xsl:template>

<xsl:template match="text()">

<xsl:if test="string-length(normalize-space(.))&gt;0">
<xsl:text>xmlTextWriterWriteString(w,BAD_CAST &quot;</xsl:text>
<xsl:call-template name="escape">
   <xsl:with-param name="s">
      <xsl:value-of select="."/>
   </xsl:with-param>
</xsl:call-template>
<xsl:text>&quot;);
</xsl:text>
</xsl:if>
</xsl:template>


<xsl:template name="namespace">
<xsl:param name="uri"/>

<xsl:choose>
	<xsl:when test="$uri='http://www.w3.org/1999/XSL/Transform'">XSL_NS</xsl:when>
	<xsl:when test="$uri='http://www.w3.org/1999/xhtml'">HTML_NS</xsl:when>
	<xsl:when test="$uri='http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul'">XUL_NS</xsl:when>
	<xsl:when test="$uri='http://www.w3.org/2000/svg'">SVG_NS</xsl:when>
	<xsl:when test="$uri='http://www.w3.org/1999/xlink'">XLINK_NS</xsl:when>
	<xsl:when test="$uri='http://www.w3.org/1999/02/22-rdf-syntax-ns#'">RDF_NS</xsl:when>
	<xsl:when test="$uri='http://www.w3.org/2000/01/rdf-schema#'">RDFS_NS</xsl:when>
	<xsl:when test="$uri='http://www.w3.org/1999/XSL/Transform'">XSLT_NS</xsl:when>
	<xsl:otherwise>"<xsl:value-of select="$uri"/>"</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="escape">
<xsl:param name="s"/><xsl:variable name="c"><xsl:value-of select="substring($s,1,1)"/></xsl:variable>
<xsl:choose>
 <xsl:when test="$c='&#xA;'">\n</xsl:when>
 <xsl:when test='$c="&#39;"'>\'</xsl:when>
 <xsl:when test="$c='&#34;'">\"</xsl:when>
 <xsl:when test="$c='\'">\\</xsl:when>
 <xsl:otherwise><xsl:value-of select="$c"/></xsl:otherwise>
</xsl:choose><xsl:if test="string-length($s) &gt;1"><xsl:call-template name="escape">
<xsl:with-param name="s"><xsl:value-of select="substring($s,2,string-length($s)-1)"/></xsl:with-param>
</xsl:call-template></xsl:if>
</xsl:template>


</xsl:stylesheet>

