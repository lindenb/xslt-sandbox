<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
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
<xsl:apply-templates select="node"/>

<xsl:document href="{$base.dir}/plugin.xml" method="xml">
<xsl:processing-instruction name="eclipse"> version="3.0" </xsl:processing-instruction >
<plugin>
  <extension point="org.knime.workbench.repository.categories">
  	<category description="KNime4Bio"  level-id="knime4bio" name="KNime4Bio" path="/community"/>
  </extension>
  <extension point="org.knime.workbench.repository.nodes">
  	<xsl:apply-templates select="node" mode="plugin.xml"/> 
  </extension>
</plugin>
</xsl:document>

</xsl:template>

<xsl:template match="node" mode="plugin.xml">
<node  category-path="/community/knime4bio/linux">
    <xsl:attribute name="factory-class"></xsl:attribute>
    <xsl:attribute name="id"></xsl:attribute>   
</node>
</xsl:template>


<xsl:template match="node">

<xsl:message terminate="no">X1</xsl:message>
<xsl:variable name="outdir"><xsl:value-of select="concat($base.dir,'/')"/><xsl:apply-templates select="." mode="out.dir"/></xsl:variable>
<xsl:message terminate="no">X2</xsl:message>
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

<xsl:message terminate="no">X3</xsl:message>

<xsl:document href="{$outdir}/{$node.name}NodePlugin.java" method="text">
/* @(#)$RCSfile$ 
 * $Revision$ $Date$ $Author$
 *
 */
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

<xsl:message terminate="no">X4</xsl:message>

<xsl:document href="{$outdir}/{$node.name}NodeFactory.java" method="text">
package <xsl:apply-templates select="." mode="package"/>;

import org.knime.core.node.NodeDialogPane;
import org.knime.core.node.NodeFactory;
import org.knime.core.node.NodeView;

@javax.annotation.Generated("jvarkit")
public class <xsl:apply-templates select="." mode="name"/>NodeFactory
        extends NodeFactory&lt;<xsl:apply-templates select="." mode="name"/>Model&gt; {
	
    @Override
    public <xsl:apply-templates select="." mode="name"/>NodeModel createNodeModel() {
        return new <xsl:apply-templates select="." mode="name"/>NodeModel();
    }
	
    @Override
    public int getNrNodeViews() {
        return 0;
    }
	
    @Override
    public NodeView&lt;<xsl:apply-templates select="." mode="name"/>Model&gt; createNodeView(final int viewIndex,
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

<xsl:message terminate="no">X5</xsl:message>

<xsl:document href="{$outdir}/{$node.name}NodeDialog.java" method="text">
package <xsl:apply-templates select="." mode="package"/>;

import org.knime.core.node.defaultnodesettings.DefaultNodeSettingsPane;
import org.knime.core.node.defaultnodesettings.DialogComponentMultiLineString;
import org.knime.core.node.defaultnodesettings.DialogComponentNumber;
import org.knime.core.node.defaultnodesettings.DialogComponentStringSelection;
import org.knime.core.node.defaultnodesettings.SettingsModelInteger;
import org.knime.core.node.defaultnodesettings.SettingsModelString;



@javax.annotation.Generated("jvarkit")
public class <xsl:apply-templates select="." mode="name"/>NodeDialog
	extends DefaultNodeSettingsPane
	{
    protected <xsl:apply-templates select="." mode="name"/>NodeDialog()
    	{
    	<xsl:apply-templates select="property" mode="dialog"/>
    	addDialogComponent(new DialogComponentMultiLineString(
                new SettingsModelString( <xsl:apply-templates select="." mode="name"/>NodeModel.NCBI_QUERY_PROPERTY,<xsl:apply-templates select="." mode="name"/>NodeModel.NCBI_QUERY_DEFAULT)
                    ,"Entrez Query:",false,80,25));

    	addDialogComponent(new DialogComponentStringSelection(
    			new SettingsModelString(<xsl:apply-templates select="." mode="name"/>NodeModel.DB_IN_PROPERTY, <xsl:apply-templates select="." mode="name"/>NodeModel.DB_IN_DEFAULT),
    			"Database Input",
    			EInfo.getDatabases()
    			));
    	
    
    	
    	addDialogComponent(new DialogComponentNumber(
    			new SettingsModelInteger(<xsl:apply-templates select="." mode="name"/>NodeModel.LIMIT_PROPERTY, <xsl:apply-templates select="." mode="name"/>NodeModel.LIMIT_DEFAULT),
    			"Limit",1,10
    			));
    	}
	}
</xsl:document>

<xsl:message terminate="no">X6</xsl:message>

<xsl:document href="{$outdir}/{$node.name}NodeModel.java" method="text">
package <xsl:apply-templates select="." mode="package"/>;

import java.io.File;
import java.io.IOException;

import org.knime.core.node.CanceledExecutionException;
import org.knime.core.node.ExecutionMonitor;
import org.knime.core.node.NodeModel;
import org.knime.core.node.NodeSettingsRO;
import org.knime.core.node.InvalidSettingsException;
import org.knime.core.node.NodeSettingsWO;

@javax.annotation.Generated("jvarkit")
public class <xsl:apply-templates select="." mode="name"/>Model
	extends org.knime.core.node.NodeModel
	{
	<xsl:apply-templates select="property"/>
	
	public <xsl:apply-templates select="." mode="name"/>Model()
		{
		/* super(inport,outport) */
		super( <xsl:value-of select="count(inPort)"/>, <xsl:value-of select="count(outPort)"/> );
		}
	
	 private DataTableSpec createOutTableSpec()
    	{
    	DataTableSpec tspec[]=new DataTableSpec[<xsl:value-of select="count(outPort)"/>];
    	<xsl:for-each select="outPort">
    	tspec[ <xsl:value-of select="position() -1 "/> ] = <xsl:apply-templates select="." mode="create.table.spec.decl"/>();
    	</xsl:for-each>
    	return new DataTableSpec(tspec);
    	}
	<xsl:for-each select="outPort">
	
	private DataTableSpec <xsl:apply-templates select="." mode="create.table.spec.decl"/>()
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
	
	
    private java.util.List&lt;SettingsModel&gt; getSettingsModel() {
    	java.util.List&lt;SettingsModel&gt; L=new java.util.ArrayList&lt;SettingsModel&gt;( <xsl:value-of select="count(column)"/> );
    	<xsl:for-each select="property">
    	L.add(this.<xsl:apply-templates select="." mode="var.name"/>);
    	</xsl:for-each>
    	return L;
    	}

	
	@Override
	protected void loadInternals(File arg0, ExecutionMonitor arg1)
			throws IOException, CanceledExecutionException
		{
		}
	
	@Override
	protected void loadValidatedSettingsFrom(NodeSettingsRO arg0)
			throws InvalidSettingsException
		{
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
		getLogger().info("saveInternals "+getClass().getName());
		}
	@Override
	protected void saveSettingsTo(NodeSettingsWO settings) {
		getLogger().info("saveSettingsTo "+getClass().getName());
		}
	@Override
	protected void validateSettings(NodeSettingsRO settings)
			throws InvalidSettingsException {
		getLogger().info("validateSettings "+getClass().getName());
		}
	}

</xsl:document>

<xsl:message terminate="no">X100</xsl:message>

</xsl:template>


<xsl:template match="plugin" mode="package">
<xsl:choose>
	<xsl:when test="@package"><xsl:value-of select="@package"/></xsl:when>
	<xsl:otherwise><xsl:text>generated</xsl:text></xsl:otherwise>
</xsl:choose>
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
<xsl:message terminate="no">XXXXXXXXXX1</xsl:message>
<xsl:call-template name="titleize">
	<xsl:with-param name="s">
		<xsl:choose>
			<xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
			<xsl:otherwise><xsl:message terminate="no">XXXXXXXXXX4</xsl:message><xsl:value-of select="generate-id(.)"/><xsl:message terminate="no">XXXXXXXXXX5</xsl:message></xsl:otherwise>
		</xsl:choose>
	</xsl:with-param>
</xsl:call-template>
<xsl:message terminate="no">XXXXXXXXXX2</xsl:message>
</xsl:template>


<xsl:template match="node" mode="out.dir">
<xsl:variable name="package"><xsl:apply-templates select="." mode="package"/></xsl:variable>
<xsl:value-of select="concat('./',translate($package,'.','/'),'/')"/>
</xsl:template>



<xsl:template match="property">

static final <xsl:apply-templates select="."/> <xsl:apply-templates select="." mode="default.name.decl"/>=<xsl:apply-templates select="." mode="default.name.value"/>;
static final String DEFAULT_FILENAME_PROPERTY="out.bed";

</xsl:template>

<xsl:template match="property">
<xsl:choose>
<xsl:when test="@type='int'">org.knime.core.node.defaultnodesettings.SettingsModelInteger(<xsl:apply-templates select="." mode="xx"/>,<xsl:apply-templates select="." mode="xxx"/>);</xsl:when>
<xsl:otherwise>org.knime.core.node.defaultnodesettings.SettingsModelString(<xsl:apply-templates select="." mode="xx"/>,<xsl:apply-templates select="." mode="xxx"/>)</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="property" mode="default.value">
	<xsl:choose>
		<xsl:when test='@default'>
			<xsl:choose>
				<xsl:when test="@type='string'"><xsl:value-of select='.'/></xsl:when>
				<xsl:otherwise>org.knime.core.node.defaultnodesettings.SettingsModelString(<xsl:apply-templates select="." mode="xxx"/>,<xsl:apply-templates select="." mode="xxx"/>)</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="@type='boolean'">false</xsl:when>
				<xsl:when test="@type='int'">0</xsl:when>
				<xsl:when test="@type='string'">""</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="outPort" mode="create.table.spec.decl">
<xsl:value-of select="concat('_',generate-id(.),'CreateTableSpec')"/>
</xsl:template>

</xsl:stylesheet>
