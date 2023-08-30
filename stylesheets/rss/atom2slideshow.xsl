<?xml version='1.0'  encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:media="http://search.yahoo.com/mrss/"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:xhtml='http://www.w3.org/1999/xhtml'
	exclude-result-prefixes="atom media"
	version='1.1'
	>
<!-- use with feed having content/@type="xhtml" -->
<xsl:output method="html" indent="yes"/>


<xsl:template match="/">
<html>
<head>
	<title>Atom merger</title>

<script>
var feeds=[];
function init() {
	var feed = null;
	var content = null;
	<xsl:apply-templates select="atom:feed"/>
	};
function show(idx) {
	if(idx&lt;0 ||idx &gt;=feeds.length) return;
	window.scrollTo(0,0);
	var feed = feeds[idx];
	var root= document.getElementById("content");
	while(root.firstChild) root.removeChild(root.firstChild);
	
	var h3 = document.createElement("h3");
	root.appendChild(h3);
	h3.appendChild(document.createTextNode(feed.title+" ("+feed.updated+") N:"+feed.images.length));
	
	var p= document.createElement("p");
	for(var x in feed.images)
		{
		var image = feed.images[x];
		var a = document.createElement("a");
		
		a.setAttribute("target","_blank");
		a.setAttribute("href",image.href);
		a.setAttribute("title",image.href);
		
		var img = document.createElement("img");
		img.setAttribute("src",image.src);
		img.setAttribute("width",image.width);
		img.setAttribute("height",image.height);
		img.setAttribute("alt",image.href);
		
		a.appendChild(img);
		p.appendChild(a);
		}
	
	root.appendChild(p);
	}
window.addEventListener("load", function(event) {
	init();
	show(0);
	});
</script>
</head>
<body>
<div id="content"></div>
<hr/>
<div>
<xsl:for-each select="atom:feed/atom:entry">
	<xsl:text>[</xsl:text>
	<a>
		<xsl:attribute name="href">javascript:show(<xsl:value-of select="position() - 1"/>);</xsl:attribute>
		<xsl:value-of select="atom:title/text()"/>
	</a>
	<xsl:text>]</xsl:text>
	<xsl:text> | </xsl:text>
</xsl:for-each>
</div>
</body>
</html>
</xsl:template>

<xsl:template match="atom:feed">
 <xsl:apply-templates select="atom:entry"/>
</xsl:template>





<xsl:template match="atom:entry">
feed={};
feed.href="<xsl:value-of select="atom:link/@href"/>";
feed.title="<xsl:value-of select="atom:title/text()"/>";
feed.updated="<xsl:value-of select="atom:updated/text()"/>";
feed.images =[];
<xsl:apply-templates select="atom:content[@type='xhtml']"/>
feeds.push(feed);
</xsl:template>

<xsl:template match="atom:content">

<xsl:for-each select=".//xhtml:img[local-name(..)='a' and @src and ../@href]">
feed.images.push({
"href":"<xsl:value-of select="../@href"/>",
"src":"<xsl:value-of select="@src"/>",
"width":"<xsl:value-of select="@width"/>",
"height":"<xsl:value-of select="@height"/>"
});
</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
