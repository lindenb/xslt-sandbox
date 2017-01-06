<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:j="http://www.ibm.com/xmlns/prod/2009/jsonx"
	xmlns:fx="http://javafx.com/fxml"
	version="1.0"
	>
<xsl:output method="text" indent="yes"/>

<xsl:template match="/">
<xsl:variable name="engine" select="/j:object/j:string[@name='name']"/>

import javafx.application.Application;
import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.*;
import javafx.stage.Stage;
import java.util.ResourceBundle;
import javafx.fxml.*;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.*;
import javafx.geometry.Rectangle2D;
import javafx.stage.Screen;

public class <xsl:value-of select="$engine"/>
	extends Application
	{
	public <xsl:value-of select="$engine"/>()
		{
		
		}
	
	@Override
	public void start(Stage stage) throws Exception {
		final Parent root;
		
		try
			{
			root = FXMLLoader.load( getClass().getResource("<xsl:value-of select="$engine"/>.fxml"));
    		}
    	catch(Exception err)
    		{
    		err.printStackTrace();
    		throw err;
    		}
    		
		xx.CheckboxOpt x=null;
       
    	Rectangle2D primaryScreenBounds = Screen.getPrimary().getVisualBounds();
        Scene scene = new Scene(root);
    	
        stage.setTitle("<xsl:value-of select="$engine"/>");
        stage.setScene(scene);
       
        stage.setX(50);
        stage.setY(50);
        stage.setWidth(primaryScreenBounds.getWidth()-100);
        stage.setHeight(primaryScreenBounds.getHeight()-100);
        stage.show();
    	}
    
  @FXML
  private void doMenuQuit(final ActionEvent event)
  {
      Platform.exit();
  }
    
	public static void main(String[] args) {
        launch( <xsl:value-of select="$engine"/>.class,args);
    	}

	<xsl:apply-templates select="/j:object/j:array[@name='arguments']/j:object"/>
	
	}

</xsl:template>

<xsl:template match="j:object[j:string[@name='type'] = 'Boolean' or j:string[@name='type'] = 'boolean']">
    @FXML
	<xsl:apply-templates select="."  mode="GATK"/>
    private CheckBox <xsl:apply-templates select="."  mode="variable"/>; 
</xsl:template>

<xsl:template match="j:object">
    @FXML
    <xsl:apply-templates select="."  mode="GATK"/>
    private TextField <xsl:apply-templates select="." mode="variable"/>; 
<xsl:text>

</xsl:text>
</xsl:template>


<xsl:template match="j:object" mode="variable">
<xsl:value-of select="substring(j:string[@name='name'],3)"/>
</xsl:template>

<xsl:template match="j:object" mode="GATK">
@GATK(param="<xsl:value-of select="j:string[@name='name']"/>",type="<xsl:value-of select="j:string[@name='type']"/>")
</xsl:template>

</xsl:stylesheet>
