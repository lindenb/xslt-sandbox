<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
	>

<xsl:template match="xul:file-chooser-button|xul:file-open-button|xul:file-save-button">
<xsl:variable name="id"><xsl:apply-templates select="." mode="id"/></xsl:variable>
/* BEGIN: FILE CHOOSER BUTTON */

GtkWidget* <xsl:value-of select="$id"/> = gtk_file_chooser_button_new(
	"<xsl:value-of select="@label"/>",
	<xsl:choose>
		<xsl:when test="(local-name(.)='file-open-button' or @mode='open') and @directory='true'">GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER</xsl:when>
		<xsl:when test="(local-name(.)='file-open-button' or @mode='open')">GTK_FILE_CHOOSER_ACTION_OPEN</xsl:when>
		<xsl:when test="(local-name(.)='file-save-button' or @mode='save') and @directory='true'">GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER</xsl:when>
		<xsl:when test="(local-name(.)='file-save-button' or @mode='save')">GTK_FILE_CHOOSER_ACTION_SAVE</xsl:when>
		<xsl:otherwise>
			<xsl:message terminate="yes">
				<xsl:value-of select="name(.)"/>: illegal declaration
			</xsl:message>
		</xsl:otherwise>
	</xsl:choose>
	);

gtk_file_chooser_button_set_title(
		GTK_FILE_CHOOSER_BUTTON(<xsl:value-of select="$id"/>),
		<xsl:choose>
			<xsl:when test="@title">"<xsl:value-of select="@title"/>"</xsl:when>
			<xsl:otherwise>"<xsl:value-of select="@label"/>"</xsl:otherwise>
		</xsl:choose>);

gtk_file_chooser_button_set_width_chars(
		GTK_FILE_CHOOSER_BUTTON(<xsl:value-of select="$id"/>),
		<xsl:choose>
			<xsl:when test="@length">( gint)<xsl:value-of select="@length"/></xsl:when>
			<xsl:otherwise>20</xsl:otherwise>
		</xsl:choose>);
	
gtk_widget_show( <xsl:value-of select="$id"/>);
/* END: FILE CHOOSER BUTTON */
</xsl:template>

</xsl:stylesheet>
