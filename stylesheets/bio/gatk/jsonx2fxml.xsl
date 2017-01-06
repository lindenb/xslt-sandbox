<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:j="http://www.ibm.com/xmlns/prod/2009/jsonx"
	xmlns:fx="http://javafx.com/fxml"
	version="1.0"
	>
<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">

<xsl:processing-instruction name="import">javafx.scene.layout.*</xsl:processing-instruction>
<xsl:processing-instruction name="import">javafx.scene.paint.*</xsl:processing-instruction>
<xsl:processing-instruction name="import">javafx.scene.control.*</xsl:processing-instruction>
<xsl:processing-instruction name="import">javafx.geometry.*</xsl:processing-instruction>
<xsl:processing-instruction name="import">xx.CheckboxOpt</xsl:processing-instruction>
<VBox>
<MenuBar>
	<Menu text="File">
       <MenuItem text="Quit" />
    </Menu>
</MenuBar>
<TabPane>

<Tab>
	 <xsl:attribute name="text">
				<xsl:value-of select="/j:object/j:string[@name='name']"/>
	</xsl:attribute>
<ScrollPane>
<VBox alignment="CENTER_RIGHT" style="-fx-padding: 15px;">
<xsl:apply-templates select="/j:object/j:array[@name='arguments']/j:object"/>
</VBox>
</ScrollPane>
 </Tab>
 
  <Tab text="Reference" >
 </Tab>
 
</TabPane>
</VBox>
</xsl:template>

<xsl:template match="j:object[j:string[@name='type'] = 'Boolean' or j:string[@name='type'] = 'boolean'] ">
<xsl:text>

</xsl:text>
<BorderPane style="-fx-padding: 5 5 5 5;">
	
   <center>
   	<FlowPane style="-fx-padding: 5 0 5 0;">
    <CheckBox style="-fx-font-weight:bold;" BorderPane.alignment="CENTER_LEFT" >
    		 <xsl:apply-templates select="."  mode="variable"/>
    		 <xsl:attribute name="text">
				<xsl:value-of select="j:string[@name='summary']"/>
			</xsl:attribute>
			<xsl:apply-templates select="."  mode="tooltip"/>
			
    </CheckBox>
    </FlowPane>
   </center>
</BorderPane>
<Separator/>
<xsl:text>

</xsl:text>
</xsl:template>

<xsl:template match="j:object">
<xsl:text>

</xsl:text>
<BorderPane style="-fx-padding: 5 5 5 5;">
	<xsl:apply-templates select="."  mode="summary"/>
	<center>
		<FlowPane style="-fx-padding: 5 0 5 20;">
		<TextField prefColumnCount="50">
			<xsl:apply-templates select="."  mode="variable"/>
			 <xsl:attribute name="promptText">
			 	<xsl:value-of select="j:string[@name='summary']"/>
			</xsl:attribute>
		</TextField> 
		</FlowPane>
    </center>
    <bottom>
    	<CheckboxOpt/>
    </bottom>
</BorderPane>
<Separator/>
<xsl:text>

</xsl:text>
</xsl:template>


<xsl:template match="j:object" mode="variable">
<xsl:attribute name="id">
<xsl:value-of select="substring(j:string[@name='name'],3)"/>
</xsl:attribute>
<xsl:attribute name="fx:id">
<xsl:value-of select="substring(j:string[@name='name'],3)"/>
</xsl:attribute>
</xsl:template>

<xsl:template match="j:object" mode="summary">
<top>
<Label style="-fx-font-weight:bold;">
<xsl:attribute name="text">
<xsl:value-of select="j:string[@name='summary']"/>
</xsl:attribute>
<xsl:apply-templates select="." mode="tooltip"/>
</Label>
</top>
</xsl:template>

<xsl:template match="j:object" mode="tooltip">
<tooltip>
      <Tooltip>
      	<xsl:attribute name="text">
			<xsl:value-of select="j:string[@name='fulltext']"/>
		</xsl:attribute>
      </Tooltip>
</tooltip>
</xsl:template>

</xsl:stylesheet>
