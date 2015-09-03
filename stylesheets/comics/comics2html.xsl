<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        xmlns:svg="http://www.w3.org/2000/svg"
        version='1.0'
        >
<!-- idea from https://thimble.mozilla.org/ -->
<xsl:output method="xml"/>

<xsl:template match="/">
<xsl:apply-templates select="comic"/>
</xsl:template>

<xsl:template match="comic">
<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
<html>
  <head>
    <title><xsl:value-of select="@title"/></title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <!-- These are the styles for the comic -->
    <style>
      body {
        background-color: #efefef;
       font-family: 'Comic Sans MS', serif;
        font-size: 12px;

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
        position: absolute;
        clip: rect(10px, 20px, 50px, 40px,0,0);
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
    <h1><xsl:apply-templates select="@title"/></h1>

    <!-- 
This is where the comic starts. 
The 'comic' <div> wraps around each comic 'scene' to contain them all.
-->
    <div class="comic">
		<xsl:apply-templates select="page"/>
    </div>

    <!-- Disclaimer for images -->
    <footer>
     Pierre Lindenbaum
    </footer>

  </body>
</html>
</xsl:template>

<xsl:template match="page">
  <div>
  	<xsl:apply-templates select="scene"/>
  </div>
</xsl:template>

<xsl:template match="scene">
  <div class="scene">
  	<xsl:apply-templates select="caption|speech|img|shout|think"/>
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
</p>
</xsl:template>

<xsl:template match="think">
<svg width="250" height="250" style="display: block;top:0;bottom:0;position:absolute;">
	<g transform="translate(10,10) scale(2.0) ">
	    <path style="fill:#ffffff;fill-opacity:1;fill-rule:evenodd;stroke:#000000;stroke-width:1;stroke-linejoin:round;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0" d="m 46.46875,978.86218 c -3.50628,0 -6.55603,1.9036 -8.21875,4.71875 -1.58346,-1.16422 -3.54015,-1.84375 -5.65625,-1.84375 -3.91779,0 -7.24353,2.34491 -8.71875,5.71875 -1.26144,-0.61366 -2.65917,-0.96875 -4.15625,-0.96875 -5.27785,0 -9.5625,4.28465 -9.5625,9.5625 0,0.0213 -1.4e-4,0.0413 0,0.0625 -4.83372,0.47505 -8.59375,4.54142 -8.59375,9.50002 0,2.0509 0.65031,3.9433 1.75,5.5 -1.6987,1.2318 -2.8125,3.2412 -2.8125,5.5 0,3.5845 2.78969,6.5069 6.3125,6.75 -0.3859,0.8439 -0.59375,1.7759 -0.59375,2.7812 0,3.4923 2.61541,6.3438 5.84375,6.3438 0.88073,0 1.71973,-0.2164 2.46875,-0.5938 1.57566,3.1123 4.80428,5.25 8.53125,5.25 0.73707,0 1.43584,-0.092 2.125,-0.25 0.83344,2.6988 3.21143,4.6563 6,4.6563 1.37414,0 2.62016,-0.4789 3.65625,-1.2813 1.05469,2.1627 3.13472,3.6563 5.5625,3.6563 3.01674,0 5.53397,-2.2996 6.15625,-5.3438 -6.8e-4,0.042 0,0.083 0,0.125 0,3.2456 2.0149,5.875 4.46875,5.875 1.40576,0 2.6546,-0.8709 3.46875,-2.2187 0.81413,1.2718 2.07102,2.0937 3.5,2.0937 1.28527,0 2.40646,-0.6601 3.21875,-1.7187 -0.01285,0.1372 -0.03125,0.2658 -0.03125,0.4062 0,2.5132 2.09308,4.5625 4.6875,4.5625 2.59442,0 4.71875,-2.0493 4.71875,-4.5625 0,-0.5375 -0.13584,-1.0212 -0.3125,-1.5 0.82115,-0.6559 1.49137,-1.5296 1.9375,-2.5312 0.67715,0.658 1.5104,1.0625 2.4375,1.0625 1.65139,0 3.08227,-1.2261 3.6875,-3 1.08279,0.9409 2.46844,1.5 3.96875,1.5 3.48402,0 6.28125,-3.0334 6.28125,-6.7813 0,-0.1917 -0.01676,-0.3747 -0.03125,-0.5625 0.44848,0.1089 0.89595,0.1875 1.375,0.1875 3.48402,0 6.3125,-3.0333 6.3125,-6.7812 0,-1.0996 -0.25596,-2.1439 -0.6875,-3.0625 2.61426,-0.8286 4.5,-3.4194 4.5,-6.5 0,-2.8005 -1.56171,-5.2134 -3.8125,-6.25 1.72858,-1.2104 2.875,-3.3034 2.875,-5.6875 0,-3.74793 -2.82848,-6.81252 -6.3125,-6.81252 -1.04901,0 -2.03593,0.29393 -2.90625,0.78125 C 89.97358,996.83268 90,996.43967 90,996.04968 c 0,-3.99147 -3.66824,-7.21875 -8.1875,-7.21875 -1.79424,0 -3.43248,0.51013 -4.78125,1.375 0.0046,-0.12244 0,-0.25142 0,-0.375 0,-5.27785 -4.2534,-9.53125 -9.53125,-9.53125 -1.69008,0 -3.27879,0.44897 -4.65625,1.21875 -1.64405,-1.33709 -3.71569,-2.15625 -6,-2.15625 -1.75605,0 -3.39849,0.48599 -4.8125,1.3125 -1.57019,-1.13151 -3.47928,-1.8125 -5.5625,-1.8125 z m 26.9375,65.62502 c -1.73105,0 -3.125,1.3544 -3.125,3.0312 0,1.6769 1.39395,3.0625 3.125,3.0625 1.73105,0 3.125,-1.3856 3.125,-3.0625 0,-1.6768 -1.39395,-3.0312 -3.125,-3.0312 z m 5.96875,3.3125 c -1.15548,0 -2.09375,0.9119 -2.09375,2.0312 0,1.1193 0.93827,2.0313 2.09375,2.0313 1.15548,0 2.09375,-0.912 2.09375,-2.0313 0,-1.1193 -0.93827,-2.0312 -2.09375,-2.0312 z" />

</g>
</svg>
<!--
<p>
<xsl:attribute name="class">
	<xsl:text>speech </xsl:text>
	<xsl:choose>
		<xsl:when test="@position"><xsl:value-of select="@position"/></xsl:when>
		<xsl:otherwise>left</xsl:otherwise>
	</xsl:choose>
</xsl:attribute>
<xsl:apply-templates/>
</p>-->
</xsl:template>


<xsl:template match="img">
<img style="filter: blur(5px);">
<xsl:attribute name="src">
	<xsl:value-of select="@src"/>
</xsl:attribute>
</img>
<!--
<svg width="250" height="250" style="display: block;top:0;bottom:0;position:absolute;">
	<g transform="translate(100,100) scale(0.1) ">
	<path
     style="fill:#ffffff;fill-rule:evenodd;stroke:#000000;stroke-width:10;stroke-linejoin:round"
     d="m 218.77197,279.55398 224.24,161.88 -161.88,-164.28 77.94,32.38 c 13.2,-20.39 20.39,-23.99 32.38,-38.38 20.39,6 73.15,19.19 81.54,22.79 l -20.38,-68.35 31.18,-55.16 -31.18,-52.77 14.39,-76.741996 -79.15,21.58 -63.55,-41.97 -79.14,53.958 -74.35,-49.161 -56.363,50.361 -82.740998,-14.387 34.775,69.548996 -40.771,64.76 40.771,41.97 -25.182,82.74 76.747998,-32.38 52.76,47.97 47.96,-56.36 z" />
</g>
</svg> -->
</xsl:template>

</xsl:stylesheet>

