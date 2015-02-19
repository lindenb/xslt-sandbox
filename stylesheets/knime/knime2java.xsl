<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        xmlns:date="http://exslt.org/dates-and-times" 
        xmlns:xi="http://www.w3.org/2001/XInclude"
		version='1.0'
		exclude-result-prefixes="date xi"
        >
<!--
Author:
        Pierre Lindenbaum @yokofakun
        http://plindenbaum.blogspot.com
   
-->

<xsl:import href="../util/util.xsl"/>
<xsl:output method="text"/>
<xsl:param name="base.dir">TMP</xsl:param>
<xsl:param name="extra.source.dir"></xsl:param>
<xsl:param name="extra.jars"></xsl:param>

<xsl:variable name="default-icon16">iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAACxIAAAsSAdLdfvwAAAAadEVYdFNvZnR3YXJlAFBhaW50Lk5FVCB2My41LjExR/NCNwAAAMFJREFUOE+lU1ERgzAUqwMkIAEJSEDKJCABCUiYBCTsa9+VMAldHiR3pbxBt+UuXJvkvQ8CIaX0F0+RnuFm5PU7YLABX2RDuR4YmsBETpTrgIE2GxZb2tdAeCmGjQvtcyDYF4M5e8Y+A6GoMPjgWYyM+UDAalvDlKRZE1oy0toDhmrbLTDQUyt+rRBnBg4LBOhaMlPaAKGj4S7A3XsfHe01cKiNun0P91zPuNWKw1AY4uhoJQdboNp+YcTT/03rmMIbIBaXYlrHs80AAAAASUVORK5CYII=</xsl:variable>

<xsl:template match="/">
<xsl:apply-templates select="plugin"/>
</xsl:template>


<xsl:template match="plugin">

<xsl:variable name="outdir"><xsl:value-of select="concat($base.dir,'/')"/>src/<xsl:apply-templates select="." mode="out.dir"/></xsl:variable>
<xsl:variable name="_package"><xsl:apply-templates select="." mode="package"/></xsl:variable>
<xsl:variable name="jar.name"><xsl:value-of select="translate(normalize-space($_package),'.','_')"/></xsl:variable>

<xsl:apply-templates select="category"/>

<xsl:document href="{$base.dir}/MANIFEST.MF" method="text">Manifest-Version: 1.0
Bundle-ManifestVersion: 2
Bundle-Name: <xsl:apply-templates select="." mode="label"/> Compiled on <xsl:value-of select="date:date-time()"/>
Bundle-SymbolicName: <xsl:for-each select="category//node"><xsl:if test="position()=1"><xsl:apply-templates select="." mode="package"/></xsl:if></xsl:for-each>; singleton:=true
Bundle-Version: <xsl:apply-templates select="." mode="version"/>
Bundle-ClassPath: <xsl:value-of select="$jar.name"/>.jar<xsl:if test="string-length($extra.jars)&gt;0">,___EXTRAJARS___</xsl:if>
Bundle-Activator: <xsl:for-each select="category//node"><xsl:if test="position()=1"><xsl:apply-templates select="." mode="package"/>.<xsl:apply-templates select="." mode="name"/>NodePlugin</xsl:if></xsl:for-each>
Bundle-Vendor: Pierre Lindenbaum
Require-Bundle: org.eclipse.core.runtime,org.knime.workbench.core,org.knime.workbench.repository,org.knime.base
Bundle-ActivationPolicy: lazy
Export-Package: <xsl:for-each select="category//node"><xsl:if test="position()=1"><xsl:apply-templates select="." mode="package"/></xsl:if></xsl:for-each>
Bundle-RequiredExecutionEnvironment: JavaSE-1.7

</xsl:document>

<xsl:document href="{$base.dir}/Makefile" method="text"># I hate ant
.PHONY=all clean install doc
SHELL=/bin/bash
tmp.dir=tmp
extra.source.dir=<xsl:value-of select="$extra.source.dir"/>
extra.jars=<xsl:value-of select="$extra.jars"/>
plugin.version=<xsl:apply-templates select="." mode="version"/>
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)
COMMA := ,

feature.dir=${tmp.dir}/feature/<xsl:apply-templates select="." mode="package"/>.feature_${plugin.version}
plugin.dir=${tmp.dir}/plugins/<xsl:apply-templates select="." mode="package"/>_${plugin.version}
manifest=${plugin.dir}/META-INF/MANIFEST.MF


ifeq ($(realpath ${knime.root}),)
$(error ERROR================ $$knime.root was not defined. Run 'make' with knime.root=/path/to/knime )
endif

knime.jars=$(shell find ${knime.root}/plugins -type f -name "knime-core.jar" -o -name "org.knime.core.util_*.jar" -o -name "org.eclipse.osgi_*.jar" -o -name "xbean*.jar" -o -name "org.eclipse.core.runtime_*.jar")


JAVAC?=javac

all: dist/<xsl:apply-templates select="." mode="package"/>_${plugin.version}.jar 

install: dist/<xsl:apply-templates select="." mode="package"/>_${plugin.version}.jar 
	rm -f ${knime.root}/plugins/<xsl:apply-templates select="." mode="package"/>_*.jar
	cp $&lt; ${knime.root}/plugins/

dist/<xsl:apply-templates select="." mode="package"/>_${plugin.version}.jar : dist/<xsl:value-of select="$jar.name"/>.jar  $(subst :, ,${extra.jars})
	rm -f $@ 
	mkdir -p ${tmp.dir}/META-INF $(dir $@)
	cat MANIFEST.MF | sed 's%___EXTRAJARS___%$(subst $(SPACE),$(COMMA),$(notdir $(subst :,$(SPACE),${extra.jars})))%g' | awk '{S=$$0;i=0;while(length(S)&gt;70) {printf("%s%s\n",(i==0?"":" "),substr(S,1,70));S=substr(S,71);i++;} printf("%s%s\n",(i==0?"":" "),S);}' &gt; ${tmp.dir}/META-INF/MANIFEST.MF
	cp plugin.xml ${tmp.dir}
	cp $(filter %.jar,$^) ${tmp.dir}
	jar cmvf ${tmp.dir}/META-INF/MANIFEST.MF $@  -C ${tmp.dir} .
	rm -rf ${tmp.dir}
	

dist/<xsl:value-of select="$jar.name"/>.jar : ${knime.jars} $(subst :, ,${extra.jars})
	mkdir -p $(dir $@) ${tmp.dir}/icons
	cp -r src/. $(addsuffix /.,$(subst :, ,${extra.source.dir}) ) ${tmp.dir}<xsl:for-each select="category//node">
	echo "<xsl:choose><xsl:when test="icon-base64"><xsl:value-of select="normalize-space(icon-base64)"/></xsl:when><xsl:otherwise><xsl:value-of select="$default-icon16"/></xsl:otherwise></xsl:choose>" | base64 -d &gt; ${tmp.dir}/<xsl:apply-templates select="." mode="out.dir"/>default.png</xsl:for-each><xsl:for-each select=".//category">
	echo "<xsl:choose><xsl:when test="icon-base64"><xsl:value-of select="normalize-space(icon-base64)"/></xsl:when><xsl:otherwise><xsl:value-of select="$default-icon16"/></xsl:otherwise></xsl:choose>" | base64 -d &gt; ${tmp.dir}/icons/default.png </xsl:for-each>
	${JAVAC} -Xlint -d ${tmp.dir} -g -classpath "$(subst $(SPACE),:,$(filter %.jar,$^))" -sourcepath ${tmp.dir} src/<xsl:apply-templates select="." mode="out.dir"/>CompileAll__.java
	jar cf $@ -C ${tmp.dir} .
	rm -rf ${tmp.dir}

doc: ${knime.jars} $(subst :, ,${extra.jars})
	mkdir -p javadoc
	javadoc -d javadoc -classpath "$(subst $(SPACE),:,$(filter %.jar,$^))" -sourcepath src -subpackages <xsl:apply-templates select="." mode="package"/>
	
	
clean:
	
	
</xsl:document>


<xsl:document href="{$outdir}CompileAll__.java" method="text">/**
<xsl:value-of select="$mit.license"/>
**/
package <xsl:apply-templates select="." mode="package"/>;
/**
 * I'm lazy: this class is just used to provide a cental point of compilation for javac
 */
class CompileAll__
	{
	<xsl:for-each select="category//node">
	static <xsl:apply-templates select="." mode="package"/>.<xsl:apply-templates select="." mode="name"/>NodePlugin _p<xsl:value-of select="generate-id(.)"/> = null; 
	static <xsl:apply-templates select="." mode="package"/>.<xsl:apply-templates select="." mode="name"/>NodeFactory _f<xsl:value-of select="generate-id(.)"/> = null; 
	static <xsl:apply-templates select="." mode="package"/>.<xsl:apply-templates select="." mode="name"/>NodeModel _m<xsl:value-of select="generate-id(.)"/> = null; 
	</xsl:for-each>
	}


</xsl:document>

<xsl:document href="{$outdir}AbstractNodeModel.java" method="text">/**
<xsl:value-of select="$mit.license"/>
**/
package <xsl:apply-templates select="." mode="package"/>;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringWriter;

import org.knime.core.node.CanceledExecutionException;
import org.knime.core.node.ExecutionMonitor;
import org.knime.core.node.NodeSettingsRO;
import org.knime.core.node.InvalidSettingsException;
import org.knime.core.node.defaultnodesettings.SettingsModel;
import org.knime.core.node.NodeSettingsWO;
import org.knime.core.node.port.PortType;
import org.knime.core.util.FileUtil;
import org.knime.core.data.DataTableSpec;
import org.knime.core.data.DataType;
import org.knime.core.node.defaultnodesettings.SettingsModelColumnName;

/**
 * date: <xsl:value-of select="date:date-time()"/>
 */

@javax.annotation.Generated("xslt-sandbox/knime2java")
public abstract class AbstractNodeModel extends
	<xsl:choose>
	  <xsl:when test="string-length(@extends-model)&gt;0">
	  <xsl:value-of select="@extends-model"/>
	  </xsl:when>
	 <xsl:otherwise>
	 org.knime.core.node.NodeModel
	 </xsl:otherwise>
	</xsl:choose>
	 
	{
	private final static String UNIQ_ID_FILE="nodeid.txt";
	/** uniq ID for this node */
	private String nodeUniqId=null;



	
	protected AbstractNodeModel(int inport,int outport)
		{
		/* super(inport,outport) */
		super(inport,outport);
		}
	
	protected AbstractNodeModel(PortType[] inPortTypes, PortType[] outPortTypes)
		{
		super(inPortTypes, outPortTypes);
		}

	/** return the date when this class was generated */
	public final String getCompilationDate()
		{
		return "<xsl:value-of select="date:date-time()"/>";
		}
	
	protected DataTableSpec[] createOutTableSpec()
    	{
    	DataTableSpec tspecs[]=new DataTableSpec[ this.getNrOutPorts() ];
    	for(int i=0;i &lt; tspecs.length; ++i)
    		{
    		tspecs[ i ] =  createOutDataTableSpec(i);
    		}
    	return tspecs;
    	}
    
    /** returns summary of the NodeSettings as a string */
    protected abstract String getSettingsModelSummary();
    
    /* @inheritDoc */
    @Override	
    protected abstract DataTableSpec[] configure(DataTableSpec[] inSpecs) throws org.knime.core.node.InvalidSettingsException;
	
    
	protected abstract DataTableSpec createOutDataTableSpec(int index);
	
	
	/** returns all the settings */
	protected java.util.List&lt;SettingsModel&gt; getSettingsModel()
		{
		java.util.List&lt;SettingsModel&gt; L=new java.util.ArrayList&lt;SettingsModel&gt;();
		fillSettingsModel(L);
		return L;
		}
	
	/** collect all the settings. default implementation doesn't change the list */
    protected java.util.List&lt;SettingsModel&gt; fillSettingsModel(java.util.List&lt;SettingsModel&gt; list) {
    	return list;
    	}
	
	/* @inheritDoc */
	@Override
	protected void loadInternals(File dir, ExecutionMonitor executionMonitor)
			throws IOException, CanceledExecutionException
		{
		getLogger().info("loadInternals "+getClass().getName()+" from "+dir);
		File f=new File(dir,UNIQ_ID_FILE);
		if(f.exists() &amp;&amp; f.isFile())
			{
			FileReader r=new FileReader(f);
			StringWriter sw=new StringWriter();
			FileUtil.copy(r, sw);
			r.close();
			String id=sw.toString();
			if(this.nodeUniqId!=null &amp;&amp; !id.equals(this.nodeUniqId))
				{
				throw new IOException("No the same node  id?? "+id+ " "+this.nodeUniqId);
				}
			this.nodeUniqId=id;
			}

		}
	
	/* @inheritDoc */
	@Override
	protected void loadValidatedSettingsFrom(NodeSettingsRO settings)
			throws InvalidSettingsException
		{
		getLogger().info("loadValidatedSettingsFrom "+getClass().getName());
		for(SettingsModel param:getSettingsModel())
    		param.loadSettingsFrom(settings);
		}
	
	/* @inheritDoc */
	@Override
	protected void reset()
		{
		getLogger().info("reset "+getClass().getName());
		}
	
	/* @inheritDoc */
	@Override
	protected void saveInternals(File dir, ExecutionMonitor executionMonitor)
			throws IOException, CanceledExecutionException
		{
		getLogger().info("saveInternals "+getClass().getName()+" to "+dir);
		
		if( hasNodeUniqId() )
			{
			/* save node uniq id */
			FileWriter w=new FileWriter(new File(dir,UNIQ_ID_FILE));
			w.write(getNodeUniqId());;
			w.flush();
			w.close();
			}
		}
	
	/*  @inheritDoc 
		Adds to the given NodeSettings the model specific settings. The settings don't need to be complete or consistent.
		If, right after startup, no valid settings are available this method can write either nothing or invalid settings.
		*/
	@Override
	protected void saveSettingsTo(NodeSettingsWO settings) {
		getLogger().info("saveSettingsTo "+getClass().getName());
		for(SettingsModel sm:getSettingsModel())
			sm.saveSettingsTo(settings);
		}
		
	/* @inheritDoc */
	@Override
	protected void validateSettings(NodeSettingsRO settings)
			throws InvalidSettingsException {
		getLogger().info("validateSettings "+getClass().getName());
		for(SettingsModel sm:getSettingsModel())
				sm.validateSettings(settings);
		}

	/* get MD5 for a string */
	protected static String md5(CharSequence sequence)
		{
		try {
			java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
	        for(int i=0;i &lt; sequence.length();++i)
	          md.update((byte)sequence.charAt(i));
	        byte[] mdbytes = md.digest();
	        StringBuffer hexString = new StringBuffer(50);
	    	for (int i=0;i&lt;mdbytes.length;i++) {
	    		String hex=Integer.toHexString(0xff &amp; mdbytes[i]);
	   	     	if(hex.length()==1) hexString.append('0');
	   	     	hexString.append(hex);
	    		}
	    	return hexString.toString();
			}
		catch(Exception err)
			{
			throw new RuntimeException(err);
			}
		}
	/** get uniq node id for this node https://tech.knime.org/node/20789 */
	protected synchronized String getNodeUniqId()
		{
		if(this.nodeUniqId==null)
			{
			this.nodeUniqId= md5(
				String.valueOf(getClass().getName())+":"+
				System.currentTimeMillis()+":"+
				String.valueOf(System.getProperty("user.name"))+":"+
				String.valueOf(Math.random())
				);
			}
		return this.nodeUniqId;
		}
	
	/** return wether the node ID for this node has been defined */
	protected synchronized boolean hasNodeUniqId()
		{
		return nodeUniqId!=null;
		}
	
	/** return a name describing this type of node */
	protected String getNodeName()
		{
		return this.getClass().getSimpleName();
		}	
		
		
	/** read input stream, decompress gzip if needed */
	protected java.io. InputStream  openUriForInputStream(String uri) throws java.io.IOException
		{
		java.io.InputStream  input = null;
		try
			{
			input= org.knime.core.util.FileUtil.openInputStream(uri);
			}
		catch(Exception err)
			{
			throw new java.io.IOException(err);
			}
		/* http://stackoverflow.com/questions/4818468 */
		java.io.PushbackInputStream pb = new java.io.PushbackInputStream( input, 2 ); //we need a pushbackstream to look ahead
     	byte [] signature = new byte[2];
    	pb.read( signature ); //read the signature
    	pb.unread( signature ); //push back the signature to the stream
     	if( signature[ 0 ] == (byte) 0x1f &amp;&amp; signature[ 1 ] == (byte) 0x8b ) //check if matches standard gzip magic number
       		return new java.util.zip.GZIPInputStream( pb );
     	else 
       		return pb;
		}	
		
	/** read input reader, decompress gzip if needed */
	protected java.io.BufferedReader openUriForBufferedReader(String uri) throws java.io.IOException
		{
		return new java.io.BufferedReader(
			new java.io.InputStreamReader(
			this.openUriForInputStream(uri)
			));
		}
	
	/* generic way to open a file for writing, gzip if extension=.gz */
	protected java.io.OutputStream openFileForWriting(java.io.File fout)  throws java.io.IOException
		{
		java.io.OutputStream out= new java.io.FileOutputStream(fout);
		if(fout.getName().endsWith(".gz"))
			{
			out= new java.util.zip.GZIPOutputStream(out);
			}
		return out;
		}
	
	
	/** throws an InvalidSettingsException if column was not found */
    public int findColumnIndex(DataTableSpec dataTableSpec,String name)
		throws InvalidSettingsException
		{
		int index;
		if((index=dataTableSpec.findColumnIndex(name))==-1)
			{
			throw new InvalidSettingsException("Node "+this.getClass().getName()+": cannot find column title= \""+name+"\"");
			}
		return index;
		}
	
	 /** throws an InvalidSettingsException if column was not found */
	public int findColumnIndex(DataTableSpec dataTableSpec,String name,DataType dataType)
	throws InvalidSettingsException
		{
		if(name==null) throw new NullPointerException("undefined column name");
		int index=findColumnIndex(dataTableSpec,name);
		if(dataTableSpec.getColumnSpec(name).getType()!=dataType)
			{
			throw new InvalidSettingsException("Node "+this.getClass().getName()+" column["+index+"]=\""+name+"\" is not a \""+dataType+"\" but a \""+dataTableSpec.getColumnSpec(name).getType()+"\"");
			}
		return index;
		}
	
	public int findColumnIndex(DataTableSpec dataTableSpec,SettingsModelColumnName colName,DataType dataType)
		throws InvalidSettingsException
		{
		return findColumnIndex(dataTableSpec,colName.getColumnName(),dataType);
		}

	
	
	}

</xsl:document>

<xsl:document href="{$base.dir}/plugin.xml" method="xml" indent="yes">
<xsl:processing-instruction name="eclipse"> version="3.0" </xsl:processing-instruction >
<plugin>
  <extension point="org.knime.workbench.repository.categories">
  	<xsl:apply-templates select="category" mode="plugin.xml"/> 
  </extension>
  <extension point="org.knime.workbench.repository.nodes">
  	<xsl:apply-templates select="category//node" mode="plugin.xml"/> 
  </extension>
</plugin>
</xsl:document>

</xsl:template>


<xsl:template match="node" mode="plugin.xml">
<node>
	<xsl:attribute name="category-path">
		<xsl:apply-templates select=".." mode="path"/>
		<xsl:value-of select="../@name"/>
	</xsl:attribute>
    <xsl:attribute name="factory-class"><xsl:apply-templates select="." mode="package"/><xsl:text>.</xsl:text><xsl:apply-templates select="." mode="name"/>NodeFactory</xsl:attribute>
    <xsl:attribute name="id"><xsl:apply-templates select="." mode="package"/><xsl:text>.</xsl:text><xsl:apply-templates select="." mode="name"/>NodeFactory</xsl:attribute>   
</node>
</xsl:template>


<xsl:template match="node">
<xsl:variable name="outdir"><xsl:value-of select="concat($base.dir,'/')"/>src<xsl:apply-templates select="." mode="out.dir"/></xsl:variable>
<xsl:variable name="node.name"><xsl:apply-templates select="." mode="name"/></xsl:variable>

<xsl:message terminate="no">node name <xsl:value-of select="$node.name"/></xsl:message>
<xsl:message terminate="no">outdir <xsl:value-of select="$outdir"/></xsl:message>

<xsl:document href="{$outdir}{$node.name}NodeFactory.xml" method="xml" indent="yes">
<knimeNode icon="default.png" type="Source">
	<xsl:comment>Generated with knime2java</xsl:comment>
    <name><xsl:apply-templates select="." mode="label"/></name>
    <shortDescription><xsl:apply-templates select="."  mode="short.desc"/></shortDescription>    
    <fullDescription>
        <intro><xsl:apply-templates select="description" mode="html"/>
        
        
        <xsl:if test="code/body">
        <h3>Source code</h3>
		Main source code:<pre><xsl:apply-templates select="code/body"/></pre> 
		</xsl:if>

        <h3>Compilation</h3>
        This node was compiled on : <xsl:value-of select="date:date-time()"/>.
       		Version: <xsl:apply-templates select="/plugin" mode="version"/>
		<xsl:apply-templates select="property" mode="nodeFactory.xml"/>
        
        </intro>

		
    </fullDescription>
    
    <ports>
    	<xsl:apply-templates select="inPort" mode="nodeFactory.xml"/>
    	<xsl:apply-templates select="outPort" mode="nodeFactory.xml"/>
    </ports>
</knimeNode>
</xsl:document >



<xsl:document href="{$outdir}{$node.name}NodePlugin.java" method="text">/**
<xsl:value-of select="$mit.license"/>
**/
package <xsl:apply-templates select="." mode="package"/>;

import org.eclipse.core.runtime.Plugin;
import org.osgi.framework.BundleContext;

public class  <xsl:apply-templates select="." mode="name"/>NodePlugin extends  <xsl:choose>
	<xsl:when test="string-length(@extends-plugin)&gt;0">
		<xsl:value-of select="@extends-plugin"/>
	</xsl:when>
		<xsl:otherwise>
		 	Plugin
		</xsl:otherwise>
	</xsl:choose>
	{
    // The shared instance.
    private static  <xsl:apply-templates select="." mode="name"/>NodePlugin plugin;

    /**
     * The constructor.
     */
    public  <xsl:apply-templates select="." mode="name"/>NodePlugin() {
        super();
        plugin = this;
    }

    /**
     * This method is called upon plug-in activation.
     * 
     * @inheritDoc
     * @param context The OSGI bundle context
     * @throws Exception If this plugin could not be started
     */
    @Override
    public void start(final BundleContext context) throws Exception {
        super.start(context);

    }

    /**
     * This method is called when the plug-in is stopped.
     * 
     * @inheritDoc
     * @param context The OSGI bundle context
     * @throws Exception If this plugin could not be stopped
     */
    @Override
    public void stop(final BundleContext context) throws Exception {
        super.stop(context);
        plugin = null;
    }

    /**
     * Returns the shared instance.
     * 
     * @inheritDoc
     * @return Singleton instance of the Plugin
     */
    public static  <xsl:apply-templates select="." mode="name"/>NodePlugin getDefault() {
        return plugin;
    }

}

</xsl:document>


<xsl:document href="{$outdir}{$node.name}NodeFactory.java" method="text">/**
<xsl:value-of select="$mit.license"/>
**/
package <xsl:apply-templates select="." mode="package"/>;

import org.knime.core.node.NodeDialogPane;
import org.knime.core.node.NodeFactory;
import org.knime.core.node.NodeView;
import org.knime.core.data.DataTableSpec;

@javax.annotation.Generated("xslt-sandbox/knime2java")
public class <xsl:apply-templates select="." mode="name"/>NodeFactory
        extends <xsl:choose>
	<xsl:when test="string-length(@extends-factory)&gt;0">
		<xsl:value-of select="@extends-factory"/>
	</xsl:when>
		<xsl:otherwise>
		 	NodeFactory&lt;<xsl:apply-templates select="." mode="name"/>NodeModel&gt; 
		</xsl:otherwise>
	</xsl:choose>
    {
	/** constructor */
	public <xsl:apply-templates select="." mode="name"/>NodeFactory()
		{
		System.err.println("[LOG]"+getClass()+" constructor");
		}
	
	/* @inheritDoc */
    @Override
    public <xsl:apply-templates select="." mode="name"/>NodeModel createNodeModel() {
        return new <xsl:apply-templates select="." mode="name"/>NodeModel();
    }
	
	/* @inheritDoc */
    @Override
    public int getNrNodeViews() {
        return 0;
    }
	
	/* @inheritDoc */
    @Override
    public NodeView&lt;<xsl:apply-templates select="." mode="name"/>NodeModel&gt; createNodeView(final int viewIndex,
            final <xsl:apply-templates select="." mode="name"/>NodeModel nodeModel) {
        throw new IllegalStateException();
    }
	
	/* @inheritDoc */
    @Override
    public boolean hasDialog() {
        return true;
    }

	/* @inheritDoc */
    @Override
    public NodeDialogPane createNodeDialogPane() {
        return new <xsl:apply-templates select="." mode="name"/>NodeDialog();
    }

}

</xsl:document>


<xsl:document href="{$outdir}/{$node.name}NodeDialog.java" method="text">/**
<xsl:value-of select="$mit.license"/>
**/
package <xsl:apply-templates select="." mode="package"/>;

import org.knime.core.node.defaultnodesettings.DefaultNodeSettingsPane;

@javax.annotation.Generated("xslt-sandbox/knime2java")
public class <xsl:apply-templates select="." mode="name"/>NodeDialog
	extends DefaultNodeSettingsPane
	{
	@SuppressWarnings("unchecked")
    public <xsl:apply-templates select="." mode="name"/>NodeDialog()
    	{
    	<xsl:apply-templates select="property" mode="dialog"/>
    	}
	}
</xsl:document>


<xsl:document href="{$outdir}Abstract{$node.name}NodeModel.java" method="text">/**
<xsl:value-of select="$mit.license"/>
**/
package <xsl:apply-templates select="." mode="package"/>;

import org.knime.core.node.defaultnodesettings.SettingsModel;
import org.knime.core.data.DataTableSpec;
import org.knime.core.data.DataColumnSpec;
import org.knime.core.node.InvalidSettingsException;
import org.knime.core.data.DataCell;
import org.knime.core.data.DataType;
import org.knime.core.data.def.StringCell;
import org.knime.core.data.def.DoubleCell;
import org.knime.core.data.def.IntCell;



@javax.annotation.Generated("xslt-sandbox/knime2java")
public abstract class Abstract<xsl:apply-templates select="." mode="name"/>NodeModel
extends <xsl:choose>
	<xsl:when test="string-length(@extends-model)&gt;0">
		<xsl:value-of select="@extends-model"/>
	</xsl:when>
	<xsl:otherwise>
	 <xsl:apply-templates select="/plugin" mode="package"/>
	 <xsl:text>.AbstractNodeModel</xsl:text>
	</xsl:otherwise>
	</xsl:choose>
	{
	<xsl:apply-templates select="property" />
	
	
	/** constructor */
	protected Abstract<xsl:apply-templates select="." mode="name"/>NodeModel()
		{
		/* super(inport,outport) */
		super( <xsl:value-of select="count(inPort)"/>, <xsl:value-of select="count(outPort)"/> );
		}
	
	/** get 'this' , shortcut to be used by internal generated classes to get an universal
	   handler to the parant class */ 
	public <xsl:apply-templates select="." mode="name"/>NodeModel getOwnerNode()
		{
		return <xsl:apply-templates select="." mode="name"/>NodeModel.class.cast(this);
		}
	
	/** returns Settings Summary as a String
	 	@inheritDoc */
	@Override
	protected String getSettingsModelSummary()
		{
		StringBuilder b=new StringBuilder();
		<xsl:for-each select="property" >
		<xsl:if test="position()&gt;1">b.append(" ");</xsl:if>
		b.append("<xsl:value-of select="@name"/>").append("=").append(String.valueOf(<xsl:apply-templates select="." mode="getter.value"/>()));
		</xsl:for-each>
		return b.toString();
		}
	
	/* @inheritDoc */
	@Override 
	protected DataTableSpec[] configure(final DataTableSpec[] inSpecs) throws InvalidSettingsException
		{
    	if(inSpecs==null || inSpecs.length!= <xsl:value-of select="count(inPort)"/>)
			{
			throw new InvalidSettingsException("Expected  <xsl:value-of select="count(inPort)"/> tables");
			}
    	DataTableSpec datatablespecs[] = new DataTableSpec[<xsl:value-of select="count(outPort)"/>];
    	<xsl:for-each select="outPort">
    	datatablespecs[<xsl:value-of select="position() -1 "/>] = configureOutDataTableSpec(<xsl:value-of select="position() -1 "/>,inSpecs);
    	</xsl:for-each>
    	return datatablespecs;
    	}

	
	/* @inheritDoc */
	@Override
    protected DataTableSpec createOutDataTableSpec(int index)
    	{
    	switch(index)
    		{
    		<xsl:for-each select="outPort">case <xsl:value-of select="position() -1 "/> : return createOutTableSpec<xsl:value-of select="position() -1 "/>();
    		</xsl:for-each>
    		default: throw new IllegalStateException();
    		}
    	}
    /** configure output port for known-index for known inSpecs */	
	protected DataTableSpec configureOutDataTableSpec(int index,DataTableSpec[] inSpecs) throws InvalidSettingsException
		{
		switch(index)
    		{
    		<xsl:for-each select="outPort">case <xsl:value-of select="position() -1 "/> : return configureOutTableSpec<xsl:value-of select="position() -1 "/>(inSpecs);
    		</xsl:for-each>
    		default: throw new IllegalStateException();
    		}
		}

	<xsl:for-each select="outPort">
	
	
	
	protected DataCell[] createDataCellsForOutTableSpec<xsl:value-of select="position() -1 "/>(
		<xsl:for-each select="column">
			<xsl:if test="position()&gt;1">,</xsl:if>
			<xsl:choose>
				<xsl:when test="not(@type) or @type='string'">CharSequence </xsl:when>
				<xsl:when test="'int'">java.lang.Integer </xsl:when>
				<xsl:when test="'bool'">java.lang.Boolean </xsl:when>
				<xsl:when test="'double'">java.lang.Double </xsl:when>
				<xsl:otherwise><xsl:message terminate="yes">unknown type</xsl:message></xsl:otherwise>
			</xsl:choose>
			<xsl:text> </xsl:text>
			<xsl:value-of select="@name"/>
		</xsl:for-each>
		)
		{
		DataCell __cells[]=new DataCell[<xsl:value-of select="count(column)"/>];
		<xsl:for-each select="column">
		<xsl:text>__cells[</xsl:text>
		<xsl:value-of select="position() -1 "/>
		<xsl:text> ] = </xsl:text>
		<xsl:choose>
				<xsl:when test="not(@type) or @type='string'">( <xsl:value-of select="@name"/> !=null? new StringCell( <xsl:value-of select="@name"/>.toString() ) :  DataType.getMissingCell() ) </xsl:when>
				<xsl:when test="'int'"> ( <xsl:value-of select="@name"/> !=null? new IntCell( <xsl:value-of select="@name"/> ) :  DataType.getMissingCell() )</xsl:when>
				<xsl:when test="'bool'"> ( <xsl:value-of select="@name"/> !=null? new BooleanCell( <xsl:value-of select="@name"/> ) :  DataType.getMissingCell() )</xsl:when>
				<xsl:when test="'double'"> ( <xsl:value-of select="@name"/> !=null? new DoubleCell( <xsl:value-of select="@name"/> ) :  DataType.getMissingCell() )</xsl:when>
				<xsl:otherwise><xsl:message terminate="yes">unknown type</xsl:message></xsl:otherwise>
		</xsl:choose>
		<xsl:text>;
		</xsl:text>
		</xsl:for-each>
		return __cells;
		}
	
	/** create DataTableSpec for outport '<xsl:value-of select="position() -1 "/>' <xsl:apply-templates select="." mode="label"/> */
	protected DataTableSpec createOutTableSpec<xsl:value-of select="position() -1 "/>()
		{
		DataColumnSpec colspecs[]=new DataColumnSpec[ <xsl:value-of select="count(column)"/> ];
		<xsl:for-each select="column">
		colspecs[ <xsl:value-of select="position() -1 "/> ] = <xsl:apply-templates select="." mode="create.data.column.spec"/>;
		</xsl:for-each>
    	return new DataTableSpec(colspecs);
		}
	
	/** create DataTableSpec for outport '<xsl:value-of select="position() -1 "/>' <xsl:apply-templates select="." mode="label"/> for known DataTableSpec */
	protected DataTableSpec configureOutTableSpec<xsl:value-of select="position() -1 "/>(DataTableSpec[] inSpecs) throws InvalidSettingsException
		{
		<xsl:for-each select="../property[@type=column]">
		/* findColumnIndex(inSpecs[0],m_column.getColumnName()); */
		</xsl:for-each>
		
		
		return this.createOutTableSpec<xsl:value-of select="position() -1 "/>();
		}	
	</xsl:for-each>
	
	/* @inheritDoc */
	@Override
    protected java.util.List&lt;SettingsModel&gt; fillSettingsModel(java.util.List&lt;SettingsModel&gt; list) {
    	list = super.fillSettingsModel(list);
    	<xsl:for-each select="property">
    	list.add(this.<xsl:apply-templates select="." mode="getter"/>());
    	</xsl:for-each>
    	return list;
    	}
    
	
	}

</xsl:document>


<xsl:choose>
<xsl:when test="not(@generate-model='false')">
<xsl:document href="{$outdir}/{$node.name}NodeModel.java" method="text">/*
<xsl:value-of select="$mit.license"/>
*/
package <xsl:apply-templates select="." mode="package"/>;
import org.knime.core.node.*;
import org.knime.core.data.*;
import org.knime.core.data.def.*;

/** BEGIN user imports */
<xsl:apply-templates select="code/import"/>
/** END user imports */


/**
 * <xsl:apply-templates select="." mode="name"/>NodeModel
 * @author Pierre Lindenbaum
 */
@javax.annotation.Generated("xslt-sandbox/knime2java")
public class <xsl:apply-templates select="." mode="name"/>NodeModel
	extends Abstract<xsl:apply-templates select="." mode="name"/>NodeModel
	{
	public <xsl:apply-templates select="." mode="name"/>NodeModel()
		{
		}
	
	
	<xsl:choose>
	<xsl:when test="code/body">
		/** BEGIN user code/body */
		<xsl:apply-templates select="code/body"/>
		/** END user code/body */
	</xsl:when>
	<xsl:otherwise>
	

	
	/* @inheritDoc */
	@Override
    protected BufferedDataTable[] execute(
    		final BufferedDataTable[] inData,
            final ExecutionContext exec
            ) throws Exception
			{
			BufferedDataContainer containers[]=  new BufferedDataContainer[getNrOutPorts()];;
			try
		    	{
				BufferedDataTable table1=inData[0];
		       	 <xsl:for-each select="outPort">
		        containers[<xsl:value-of select="position() -1"/>] = null; /* TODO */
		        </xsl:for-each>
		        double total=table1.getRowCount();
		        long nRow = 0L;
		        RowIterator iter1=null;
		       
		        try {
		        	iter1=table1.iterator();
		     
		        	while(iter1.hasNext())
		        		{
		        		++nRow;
		        		DataRow row=iter1.next();
		        		
		        		exec.checkCanceled();
		            	exec.setProgress(nRow/total,"Extracting <xsl:value-of select="@name"/>....");
		        		}
					} 
		        catch (Exception e)
					{
		        	e.printStackTrace();
					throw e;
					}
				finally
					{
					
					}
		        
		        /* create and fill array to be returned */
		        BufferedDataTable returnBufferedDataTable[]= new BufferedDataTable[getNrOutPorts()];
		        <xsl:for-each select="outPort">
		        containers[<xsl:value-of select="position() -1"/>].close();
		       	returnBufferedDataTable[ <xsl:value-of select="position() -1"/> ] = containers[<xsl:value-of select="position() -1"/>].getTable() ;
		        </xsl:for-each>
		    	return returnBufferedDataTable;
		    	}
		catch(Exception err)
			{
			getLogger().error("Boum", err);
			err.printStackTrace();
			throw err;
			}
		finally
			{
			
			}
		}
	</xsl:otherwise>
	</xsl:choose>
	}
</xsl:document>
</xsl:when>
<xsl:otherwise>
<xsl:message terminate="no">No <xsl:apply-templates select="." mode="name"/>Model.java will be generated.</xsl:message>
</xsl:otherwise>

</xsl:choose>


</xsl:template>


<xsl:template match="plugin" mode="package">
<xsl:choose>
	<xsl:when test="@package"><xsl:value-of select="normalize-space(@package)"/></xsl:when>
	<xsl:otherwise><xsl:text>generated</xsl:text></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="plugin" mode="name">
<xsl:choose>
	<xsl:when test="@name"><xsl:value-of select="normalize-space(@name)"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="generate-id()"/></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="plugin" mode="label">
<xsl:choose>
	<xsl:when test="@label"><xsl:value-of select="normalize-space(@label)"/></xsl:when>
	<xsl:otherwise><xsl:apply-templates select="." mode="name"/></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="plugin" mode="description">
<xsl:choose>
	<xsl:when test="@description"><xsl:value-of select="normalize-space(@description)"/></xsl:when>
	<xsl:when test="description"><xsl:apply-templates select="." mode="description"/></xsl:when>
	<xsl:otherwise><xsl:apply-templates select="." mode="label"/></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="plugin" mode="version">
<xsl:choose>
	<xsl:when test="@version"><xsl:value-of select="@version"/></xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="date:year()"/>
		<xsl:text>.</xsl:text>
		<xsl:if test="number(date:month-in-year())&lt;10">0</xsl:if>
		<xsl:value-of select="date:month-in-year()"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="date:day-in-month()"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>



<xsl:template match="plugin" mode="out.dir">
<xsl:variable name="package"><xsl:apply-templates select="." mode="package"/></xsl:variable>
<xsl:value-of select="concat(translate($package,'.','/'),'/')"/>
</xsl:template>

<!-- ========================================================================================= -->
<!-- ========================================================================================= -->
<!-- ========================================================================================= -->


<xsl:template match="category">
<xsl:apply-templates select=".//node"/>
</xsl:template>


<xsl:template match="category" mode="plugin.xml">
	
  	<category>
  		<xsl:attribute name="level-id"><xsl:value-of select="@name"/></xsl:attribute>
  		<xsl:attribute name="name"><xsl:apply-templates select="." mode="label"/></xsl:attribute>
  		<xsl:attribute name="path"><xsl:apply-templates select="." mode="path"/></xsl:attribute>
  		<xsl:attribute name="description"><xsl:apply-templates select="." mode="description"/></xsl:attribute>
  	</category>
  	<!-- apply child node in that category -->
  	<xsl:apply-templates select="category" mode="plugin.xml"/>
  	
</xsl:template>

<xsl:template match="category" mode="description">
<xsl:choose>
	<xsl:when test="@description"><xsl:value-of select="@description"/></xsl:when>
	<xsl:when test="description"><xsl:value-of select="description"/></xsl:when>
	<xsl:otherwise><xsl:apply-templates select="." mode="label"/></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="category" mode="label">
<xsl:choose>
	<xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
	<xsl:otherwise>
		<xsl:call-template name="titleize">
			<xsl:with-param name="s">
				<xsl:value-of select="@name"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="category" mode="path">
<xsl:choose>
	<xsl:when test="name(..)='plugin'">
		<xsl:text>/community/</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates select=".." mode="path"/>
		<xsl:value-of select="../@name"/>
		<xsl:text>/</xsl:text>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="category" mode="package">
<xsl:choose>
	<xsl:when test="@package"><xsl:value-of select="@package"/></xsl:when>
	<xsl:otherwise>
		<xsl:if test="name(..)='category'">
			<xsl:apply-templates select=".." mode="package"/>
			<xsl:text>.</xsl:text>
		</xsl:if>
		<xsl:apply-templates select=".." mode="package"/>
		<xsl:text>.</xsl:text>
		<xsl:call-template name="tolowercase">
			<xsl:with-param name="s"><xsl:value-of select="@name"/></xsl:with-param>
		</xsl:call-template>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>



<!-- ========================================================================================= -->
<!-- ========================================================================================= -->
<!-- ========================================================================================= -->


<xsl:template match="node" mode="package">
<xsl:choose>
	<xsl:when test="@package"><xsl:value-of select="@package"/></xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates select="/plugin" mode="package"/>
		<xsl:text>.</xsl:text>
		<xsl:for-each select="ancestor::category">
				<xsl:call-template name="tolowercase">
					<xsl:with-param name="s"><xsl:value-of select="@name"/></xsl:with-param>
				</xsl:call-template>
				<xsl:text>.</xsl:text>
		</xsl:for-each>
		<xsl:call-template name="tolowercase">
			<xsl:with-param name="s"><xsl:apply-templates select="." mode="name"/></xsl:with-param>
		</xsl:call-template>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="node" mode="name">
<xsl:call-template name="titleize">
	<xsl:with-param name="s">
		<xsl:choose>
			<xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
		</xsl:choose>
	</xsl:with-param>
</xsl:call-template>
</xsl:template>

<xsl:template match="node" mode="label">
<xsl:choose>
	<xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
	<xsl:when test="label"><xsl:value-of select="label"/></xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates select="." mode="name"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="node" mode="short.desc">
<xsl:choose>
	<xsl:when test="@short-desc"><xsl:value-of select="@short-desc"/></xsl:when>
	<xsl:when test="short-desc"><xsl:value-of select="short-desc"/></xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates select="." mode="label"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="node" mode="description">
<xsl:choose>
	<xsl:when test="@description"><xsl:value-of select="@description"/></xsl:when>
	<xsl:when test="description"><xsl:value-of select="description"/></xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates select="." mode="short.desc"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="node" mode="out.dir">
<xsl:variable name="package"><xsl:apply-templates select="." mode="package"/></xsl:variable>
<xsl:value-of select="concat('/',translate($package,'.','/'),'/')"/>
</xsl:template>

<!-- ========================================================================================= -->
<!-- ========================================================================================= -->
<!-- ========================================================================================= -->




<xsl:template match="property">

	/** <xsl:apply-templates select="." mode="label"/> *************************************************************/

<xsl:choose>

<xsl:when test="@type='bool'">
	final static String <xsl:apply-templates select="." mode="config.name"/> = "<xsl:apply-templates select="." mode="config.name"/>";
	final static boolean <xsl:apply-templates select="." mode="default.name"/> = <xsl:choose>
			<xsl:when test="@default"><xsl:value-of select="@default"/></xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>;

	private org.knime.core.node.defaultnodesettings.SettingsModelBoolean <xsl:apply-templates select="." mode="variable.name"/> = 
		new  org.knime.core.node.defaultnodesettings.SettingsModelBoolean(
			<xsl:apply-templates select="." mode="config.name"/>,
			<xsl:apply-templates select="." mode="default.name"/>
			);
		
	
	protected org.knime.core.node.defaultnodesettings.SettingsModelBoolean <xsl:apply-templates select="." mode="getter"/>()
		{
		return this.<xsl:apply-templates select="." mode="variable.name"/>;
		}
	
	protected boolean <xsl:apply-templates select="." mode="getter.value"/>()
		{
		return <xsl:apply-templates select="." mode="getter"/>().getBooleanValue();
		}

	
</xsl:when>


<xsl:when test="@type='int'">
	final static String <xsl:apply-templates select="." mode="config.name"/> = "<xsl:apply-templates select="." mode="config.name"/>";
	final static int <xsl:apply-templates select="." mode="default.name"/> = <xsl:choose>
			<xsl:when test="@default"><xsl:value-of select="@default"/></xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>;

	private org.knime.core.node.defaultnodesettings.SettingsModelInteger <xsl:apply-templates select="." mode="variable.name"/> = 
		new  org.knime.core.node.defaultnodesettings.SettingsModelInteger(
			<xsl:apply-templates select="." mode="config.name"/>,
			<xsl:apply-templates select="." mode="default.name"/>
			);

	protected org.knime.core.node.defaultnodesettings.SettingsModelInteger <xsl:apply-templates select="." mode="getter"/>()
		{
		return this.<xsl:apply-templates select="." mode="variable.name"/>;
		}
	
	protected int <xsl:apply-templates select="." mode="getter.value"/>()
		{
		return <xsl:apply-templates select="." mode="getter"/>().getIntValue();
		}

	
</xsl:when>


<xsl:when test="@type='long'">
	final static String <xsl:apply-templates select="." mode="config.name"/> = "<xsl:apply-templates select="." mode="config.name"/>";
	final static long <xsl:apply-templates select="." mode="default.name"/> = <xsl:choose>
			<xsl:when test="@default"><xsl:value-of select="@default"/></xsl:when>
			<xsl:otherwise>0L</xsl:otherwise>
		</xsl:choose>;

	private org.knime.core.node.defaultnodesettings.SettingsModelLong <xsl:apply-templates select="." mode="variable.name"/> = 
		new  org.knime.core.node.defaultnodesettings.SettingsModelLong(
			<xsl:apply-templates select="." mode="config.name"/>,
			<xsl:apply-templates select="." mode="default.name"/>
			);
	
	protected org.knime.core.node.defaultnodesettings.SettingsModelLong <xsl:apply-templates select="." mode="getter"/>()
		{
		return this.<xsl:apply-templates select="." mode="variable.name"/>;
		}
	
	protected long <xsl:apply-templates select="." mode="getter.value"/>()
		{
		return <xsl:apply-templates select="." mode="getter"/>().getLongValue();
		}

	
</xsl:when>

<xsl:when test="@type='double'">
	final static String <xsl:apply-templates select="." mode="config.name"/> = "<xsl:apply-templates select="." mode="config.name"/>";
	final static double <xsl:apply-templates select="." mode="default.name"/> = <xsl:choose>
			<xsl:when test="@default"><xsl:value-of select="@default"/></xsl:when>
			<xsl:otherwise>0.0</xsl:otherwise>
		</xsl:choose>;

	
	private org.knime.core.node.defaultnodesettings.SettingsModelDouble <xsl:apply-templates select="." mode="variable.name"/> = 
		new  org.knime.core.node.defaultnodesettings.SettingsModelDouble(
			<xsl:apply-templates select="." mode="config.name"/>,
			<xsl:apply-templates select="." mode="default.name"/>
			);

	protected org.knime.core.node.defaultnodesettings.SettingsModelDouble <xsl:apply-templates select="." mode="getter"/>()
		{
		return this.<xsl:apply-templates select="." mode="variable.name"/>;
		}
	
	protected double <xsl:apply-templates select="." mode="getter.value"/>()
		{
		return <xsl:apply-templates select="." mode="getter"/>().getDoubleValue();
		}


</xsl:when>


<xsl:when test="@type='column'">
<xsl:variable name="titlename">
<xsl:call-template name="titleize">
	<xsl:with-param name="s" select="@name"/>
</xsl:call-template>
</xsl:variable>
	final static String <xsl:apply-templates select="." mode="config.name"/> = "<xsl:apply-templates select="." mode="config.name"/>";
	final static String <xsl:apply-templates select="." mode="default.name"/> = <xsl:choose>
			<xsl:when test="@default">"<xsl:value-of select="@default"/>"</xsl:when>
			<xsl:otherwise>"COLUMN"</xsl:otherwise>
		</xsl:choose>;

	
	private org.knime.core.node.defaultnodesettings.SettingsModelColumnName <xsl:apply-templates select="." mode="variable.name"/> = 
		new  org.knime.core.node.defaultnodesettings.SettingsModelColumnName(
			<xsl:apply-templates select="." mode="config.name"/>,
			<xsl:apply-templates select="." mode="default.name"/>
			);

	protected org.knime.core.node.defaultnodesettings.SettingsModelColumnName <xsl:apply-templates select="." mode="getter"/>()
		{
		return this.<xsl:apply-templates select="." mode="variable.name"/>;
		}
	
	protected String <xsl:apply-templates select="." mode="getter.value"/>()
		{
		return <xsl:apply-templates select="." mode="getter"/>().getStringValue();
		}

	protected int find<xsl:value-of select="$titlename"/>ColumnIndex(final  DataTableSpec inSpec)
		{
		int index= inSpec.findColumnIndex(<xsl:apply-templates select="." mode="getter.value"/>());
		
		return index;
		}
	
	protected int find<xsl:value-of select="$titlename"/>RequiredColumnIndex(final  DataTableSpec inSpec)
		throws InvalidSettingsException
		{
		int index =  find<xsl:value-of select="$titlename"/>ColumnIndex(inSpec);
		if(index == -1 )
			{
			throw new InvalidSettingsException("Node "+this.getClass().getName()+": cannot find column title= \"<xsl:apply-templates select="." mode="label"/>\"");
			}

		return index;
		}
	
</xsl:when>

<xsl:when test="@type='file-read' or @type='file-save'">
<xsl:variable name="titlename">
<xsl:call-template name="titleize">
	<xsl:with-param name="s" select="@name"/>
</xsl:call-template>
</xsl:variable>
	final static String <xsl:apply-templates select="." mode="config.name"/> = "<xsl:apply-templates select="." mode="config.name"/>";
	final static String <xsl:apply-templates select="." mode="default.name"/> = <xsl:choose>
			<xsl:when test="@default">"<xsl:value-of select="@default"/>"</xsl:when>
			<xsl:otherwise>""</xsl:otherwise>
		</xsl:choose>;

	protected org.knime.core.node.defaultnodesettings.SettingsModelString <xsl:apply-templates select="." mode="variable.name"/> = 
		new  org.knime.core.node.defaultnodesettings.SettingsModelString(
			<xsl:apply-templates select="." mode="config.name"/>,
			<xsl:apply-templates select="." mode="default.name"/>
			);


	protected org.knime.core.node.defaultnodesettings.SettingsModelString <xsl:apply-templates select="." mode="getter"/>()
		{
		return this.<xsl:apply-templates select="." mode="variable.name"/>;
		}
	
	protected String <xsl:apply-templates select="." mode="getter.value"/>()
		{
		return <xsl:apply-templates select="." mode="getter"/>().getStringValue();
		}

	<xsl:choose>
		<xsl:when test="@type='file-read'">
		
		protected java.io.BufferedReader open<xsl:value-of select="$titlename"/>ForBufferedReader() throws java.io.IOException
			{
			return this.openUriForBufferedReader(<xsl:apply-templates select="." mode="getter.value"/>());
			}
		
		</xsl:when>
		<xsl:when test="@type='file-save'">

		protected java.io.OutputStream open<xsl:value-of select="$titlename"/>ForWriting() throws java.io.IOException
			{
			String uri = <xsl:apply-templates select="." mode="getter.value"/>();
			java.io.File file= new java.io.File(uri);
			return this.openFileForWriting(file);
			}

		
		protected java.io.PrintWriter open<xsl:value-of select="$titlename"/>ForPrinting() throws java.io.IOException
			{
			String uri = <xsl:apply-templates select="." mode="getter.value"/>();
			java.io.File file= new java.io.File(uri);
			if(file.getName().endsWith(".gz"))
				{
				return new java.io.PrintWriter(this.open<xsl:value-of select="$titlename"/>ForWriting()); 
				}
			else
				{
				return new java.io.PrintWriter(file); 
				}
			}
		
		</xsl:when>		
	</xsl:choose>

</xsl:when>



<!-- string -->
<xsl:when test='not(@type) or @type="string"'>
	final static String <xsl:apply-templates select="." mode="config.name"/> = "<xsl:apply-templates select="." mode="config.name"/>";
	
	<xsl:choose>
	<xsl:when test="enum">
	final static String <xsl:apply-templates select="." mode="enum.name"/>[] = new String[]{
		<xsl:for-each select="enum"><xsl:if test="position()&gt;1">,</xsl:if>
		"<xsl:value-of select="text()"/>"</xsl:for-each>
		};
	
	final static String <xsl:apply-templates select="." mode="default.name"/> = <xsl:apply-templates select="." mode="enum.name"/>[<xsl:choose>
			<xsl:when test="@default">
				<xsl:for-each select="enum"><xsl:if test="text() =../@default"><xsl:value-of select="position() - 1"/></xsl:if></xsl:for-each>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>];
	
	
	</xsl:when>
	<xsl:otherwise>
	final static String <xsl:apply-templates select="." mode="default.name"/> = <xsl:choose>
			<xsl:when test="@default">"<xsl:value-of select="@default"/>"</xsl:when>
			<xsl:otherwise>""</xsl:otherwise>
		</xsl:choose>;
	</xsl:otherwise>
	</xsl:choose>


	protected org.knime.core.node.defaultnodesettings.SettingsModelString <xsl:apply-templates select="." mode="variable.name"/> = 
		new  org.knime.core.node.defaultnodesettings.SettingsModelString(
			<xsl:apply-templates select="." mode="config.name"/>,
			<xsl:apply-templates select="." mode="default.name"/>
			);


	protected org.knime.core.node.defaultnodesettings.SettingsModelString <xsl:apply-templates select="." mode="getter"/>()
		{
		return this.<xsl:apply-templates select="." mode="variable.name"/>;
		}
	
	protected String <xsl:apply-templates select="." mode="getter.value"/>()
		{
		return <xsl:apply-templates select="." mode="getter"/>().getStringValue();
		}
	

</xsl:when>


<xsl:when test='@type="strings"'>
	final static String <xsl:apply-templates select="." mode="config.name"/> = "<xsl:apply-templates select="." mode="config.name"/>";
	
	final static String <xsl:apply-templates select="." mode="enum.name"/>[] = <xsl:choose>
	 <xsl:when test="code">
	 	<xsl:apply-templates select="code"/>
	 </xsl:when>
	 <xsl:otherwise>  new String[]{
		<xsl:for-each select="enum"><xsl:if test="position()&gt;1">,</xsl:if>
		"<xsl:value-of select="text()"/>"</xsl:for-each>
		};
	</xsl:otherwise>
	</xsl:choose>
	
	final static String[] <xsl:apply-templates select="." mode="default.name"/> = <xsl:apply-templates select="." mode="enum.name"/>;
	
	protected org.knime.core.node.defaultnodesettings.SettingsModelStringArray <xsl:apply-templates select="." mode="variable.name"/> = 
		new  org.knime.core.node.defaultnodesettings.SettingsModelStringArray(
			<xsl:apply-templates select="." mode="config.name"/>,
			<xsl:apply-templates select="." mode="default.name"/>
			);


	protected org.knime.core.node.defaultnodesettings.SettingsModelStringArray <xsl:apply-templates select="." mode="getter"/>()
		{
		return this.<xsl:apply-templates select="." mode="variable.name"/>;
		}
	
	protected String[] <xsl:apply-templates select="." mode="getter.value"/>()
		{
		return <xsl:apply-templates select="." mode="getter"/>().getStringArrayValue();
		}
	

</xsl:when>



<xsl:otherwise>
  <xsl:message terminate="yes">
  Model header : Undefined type "<xsl:value-of select="@type"/>"
  </xsl:message>
</xsl:otherwise>

</xsl:choose>
</xsl:template>


<xsl:template match="property" mode="dialog">
<xsl:choose>

<xsl:when test="@type='bool'">
		this.addDialogComponent(new org.knime.core.node.defaultnodesettings.DialogComponentBoolean(
					new org.knime.core.node.defaultnodesettings.SettingsModelBoolean(
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="config.name"/>,
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="default.name"/>
						),
					"<xsl:apply-templates select="." mode="label"/>"
					));
</xsl:when>

<xsl:when test="@type='int'">
		this.addDialogComponent(new org.knime.core.node.defaultnodesettings.DialogComponentNumber(
					new org.knime.core.node.defaultnodesettings.SettingsModelInteger(
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="config.name"/>,
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="default.name"/>
						),
					"<xsl:apply-templates select="." mode="label"/>",1,10
					));
</xsl:when>

<xsl:when test="@type='long'">
		this.addDialogComponent(new org.knime.core.node.defaultnodesettings.DialogComponentNumber(
					new org.knime.core.node.defaultnodesettings.SettingsModelLong(
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="config.name"/>,
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="default.name"/>
						),
					"<xsl:apply-templates select="." mode="label"/>",1,10
					));
</xsl:when>

<xsl:when test="@type='double'">
		this.addDialogComponent(new org.knime.core.node.defaultnodesettings.DialogComponentNumber(
					new org.knime.core.node.defaultnodesettings.SettingsModelDouble(
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="config.name"/>,
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="default.name"/>
						),
					"<xsl:apply-templates select="." mode="label"/>",1,10
					));
</xsl:when>

<xsl:when test="@type='column'">
<!-- get the name of the por for this column : default @port then, uniq port if there is one -->
<xsl:variable name="port">
<xsl:apply-templates select="." mode="port-name"/>
</xsl:variable>


		this.addDialogComponent(new org.knime.core.node.defaultnodesettings.DialogComponentColumnNameSelection(
					new org.knime.core.node.defaultnodesettings.SettingsModelColumnName(
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="config.name"/>,
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="default.name"/>
						),
					"<xsl:apply-templates select="." mode="label"/>",
					<xsl:for-each select="../inPort">
						<xsl:if test="@name = $port"><xsl:value-of select="position() - 1"/> /* inSpsec '<xsl:value-of select="@name"/>' */</xsl:if>
					</xsl:for-each>,
					<xsl:choose>
						<xsl:when test="@required='false'">false</xsl:when>
						<xsl:otherwise>true</xsl:otherwise>
					</xsl:choose>, /* isRequired */
					<xsl:choose>
						<xsl:when test="@none='true'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose> /* addNoneCol "if a none option should be added to the column list" */
					<xsl:choose>
					<xsl:when test="count(type)&gt;0">
						<xsl:for-each select="type">
							<xsl:if test="position()&gt;1">,</xsl:if>
							<xsl:choose>
								<xsl:when test="text()='int'">org.knime.core.data.IntValue.class</xsl:when>
								<xsl:when test="text()='string'">org.knime.core.data.StringValue.class</xsl:when>
								<xsl:when test="text()='double'">org.knime.core.data.DoubleValue.class</xsl:when>
								<xsl:otherwise><xsl:message terminate="yes">Not implemented</xsl:message></xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="@data-type">
							<xsl:text>,</xsl:text>
							<xsl:choose>
								<xsl:when test="@data-type='int'">org.knime.core.data.IntValue.class</xsl:when>
								<xsl:when test="@data-type='string'">org.knime.core.data.StringValue.class</xsl:when>
								<xsl:when test="@data-type='double'">org.knime.core.data.DoubleValue.class</xsl:when>
								<xsl:otherwise><xsl:message terminate="yes">Not implemented</xsl:message></xsl:otherwise>
							</xsl:choose>
					</xsl:when>
					<xsl:when test="filter">,
					new  org.knime.core.node.util.ColumnFilter() {
						@Override
						public boolean includeColumn(org.knime.core.data.DataColumnSpec dcs) {
							return true;
						}
						
						@Override
						public String allFilteredMsg() {
							return "Cannot find any valid column for <xsl:apply-templates select="." mode="label"/>";
						}
					}
					</xsl:when>
					<xsl:otherwise><xsl:message terminate="yes">you must specify DialogComponentColumnNameSelection</xsl:message></xsl:otherwise>
					</xsl:choose>
					));
</xsl:when>

<xsl:when test="@type='file-read'">
<xsl:variable name="port" select="@port"/>
<xsl:variable name="chooser" select="concat('chooser_read_',generate-id())"/>
		
		org.knime.core.node.defaultnodesettings.DialogComponentFileChooser <xsl:value-of select="$chooser"/> = new org.knime.core.node.defaultnodesettings.DialogComponentFileChooser(
					new org.knime.core.node.defaultnodesettings.SettingsModelString(
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="config.name"/>,
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="default.name"/>
						),
					"<xsl:value-of select="generate-id(.)"/>",/* historyID */
					javax.swing.JFileChooser.OPEN_DIALOG
					<xsl:for-each select="extension">,"<xsl:value-of select="."/>"</xsl:for-each>
					);
		<xsl:value-of select="$chooser"/>.setAllowRemoteURLs(true);
		<xsl:value-of select="$chooser"/>.setBorderTitle("<xsl:apply-templates select="." mode="label"/>");
		<xsl:value-of select="$chooser"/>.setToolTipText("<xsl:apply-templates select="." mode="description"/>");
		this.addDialogComponent(<xsl:value-of select="$chooser"/> );
</xsl:when>

<xsl:when test="@type='file-save'">
<xsl:variable name="port" select="@port"/>
		this.addDialogComponent(new org.knime.core.node.defaultnodesettings.DialogComponentFileChooser(
					new org.knime.core.node.defaultnodesettings.SettingsModelString(
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="config.name"/>,
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="default.name"/>
						),
					"<xsl:value-of select="generate-id(.)"/>",/* historyID */
					javax.swing.JFileChooser.SAVE_DIALOG
					));
</xsl:when>

<xsl:when test="not(@type) or @type='string'">

		this.addDialogComponent(new org.knime.core.node.defaultnodesettings.DialogComponentMultiLineString(
					new org.knime.core.node.defaultnodesettings.SettingsModelString(
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="config.name"/>,
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="default.name"/>
						),
					"<xsl:apply-templates select="." mode="label"/>",false,80,25
					));
</xsl:when>

<xsl:when test="@type='strings'">
<xsl:variable name="setting" select="concat('_',generate-id())"/>
	org.knime.core.node.defaultnodesettings.SettingsModelStringArray <xsl:value-of select="$setting"/> = new org.knime.core.node.defaultnodesettings.SettingsModelStringArray(
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="config.name"/>,
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="default.name"/>
						);
	
		this.addDialogComponent(new org.knime.core.node.defaultnodesettings.DialogComponentStringListSelection(
					<xsl:value-of select="$setting"/>,
					"<xsl:apply-templates select="." mode="label"/>",
					java.util.Arrays.asList(<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="enum.name"/>),
					<xsl:choose>
						<xsl:when test="@required='false'">false</xsl:when>
						<xsl:otherwise>true</xsl:otherwise>
					</xsl:choose>, /* isRequired */
					<xsl:choose>
						<xsl:when test="@visible"><xsl:value-of select="@visible"/></xsl:when>
						<xsl:otherwise>10</xsl:otherwise>
					</xsl:choose> /* visibleRowCount */
					));
</xsl:when>




<xsl:otherwise>
	<xsl:message terminate="yes">Error Dialog: undefined type: <xsl:value-of select="@type"/></xsl:message>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="property" mode="port-name">
<xsl:choose>
 <xsl:when test="@port"><xsl:value-of select="@port"/></xsl:when>
 <xsl:when test="count(../inPort)=1"><xsl:value-of select="../inPort/@name"/></xsl:when>
 <xsl:otherwise><xsl:message terminate="yes">Boum property/port-name</xsl:message></xsl:otherwise>
</xsl:choose>
</xsl:template>




<xsl:template match="property" mode="getter">
<xsl:text>getProperty</xsl:text>
<xsl:call-template name="titleize">
 <xsl:with-param name="s" select="@name"/>
</xsl:call-template>
<xsl:text>Settings</xsl:text>
</xsl:template>

<xsl:template match="property" mode="getter.value">
<xsl:choose>
	<xsl:when test="@type='bool'">
		<xsl:text>isProperty</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>getProperty</xsl:text>
	</xsl:otherwise>
</xsl:choose>
<xsl:call-template name="titleize">
 <xsl:with-param name="s" select="@name"/>
</xsl:call-template>
<xsl:text>Value</xsl:text>
</xsl:template>


<xsl:template match="property" mode="variable.name">
<xsl:value-of select="concat('m_',generate-id(.))"/>
</xsl:template>

<xsl:template match="property" mode="config.name">
<xsl:text>CONFIG_</xsl:text>
<xsl:call-template name="touppercase">
 <xsl:with-param name="s" select="@name"/>
</xsl:call-template>
</xsl:template>


<xsl:template match="property" mode="enum.name">
<xsl:apply-templates select="." mode="config.name"/>
<xsl:text>_ENUM</xsl:text>
</xsl:template>


<xsl:template match="property" mode="label">
	<xsl:choose>
		<xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
		<xsl:when test="label"><xsl:value-of select="label"/></xsl:when>
		<xsl:otherwise>
			<xsl:message terminate="no"> No label for &lt;<xsl:value-of select="name(.)"/>/<xsl:value-of select="@name"/>&gt;, using @name</xsl:message>
			<xsl:value-of select="@name"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="property" mode="description">
	<xsl:choose>
		<xsl:when test="@description"><xsl:value-of select="@description"/></xsl:when>
		<xsl:when test="description"><xsl:value-of select="description"/></xsl:when>
		<xsl:otherwise>
			<xsl:message terminate="no"> No property for &lt;<xsl:value-of select="name(.)"/>/<xsl:value-of select="@name"/>&gt;, using label</xsl:message>
			<xsl:apply-templates select="." mode="label"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>



<xsl:template match="property" mode="default.name">
<xsl:text>DEFAULT_</xsl:text>
<xsl:call-template name="touppercase">
 <xsl:with-param name="s" select="@name"/>
</xsl:call-template>
</xsl:template>


<xsl:template match="property" mode="nodeFactory.xml">
<option>
   <xsl:attribute name="name"><xsl:apply-templates select="." mode="label"/></xsl:attribute>
   <xsl:apply-templates select="." mode="description"/>
   <xsl:text>:</xsl:text>
   <xsl:choose>
   	<xsl:when test="@type='file-read'"><xsl:text> A file Reader.</xsl:text></xsl:when>
   	<xsl:otherwise>Node type: <xsl:value-of select="@type"/>.</xsl:otherwise>
   </xsl:choose>
   <xsl:if test="extension">
   		<xsl:text> The valid file extensions are: </xsl:text>
   		<xsl:for-each select="extension">
   			<xsl:if test="position()&gt;1">,</xsl:if>
   			<xsl:text>"</xsl:text>
   			<xsl:value-of select="text()"/>
   			<xsl:text>"</xsl:text>
   		</xsl:for-each>
   		<xsl:text>.</xsl:text>
   </xsl:if>
</option>
</xsl:template>

<!-- ========================================================================================= -->
<!-- ========================================================================================= -->
<!-- ========================================================================================= -->
<xsl:template match="inPort" mode="nodeFactory.xml">
<inPort>
	<xsl:attribute name="index"><xsl:value-of select="count(ancestor::inPort)"/></xsl:attribute>
	<xsl:attribute name="name"><xsl:apply-templates select="." mode="label"/></xsl:attribute>
	<xsl:apply-templates select="." mode="description"/>
	<xsl:if test="column">
		<xsl:text>Columns: </xsl:text>
		<xsl:apply-templates select="column" mode="nodeFactory.xml"/>
	</xsl:if>
</inPort>
</xsl:template>

<xsl:template match="outPort" mode="nodeFactory.xml">
<outPort>
	<xsl:attribute name="index"><xsl:value-of select="count(ancestor::outPort)"/></xsl:attribute>
	<xsl:attribute name="name"><xsl:apply-templates select="." mode="label"/></xsl:attribute>
	<xsl:apply-templates select="." mode="description"/>
	<xsl:if test="column">
		<xsl:text>Columns: </xsl:text>
		<xsl:apply-templates select="column" mode="nodeFactory.xml"/>
	</xsl:if>
</outPort>
</xsl:template>

<xsl:template match="inPort|outPort" mode="label">
<xsl:choose>
	<xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
	<xsl:when test="label"><xsl:value-of select="label"/></xsl:when>
	<xsl:otherwise>
		<xsl:message terminate="no"> No label for &lt;<xsl:value-of select="name(.)"/>/<xsl:value-of select="@name"/>&gt;, using @name</xsl:message>
		<xsl:value-of select="@name"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="inPort|outPort" mode="description">
<xsl:choose>
	<xsl:when test="@description"><xsl:value-of select="@description"/></xsl:when>
	<xsl:when test="description"><xsl:value-of select="description"/></xsl:when>
	<xsl:otherwise>
		<xsl:message terminate="no"> No description for &lt;<xsl:value-of select="name(.)"/>/<xsl:value-of select="@name"/>&gt;, using label</xsl:message>
		<xsl:apply-templates select="." mode="label"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ========================================================================================= -->
<!-- ========================================================================================= -->
<!-- ========================================================================================= -->

<xsl:template match="column" mode="nodeFactory.xml">
		<xsl:if test="count(preceding-sibling::column)&gt;0">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:text>"</xsl:text>
		<xsl:apply-templates select="." mode="label"/>
		<xsl:text>" [type:</xsl:text>
		<xsl:choose>
			<xsl:when test="not(@type)">String</xsl:when>
			<xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
		</xsl:choose>
		<xsl:text>]</xsl:text>
</xsl:template>


<xsl:template match="column" mode="label">
<xsl:choose>
	<xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
	<xsl:when test="label"><xsl:value-of select="label"/></xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="@name"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="column" mode="create.data.column.spec">
	<xsl:text>new org.knime.core.data.DataColumnSpecCreator("</xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text>",org.knime.core.data.DataType.getType(</xsl:text>
<xsl:choose>
	<xsl:when test="not(@type) or @type='string'">
		<xsl:text>org.knime.core.data.def.StringCell</xsl:text>
	</xsl:when>
	<xsl:when test="@type='int'">
		<xsl:text>org.knime.core.data.def.IntCell</xsl:text>
	</xsl:when>
	<xsl:when test="@type='double'">
		<xsl:text>org.knime.core.data.def.DoubleCell</xsl:text>
	</xsl:when>
	<xsl:when test="@type='bool'">
		<xsl:text>org.knime.core.data.def.BooleanCell</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:message terminate="yes">
			unknown type
		</xsl:message>	
	</xsl:otherwise>
</xsl:choose>
<xsl:text>.class)).createSpec()</xsl:text>

</xsl:template>

<!-- ========================================================================================= -->
<!-- ========================================================================================= -->
<!-- ========================================================================================= -->

<xsl:template match="body">
<xsl:apply-templates select="*|text()"/>
</xsl:template>

<xsl:template match="description" mode="html">
<xsl:apply-templates select="*" mode="html"/>
</xsl:template>


<xsl:template match="a|b|i|p|ul|ol|li|a|tt|h3|h4|h|pre|sub|br|table|th|td|tr|@*|text()" mode="html">
  <xsl:copy>
    <xsl:apply-templates select="@*" mode="html"/>
    <xsl:apply-templates select="*|text()" mode="html"/>
  </xsl:copy>
</xsl:template>



</xsl:stylesheet>
