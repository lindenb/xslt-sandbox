<?xml version="1.0"?>
<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:e="https://github.com/lindenb/xslt-sandbox/stylesheets/emf"
  >

<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes" />


<xsl:template match="/">
<xsl:apply-templates select="e:model"/>
</xsl:template>

<xsl:template match="e:model">
<xsl:if test="@package">package <xsl:value-of select="@package"/>;</xsl:if>
<xsl:variable name="className">
	<xsl:choose>
		<xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
		<xsl:otherwise>Model</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

import java.util.*;
import java.io.*;
import org.eclipse.emf.ecore.impl.*;
import org.eclipse.emf.ecore.*;
<xsl:if test="@velocity='true'">
import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.apache.velocity.runtime.RuntimeConstants;
import org.apache.velocity.runtime.resource.loader.StringResourceLoader;
</xsl:if>

@javax.annotation.Generated("xslt")
public class <xsl:value-of select="$className"/>
	{
	private final List&lt;EPackage&gt; packages;
	
	public static class Factory implements java.util.functions.Factory&lt;<xsl:value-of select="$className"/>&gt;
		{
		@Override
		public void <xsl:value-of select="$className"/> make() {
			return <xsl:value-of select="$className"/>.getInstance();
			}
		}
	
	
	private static class Ref2Type {
		final EReference ref;
		final String qName;
		Ref2Type(final EReference ref,final String qName) {
				this.ref = ref;
				this.qName = qName;
		}
	}


	public <xsl:value-of select="$className"/>() {	
		final List&lt;EPackage&gt; packages = new ArrayList&lt;&gt;();
		final Map&lt;String,EClass&gt; qname2eclass = new HashMap&lt;&gt;();
		final Map&lt;String,EReference&gt; qName2ereference = new HashMap&lt;&gt;();
		final List&lt;Ref2Type&gt; att2types = new ArrayList&lt;&gt;();
		final List&lt;Ref2Type&gt; opposites = new ArrayList&lt;&gt;();

		final EcoreFactory ecoreFactory = EcoreFactory.eINSTANCE;
		final EcorePackage ecorePackage = EcorePackage.eINSTANCE;
		<xsl:apply-templates select="e:package" mode="before"/>
		<xsl:apply-templates select="e:package/e:class" mode="before"/>
		<xsl:apply-templates select="e:package/e:class/e:attribute" mode="before"/>
		<xsl:apply-templates select="e:package/e:class/e:reference" mode="before"/>
		
		<xsl:apply-templates select="e:package/e:class/e:reference" mode="after"/>
		<xsl:apply-templates select="e:package/e:class/e:attribute" mode="after"/>
		<xsl:apply-templates select="e:package/e:class" mode="after"/>
		<xsl:apply-templates select="e:package" mode="after"/>
		
		for(final Ref2Type att2type: opposites) {
			final EReference eRef= qName2ereference.get(att2type.qName);
			att2type.ref.setEOpposite(eRef);
		}

		
		this.packages = java.util.Collections.unmodifiableList(packages);
		}
	
	public List&lt;EPackage&gt; getEPackages() {
		return this.packages;
		}
	
	public List&lt;EClassifier&gt; getEClassifiers() {
		final List&lt;EClassifier&gt; classes = new ArrayList&lt;&gt;();
		for(final EPackage p: this.getEPackages() ) {
			classes.addAll( p.getEClassifiers() );
			}
		return classes;
		}
	
	private static <xsl:value-of select="$className"/> INSTANCE = null;
	
	public static <xsl:value-of select="$className"/> getInstance() {
		if( INSTANCE == null )
			{
			INSTANCE = new <xsl:value-of select="$className"/>();
			}
		return INSTANCE;
		}
	
	<xsl:if test="@velocity='true'">
	private static void mainVelocity(final String args[]) {
			if( args.length==0) {
				System.err.println("Illegal Number of arguments. Expected one or velocity templates");
				System.exit(-1);
				}
			final VelocityContext context= new VelocityContext();
			context.put("model", model);
			final PrintWriter w=new PrintWriter( System.out);
    		for(final String filename: args)
                    {
                    final File file=new File(filename);
                    final VelocityEngine ve = new VelocityEngine();
                    ve.setProperty(RuntimeConstants.RESOURCE_LOADER, "file");
                    ve.setProperty("file.resource.loader.class","org.apache.velocity.runtime.resource.loader.FileResourceLoader");
                    ve.setProperty("file.resource.loader.path",file.getParent());
                    ve.init();
                    final Template template = ve.getTemplate(file.getName());
                    template.merge( context, w);
                    }
			    	
		    	w.flush();
		    	w.close();
	}
	</xsl:if>
		
	public static void main(final String args[]) {
		
		final <xsl:value-of select="$className"/> model = <xsl:value-of select="$className"/>.getInstance();
		<xsl:choose>
			<xsl:when test="@velocity='true'">
				mainVelocity(args);
			</xsl:when>
			<xsl:otherwise>
			System.err.println( model.getEPackages());
			System.err.println( model.getEClassifiers());
			System.err.println("Done.");
			</xsl:otherwise>
		</xsl:choose>
		}
	}

</xsl:template>



<xsl:template match="e:package" mode="before">
final EPackage <xsl:value-of select="generate-id(.)"/> =  ecoreFactory.createEPackage();

final String <xsl:value-of select="concat(generate-id(.),'_prefix')"/> = "<xsl:value-of select="@prefix"/>";
if(!<xsl:value-of select="concat(generate-id(.),'_prefix')"/>.matches("[a-zA-Z_][a-zA-Z0-9_]*")) {
	throw new IllegalArgumentException("Bad Prefix : \"" + <xsl:value-of select="concat(generate-id(.),'_prefix')"/> + "\"");
	}
<xsl:value-of select="generate-id(.)"/>.setNsPrefix(<xsl:value-of select="concat(generate-id(.),'_prefix')"/>);

final String <xsl:value-of select="concat(generate-id(.),'_ns')"/> = "<xsl:value-of select="@namespace-uri"/>";

<xsl:if test="not(@name) or @name=''"><xsl:message terminate='yes'>Attribute name missing or empty in <xsl:value-of select="name(.)"/>.</xsl:message></xsl:if>
<xsl:value-of select="generate-id(.)"/>.setName("<xsl:value-of select="@name"/>");
if(!<xsl:value-of select="generate-id(.)"/>.getName().matches("[a-zA-Z_]([a-zA-Z_0-9])*")) {
	throw new IllegalArgumentException("Bad Name : \""+<xsl:value-of select="generate-id(.)"/>.getNsURI()+"\"");
	}

<xsl:value-of select="generate-id(.)"/>.setNsURI(<xsl:value-of select="concat(generate-id(.),'_ns')"/>);
try {
	new java.net.URI(<xsl:value-of select="generate-id(.)"/>.getNsURI());
	}
catch(final java.net.URISyntaxException err)
	{
	throw new IllegalArgumentException("Bad URI : \""+<xsl:value-of select="generate-id(.)"/>.getNsURI()+"\"");
	}

for(final EPackage p2 : packages )
	{
	if( p2.getName().equals( <xsl:value-of select="generate-id(.)"/>.getName() ) ) {
		throw new IllegalArgumentException("Duplicate package "+ p2.getName() );
		}
	}
</xsl:template>



<xsl:template match="e:package" mode="after">
EPackage.Registry.INSTANCE.put(
	<xsl:value-of select="generate-id(.)"/>.getNsURI(),
	<xsl:value-of select="generate-id(.)"/>
	);
packages.add(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>


<xsl:template match="e:class" mode="before">
final EClass <xsl:value-of select="generate-id(.)"/> = ecoreFactory.createEClass();
<xsl:apply-templates select="." mode="enamed"/>
<xsl:if test="@abstract"><xsl:value-of select="generate-id(.)"/>.setAbstract(<xsl:value-of select="@abstract"/>);</xsl:if>
<xsl:if test="@interface"><xsl:value-of select="generate-id(.)"/>.setInterface(<xsl:value-of select="@interface"/>);</xsl:if>

final String <xsl:value-of select="concat(generate-id(.),'qName')"/> = <xsl:value-of select="generate-id(..)"/>.getNsPrefix()+":"+<xsl:value-of select="generate-id(.)"/>.getName();
if( qname2eclass.containsKey( <xsl:value-of select="concat(generate-id(.),'qName')"/> ) ) {
	throw new IllegalArgumentException("");
	}
qname2eclass.put( <xsl:value-of select="concat(generate-id(.),'qName')"/> , <xsl:value-of select="generate-id(.)"/> );

<xsl:value-of select="generate-id(.)"/>.setInstanceClassName("<xsl:value-of select="@name"/>");
</xsl:template>


<xsl:template match="e:class" mode="after">
/* add EClass <xsl:value-of select="@name"/> to EPackage <xsl:value-of select="../@name"/> */
<xsl:value-of select="generate-id(..)"/>.getEClassifiers().add(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>

<xsl:template match="e:attribute" mode="before">
final EAttribute <xsl:value-of select="generate-id(.)"/> = ecoreFactory.createEAttribute();
<xsl:if test="@id"><xsl:value-of select="generate-id(.)"/>.setID(<xsl:value-of select="@id"/>);</xsl:if>

<xsl:apply-templates select="." mode="enamed"/>
<xsl:if test="not(@type) or @type=''"><xsl:message terminate='yes'>Attribute type missing or empty in Eattribute <xsl:value-of select="@name"/>.</xsl:message></xsl:if>

<xsl:value-of select="generate-id(.)"/>.setEType( <xsl:choose>
	<xsl:when test="@type='string'">ecorePackage.getEString()</xsl:when>
	<xsl:when test="@type='int'">ecorePackage.getEInt()</xsl:when>
	<xsl:when test="@type='short'">ecorePackage.getEShort()</xsl:when>
	<xsl:when test="@type='long'">ecorePackage.getELong()</xsl:when>
	<xsl:when test="@type='float'">ecorePackage.getEFloat()</xsl:when>
	<xsl:when test="@type='double'">ecorePackage.getEDouble()</xsl:when>
	<xsl:otherwise>
		<xsl:message terminate='yes'>
			Unknow type "<xsl:value-of select="@type"/>" for EClass <xsl:value-of select="@name"/>
		</xsl:message>
	</xsl:otherwise>
</xsl:choose> );



<xsl:apply-templates select="." mode="eclassifier"/>
</xsl:template>


<xsl:template match="e:attribute" mode="after">
/* add  EAttribute <xsl:value-of select="@name"/> to EClass <xsl:value-of select="../@name"/> */
<xsl:value-of select="generate-id(..)"/>.getEStructuralFeatures().add(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>

<xsl:template match="e:reference" mode="before">
final EReference <xsl:value-of select="generate-id(.)"/> = ecoreFactory.createEReference();
<xsl:apply-templates select="." mode="enamed"/>
<xsl:if test="not(@type) or @type=''"><xsl:message terminate='yes'>Attribute type missing or empty in EReference <xsl:value-of select="@name"/>.</xsl:message></xsl:if>

final String <xsl:value-of select="concat(generate-id(.),'type')"/> =  "<xsl:value-of select="@type"/>";
if(!qname2eclass.containsKey(<xsl:value-of select="concat(generate-id(.),'type')"/>))
	{
	throw new IllegalArgumentException("Undefined type \"" + <xsl:value-of select="concat(generate-id(.),'type')"/> +"\"");
	}
<xsl:value-of select="generate-id(.)"/>.setEType(qname2eclass.get(<xsl:value-of select="concat(generate-id(.),'type')"/>));

<xsl:if test="@containment"><xsl:value-of select="generate-id(.)"/>.setContainment("<xsl:value-of select="@containment"/>");</xsl:if>
<xsl:if test="@resolve-proxies"><xsl:value-of select="generate-id(.)"/>.setResolveProxies("<xsl:value-of select="@resolve-proxies"/>");</xsl:if>

<xsl:if test="@opposite">
	opposites.add(new Ref2Type(<xsl:value-of select="generate-id(.)"/>,"<xsl:value-of select="@opposite"/>"));
</xsl:if>

qName2ereference.put("<xsl:value-of select="../../@prefix"/>:<xsl:value-of select="../@name"/>:<xsl:value-of select="@name"/>",<xsl:value-of select="generate-id(.)"/>);


<xsl:apply-templates select="." mode="eclassifier"/>
</xsl:template>


<xsl:template match="e:reference" mode="after">
<xsl:value-of select="generate-id(..)"/>.getEStructuralFeatures().add(<xsl:value-of select="generate-id(.)"/>);
</xsl:template>

<xsl:template match="e:reference|e:attribute" mode="estructuralfeature">
<xsl:if test="@default"><xsl:value-of select="generate-id(.)"/>.setDefaultValueLiteral("<xsl:value-of select="@default"/>");</xsl:if>
<xsl:if test="@derived"><xsl:value-of select="generate-id(.)"/>.setDerived("<xsl:value-of select="@derived"/>");</xsl:if>
<xsl:if test="@transient"><xsl:value-of select="generate-id(.)"/>.setTransient("<xsl:value-of select="@transient"/>");</xsl:if>
<xsl:if test="@unsettable"><xsl:value-of select="generate-id(.)"/>.setUnsettable("<xsl:value-of select="@unsettable"/>");</xsl:if>
<xsl:if test="@volatile"><xsl:value-of select="generate-id(.)"/>.seyVolatile("<xsl:value-of select="@volatile"/>");</xsl:if>
</xsl:template>


<xsl:template match="e:reference|e:attribute" mode="eclassifier">
<xsl:if test="@changeable"><xsl:value-of select="generate-id(.)"/>.setChangeable(<xsl:value-of select="@changeable"/>);</xsl:if>
</xsl:template>


<xsl:template match="e:reference|e:attribute" mode="etypedelement">
<xsl:if test="@unique"><xsl:value-of select="generate-id(.)"/>.setUnique(<xsl:value-of select="@unique"/>);</xsl:if>
<xsl:if test="@ordered"><xsl:value-of select="generate-id(.)"/>.setOrdered(<xsl:value-of select="@ordered"/>);</xsl:if>
<xsl:if test="@lower-bound"><xsl:value-of select="generate-id(.)"/>.setLowerBound(<xsl:value-of select="@lower-bound"/>);</xsl:if>
<xsl:if test="@upper-bound"><xsl:value-of select="generate-id(.)"/>.setUpperBound(<xsl:value-of select="@upper-bound"/>);</xsl:if>
</xsl:template>

<xsl:template match="*" mode="enamed">
<xsl:if test="not(@name)"><xsl:message terminate='yes'>Attribute name missing in <xsl:value-of select="name(.)"/>.</xsl:message></xsl:if>
<xsl:value-of select="generate-id(.)"/>.setName("<xsl:value-of select="@name"/>");
if(!<xsl:value-of select="generate-id(.)"/>.getName().matches("[a-zA-Z_]([a-zA-Z_0-9])*")) {
	throw new IllegalArgumentException("Bad Name : \""+<xsl:value-of select="generate-id(.)"/>.getName()+"\"");
	}
</xsl:template>


<xsl:template match="*" mode="eannotation">

final <xsl:value-of select="concat(generate-id(.),'eannot')"/> = EcoreFactory.eINSTANCE.createEAnnotation();
<xsl:value-of select="concat(generate-id(.),'eannot')"/>.setSource(EcorePackage.eNS_URI);

//TODO
</xsl:template>


</xsl:stylesheet>
