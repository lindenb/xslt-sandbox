<?xml version="1.0"?>
<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:e="http://d"
  >

<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes" />
<xsl:key name="classes" match="e:class" use="@id" />

<xsl:template match="/">
<xsl:apply-templates select="e:model"/>
</xsl:template>

<xsl:template match="e:model">
import java.util.*;
import java.io.*;
import org.eclipse.emf.ecore.impl.*;
import org.eclipse.emf.ecore.*;

public class Model
	{
	private final List&lt;EPackage&gt; packages;
	
	private Model() {
		final List&lt;EPackage&gt; packages = new ArrayList&lt;&gt;();
		final EcoreFactory ecoreFactory = EcoreFactory.eINSTANCE;
		final EcorePackage ecorePackage = EcorePackage.eINSTANCE;
		<xsl:apply-templates select="e:package" mode="before"/>
		<xsl:apply-templates select="e:package/e:class" mode="before">
		<xsl:apply-templates select="e:package/e:class" mode="after">
		<xsl:apply-templates select="e:package" mode="after"/>
		this.packages = Collections.unmofifiableList(packages);
		}
	
	public List&lt;EPackage&gt; getEPackages() {
		return this.packages;
		}
	private static Model INSTANCE = null;
	
	public static Model getInstance() {
		if( INSTANCE == null )
			{
			INSTANCE = new Model();
			}
		return INSTANCE;
		}
	}

</xsl:template>



<xsl:template match="e:package" mode="before">
final EPackage <xsl:value-of select="generate-id(.)"/> =  ecoreFactory.createEPackage();
<xsl:value-of select="generate-id(.)"/>.setName("<xsl:value-of select="@name"/>");}
<xsl:value-of select="generate-id(.)"/>.setNsPrefix("my");
<xsl:value-of select="generate-id(.)"/>.setNsURI("http://www.c.ru#");


</xsl:template>

<xsl:template match="e:package" mode="after">
<xsl:apply-templates select="e:class" mode="after">
EPackage.Registry.INSTANCE.put(
	<xsl:value-of select="generate-id(.)"/>.getNsURI(),
	<xsl:value-of select="generate-id(.)"/>
	);
packages.add(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>

<xsl:template match="e:class" mode="before">
final EClass <xsl:value-of select="generate-id(.)"/> = ecoreFactory.createEClass();
<xsl:value-of select="generate-id(.)"/>.setName("<xsl:value-of select="@name"/>");
<xsl:value-of select="generate-id(.)"/>.setInstanceClassName("<xsl:value-of select="@name"/>");
</xsl:template>


<xsl:template match="e:class" mode="after">
<xsl:value-of select="generate-id(..)"/>.getEClassifiers().add(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>

<xsl:template match="e:attribute" mode="before">
final EAttribute <xsl:value-of select="generate-id(.)"/> = ecoreFactory.createEAttribute();
<xsl:value-of select="generate-id(.)"/>.setName("<xsl:value-of select="@name"/>");
<xsl:value-of select="generate-id(.)"/>.setEType( <xsl:choose>
	<xsl:when test="@type='string'">ecorePackage.getEString()</xsl:when>
	<xsl:when test="@type='int'">ecorePackage.getEInt()</xsl:when>
	<xsl:otherwise>ecorePackage.getEString()</xsl:otherwise>
</xsl:choose> );
<xsl:apply-templates select="." mode="eclassifier"/>
</xsl:template>


<xsl:template match="e:attribute" mode="after">
<xsl:value-of select="generate-id(..)"/>.getEStructuralFeatures().add(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>

<xsl:template match="e:reference" mode="before">
final EReference <xsl:value-of select="generate-id(.)"/> = ecoreFactory.createEReference();
<xsl:value-of select="generate-id(.)"/>.setName("<xsl:value-of select="@name"/>");
<xsl:value-of select="generate-id(.)"/>.setEType(<xsl:value-of select="generate-id(key('classes', @ref))"/>);
<xsl:apply-templates select="." mode="eclassifier"/>
</xsl:template>


<xsl:template match="e:reference" mode="after">
<xsl:value-of select="generate-id(..)"/>.getEStructuralFeatures().add(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>


<xsl:template match="e:reference|e:attribute" mode="eclassifier">
<xsl:choose>
	<xsl:when test="@changeable='true'"><xsl:value-of select="generate-id(.)"/>.setChangeable(true);</xsl:when>
	<xsl:when test="@changeable='false'"><xsl:value-of select="generate-id(.)"/>.setChangeable(false);</xsl:when>
</xsl:choose>
<xsl:choose>
	<xsl:when test="@unique='true'"><xsl:value-of select="generate-id(.)"/>.setUnique(true);</xsl:when>
	<xsl:when test="@unique='false'"><xsl:value-of select="generate-id(.)"/>.setUnique(false);</xsl:when>
</xsl:choose>
<xsl:choose>
	<xsl:when test="@ordered='true'"><xsl:value-of select="generate-id(.)"/>.setOrdered(true);</xsl:when>
	<xsl:when test="@ordered='false'"><xsl:value-of select="generate-id(.)"/>.setOrdered(false);</xsl:when>
</xsl:choose>
<xsl:choose>
	<xsl:when test="@lower-bound"><xsl:value-of select="generate-id(.)"/>.setLowerBound(<xsl:value-of select="@lower-bound"/>);</xsl:when>
</xsl:choose>
<xsl:choose>
	<xsl:when test="@upper-bound"><xsl:value-of select="generate-id(.)"/>.setUpperBound(<xsl:value-of select="@upper-bound"/>);</xsl:when>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
