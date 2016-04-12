<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
	xmlns:my="https://github.com/lindenb/xslt-sandbox/blob/master/stylesheets/xul/app2xul.xsl"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:t="http://exslt.org/dates-and-times"
	version="1.0">
<xsl:import href="../util/util.xsl"/>
<xsl:param name="outdir">OUTDIR</xsl:param>

<xsl:template match="/">
<xsl:apply-templates select="my:app"/>
</xsl:template>

<xsl:template match="my:app">
<xsl:variable name="appname"><xsl:apply-templates select="." mode="name"/></xsl:variable>


<!-- application.ini -->
<xsl:document href="{$outdir}/{$appname}/application.ini" method="text">[App]
Vendor=lindenb
Name=<xsl:apply-templates select="." mode="name"/>
Version=0.1
BuildID=<xsl:value-of select="t:year()"/>
<xsl:if test="number(t:month-in-year())&lt;10">0</xsl:if>
<xsl:value-of select="t:month-in-year()"/>
<xsl:if test="number(t:day-in-month())&lt;10">0</xsl:if>
<xsl:value-of select="t:day-in-month()"/>
<xsl:if test="number(t:hour-in-day())&lt;10">0</xsl:if>
<xsl:value-of select="t:hour-in-day()"/>
<xsl:if test="number(t:minute-in-hour())&lt;10">0</xsl:if>
<xsl:value-of select="t:minute-in-hour()"/>
ID=<xsl:apply-templates select="." mode="name"/>@pierre.lindenbaum.fr

[Gecko]
MinVersion=1.0
MaxVersion=999.*
</xsl:document>

<!-- create chrome/chrome.manifest -->
<xsl:document href="{$outdir}/{$appname}/chrome.manifest" method="text">manifest	chrome/chrome.manifest
</xsl:document>

<!-- create chrome/chrome.manifest -->
<xsl:document href="{$outdir}/{$appname}/chrome/chrome.manifest" method="text">content	<xsl:apply-templates select="." mode="name"/>	content/
</xsl:document>


<!-- prefs.js  -->
<xsl:document href="{$outdir}/{$appname}/defaults/preferences/prefs.js" method="text">pref("toolkit.defaultChromeURI", "chrome://<xsl:apply-templates select="." mode="name"/>/content/<xsl:apply-templates select="." mode="name"/>.xul");

pref("app.support.baseURL", "chrome://<xsl:apply-templates select="." mode="name"/>/content/<xsl:apply-templates select="." mode="name"/>.xul");
pref("browser.chromeURL", "chrome://<xsl:apply-templates select="." mode="name"/>/content/<xsl:apply-templates select="." mode="name"/>.xul");


/* debugging prefs */
pref("browser.dom.window.dump.enabled", true);
pref("javascript.options.showInConsole", true);
pref("javascript.options.strict", true);
pref("nglayout.debug.disable_xul_cache", true);
pref("nglayout.debug.disable_xul_fastload", true);

</xsl:document>

<!-- main js  -->
<xsl:document href="{$outdir}/{$appname}/chrome/content/{$appname}.js" method="text">
<xsl:apply-templates select="my:command" mode="js"/>
</xsl:document>

<!-- main xul  -->
<xsl:document href="{$outdir}/{$appname}/chrome/content/{$appname}.xul" method="xml">
<xsl:processing-instruction name="xml-stylesheet">href="chrome://global/skin/" type="text/css" </xsl:processing-instruction> 
<xul:window id="main" width="800" height="600">
<xsl:attribute name="title"><xsl:apply-templates select="." mode="name"/></xsl:attribute>

<xul:script>
	<xsl:attribute name="src">
		<xsl:value-of select="concat('chrome://',$appname,'/content/',$appname,'.js')"/>
	</xsl:attribute>
</xul:script>
<xul:toolbox>
	<xul:menubar id="sample-menubar">
		<xul:menu id="file-menu" label="File">
			<xul:menupopup>
			 <xul:menuseparator/>
			 <xul:menuitem label="Exit" oncommand="window.close();"/>
			 </xul:menupopup>
		</xul:menu>
	</xul:menubar>
</xul:toolbox>


<xul:tabbox>
	<xul:tabs>
		<xsl:apply-templates select="my:command" mode="tab"/>
	</xul:tabs>
	<xul:tabpanels>
		<xsl:apply-templates select="my:command" mode="tabpanel"/>
	</xul:tabpanels>
</xul:tabbox>

</xul:window>
</xsl:document>

</xsl:template>

<xsl:template match="my:app" mode="name">
<xsl:value-of select="@name"/>
</xsl:template>

<xsl:template match="my:command" mode="js">

<xsl:apply-templates select="my:checkbox|my:textbox|my:input-file" mode="js"/>

/** exectute command <xsl:value-of select="@name"/> */
function exectute_<xsl:value-of select="@name"/>()
	{
	var args=[];
	<xsl:for-each select="my:checkbox|my:textbox|my:input-file">
	  <xsl:value-of select="concat('fill',generate-id(.),'()')"/>(args);
	</xsl:for-each>
		
	return null;
	}
	
	
	
</xsl:template>


<xsl:template match="my:command" mode="tab">
	<xul:tab>
		<xsl:attribute name="id">
			<xsl:value-of select="concat('tab',generate-id(.))"/>
		</xsl:attribute>
		<xsl:attribute name="label">
			<xsl:value-of select="@name"/>
		</xsl:attribute>
	</xul:tab>
</xsl:template>


<xsl:template match="my:command" mode="tabpanel">
	<xul:tabpanel  orient="vertical">
		<xsl:attribute name="id">
			<xsl:value-of select="concat('tabpanel',generate-id(.))"/>
		</xsl:attribute>
		<xul:description>
			<xsl:apply-templates select="my:description"/>
		</xul:description>
		<xsl:apply-templates select="my:checkbox|my:textbox|my:input-file" mode="xul"/>
		
		<!-- output file -->
		<xul:hbox>
			<xul:label label="Output:"/>
			<xul:textbox/>
			<xul:button/>
		</xul:hbox>
		
		<xul:spacer flex="1"/>
		<xul:button>
			<xsl:attribute name="id"><xsl:value-of select="concat('execbutton',generate-id(.))"/></xsl:attribute>
			<xsl:attribute name="label">Run <xsl:value-of select="@name"/></xsl:attribute>
			<xsl:attribute name="oncommand">exectute_<xsl:value-of select="@name"/>();</xsl:attribute>
		</xul:button>
	</xul:tabpanel>
</xsl:template>


<xsl:template match="my:checkbox" mode="js">

function <xsl:value-of select="concat('fill',generate-id(.),'()')"/>(args)
  {
  var E = document.getElementById('<xsl:apply-templates select="." mode="id"/>');
  if( E.checked ) {
    args.push("-<xsl:value-of select="@opt"/>");
    }
  return null;
  }


</xsl:template>

<xsl:template match="my:checkbox" mode="xul">
<xul:checkbox>
<xsl:attribute name="id"><xsl:apply-templates select="." mode="id"/></xsl:attribute>
<xsl:attribute name="label"><xsl:apply-templates select="." mode="label"/></xsl:attribute>
<xsl:attribute name="checked"><xsl:value-of select="@checked"/></xsl:attribute>
</xul:checkbox>
</xsl:template>


<xsl:template match="my:textbox" mode="js">

function <xsl:value-of select="concat('fill',generate-id(.),'()')"/>(args)
  {
  var E = document.getElementById('<xsl:apply-templates select="." mode="id"/>');
  var content = E.value.trim();
  if(content.length &gt;0)
    {
    args.push("-<xsl:value-of select="@opt"/>");
    args.push(content);
    }
  return null;
  }

</xsl:template>

<xsl:template match="my:textbox" mode="xul">
<xul:hbox>
<xul:label flex="1">
	<xsl:attribute name="value"><xsl:apply-templates select="." mode="label"/>:</xsl:attribute>
	<xsl:attribute name="control"><xsl:apply-templates select="." mode="id"/></xsl:attribute>
</xul:label>
<xul:textbox flex="5">
<xsl:attribute name="id"><xsl:apply-templates select="." mode="id"/></xsl:attribute>
<xsl:attribute name="value"><xsl:value-of select=" @value"/></xsl:attribute>
<xsl:attribute name="checked"><xsl:value-of select="@checked"/></xsl:attribute>
</xul:textbox>
</xul:hbox>
</xsl:template>

<!-- https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XUL/Tutorial/Open_and_Save_Dialogs -->
<xsl:template match="my:input-file" mode="js">

function <xsl:value-of select="concat('select',generate-id(.),'()')"/> {
	var nsIFilePicker = Components.interfaces.nsIFilePicker;
	var fp = Components.classes["@mozilla.org/filepicker;1"].createInstance(nsIFilePicker);
	fp.init(window, "Select a File", nsIFilePicker.modeOpen);
	var res = fp.show();
	if (res != nsIFilePicker.returnCancel){
		document.getElementById('<xsl:apply-templates select="." mode="id"/>').value = fp.file.path;
		}
	}

function <xsl:value-of select="concat('fill',generate-id(.),'()')"/>(args)
  {
  var E = document.getElementById('<xsl:apply-templates select="." mode="id"/>');
  var filename = E.value.trim();
  if(filename.length &gt;0)
    {
    args.push("-<xsl:value-of select="@opt"/>");
    args.push(filename);
    }
  return null;
  }
	
</xsl:template>

<xsl:template match="my:input-file" mode="xul">
<xul:hbox>
<xul:label flex="1">
	<xsl:attribute name="value"><xsl:apply-templates select="." mode="label"/>:</xsl:attribute>
	<xsl:attribute name="control"><xsl:apply-templates select="." mode="id"/></xsl:attribute>
</xul:label>
<xul:textbox flex="4">
<xsl:attribute name="id"><xsl:apply-templates select="." mode="id"/></xsl:attribute>
<xsl:attribute name="value"><xsl:value-of select="generate-id(.)"/>:</xsl:attribute>
<xsl:attribute name="checked"><xsl:value-of select="@checked"/></xsl:attribute>
</xul:textbox>
<xul:button label="Select ..."  flex="1">
	<xsl:attribute name="oncommand"><xsl:value-of select="concat('select',generate-id(.),'();')"/></xsl:attribute>
</xul:button>
</xul:hbox>
</xsl:template>

<xsl:template match="*" mode="label">
<xsl:choose>
	<xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
	<xsl:when test="my:label"><xsl:value-of select="my:label"/></xsl:when>
	<xsl:when test="name"><xsl:value-of select="@name"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="generate-id()"/></xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="*" mode="id">
<xsl:choose>
	<xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="generate-id()"/></xsl:otherwise>
</xsl:choose>
</xsl:template>


</xsl:stylesheet>

