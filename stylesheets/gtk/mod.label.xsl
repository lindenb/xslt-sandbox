<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
	>

<xsl:template match="xul:label|xul:description">
<xsl:variable name="id"><xsl:apply-templates select="." mode="id"/></xsl:variable>
GtkWidget* <xsl:value-of select="$id"/> = gtk_label_new("<xsl:value-of select="text()"/>");

gtk_widget_show(<xsl:value-of select="$id"/>);
</xsl:template>

</xsl:stylesheet>
