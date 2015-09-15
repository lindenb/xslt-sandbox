<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
	>

<xsl:template match="xul:menubar">
<xsl:variable name="id"><xsl:apply-templates select="." mode="id"/></xsl:variable>
WHERE;
/* BEGIN menubar */
GtkWidget*  <xsl:value-of select="$id"/> =  gtk_menu_bar_new();
<xsl:apply-templates select="xul:menu"/>
gtk_widget_show ( <xsl:value-of select="$id"/>);
/* END menubar */
</xsl:template>


<xsl:template match="xul:menu">
<xsl:variable name="id"><xsl:apply-templates select="." mode="id"/></xsl:variable>
/* begin menu */
WHERE;
GtkWidget*  <xsl:value-of select="$id"/> = gtk_menu_item_new_with_label("<xsl:value-of select="@label"/>");
GtkWidget*  <xsl:value-of select="concat('m_',$id)"/> = gtk_menu_new();

gtk_menu_item_set_submenu(
	GTK_MENU_ITEM(<xsl:value-of select="$id"/>), /* menu item */ 
	<xsl:value-of select="concat('m_',$id)"/> /* menu  */
	);

gtk_menu_shell_append(
	GTK_MENU_SHELL(<xsl:apply-templates select=".." mode="id"/> ), /* menubar */ 
	<xsl:value-of select="$id"/> /* menu item */
	);

gtk_widget_show ( <xsl:value-of select="$id"/>);
WHERE;
<xsl:apply-templates select="xul:menuitem|xul:separator"/>
WHERE;
/* end menu */
</xsl:template>


<xsl:template match="xul:menuitem">
<xsl:variable name="id"><xsl:apply-templates select="." mode="id"/></xsl:variable>
<xsl:variable name="pid"><xsl:apply-templates select=".." mode="id"/></xsl:variable>
WHERE;
/* BEGIN menuitem */
GtkWidget* <xsl:value-of select="$id"/> = gtk_menu_item_new_with_label("<xsl:value-of select="@label"/>");
gtk_menu_shell_append(GTK_MENU_SHELL(<xsl:value-of select="concat('m_',$pid)"/>),  <xsl:value-of select="$id"/>);
gtk_widget_show ( <xsl:value-of select="$id"/>);
<xsl:apply-templates select="*"/>
WHERE;
/* END menuitem */
</xsl:template>

<xsl:template match="xul:separator[local-name(..)='menu']">
<xsl:variable name="id"><xsl:apply-templates select="." mode="id"/></xsl:variable>
<xsl:variable name="pid"><xsl:apply-templates select=".." mode="id"/></xsl:variable>
WHERE;
GtkWidget*  <xsl:value-of select="$id"/> = gtk_menu_item_new();
gtk_menu_shell_append(GTK_MENU_SHELL(<xsl:value-of select="concat('m_',$pid)"/>),  <xsl:value-of select="$id"/>);
gtk_widget_show ( <xsl:value-of select="$id"/>);
WHERE;
</xsl:template>


</xsl:stylesheet>
