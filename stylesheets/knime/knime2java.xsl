<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        xmlns:date="http://exslt.org/dates-and-times" 
		version='1.0'
        >
<xsl:import href="../util/util.xsl"/>
<xsl:output method="text"/>
<xsl:param name="base.dir">TMP</xsl:param>

<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Params:
   * anonymous
   * title
Usage :
   xsltproc  model2java01.xslt model.xml > fixme.java
   javac fixme.java
   java fixme
   
-->
<xsl:template match="/">
<xsl:apply-templates select="plugin"/>
</xsl:template>


<xsl:template match="plugin">

<xsl:variable name="outdir"><xsl:value-of select="concat($base.dir,'/')"/><xsl:apply-templates select="." mode="out.dir"/></xsl:variable>

<xsl:apply-templates select="category"/>


<xsl:document href="{$outdir}/AbstractNodeModel.java" method="text">/**
<xsl:value-of select="$apache2.license"/>
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

/**
 * date: <xsl:value-of select="date:date-time()"/>
 */

@javax.annotation.Generated("xslt-sandbox/knime2java")
public abstract class AbstractNodeModel
	extends org.knime.core.node.NodeModel
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
	
	@Override
	protected void loadValidatedSettingsFrom(NodeSettingsRO settings)
			throws InvalidSettingsException
		{
		getLogger().info("loadValidatedSettingsFrom "+getClass().getName());
		for(SettingsModel param:getSettingsModel())
    		param.loadSettingsFrom(settings);
		}
	
	@Override
	protected void reset()
		{
		getLogger().info("reset "+getClass().getName());
		}
	@Override
	protected void saveInternals(File dir, ExecutionMonitor executionMonitor)
			throws IOException, CanceledExecutionException
		{
		getLogger().info("saveInternals "+getClass().getName()+" to "+dir);
		/* save node uniq id */
		FileWriter w=new FileWriter(new File(dir,UNIQ_ID_FILE));
		w.write(getNodeUniqId());;
		w.flush();
		w.close();
		}
	
	/* Adds to the given NodeSettings the model specific settings. The settings don't need to be complete or consistent.
		If, right after startup, no valid settings are available this method can write either nothing or invalid settings.
		*/
	@Override
	protected void saveSettingsTo(NodeSettingsWO settings) {
		getLogger().info("saveSettingsTo "+getClass().getName());
		for(SettingsModel sm:getSettingsModel())
			sm.saveSettingsTo(settings);
		}
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

	}

</xsl:document>

<xsl:document href="{$base.dir}/plugin.xml" method="xml" indent="yes">
<xsl:processing-instruction name="eclipse"> version="3.0" </xsl:processing-instruction >
<plugin>
  <extension point="org.knime.workbench.repository.categories">
  	<xsl:apply-templates select="category" mode="plugin.xml"/> 
  </extension>
  <extension point="org.knime.workbench.repository.nodes">
  	<xsl:apply-templates select="category/node" mode="plugin.xml"/> 
  </extension>
</plugin>
</xsl:document>

</xsl:template>


<xsl:template match="node" mode="plugin.xml">
<node  category-path="/community/knime4bio/linux">
    <xsl:attribute name="factory-class"><xsl:apply-templates select="." mode="package"/><xsl:text>.</xsl:text><xsl:apply-templates select="." mode="name"/>NodeFactory</xsl:attribute>
    <xsl:attribute name="id"><xsl:apply-templates select="." mode="package"/><xsl:text>.</xsl:text><xsl:apply-templates select="." mode="name"/>NodeFactory</xsl:attribute>   
</node>
</xsl:template>


<xsl:template match="node">
<xsl:variable name="outdir"><xsl:value-of select="concat($base.dir,'/')"/><xsl:apply-templates select="." mode="out.dir"/></xsl:variable>
<xsl:variable name="node.name"><xsl:apply-templates select="." mode="name"/></xsl:variable>

<xsl:message terminate="no">node name <xsl:value-of select="$node.name"/></xsl:message>
<xsl:message terminate="no">outdir <xsl:value-of select="$outdir"/></xsl:message>

<xsl:document href="{$outdir}/{$node.name}NodeFactory.xml" method="xml">
<knimeNode icon="default.png" type="Source">
    <name><xsl:apply-templates select="." mode="label"/></name>
    <shortDescription><xsl:apply-templates select="."  mode="short.desc"/></shortDescription>    
    <fullDescription>
        <intro>
       		<xsl:apply-templates select="." mode="todo"/>
       		
       		Date: <xsl:value-of select="date:date-time()"/>
		</intro>
        <xsl:for-each select="property">
        	<option>
        		   <xsl:attribute name="name"><xsl:apply-templates select="." mode="label"/></xsl:attribute>
        		   <xsl:apply-templates select="." mode="short.desc"/>
        	</option>
        </xsl:for-each>
    </fullDescription>
    
    <ports>
    	<xsl:for-each select="inPort">
    		<inPort>
    			<xsl:attribute name="index"><xsl:value-of select="position()-1"/></xsl:attribute>
    			<xsl:attribute name="name"><xsl:apply-templates select="." mode="label"/></xsl:attribute>
    			<xsl:apply-templates select="." mode="short.desc"/>
    		</inPort>
    	</xsl:for-each>
    	<xsl:for-each select="outPort">
    		<outPort>
    			<xsl:attribute name="index"><xsl:value-of select="position()-1"/></xsl:attribute>
    			<xsl:attribute name="name"><xsl:apply-templates select="." mode="label"/></xsl:attribute>
    			<xsl:apply-templates select="." mode="short.desc"/>
    		</outPort>
    	</xsl:for-each>
    </ports>
</knimeNode>
</xsl:document >



<xsl:document href="{$outdir}/{$node.name}NodePlugin.java" method="text">/**
<xsl:value-of select="$apache2.license"/>
**/
package <xsl:apply-templates select="." mode="package"/>;

import org.eclipse.core.runtime.Plugin;
import org.osgi.framework.BundleContext;

public class  <xsl:apply-templates select="." mode="name"/>NodePlugin extends Plugin {
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
     * @return Singleton instance of the Plugin
     */
    public static  <xsl:apply-templates select="." mode="name"/>NodePlugin getDefault() {
        return plugin;
    }

}

</xsl:document>


<xsl:document href="{$outdir}/{$node.name}NodeFactory.java" method="text">/**
<xsl:value-of select="$apache2.license"/>
**/
package <xsl:apply-templates select="." mode="package"/>;

import org.knime.core.node.NodeDialogPane;
import org.knime.core.node.NodeFactory;
import org.knime.core.node.NodeView;
import org.knime.core.data.DataTableSpec;

@javax.annotation.Generated("xslt-sandbox/knime2java")
public class <xsl:apply-templates select="." mode="name"/>NodeFactory
        extends NodeFactory&lt;<xsl:apply-templates select="." mode="name"/>NodeModel&gt; {
	
    @Override
    public <xsl:apply-templates select="." mode="name"/>NodeModel createNodeModel() {
        return new <xsl:apply-templates select="." mode="name"/>NodeModel();
    }
	
    @Override
    public int getNrNodeViews() {
        return 0;
    }
	
    @Override
    public NodeView&lt;<xsl:apply-templates select="." mode="name"/>NodeModel&gt; createNodeView(final int viewIndex,
            final <xsl:apply-templates select="." mode="name"/>NodeModel nodeModel) {
        throw new IllegalStateException();
    }
	
    @Override
    public boolean hasDialog() {
        return true;
    }

    @Override
    public NodeDialogPane createNodeDialogPane() {
        return new <xsl:apply-templates select="." mode="name"/>NodeDialog();
    }

}

</xsl:document>


<xsl:document href="{$outdir}/{$node.name}NodeDialog.java" method="text">/**
<xsl:value-of select="$apache2.license"/>
**/
package <xsl:apply-templates select="." mode="package"/>;

import org.knime.core.node.defaultnodesettings.DefaultNodeSettingsPane;

@javax.annotation.Generated("xslt-sandbox/knime2java")
public class <xsl:apply-templates select="." mode="name"/>NodeDialog
	extends DefaultNodeSettingsPane
	{
    public <xsl:apply-templates select="." mode="name"/>NodeDialog()
    	{
    	<xsl:apply-templates select="property" mode="dialog"/>
    	}
	}
</xsl:document>


<xsl:document href="{$outdir}/Abstract{$node.name}NodeModel.java" method="text">/**
<xsl:value-of select="$apache2.license"/>
**/
package <xsl:apply-templates select="." mode="package"/>;

import org.knime.core.node.defaultnodesettings.SettingsModel;
import org.knime.core.data.DataTableSpec;
import org.knime.core.data.DataColumnSpec;



@javax.annotation.Generated("xslt-sandbox/knime2java")
public abstract class Abstract<xsl:apply-templates select="." mode="name"/>NodeModel
extends <xsl:choose>
	<xsl:when test="string-length(@extends)&gt;0">
		<xsl:value-of select="@extends"/>
	</xsl:when>
	<xsl:otherwise>
	 <xsl:apply-templates select=".." mode="package"/>
	 <xsl:text>.AbstractNodeModel</xsl:text>
	</xsl:otherwise>
	</xsl:choose>
	{
	<xsl:apply-templates select="property" />
	
	protected Abstract<xsl:apply-templates select="." mode="name"/>NodeModel()
		{
		/* super(inport,outport) */
		super( <xsl:value-of select="count(inPort)"/>, <xsl:value-of select="count(outPort)"/> );
		}
	
	
	 @Override
    protected abstract org.knime.core.node.BufferedDataTable[] execute(
    		final org.knime.core.node.BufferedDataTable[] inData,
            final org.knime.core.node.ExecutionContext exec
            ) throws Exception;
			
	
	@Override
    protected DataTableSpec createOutDataTableSpec(int index)
    	{
    	switch(index)
    		{
    		<xsl:for-each select="outPort">case <xsl:value-of select="position() -1 "/> : return _createOutTableSpec<xsl:value-of select="position() -1 "/>();
    		</xsl:for-each>
    		default: throw new IllegalStateException();
    		}
    	}
    	
	<xsl:for-each select="outPort">
	
	/** create DataTableSpec for outport '0' <xsl:apply-templates select="." mode="label"/> */
	protected DataTableSpec _createOutTableSpec<xsl:value-of select="position() -1 "/>()
		{
		DataColumnSpec colspec;
		DataColumnSpec colspecs[]=new DataColumnSpec[ <xsl:value-of select="count(column)"/> ];
		<xsl:for-each select="outPort">
		colspec = <xsl:apply-templates select="." mode="create.table.spec.decl"/>();
    	colspecs[ <xsl:value-of select="position() -1 "/> ] = colspec;
		</xsl:for-each>
    	return new DataTableSpec(colspecs);
		}
	
	</xsl:for-each>
	

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




<xsl:document href="{$outdir}/{$node.name}NodeModel.java" method="text">/*
<xsl:value-of select="$apache2.license"/>
*/
package <xsl:apply-templates select="." mode="package"/>;
import org.knime.core.node.*;
import org.knime.core.data.*;
<xsl:apply-templates select="code/import"/>

@javax.annotation.Generated("xslt-sandbox/knime2java")
public class <xsl:apply-templates select="." mode="name"/>NodeModel
	extends Abstract<xsl:apply-templates select="." mode="name"/>NodeModel
	{
	public <xsl:apply-templates select="." mode="name"/>NodeModel()
		{
		}
		
	<xsl:choose>
	<xsl:when test="code/body">
		<xsl:apply-templates select="code/body"/>
	</xsl:when>
	<xsl:otherwise>
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



</xsl:template>


<xsl:template match="plugin" mode="package">
<xsl:choose>
	<xsl:when test="@package"><xsl:value-of select="@package"/></xsl:when>
	<xsl:otherwise><xsl:text>generated</xsl:text></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="plugin" mode="out.dir">
<xsl:variable name="package"><xsl:apply-templates select="." mode="package"/></xsl:variable>
<xsl:value-of select="concat('./',translate($package,'.','/'),'/')"/>
</xsl:template>



<xsl:template match="category" mode="plugin.xml">
  	<category>
  		<xsl:attribute name="level-id"><xsl:value-of select="@name"/></xsl:attribute>
  		<xsl:attribute name="name"><xsl:apply-templates select="." mode="label"/></xsl:attribute>
  		<xsl:attribute name="path"><xsl:apply-templates select="." mode="path"/></xsl:attribute>
  		<xsl:attribute name="description"><xsl:value-of select="@name"/></xsl:attribute>
  	</category>
</xsl:template>

<xsl:template match="category" mode="label">
<xsl:choose>
	<xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="category" mode="path">
<xsl:text>/community/</xsl:text>
<xsl:choose>
	<xsl:when test="@path"><xsl:value-of select="@path"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="category" mode="description">
<xsl:choose>
	<xsl:when test="description"><xsl:value-of select="description"/></xsl:when>
	<xsl:otherwise><xsl:apply-templates select="." mode="label"/></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="category" mode="package">
<xsl:choose>
	<xsl:when test="@package"><xsl:value-of select="@package"/></xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates select=".." mode="package"/>
		<xsl:text>.</xsl:text>
		<xsl:call-template name="tolowercase">
			<xsl:with-param name="s"><xsl:value-of select="@name"/></xsl:with-param>
		</xsl:call-template>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="category">
<xsl:apply-templates select="node"/>
</xsl:template>



<xsl:template match="node" mode="package">
<xsl:choose>
	<xsl:when test="@package"><xsl:value-of select="@package"/></xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates select=".." mode="package"/>
		<xsl:text>.</xsl:text>
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


<xsl:template match="node" mode="out.dir">
<xsl:variable name="package"><xsl:apply-templates select="." mode="package"/></xsl:variable>
<xsl:value-of select="concat('./',translate($package,'.','/'),'/')"/>
</xsl:template>


<xsl:template match="property" mode="label">
	<xsl:choose>
		<xsl:when test="label"><xsl:value-of select="label"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="property" mode="todo2">

static final <xsl:apply-templates select="."/> <xsl:apply-templates select="." mode="default.name.decl"/>=<xsl:apply-templates select="." mode="default.name.value"/>;
static final String DEFAULT_FILENAME_PROPERTY="out.bed";

</xsl:template>

<xsl:template match="property">

	/** <xsl:apply-templates select="." mode="label"/> */

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


</xsl:when>

<xsl:when test="@type='file-read' or @type='file-save'">
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

</xsl:when>



<!-- string -->
<xsl:otherwise>
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
<xsl:variable name="port" select="@port"/>
		this.addDialogComponent(new org.knime.core.node.defaultnodesettings.DialogComponentColumnNameSelection(
					new org.knime.core.node.defaultnodesettings.SettingsModelColumnName(
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="config.name"/>,
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="default.name"/>
						),
					"<xsl:apply-templates select="." mode="label"/>",
					<xsl:for-each select="../inPort">
						<xsl:if test="@name = $port"><xsl:value-of select="position() - 1"/> /* inSpsec '<xsl:value-of select="@name"/>' */</xsl:if>
					</xsl:for-each>,
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
					));
</xsl:when>

<xsl:when test="@type='file-read'">
<xsl:variable name="port" select="@port"/>
		this.addDialogComponent(new org.knime.core.node.defaultnodesettings.DialogComponentFileChooser(
					new org.knime.core.node.defaultnodesettings.SettingsModelString(
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="config.name"/>,
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="default.name"/>
						),
					"<xsl:value-of select="generate-id(.)"/>",/* historyID */
					javax.swing.JFileChooser.OPEN_DIALOG
					<xsl:for-each select="extension">,"<xsl:value-of select="."/></xsl:for-each>
					));
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


<xsl:otherwise>
		this.addDialogComponent(new org.knime.core.node.defaultnodesettings.DialogComponentMultiLineString(
					new org.knime.core.node.defaultnodesettings.SettingsModelString(
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="config.name"/>,
						<xsl:apply-templates select=".." mode="name"/>NodeModel.<xsl:apply-templates select="." mode="default.name"/>
						),
					"<xsl:apply-templates select="." mode="label"/>",false,80,25
					));

</xsl:otherwise>
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
<xsl:text>getProperty</xsl:text>
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


<xsl:template match="property" mode="default.name">
<xsl:text>DEFAULT_</xsl:text>
<xsl:call-template name="touppercase">
 <xsl:with-param name="s" select="@name"/>
</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
