<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text"/>

<xsl:template match="hbox|vbox">
/* BEGIN: BOX */

GtkWidget* <xsl:value-of select="generate-id(.)"/> = gtk_box_new(
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
/* END: BOX */
</xsl:template>

<xsl:template match="label">
GtkWidget* <xsl:value-of select="generate-id(.)"/> = gtk_label_new("<xsl:value-of select="text()"/>");

gtk_widget_show(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>

<xsl:template match="button">
GtkWidget* <xsl:value-of select="generate-id(.)"/> = gtk_button_new();

gtk_widget_show(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>

<xsl:template match="toggle">

</xsl:template>

<xsl:template match="checkbox">

</xsl:template>

<xsl:template match="radio-group">
 <xsl:value-of select="generate-id(.)"/> = gtk_radio_button_group (GTK_RADIO_BUTTON (button));
</xsl:template>

<xsl:template match="radio">
  <xsl:value-of select="generate-id(.)"/> = gtk_radio_button_new(<xsl:value-of select="generate-id(..)"/>);
 gtk_widget_show_all(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>


<xsl:template match="table">
GtkWidget* <xsl:value-of select="generate-id(.)"/> = gtk_table_new(<xsl:value-of select="@rows"/>,<xsl:value-of select="@columns"/>,TRUE);

gtk_widget_show(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>

<xsl:template match="frame">
GtkWidget* <xsl:value-of select="generate-id(.)"/> = gtk_frame_new(<xsl:value-of select="@rows"/>,<xsl:value-of select="@columns"/>,TRUE);

gtk_widget_show(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>

<xsl:template match="window">
/* BEGIN: WINDOW */
GtkWidget* <xsl:value-of select="generate-id(.)"/> = gtk_window_new(GTK_WINDOW_TOPLEVEL);
<xsl:if test="@title">
gtk_window_set_title(GTK_WINDOW(<xsl:value-of select="generate-id(.)"/>), "<xsl:value-of select="@title"/>");
</xsl:if>

<xsl:if test="@width and @height">
gtk_window_set_default_size(GTK_WINDOW(<xsl:value-of select="generate-id(.)"/>), <xsl:value-of select="@width"/>, <xsl:value-of select="@height"/>);
</xsl:if>

<xsl:if test="@position='center'">
gtk_window_set_position(GTK_WINDOW(<xsl:value-of select="generate-id(.)"/>), GTK_WIN_POS_CENTER);
</xsl:if>

g_signal_connect(G_OBJECT(<xsl:value-of select="generate-id(.)"/>), "destroy",
        G_CALLBACK(gtk_main_quit), NULL);
<xsl:apply-templates select="*"/>
gtk_widget_show(<xsl:value-of select="generate-id(.)"/>);
/* END: WINDOW */
</xsl:template>

<xsl:template match="menubar">
/* BEGIN menubar */
GtkWidget* <xsl:value-of select="generate-id(.)"/> =  gtk_menu_bar_new();
<xsl:apply-templates select="menu"/>
gtk_widget_show (<xsl:value-of select="generate-id(.)"/>);
<xsl:apply-templates select="." mode="insert"/>
/* END menubar */
</xsl:template>

<xsl:template match="menu">
/* begin menu */
GtkWidget* <xsl:value-of select="concat('m_',generate-id(.))"/> = gtk_menu_new();
GtkWidget* <xsl:value-of select="generate-id(.)"/> = gtk_menu_item_new_with_label("xxxFile");

gtk_menu_item_set_submenu(GTK_MENU_ITEM(<xsl:value-of select="generate-id(.)"/>), <xsl:value-of select="concat('m_',generate-id(.))"/>);
gtk_menu_shell_append(GTK_MENU_SHELL(<xsl:value-of select="generate-id(..)"/>), <xsl:value-of select="generate-id(.)"/>);
gtk_widget_show (<xsl:value-of select="generate-id(.)"/>);
<xsl:apply-templates select="menuitem"/>
/* end menu */
</xsl:template>


<xsl:template match="menuitem">
/* BEGIN menuitem */
GtkWidget* <xsl:value-of select="generate-id(.)"/> = gtk_menu_item_new_with_label("<xsl:value-of select="@label"/>");
gtk_menu_shell_append(GTK_MENU_SHELL(<xsl:value-of select="concat('m_',generate-id(..))"/>), <xsl:value-of select="generate-id(.)"/>);
gtk_widget_show (<xsl:value-of select="generate-id(.)"/>);
/* END menuitem */
</xsl:template>



<xsl:template match="callback">
gtk_signal_connect (GTK_OBJECT (<xsl:value-of select="generate-id(..)"/>), "clicked",
       GTK_SIGNAL_FUNC (callback), (gpointer) "cool button");
</xsl:template>


<xsl:template match="*" mode="insert">
	<xsl:choose>
		<xsl:when test="name(..) = 'window'">gtk_container_add(GTK_CONTAINER(<xsl:value-of select="generate-id(..)"/>), <xsl:value-of select="generate-id(.)"/>);</xsl:when>
		<xsl:when test="name(..) = 'hbox' or name(..) = 'vbox'">gtk_box_pack_start(GTK_BOX(<xsl:value-of select="generate-id(..)"/>), <xsl:value-of select="generate-id(.)"/>, TRUE, TRUE, 1);</xsl:when>
		<xsl:when test="name(..) = 'menubar'">gtk_menu_shell_append(GTK_MENU_SHELL(<xsl:value-of select="generate-id(..)"/>), <xsl:value-of select="generate-id(.)"/>);</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
