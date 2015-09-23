<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
	>

<xsl:template match="xul:hbox|xul:vbox">
<xsl:variable name="id"><xsl:apply-templates select="." mode="id"/></xsl:variable>
/* BEGIN: BOX */

GtkWidget* <xsl:value-of select="$id"/> = gtk_box_new(
	<xsl:choose>
		<xsl:when test="name(.)='hbox'">GTK_ORIENTATION_HORIZONTAL</xsl:when>
		<xsl:when test="name(.)='vbox'">GTK_ORIENTATION_VERTICAL</xsl:when>
		<xsl:otherwise>GTK_ORIENTATION_VERTICAL</xsl:otherwise>
	</xsl:choose>,
	<xsl:choose>
		<xsl:when test="@spacing"><xsl:value-of select="@spacing"/></xsl:when>
		<xsl:otherwise>0</xsl:otherwise>
	</xsl:choose>);
<xsl:apply-templates select="*"/>
<xsl:apply-templates select="." mode="insert"/>
gtk_widget_show( <xsl:value-of select="$id"/>);
/* END: BOX */
</xsl:template>

</xsl:stylesheet>
