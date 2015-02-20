<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

<xsl:output method="xml"/>
<!-- normalize github pages 


Example:  curl -s "https://github.com/lindenb/jvarkit/wiki/SamJS" | xsltproc -\-html ./github2html.xsl  -   > result.html


-->

<xsl:template match="/">
<xsl:apply-templates select="html"/>
</xsl:template> 
 
<xsl:template match="html">
<html>
<xsl:apply-templates select="head|body"/>
</html>
</xsl:template> 

<xsl:template match="head">
<head>
<xsl:apply-templates select="title"/>
</head>
</xsl:template> 

<xsl:template match="title">
<title>
<xsl:value-of select="."/>
</title>
</xsl:template> 

<xsl:template match="body">
<body style="font-family: sans-serif;color: rgb(51, 51, 51);">
<xsl:choose>
<xsl:when test="count(.//article) = 1">
<xsl:apply-templates select=".//article"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="//div[@class='markdown-body']|//article"/>
</xsl:otherwise>
</xsl:choose>
</body>
</xsl:template> 

<xsl:template match="article">
<div style="font-size: 15px; line-height: 1.7;word-wrap: break-word;background: none repeat scroll 0% 0% rgb(255, 255, 255);">
<xsl:apply-templates/>
</div>
</xsl:template>


<xsl:template match="span[@class='na']">
<span style="color: rgb(0, 128, 128);">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="div[@class='highlight']">
<div style=" background: none repeat scroll 0% 0% rgb(255, 255, 255);">
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="span[@class='o']">
<span style="font-weight: bold;">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='highlight']">
<span style="font-weight: bold;">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='s']">
<span style="color: rgb(221, 17, 68);">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='n']">
<span style="color: rgb(221, 17, 68);">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='mi']">
<span style="color: rgb(0, 153, 153);">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='mf']">
<span style="color: rgb(0, 153, 153);">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='se']">
<span style="color: rgb(221, 17, 68);">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='nv']">
<span style="color: rgb(0, 128, 128);">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='m']">
<span style="color: rgb(0, 153, 153);">
<xsl:apply-templates/>
</span>
</xsl:template>


<xsl:template match="span[@class='s1']">
<span style="color: rgb(221, 17, 68);">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='s2']">
<span style="color: rgb(221, 17, 68);">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='nf']">
<span style="color: rgb(153, 0, 0);font-weight: bold;">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='mo']">
<span style="color: rgb(0, 153, 153);">
<xsl:apply-templates/>
</span>
</xsl:template>


<xsl:template match="span[@class='o']">
<span style="font-weight: bold;">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='nt']">
<span style="color: rgb(0, 0, 128);">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='ni']">
<span style="color: rgb(128, 0, 128);">
<xsl:apply-templates/>
</span>
</xsl:template>


<xsl:template match="span[@class='c']">
<span style="color: rgb(153, 153, 136);font-style: italic;">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='c1']">
<span style="color: rgb(153, 153, 136);font-style: italic;">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='cp']">
<span style="color: rgb(153, 153, 153); font-weight: bold;">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='nb']">
<span style="color: rgb(0, 134, 179);">
<xsl:apply-templates/>
</span>
</xsl:template>


<xsl:template match="span[@class='p']">
<span>
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='k']">
<span>
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="span[@class='gi']">
<span style="color:green;">
<xsl:apply-templates/>
</span>
</xsl:template>


<xsl:template match="a[@href]">
<a>
<xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
<xsl:apply-templates/>
</a>
</xsl:template>


<xsl:template match="img[@src]">
<img>
<xsl:attribute name="src"><xsl:value-of select="@src"/></xsl:attribute>
<xsl:attribute name="alt"><xsl:value-of select="@alt"/></xsl:attribute>
</img>
</xsl:template>

<xsl:template match="pre|code|kbd|samp">
<xsl:element name="{local-name(.)}">
<xsl:attribute name="style">
background-color: rgb(248, 248, 248);
border-bottom-color: rgb(221, 221, 221);
border-bottom-left-radius: 3px;
border-bottom-right-radius: 3px;
border-bottom-style: solid;
border-bottom-width: 1px;
border-image-outset: 0 0 0 0;
border-image-repeat: stretch stretch;
border-image-slice: 100% 100% 100% 100%;
border-image-source: none;
border-image-width: 1 1 1 1;
border-left-color: rgb(221, 221, 221);
border-left-style: solid;
border-left-width: 1px;
border-right-color: rgb(221, 221, 221);
border-right-style: solid;
border-right-width: 1px;
border-top-color: rgb(221, 221, 221);
border-top-left-radius: 3px;
border-top-right-radius: 3px;
border-top-style: solid;
border-top-width: 1px;
color: rgb(51, 51, 51);
font-family: Consolas,"Liberation Mono",Courier,monospace;
font-size: 13px;
font-size-adjust: none;
font-stretch: normal;
font-style: normal;
font-variant: normal;
font-weight: 400;
line-height: 19px;
margin-bottom: 15px;
margin-left: 0px;
margin-right: 0px;
margin-top: 15px;
overflow: auto;
overflow-x: auto;
overflow-y: auto;
padding-bottom: 6px;
padding-left: 10px;
padding-right: 10px;
padding-top: 6px;
word-wrap: break-word;
</xsl:attribute>
<xsl:apply-templates/>
</xsl:element>
</xsl:template>

<xsl:template match="blockquote">
<blockquote style="border-left-color: #DDD;border-left-style: solid;border-left-width: 4px;box-sizing: border-box;color: #777; font-size: 16px;font-size-adjust: none;font-stretch: normal;font-style: normal;font-variant: normal;font-weight: 400;line-height: 25.6px;margin-bottom: 16px;margin-left: 0px;margin-right: 0px;margin-top: 0px;padding-bottom: 0px;padding-left: 15px;padding-right: 15px;padding-top: 0px;word-wrap: break-word;-moz-font-feature-settings: normal;-moz-font-language-override: normal;">
<xsl:apply-templates/>
</blockquote>
</xsl:template>


<xsl:template match="table">
<table>
<xsl:attribute name="style">
border-collapse: collapse;
border-spacing: 0px 0px;
color: rgb(51, 51, 51);
display: block;
font-family: Helvetica,arial,freesans,clean,sans-serif;
font-size: 15px;
font-size-adjust: none;
font-stretch: normal;
font-style: normal;
font-variant: normal;
font-weight: 400;
line-height: 25.5px;
margin-bottom: 15px;
margin-left: 0px;
margin-right: 0px;
margin-top: 15px;
overflow: auto;
overflow-x: auto;
overflow-y: auto;
width: 920px;
word-wrap: break-word;
-moz-font-feature-settings: normal;
-moz-font-language-override: normal;
</xsl:attribute>
<xsl:apply-templates/>
</table>
</xsl:template>

<xsl:template match="tr">
<tr>
<xsl:attribute name="style">
border-top: 1px solid rgb(204, 204, 204);
background-color: rgb(255, 255, 255);
border-top-style: solid;
</xsl:attribute>
<xsl:apply-templates/>
</tr>
</xsl:template>

<xsl:template match="th">
<th>
<xsl:attribute name="style">
border: 1px solid rgb(221, 221, 221);
padding: 6px 13px;
</xsl:attribute>
<xsl:apply-templates/>
</th>
</xsl:template>


<xsl:template match="td">
<td>
<xsl:attribute name="style">
border: 1px solid rgb(221, 221, 221);
padding: 6px 13px;
</xsl:attribute>
<xsl:apply-templates/>
</td>
</xsl:template>
    


<xsl:template match="strong|p|div|a|span|h1|h2|h3|h4|h5|br|hr|tbody|thead|tfoot|ul|ol|li">
<xsl:element name="{local-name(.)}">
<xsl:for-each select="@*"><xsl:copy-of select="."/></xsl:for-each>
<xsl:apply-templates/>
</xsl:element>
</xsl:template> 


<xsl:template match="a[@href and starts-with(@href,'/')]">
<a>
<xsl:attribute name="href"><xsl:value-of select="concat('https://github.com',@href)"/></xsl:attribute>
<xsl:apply-templates />
</a>
</xsl:template>

</xsl:stylesheet>
