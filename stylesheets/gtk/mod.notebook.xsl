<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
	>

<xsl:template match="xul:tabbedpane|xul:notebook">
<xsl:variable name="id"><xsl:apply-templates select="." mode="id"/></xsl:variable>
/* BEGIN: NOTEBOOK */

GtkWidget* <xsl:value-of select="$id"/> = gtk_notebook_new();

<xsl:apply-templates select="xul:tab"/>	
gtk_widget_show( <xsl:value-of select="$id"/>);
/* END: NOTEBOOK */
</xsl:template>


<xsl:template match="xul:tab">
<xsl:variable name="id"><xsl:apply-templates select="." mode="id"/></xsl:variable>
<xsl:if test="count(*)!=1">
	<xsl:message terminate="yes">expected one widget under xul:tab </xsl:message>
</xsl:if>
/* BEGIN: TAB */
GtkWidget* <xsl:value-of select="$id"/> = gtk_label_new ("<xsl:value-of select="@label"/>");
<xsl:apply-templates select="*"/>
gtk_notebook_append_page(
	GTK_NOTEBOOK(<xsl:apply-templates select=".." mode="id"/>),
    <xsl:apply-templates select="*" mode="id"/>,
   <xsl:value-of select="$id"/>
    );
gtk_widget_show( <xsl:value-of select="$id"/>);
/* END: TAB */
</xsl:template>


</xsl:stylesheet>
