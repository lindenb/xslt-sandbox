<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:t="http://github.com/lindenb/xslt-sandbox/stylesheets/xml/html2javascript"
	version='1.0'
	>

<xsl:output method="text" />


<xsl:template match="/">
<xsl:apply-templates select="t:templates" />
</xsl:template>

<xsl:template match="html" mode="root">
var htmlToJavaScript = {
	<xsl:apply-templates select="t:template"/>,
	"name":"<xsl:value-of select="@name"/>",
	"document": document
	};
</xsl:template>


<xsl:template match="*" mode="var">
<xsl:value-of select="concat(name(.),'_',generate-id(.))"/>
</xsl:template>

<xsl:template match="t:template">
"<xsl:value-of select="@name"/>": function(param) {
	var frag = this.document.createDocumentFragment();
	var curr = frag;
	<xsl:apply-templates select="*|text()"/>
<xsl:text>
	return frag;
	},
	</xsl:text>
</xsl:template>

<xsl:template match="t:value-of">
	curr.appendChild(  this.document.createTextNode( <xsl:value-of select="@select"/> ) );
</xsl:template>

<xsl:template match="t:inline">
	<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="td|th|a|i|b|u|div|span|li|caption|p|script|head|body|html">
	var <xsl:apply-templates select="." mode="var"/> = this.document.createElement("<xsl:value-of select="name(.)"/>");
	curr.appendChild( <xsl:apply-templates select="." mode="var"/> );
	curr = <xsl:apply-templates select="." mode="var"/>;
	<xsl:apply-templates select="@*"/>
	<xsl:apply-templates select="*|text()"/>
	curr = <xsl:apply-templates select="." mode="var"/>;
</xsl:template>

<xsl:template match="table|thead|tr|tbody|ul|ol|embed|object|param|img|meta">
	var <xsl:apply-templates select="." mode="var"/>= this.document.createElement("<xsl:value-of select="name(.)"/>");
	curr.appendChild( <xsl:apply-templates select="." mode="var"/> );
	curr = <xsl:apply-templates select="." mode="var"/>;
	<xsl:apply-templates select="@*"/>
	<xsl:apply-templates select="*"/>
	curr = <xsl:apply-templates select="." mode="var"/>;
</xsl:template>


<xsl:template match="@*">
	curr.setAttribute("<xsl:call-template name="escape">
   <xsl:with-param name="s">
      <xsl:value-of select="name(.)"/>
   </xsl:with-param>
</xsl:call-template>","<xsl:call-template name="escape">
   <xsl:with-param name="s">
      <xsl:value-of select="."/>
   </xsl:with-param>
</xsl:call-template>");
</xsl:template>

<xsl:template match="text()">
	curr.appendChild( this.document.createTextNode("<xsl:call-template name="escape">
   <xsl:with-param name="s">
      <xsl:value-of select="."/>
   </xsl:with-param>
</xsl:call-template>"));
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

