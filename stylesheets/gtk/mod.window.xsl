<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
	>

<xsl:template match="xul:window">
<xsl:variable name="id"><xsl:apply-templates select="." mode="id"/></xsl:variable>
/* BEGIN: WINDOW */
GtkWidget*  <xsl:value-of select="$id"/> = gtk_window_new(
	<xsl:choose>
		<xsl:when test="@type='top' or @type='toplevel'">GTK_WINDOW_TOPLEVEL</xsl:when>
		<xsl:when test="@type='popup'">GTK_WINDOW_POPUP</xsl:when>
		<xsl:when test="@type"><xsl:value-of select="@type"/></xsl:when>
		<xsl:otherwise>GTK_WINDOW_TOPLEVEL</xsl:otherwise>
	</xsl:choose>);
	
<xsl:if test="@title">
gtk_window_set_title(GTK_WINDOW( <xsl:value-of select="$id"/>), "<xsl:value-of select="@title"/>");
</xsl:if>

<xsl:if test="@width and @height">
gtk_window_set_default_size(GTK_WINDOW( <xsl:value-of select="$id"/>), <xsl:value-of select="@width"/>, <xsl:value-of select="@height"/>);
</xsl:if>

<xsl:if test="@position">
gtk_window_set_position(GTK_WINDOW( <xsl:value-of select="$id"/>),
	<xsl:choose>
		<xsl:when test="@position='center'">GTK_WIN_POS_CENTER</xsl:when>
		<xsl:when test="@position='none'">GTK_WIN_POS_NONE</xsl:when>
		<xsl:when test="@position='mouse'">GTK_WIN_POS_MOUSE</xsl:when>
		<xsl:when test="@position='mouse'">GTK_WIN_POS_MOUSE</xsl:when>
		<xsl:when test="@position='center-always'">GTK_WIN_CENTER_ALWAYS</xsl:when>
		<xsl:when test="@position='center-on-parent'">GTK_WIN_CENTER_ON_PARENT</xsl:when>
		<xsl:otherwise><xsl:value-of select="@position"/></xsl:otherwise>
	</xsl:choose>);
</xsl:if>

g_signal_connect(G_OBJECT( <xsl:value-of select="$id"/>), "destroy",
        G_CALLBACK(gtk_main_quit), NULL);
<xsl:apply-templates select="*"/>
<xsl:apply-templates select="." mode="insert"/>
gtk_widget_show( <xsl:value-of select="$id"/>);
//gtk_widget_show_all(<xsl:value-of select="$id"/>);
/* END: WINDOW */
</xsl:template>


</xsl:stylesheet>
