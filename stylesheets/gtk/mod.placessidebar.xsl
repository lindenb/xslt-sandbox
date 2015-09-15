<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
	>

<xsl:template match="xul:places-sidebar">
<xsl:variable name="id"><xsl:apply-templates select="." mode="id"/></xsl:variable>
/* BEGIN: PLACES SIDEBAR */

GtkWidget* <xsl:value-of select="$id"/> =gtk_places_sidebar_new();

gtk_widget_show( <xsl:value-of select="$id"/>);
/* END: PLACES SIDEBAR */
</xsl:template>

</xsl:stylesheet>
