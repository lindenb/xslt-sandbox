<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        xmlns:svg="http://www.w3.org/2000/svg"
        version='1.0'
        >
<!-- idea from https://thimble.mozilla.org/ -->
<xsl:output method="html" />

<xsl:template match="/">
<xsl:apply-templates select="comic"/>
</xsl:template>

<xsl:template match="comic">
<html>
  <head>
    <title>Create Your Own Comic: A Starter Make</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Indie+Flower"></link>
    <!-- These are the styles for the comic -->
    <style>
      body {
        background-color: #efefef;
       font-family: 'Indie Flower', serif;
        font-size: 48px;

        line-height: 1.2;
        text-align: center;
        padding: 40px 0 0 20px;
      }
      h1 {
        text-transform: uppercase;
        font-size: 40px;
        color: #d02626;
      }
      .comic {
        max-width: 826px;
        margin: 60px auto 0;
      }
      .scene {
        width: 250px;
        height: 250px;
        border: 3px solid black;
        background: white;
        margin: 8px;
        display: inline-block;
        position: relative;
      }
      .scene img {
        width: 100%;
        height: 100%;
        display: block;
      }
      .caption {
        padding: 10px;
        margin: 0;
        position: absolute;
        left: 0;
        right: 0;
        background: #e2e971;
        text-align: left;
        top: 0;
      }
      .caption.bottom {
        bottom: 0;
        top:auto;
        border-top: 2px solid black;
      }
      .caption.top {
        top: 0;
        border-bottom: 2px solid black;
      }
      .speech {
        width: 40%;
        border-radius:50%;
        border: 2px solid black;
        margin: 0;
        position: absolute;
        z-index: 1;
        background: snow ;
        padding: 20px;
        top: -15px;
        text-align: center;
      }
      /* Advanced CSS for the speech pointer */
      .speech:after {
        border-color: snow transparent;
        border-style: solid;
        border-width: 13px 13px 0;
        bottom: -11px;
        content: "";
        display: block;
        left: 50%;
        margin-left:-14px;
        position: absolute;
        width: 0;
      }
      .speech:before {
        border-color: black transparent;
        border-style: solid;
        border-width: 16px 16px 0;
        bottom: -15px;
        content: "";
        display: block;
        left: 50%;
        margin-left:-17px;
        position: absolute;
        width: 0;
      }
      .speech.left {
        left:-15px;
      }
      .speech.right {
        right:-15px;
      }
      footer {
        clear: both;
      }
    </style>

  </head>
  <body>

    <!-- Step 1: This is where you can edit the title of your comic -->
    <h1>Create your own Comic!</h1>

    <!-- 
This is where the comic starts. 
The 'comic' <div> wraps around each comic 'scene' to contain them all.
-->
    <div class="comic">
		<xsl:apply-templates select="scene"/>
    </div>

    <!-- Disclaimer for images -->
    <footer>
     Pierre Lindenbaum
    </footer>

  </body>
</html>
</xsl:template>

<xsl:template match="scene">
  <div class="scene">
  	<xsl:apply-templates select="caption"/>
  	<xsl:apply-templates select="speech"/>
  	<xsl:apply-templates select="img"/>
  </div>
</xsl:template>

<xsl:template match="caption">
<p>
<xsl:attribute name="class">
	<xsl:text>caption </xsl:text>
	<xsl:choose>
		<xsl:when test="@position"><xsl:value-of select="@position"/></xsl:when>
		<xsl:otherwise>bottom</xsl:otherwise>
	</xsl:choose>
</xsl:attribute>
<xsl:apply-templates/>
</p>
</xsl:template>


<xsl:template match="speech">
<p>
<xsl:attribute name="class">
	<xsl:text>speech </xsl:text>
	<xsl:choose>
		<xsl:when test="@position"><xsl:value-of select="@position"/></xsl:when>
		<xsl:otherwise>left</xsl:otherwise>
	</xsl:choose>
</xsl:attribute>
<xsl:apply-templates/>
<svg:svg width="100" height="100">
	<svg:rect fill="red" x="10" y="5" width="50" height="60"/>
</svg:svg>
</p>
</xsl:template>

<xsl:template match="img">
<img>
<xsl:attribute name="src">
	<xsl:value-of select="@src"/>
</xsl:attribute>
</img>
</xsl:template>

</xsl:stylesheet>

