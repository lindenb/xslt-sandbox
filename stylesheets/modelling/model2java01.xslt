<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
        >
<xsl:output method="text"/>

<xsl:template match="/">
import java.util.*;
import java.util.regex.*;

interface DataType
	{
	}
	
interface OntNode
	{
	public String getLocalName();
	public String getLabel();
	public String getDescription();
	public Icon getIcon();
	}

interface OntProperty extends OntNode
	{
	public boolean isDataProperty();
	public boolean isObjectProperty();
	public int getMinCardinality();
	public int getMaxCardinality();
	public DataProperty asDataProperty();
	public ObjectProperty asObjectProperty();
	}

interface DataProperty extends OntProperty
	{
	public boolean isId();
	public DataType getRange();
	}

interface ObjectProperty extends OntProperty
	{
	public OntClass getRange();
	}

interface OntClass extends OntNode
	{
	public List&lt;OntProperty&gt; getProperties();
	}

abstract class AbstractOntNode implements OntNode
	{
	protected AbstractOntNode()
		{
		}
		
	@Override
	public final Object clone() throws CloneNotSupportedException
		{
    		throw new CloneNotSupportedException();
  		}
	@Override
	public int hashCode()
		{
		return getLocalName().hashCode();
		}
	@Override
	public boolean equals(Object o)
		{
		return	o.getClass()==this.getClass() &amp;&amp;
			this.getLocalName().equals( ((AbstractOntNode)o).getLocalName() )
			;
		}
	@Override
	public abstract String getLocalName();
	@Override
	public String getLabel()
		{
		return getLocalName();
		}
	@Override
	public String getDescription()	
		{
		return getLabel();
		}
	@Override
	public String toString()
		{
		return getClass().getSimpleName()+"["+getLocalName()+"]";
		}
	@Override
	public DataProperty asDataProperty()
		{
		return DataProperty.class.cast(this);
		}
	@Override
	public ObjectProperty asObjectProperty()
		{
		return ObjectProperty.class.cast(this);
		}
	@Override
	public Icon getIcon()
		{
		return null;
		}
	}

abstract class AbstractOntProperty
	extends AbstractOntNode
	implements OntProperty
	{
	@Override
	public boolean isObjectProperty()
		{
		return !isDataProperty();
		}
	@Override
	public int getMinCardinality()
		{
		return 1;
		}
	@Override
	public int getMaxCardinality()
		{
		return 1;
		}
	}

abstract class AbstractDataProperty
	extends AbstractOntProperty
	implements DataProperty
	{
	@Override
	public boolean isId()
		{
		return false;
		}
	@Override
	public boolean isDataProperty()
		{
		return true;
		}
	}

abstract class AbstractObjectProperty
	extends AbstractOntProperty
	implements ObjectProperty
	{
	@Override
	public boolean isDataProperty()
		{
		return false;
		}
	}

abstract class AbstractOntClass
	extends AbstractOntNode
	implements  OntClass
	{
	
	}

abstract class AbstractDataType implements DataType
	{
	
	}


abstract class StringDataType
	extends AbstractDataType
	{
	public Pattern getPattern()
		{
		return null;
		}
	
	public Object parse(String s)
		{
		return s;
		}
	}

interface Ontology extends Iterable&lt;&lt;OntClass&gt;
	{
	public OntClass findClassByName(String s);
	public List&lt;OntClass&gt; getClasses();
	}

abstract class AbstractOntology
	implements Ontology
	{
	@Override
	public OntClass findClassByName(String s)
		{
		for(OntClass c:getClasses())
			{
			if(c.getLocalName().equals(s)) return c;
			}
		return null;
		}
	@Override
	public Iterator&lt;OntClass&gt; iterator()
		{
		return getClasses().iterator();
		}
	}

abstract class GenericTableModel&lt;T&gt;
	extends AbstractTableModel
	{
	public abstract &lt;T&gt; getItems();
	@Override
	public int getRowCount()
		{
		return getItems().size();
		}
	public T getItemAt(int i)
		{
		return getItems().get(i);
		}
	
	public abstract Object getValueOf(T objet,int col);
	
	@Override
	public Object getValueAt(int row,int col)
		{
		return getValueOf(getItemAt(row),col);
		}
	@Override
	public boolean isCellEditable(int row,int col)
		{
		return false;
		}
	}




<xsl:apply-templates select="EModel/EClass"/>
<xsl:apply-templates select="EModel"/>
</xsl:template>

<xsl:template match="EDataType[not(@type) or @type='string']">
<xsl:variable name="className"><xsl:apply-templates select=".." mode="localName"/></xsl:variable>
/** <xsl:value-of select="$className"/>DataType ********************************************************/
private class <xsl:value-of select="$className"/>DataType
	extends StringDataType
	{
	<xsl:if test="pattern">
	private Pattern pattern=null;
	@Override
	public Pattern getPattern()
		{
		return this.pattern;
		}
	</xsl:if>
	
	<xsl:value-of select="$className"/>DataType()
		{
		<xsl:if test="pattern">
		int flag=0;
		<xsl:if test="@case-insensitive='true'">
		flag |= Pattern.CASE_INSENSITIVE;
		</xsl:if>
		<xsl:if test="@canonical='true'">
		flag |= Pattern.CANON_EQ;
		</xsl:if>
		this.pattern=Pattern.compile(<xsl:apply-templates select="." mode="quote"/>,flag);
		</xsl:if>
		}
	
	}
private <xsl:value-of select="$className"/>DataType dataType = new  <xsl:value-of select="$className"/>DataType();

/*********************************************************************************************************/
</xsl:template>

<xsl:template match="EDataType">
<xsl:message terminate="yes">DataType @type not implemented</xsl:message>
</xsl:template>

<xsl:template match="EAttribute">
<xsl:variable name="className"><xsl:apply-templates select="." mode="localName"/></xsl:variable>
		/** data property */
		private class <xsl:value-of select="$className"/>
			extends AbstractDataProperty
			{
			<xsl:apply-templates select="EDataType"/>
			
			<xsl:value-of select="$className"/>()
				{
				}
	
			@Override
			public DataType getRange()
				{
				return this.dataType;
				}
			<xsl:apply-templates select="@ID"/>
			<xsl:apply-templates select="@localName"/>
			<xsl:apply-templates select="@minCardinality"/>
			<xsl:apply-templates select="@maxCardinality"/>
			<xsl:apply-templates select="@label"/>
			<xsl:apply-templates select="@description"/>
			}

		private <xsl:value-of select="$className"/> m_<xsl:value-of select="$className"/>=new <xsl:value-of select="$className"/>();
</xsl:template>

<xsl:template match="EReference">
<xsl:variable name="className"><xsl:apply-templates select="." mode="localName"/></xsl:variable>
		private class <xsl:value-of select="$className"/>
			extends AbstractObjectProperty
			{
			<xsl:value-of select="$className"/>()
				{
				}
	
			@Override
			public OntClass getRange()
				{
				<xsl:if test="not(@range)">
				  <xsl:message terminate="yes"><xsl:value-of select="$className"/> missing @range</xsl:message>
				</xsl:if>
				return <xsl:apply-templates select="@range" mode="localName"/>.getInstance();
				}
			<xsl:apply-templates select="@localName"/>
			<xsl:apply-templates select="@minCardinality"/>
			<xsl:apply-templates select="@maxCardinality"/>
			<xsl:apply-templates select="@label"/>
			<xsl:apply-templates select="@description"/>
			}

		private <xsl:value-of select="$className"/> m_<xsl:value-of select="$className"/>=new <xsl:value-of select="$className"/>();
</xsl:template>



<xsl:template match="EClass">
<xsl:variable name="className"><xsl:apply-templates select="." mode="localName"/></xsl:variable>
class <xsl:value-of select="$className"/>
	extends AbstractOntClass
	{
	/** singleton */
	private static <xsl:value-of select="$className"/> INSTANCE=null;
	
	<xsl:apply-templates select="EAttribute|EReference"/>
	
	
	
	/** properties */
	private OntProperty[] properties=null;
	/** ID property */
	private DataProperty idProperty=null;
	
	/** private ctor */
	private <xsl:value-of select="$className"/>()
		{
		properties=new OntProperty[]{
			<xsl:for-each select="EAttribute|EReference">
				<xsl:variable name="propName"><xsl:apply-templates select="." mode="localName"/></xsl:variable>
				<xsl:if test="position()!=1">,</xsl:if>
				<xsl:value-of select="concat('m_',$propName)"/>
			</xsl:for-each>
			};
		<xsl:if test="count(EAttribute[@ID='true'])!=1">
			<xsl:message terminate='yes'>ID missing or defined twice for <xsl:value-of select="$className"/></xsl:message>
		</xsl:if>
		
		<xsl:for-each select="EAttribute[@ID='true']">
		<xsl:variable name="propName"><xsl:apply-templates select="." mode="localName"/></xsl:variable>
		this.idProperty=<xsl:value-of select="concat('m_',$propName)"/>;
		</xsl:for-each>
		}
		
	/** get singleton */
	public static <xsl:value-of select="$className"/> getInstance()
		{
		if(INSTANCE==null)
			{
			synchronized(<xsl:value-of select="$className"/>.class)
				{
				if(INSTANCE==null)
					{
					INSTANCE=new <xsl:value-of select="$className"/>();
					}
				}
			}
		return INSTANCE;
		}
	@Override
	public List&lt;OntProperty&gt; getProperties()
		{
		return Arrays.asList(properties);
		}
	<xsl:apply-templates select="@localName"/>
	<xsl:apply-templates select="@label"/>
	<xsl:apply-templates select="@description"/>
	}
</xsl:template>


<xsl:template match="EModel">

/**
 * OntologyImpl
 */
class OntologyImpl extends AbstractOntology
	{
	private OntClass classes[];
	public OntologyImpl()
		{
		this.classes=new OntClass[]{
			<xsl:for-each select="EClass">
			<xsl:variable name="className"><xsl:apply-templates select="." mode="localName"/></xsl:variable>
			<xsl:if test="position()!=1">,</xsl:if>
			<xsl:value-of select="$className"/><xsl:text>.getInstance()
			</xsl:text>
			</xsl:for-each>
			};
		}
	
	
	@Override
	public List&lt;OntClass&gt; getClasses()
		{
		return Arrays.asList(this.classes);
		}
	}

public class jeter
	{
	public static void main(String args) throws Exception
		{
		
		}
	}
</xsl:template>

<xsl:template match="*|text()|@*" mode="localName">
<xsl:variable name="s">
	<xsl:choose>
	  <xsl:when test="@localName">
	  	<xsl:value-of select="@localName"/>
	  </xsl:when>
	   <xsl:when test="@name">
	  	<xsl:value-of select="@name"/>
	  </xsl:when>
	  <xsl:otherwise>
	  	<xsl:value-of select="normalize-space(.)"/>
	  </xsl:otherwise>
	</xsl:choose>
</xsl:variable>
<xsl:call-template name="titleize">
  <xsl:with-param name="name">
    <xsl:value-of select="$s"/>
  </xsl:with-param>
</xsl:call-template>
</xsl:template>

<xsl:template match="@localName">
@Override
public String getLocalName()
	{
	return <xsl:apply-templates select="." mode="quote"/>;
	}
</xsl:template>

<xsl:template match="@minCardinality">
@Override
public int getMinCardinality()
	{
	return <xsl:value-of select="."/>;
	}
</xsl:template>

<xsl:template match="@maxCardinality">
@Override
public int getMaxCardinality()
	{
	return <xsl:value-of select="."/>;
	}
</xsl:template>

<xsl:template match="@label">
@Override
public int getLabel()
	{
	return <xsl:apply-templates select="." mode="quote"/>;
	}
</xsl:template>	
	
<xsl:template match="@description">
@Override
public int getDescription()
	{
	return <xsl:apply-templates select="." mode="quote"/>;
	}
</xsl:template>	

<xsl:template match="@ID">
@Override
public boolean isId()
	{
	return <xsl:value-of select="@ID"/>;
	}
</xsl:template>	


<xsl:template match="*|text()|@*" mode="quote">
	<xsl:text>&quot;</xsl:text>
	<xsl:call-template name="escape">
		<xsl:with-param name="s" select="."/>
	</xsl:call-template>
	<xsl:text>&quot;</xsl:text>
</xsl:template>

<xsl:template name="escape">
 <xsl:param name="s"/>
        <xsl:choose>
        <xsl:when test="contains($s,'&quot;')">
                <xsl:value-of select="substring-before($s,'&quot;')"/>
                <xsl:text>\"</xsl:text>
                <xsl:call-template name="escape">
                        <xsl:with-param name="s" select="substring-after($s,'&quot;')"/>
                </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
                <xsl:value-of select='$s'/>
        </xsl:otherwise>
        </xsl:choose>
</xsl:template>


<xsl:template name="titleize">
 <xsl:param name="name"/>
 <xsl:value-of select="translate(substring($name,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
 <xsl:value-of select="substring($name,2)"/>
</xsl:template>


</xsl:stylesheet>
