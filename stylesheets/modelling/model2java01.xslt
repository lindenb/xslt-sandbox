<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
        >
<xsl:output method="text"/>

<xsl:template match="/">

interface DataType
	{
	}
	
interface OntNode
	{
	public String getLocalName();
	public String getLabel();
	public String getDescription();
	}

interface OntProperty extends OntNode
	{
	public boolean isDataProperty();
	public boolean isObjectProperty();
	public int getMinCardinality();
	public int getMaxCardinality();
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

abstract AbstractOntClass
	extends AbstractOntNode
	implements  OntClass
	{
	
	}

abstract AbstractDataType implements DataType
	{
	
	}


abstract StringDataType
	extends AbstractDataType
	{
	public Pattern getPattern()
		{
		return null;
		}
	@Override
	public Object parse(String s)
		{
		return s;
		}
	}


</xsl:template>

<xsl:template match="EDataType">
<xsl:variable name="className" select="generate-id(.)"/>
class <xsl:value-of select="$className">DataType
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
	
	<xsl:value-of select="$className">DataType()
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
</xsl:template>

<xsl:template match="EAttribute">
<xsl:variable name="className"><xsl:value-of select="localName"/></xsl:variable>
class <xsl:value-of select="$className">
	extends AbstractOntDataProperty
	{
	
	private DataType dataType=null;
	<xsl:value-of select="$className">()
		{
		}
	
	@Override
	public DataType getRange()
		{
		return this.dataType;
		}
	
	<xsl:apply-templates select="@localName"/>
	<xsl:apply-templates select="@minCardinality"/>
	<xsl:apply-templates select="@maxCardinality"/>
	<xsl:apply-templates select="@label"/>
	<xsl:apply-templates select="@description"/>
	}
</xsl:template>

<xsl:template match="EReference">
<xsl:variable name="className"><xsl:value-of select="localName"/></xsl:variable>
class <xsl:value-of select="$className">
	extends AbstractOntObjectProperty
	{
	<xsl:value-of select="$className">()
		{
		}
	
	@Override
	public OntClass getRange()
		{
		return <xsl:value-of select="@range">.getInstance();
		}
	<xsl:apply-templates select="@localName"/>
	<xsl:apply-templates select="@minCardinality"/>
	<xsl:apply-templates select="@maxCardinality"/>
	<xsl:apply-templates select="@label"/>
	<xsl:apply-templates select="@description"/>
	}
</xsl:template>

<xsl:template match="EClass">
</xsl:template>


<xsl:template match="EClass">
<xsl:variable name="className"><xsl:value-of select="localName"/></xsl:variable>
class <xsl:value-of select="$className">
	extends AbstractOntClass
	{
	/** singleton */
	private static final <xsl:value-of select="$className"> INSTANCE=null;
	private List&lt;OntProperty&gt; properties=new ArrayList&lt;OntProperty&gt;();
	/** private ctor */
	private <xsl:value-of select="$className">()
		{
		}
	/** prevent cloning */
	/** get singleton */
	public static <xsl:value-of select="$className"> getInstance()
		{
		if(INSTANCE==null)
			{
			synchronized(<xsl:value-of select="$className">.class)
				{
				if(INSTANCE==null)
					{
					INSTANCE=new <xsl:value-of select="$className">();
					}
				}
			}
		return INSTANCE;
		}
	@Override
	public List&lt;OntProperty&gt; getProperties()
		{
		return properties;
		}
	<xsl:apply-templates select="@localName"/>
	<xsl:apply-templates select="@label"/>
	<xsl:apply-templates select="@description"/>
	}
</xsl:template>


<xsl:template match="@localName">
@Override
public int getLocalName()
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
<xsl:param name="name"/><xsl:value-of select="translate(substring($name,1,1),'ab
cdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/><xsl:value-of select="
substring($name,2)"/></xsl:template>


</xsl:stylesheet>
