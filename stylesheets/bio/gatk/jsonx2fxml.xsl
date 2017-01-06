<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:j="http://www.ibm.com/xmlns/prod/2009/jsonx"
	xmlns:fx="http://javafx.com/fxml"
	version="1.0"
	>
<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
<xsl:apply-templates select="/j:object/j:array[@name='arguments']/j:object"/>
</xsl:template>

<xsl:template match="j:object[j:string[@name='type'] = 'Boolean']">
<xsl:text>

</xsl:text>
<fx:root type="javafx.scene.layout.HBox" xmlns:fx="http://javafx.com/fxml">
    <TextField editable="false" fx:id="textField" />
    <Checbox text="Select..." onAction="#doSelectFile">
    	<xsl:attribute name="text">
    		<xsl:value-of  select="j:string[@name='summary']"/>
    	</xsl:attribute>
    </Checbox>
    	
    <Button text="&#x232b;" onAction="#doClear" >
    	<tooltip>
          <Tooltip text="Remove File" />
		</tooltip>
    </Button>
</fx:root>
<xsl:text>

</xsl:text>
</xsl:template>

<xsl:template match="j:object">
<xsl:text>

</xsl:text>
<fx:root type="javafx.scene.layout.HBox" xmlns:fx="http://javafx.com/fxml">
    <TextField editable="false" fx:id="textField" />
    <Button text="Select..." onAction="#doSelectFile">
    	<tooltip>
          <Tooltip text="Select File... " />
		</tooltip>
    </Button>
    <Button text="&#x232b;" onAction="#doClear" >
    	<tooltip>
          <Tooltip text="Remove File" />
		</tooltip>
    </Button>
</fx:root>
<xsl:text>

</xsl:text>
</xsl:template>

</xsl:stylesheet>
