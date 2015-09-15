<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
	>
<xsl:import href="mod.box.xsl"/>
<xsl:import href="mod.label.xsl"/>
<xsl:import href="mod.window.xsl"/>
<xsl:import href="mod.menu.xsl"/>
<xsl:import href="mod.placessidebar.xsl"/>
<xsl:import href="mod.file-chooser-button.xsl"/>
<xsl:import href="mod.notebook.xsl"/>
<xsl:output method="text"/>



<xsl:template match="xul:button">
GtkWidget* <xsl:value-of select="generate-id(.)"/> = gtk_button_new();

gtk_widget_show(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>

<xsl:template match="xul:toggle">

</xsl:template>

<xsl:template match="xul:checkbox">

</xsl:template>

<xsl:template match="radio-group">
 <xsl:value-of select="generate-id(.)"/> = gtk_radio_button_group (GTK_RADIO_BUTTON (button));
</xsl:template>

<xsl:template match="xul:radio">
  <xsl:value-of select="generate-id(.)"/> = gtk_radio_button_new(<xsl:value-of select="generate-id(..)"/>);
 gtk_widget_show_all(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>


<xsl:template match="xul:table">
GtkWidget* <xsl:value-of select="generate-id(.)"/> = gtk_table_new(<xsl:value-of select="@rows"/>,<xsl:value-of select="@columns"/>,TRUE);

gtk_widget_show(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>

<xsl:template match="xul:frame">
GtkWidget* <xsl:value-of select="generate-id(.)"/> = gtk_frame_new(<xsl:value-of select="@rows"/>,<xsl:value-of select="@columns"/>,TRUE);

gtk_widget_show(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>





<xsl:template match="xul:callback">
gtk_signal_connect (GTK_OBJECT (<xsl:value-of select="generate-id(..)"/>), "clicked",
       GTK_SIGNAL_FUNC (callback), (gpointer) "cool button");
</xsl:template>




<xsl:template match="*" mode="insert">
	<xsl:variable name="parent" select="."/>
	
	<xsl:call-template name="_insert0">
		<xsl:with-param name="parent" select="$parent"/>
		<xsl:with-param name="root" select="$parent"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="_insert0">
	<xsl:param name="parent" />
	<xsl:param name="root" />
	<xsl:for-each select="$root/*">
		<xsl:choose>
			<xsl:when test="local-name(.)='buttongroup'">
				<xsl:call-template name="_insert0">
					<xsl:with-param name="parent" select="$parent"/>
					<xsl:with-param name="root" select="."/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="_insert1">
					<xsl:with-param name="parent" select="$parent"/>
					<xsl:with-param name="child" select="."/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>


<xsl:template name="_insert1">
	<xsl:param name="parent" />
	<xsl:param name="child" />
	<xsl:variable name="pid"><xsl:apply-templates select="$parent" mode="id"/></xsl:variable>
	<xsl:variable name="cid"><xsl:apply-templates select="$child" mode="id"/></xsl:variable>
	<xsl:choose>
		<xsl:when test="local-name($parent) = 'window'">gtk_container_add(GTK_CONTAINER(<xsl:value-of select="$pid"/>), <xsl:value-of select="$cid"/>);</xsl:when>
		<xsl:when test="local-name(..) = 'hbox' or local-name(..) = 'vbox'">gtk_box_pack_start(
				GTK_BOX(<xsl:value-of select="$pid"/>),
				<xsl:value-of select="$cid"/>,
				<xsl:choose>
					<xsl:when test="$child/@expand">(gboolean)<xsl:value-of select="$child/@expand"/></xsl:when>
					<xsl:when test="local-name($child) = 'menubar'">FALSE</xsl:when>
					<xsl:otherwise>TRUE</xsl:otherwise>
				</xsl:choose> /* expand */,
				<xsl:choose>
					<xsl:when test="$child/@fill">(gboolean)<xsl:value-of select="$child/@fill"/></xsl:when>
					<xsl:when test="local-name($child) = 'menubar'">FALSE</xsl:when>
					<xsl:otherwise>TRUE</xsl:otherwise>
				</xsl:choose> /* fill */,
				<xsl:choose>
					<xsl:when test="$child/@padding">(guint)<xsl:value-of select="$child/@padding"/></xsl:when>
					<xsl:otherwise>(guint)1</xsl:otherwise>
				</xsl:choose>  /* padding */);</xsl:when>
		<xsl:when test="local-name(..) = 'menubar'">gtk_menu_shell_append(GTK_MENU_SHELL(<xsl:value-of select="$pid"/>), <xsl:value-of select="$cid"/>);</xsl:when>
		<xsl:otherwise><xsl:message terminate="yes">Cannot _insert1 for <xsl:value-of select="name($parent)"/></xsl:message></xsl:otherwise>
	</xsl:choose>
</xsl:template>



<xsl:template match="*" mode="id">
	<xsl:choose>
		<xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
