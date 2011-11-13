<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
        >
<xsl:output method="text"/>
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
import java.util.*;
import java.awt.image.BufferedImage;
import java.util.regex.*;
import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.CardLayout;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.imageio.ImageIO;
import javax.swing.*;
import javax.swing.event.*;
import javax.swing.table.*;
import javax.swing.border.*;
import java.io.*;
import javax.xml.stream.*;
import javax.xml.stream.events.*;
import java.math.*;
import java.net.URL;

interface DataType
	{
	public Object parseInstance(XMLEventReader r,StartElement e) throws XMLStreamException;
	}

interface Summary
	{
	public String getLabel();
	public String getDescription();
	public Icon getIcon();
	}

interface OntNode
	extends Summary
	{
	public String getLocalName();
	}

interface OntProperty extends OntNode
	{
	public boolean isDataProperty();
	public boolean isObjectProperty();
	public int getMinCardinality();
	public int getMaxCardinality();
	public DataProperty asDataProperty();
	public ObjectProperty asObjectProperty();
	public Object parseInstance(XMLEventReader r,StartElement e) throws XMLStreamException;
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
	public Instance parseInstance(XMLEventReader r,StartElement e) throws XMLStreamException;
	public void writeInstance(XMLStreamWriter w,Instance instance) throws XMLStreamException;
	}

abstract class AbstractOntNode implements OntNode
	{
	protected Icon _icon=null;
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
	
	protected static Icon loadIcon(String s)
		{
		if(s==null || s.isEmpty()) return null;
		try
			{
			BufferedImage img=null;
			if(s.startsWith("http://"))
				{
				img=ImageIO.read(new URL(s));
				}
			else
				{
				InputStream in=AbstractOntNode.class.getResourceAsStream(s);
				if(in!=null)
					{
					img=ImageIO.read(in);
					in.close();
					}
				}
			if(img==null) return null;
			return new ImageIcon(img);
			}
		catch(Exception err)
			{
			return null;
			}
		}
	@Override
	public Icon getIcon()
		{
		return _icon;
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
	public final boolean isDataProperty()
		{
		return true;
		}
	@Override
	public Object parseInstance(XMLEventReader r,StartElement e) throws XMLStreamException
		{
		return getRange().parseInstance(r,e);
		}
	}

abstract class AbstractObjectProperty
	extends AbstractOntProperty
	implements ObjectProperty
	{
	@Override
	public final boolean isDataProperty()
		{
		return false;
		}
	}

abstract class AbstractOntClass
	extends AbstractOntNode
	implements  OntClass
	{
	public OntProperty getPropertyByName(String s)
		{
		for(OntProperty o: getProperties())
			{
			if(o.getLocalName().equals(s)) return o;
			}
		return null;
		}
	}

abstract class AbstractDataType implements DataType
	{
	
	}


class StringDataType
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
	@Override
	public Object parseInstance(XMLEventReader r,StartElement e) throws XMLStreamException
		{
		return parse(r.getElementText());
		}
	}

class BigIntegerDataType
	extends AbstractDataType
	{
	public Object parse(String s)
		{
		if(s==null) return null;
		return new java.math.BigInteger(s);
		}
	@Override
	public Object parseInstance(XMLEventReader r,StartElement e) throws XMLStreamException
		{
		return parse(r.getElementText());
		}
	public BigInteger getMinInclusive()
		{
		return null;
		}
	
	public BigInteger getMaxExclusive()
		{
		return null;
		}
	}

class BigDecimalDataType
	extends AbstractDataType
	{
	public Object parse(String s)
		{
		if(s==null) return null;
		return new java.math.BigDecimal(s);
		}
	@Override
	public Object parseInstance(XMLEventReader r,StartElement e) throws XMLStreamException
		{
		return parse(r.getElementText());
		}
	public BigDecimal getMinInclusive()
		{
		return null;
		}
	
	public BigDecimal getMaxInclusive()
		{
		return null;
		}
	}


interface Ontology extends Iterable&lt;OntClass&gt;
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


interface Instance
	extends Summary
	{
	public Object get(OntProperty prop);
	public OntClass getOntClass();
	public Object getId();
	}
	
abstract class AbstractInstance
	implements Instance
	{
	@Override
	public Icon getIcon()
		{
		return getOntClass().getIcon();
		}
	@Override
	public String getLabel()
		{
		return null;
		}
	@Override
	public String getDescription()
		{
		return null;
		}
	@Override
	public String toString()
		{
		return getLabel();
		}
	}
	

interface InstanceFilter
	{
	public boolean accept(Instance instance);
	}
	
class OntClassInstanceFilter implements InstanceFilter
	{
	private OntClass c;
	OntClassInstanceFilter(OntClass c)
		{
		this.c=c;
		}
	@Override
	public boolean accept(Instance instance)
		{
		return this.c== instance.getOntClass();
		}
	}

class NotInstanceFilter implements InstanceFilter
	{
	private InstanceFilter delegate;
	NotInstanceFilter(InstanceFilter delegate)
		{
		this.delegate=delegate;
		}
	@Override
	public boolean accept(Instance instance)
		{
		return ! this.delegate.accept(instance);
		}
	}

class LogicalAndInstanceFilter implements InstanceFilter
	{
	private InstanceFilter delegates[];
	LogicalAndInstanceFilter(InstanceFilter...array)
		{
		this.delegates=array;
		}
	@Override
	public boolean accept(Instance instance)
		{
		for(InstanceFilter f:this.delegates)
			{
			if(!f.accept(instance)) return false;
			}
		return true;
		}
	}

class LogicalOrInstanceFilter implements InstanceFilter
	{
	private InstanceFilter delegates[];
	LogicalOrInstanceFilter(InstanceFilter...array)
		{
		this.delegates=array;
		}
	@Override
	public boolean accept(Instance instance)
		{
		for(InstanceFilter f:this.delegates)
			{
			if(f.accept(instance)) return true;
			}
		return false;
		}
	}
	
class InstanceSearch
	{
	private InstanceFilter filter;
	private int start=0;
	private int limit=100;
	public InstanceSearch(InstanceFilter filter,int start,int limit)
		{
		this.filter=filter;
		this.limit=limit;
		this.start=start;
		}
	public InstanceSearch(InstanceFilter filter)
		{
		this.filter=filter;
		}
	public InstanceFilter getFilter()
		{
		if(this.filter==null) this.filter=new InstanceFilter()
			{
			@Override
			public boolean accept(Instance instance)
				{
				return true;
				}
			};
		return this.filter;
		}
	public int getStart()
		{
		return this.start;
		}
	public int getLimit()
		{
		return this.limit;
		}
	}

interface GenericTableModel&lt;T&gt;
	extends TableModel
	{
	/** returns item at index 'i' */
	public T getItemAt(int i);
	/** returns value at column 'col' for this object */
	public Object getValueOf(T objet,int col);
	}

abstract class AbstractGenericTableModel&lt;T&gt;
	extends AbstractTableModel
	implements GenericTableModel&lt;T&gt;
	{
	protected List&lt;T&gt; items=new ArrayList&lt;T&gt;();
	public List&lt;T&gt; getItems()
		{
		return this.items;
		}
	@Override
	public int getRowCount()
		{
		return getItems().size();
		}
	@Override
	public T getItemAt(int i)
		{
		return getItems().get(i);
		}
	@Override
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


class OntClassTableModel
	extends AbstractGenericTableModel&lt;OntClass&gt;
	{
	public OntClassTableModel(Collection&lt;OntClass&gt; list)
		{
		super.items.addAll(list);
		}
	
	@Override
	public int getColumnCount()
		{
		return 3;
		}
		
	@Override
	public String getColumnName(int col)
		{
		switch(col)
			{
			case 0: return "Icn";
			case 1: return "Label";
			case 2: return "Description";
			default: return "$"+(col+1);
			}
			
		}
	
	@Override
	public Class&lt;?&gt; getColumnClass(int col)
		{
		switch(col)
			{
			case 0: return Icon.class;
			case 1: //through
			case 2: return String.class;
			default: return Object.class;
			}
			
		}
	
	public Object getValueOf(OntClass c,int col)
		{
		if(c==null) return null;
		switch(col)
			{
			case 0: return c.getIcon();
			case 1: return c.getLabel();
			case 2: return c.getDescription();
			default: return null;
			}
		}
	
	
	}



abstract class SimpleInstanceTableModel&lt;T extends Instance&gt;
	extends AbstractGenericTableModel&lt;T&gt;
	{
	SimpleInstanceTableModel()
		{
		}
	public abstract OntClass getOntClass();
	public abstract List&lt;DataProperty&gt; getDataProperties();
	@Override
	public int getColumnCount()
		{
		return getDataProperties().size();
		}
	@Override
	public String getColumnName(int col)
		{
		return getDataProperties().get(col).getLabel();
		}
	
	@Override
	public Object getValueOf(Instance objet,int col)
		{
		return objet.get(getDataProperties().get(col));
		}
		
	}

class XmlDataStore
	{
	private Ontology ontology;
	private File xmlFile;
	private XMLInputFactory xmlInputfactory;
	private XMLOutputFactory xmlOutputfactory;
	XmlDataStore(Ontology ontology,File xmlFile)
		{
		this.ontology=ontology;
		this.xmlFile=xmlFile;
		this.xmlInputfactory = XMLInputFactory.newInstance();
		this.xmlOutputfactory = XMLOutputFactory.newInstance();
		}
	public Ontology getOntology()
		{
		return this.ontology;
		}
	protected String getRootName()
		{
		return "DataStore";
		}
	protected Instance parseInstance(XMLEventReader r,StartElement e)
		throws XMLStreamException
		{
		String localName=e.getName().getLocalPart();
		if(localName.equals(this.getRootName())) return null;
		OntClass ontClass= getOntology().findClassByName(localName);
		if(ontClass==null) throw new XMLStreamException("Cannot find ontClass "+localName);
		return ontClass.parseInstance(r,e);
		}
	private void createFile()throws IOException,XMLStreamException
		{
		FileOutputStream fout=new FileOutputStream(this.xmlFile);
		XMLStreamWriter w= this.xmlOutputfactory.createXMLStreamWriter( fout,"UTF-8");
		w.writeStartDocument("UTF-8","1.0");
		w.writeStartElement(getRootName());
		w.writeEndElement();
		w.writeEndDocument();
		w.flush();
		fout.flush();
		fout.close();
		}
	public void insert(List&lt;Instance&gt; instances) throws IOException,XMLStreamException
		{
		XMLStreamWriter w=null;
		XMLEventReader r=null;
		FileReader fin=null;
		FileOutputStream fout=null;
		try
			{
			if(!this.xmlFile.exists()) createFile();
			
			File fileout=File.createTempFile("model",".tmp.xml",this.xmlFile.getParentFile());
			List&lt;Instance&gt; array=new ArrayList&lt;Instance&gt;();
			
			
			fout=new FileOutputStream(fileout);
			w= this.xmlOutputfactory.createXMLStreamWriter( fout,"UTF-8");
			fin=new FileReader(this.xmlFile);
			r= this.xmlInputfactory.createXMLEventReader(fin);
			
			int foundIndex=-1;
			while(r.hasNext())
				{
				XMLEvent evt=r.nextEvent();
				if(evt.isStartDocument())
					{
					w.writeStartDocument("UTF-8","1.0");
					w.writeStartElement(getRootName());
					}
				else if(evt.isEndElement())
					{
					for(Instance instance:instances)
						{
						instance.getOntClass().writeInstance(w,instance);
						}
					w.writeEndElement();
					w.writeEndDocument();
					w.flush();
					break;
					}
				else if(!evt.isStartElement())
					{
					continue;
					}	
				StartElement e=evt.asStartElement();
			
				Instance instance=parseInstance(r,evt.asStartElement());
				if(instance==null) continue;
				
				}
			}
		finally
			{
			if(r!=null) try { r.close();} catch(Exception err) {} 
			if(w!=null) try { w.flush();} catch(Exception err) {} 
			if(w!=null) try { w.close();} catch(Exception err) {} 
			if(fin!=null) try { fin.close();} catch(Exception err) {} 
			if(fout!=null) try { fout.flush();} catch(Exception err) {} 
			if(fout!=null) try { fout.close();} catch(Exception err) {} 
			}
		}
	public List&lt;Instance&gt; search(InstanceSearch search) throws IOException,XMLStreamException
		{
		XMLEventReader r=null;
		FileReader fin=null;
		try
			{
			List&lt;Instance&gt; array=new ArrayList&lt;Instance&gt;();
			if(!this.xmlFile.exists()) return array;
			fin=new FileReader(this.xmlFile);
			r= this.xmlInputfactory.createXMLEventReader(fin);
			
			int foundIndex=-1;
			while(r.hasNext())
				{
				XMLEvent evt=r.nextEvent();
				if(!evt.isStartElement()) continue;	
				StartElement e=evt.asStartElement();
			
				Instance instance=parseInstance(r,evt.asStartElement());
				if(instance==null) continue;
				if(!search.getFilter().accept(instance)) continue;
				foundIndex++;
				if(foundIndex &lt; search.getStart()) continue;
				array.add(instance);
				if(array.size() &gt;= search.getLimit()) break;
				}
			return array;
			}
		finally
			{
			if(r!=null) try { r.close();} catch(Exception err) {} 
			if(fin!=null) try { fin.close();} catch(Exception err) {} 
			}
		}
	public void close()
		{
		
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


<xsl:template match="EDataType[@type='enum']" mode="enum-decl">
<xsl:variable name="className"><xsl:apply-templates select=".." mode="localName"/></xsl:variable>
<xsl:if test="count(enum)=0">
  <xsl:message terminate="yes">No item defined in enumeration</xsl:message>
</xsl:if>

/** enumeration for <xsl:value-of select="$className"/> */
enum E_<xsl:value-of select="$className"/>
	{
	<xsl:for-each select="enum">
	<xsl:if test="position()&gt;1">,</xsl:if>
	<xsl:choose>
		<xsl:when test="@value">
		<xsl:value-of select="@value"/>()
			{
			@Override
			public String toString()
				{
				return &quot;<xsl:value-of select="."/>&quot;;
				}
			}
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="."/>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:for-each>;
	}
</xsl:template>

<xsl:template match="EDataType[@type='enum']">
<xsl:variable name="className"><xsl:apply-templates select=".." mode="localName"/></xsl:variable>
<xsl:if test="count(enum)=0">
  <xsl:message terminate="yes">No item defined in enumeration</xsl:message>
</xsl:if>
/***
 *
 * <xsl:value-of select="$className"/>DataType
 *
 */
private class <xsl:value-of select="$className"/>DataType
	extends AbstractDataType
	{
	
	
	public Object parse(String s)
		{
		if(s==null) return null;
		return E_<xsl:value-of select="$className"/>.valueOf(s);
		}
	@Override
	public Object parseInstance(XMLEventReader r,StartElement e) throws XMLStreamException
		{
		return parse(r.getElementText());
		}
	}
private <xsl:value-of select="$className"/>DataType dataType = new  <xsl:value-of select="$className"/>DataType();

/*********************************************************************************************************/
</xsl:template>


<xsl:template match="EDataType[@type='integer']">
<xsl:variable name="className"><xsl:apply-templates select=".." mode="localName"/></xsl:variable>
/** <xsl:value-of select="$className"/>DataType ********************************************************/
private class <xsl:value-of select="$className"/>DataType
	extends BigIntegerDataType
	{
	<xsl:if test="@min">
	private BigInteger min_inclusive=new BigInteger(&quot;<xsl:value-of select="@min"/>&quot;);
	</xsl:if>
	<xsl:if test="@max">
	private BigInteger max_exclusive=new BigInteger(&quot;<xsl:value-of select="@max"/>&quot;);
	</xsl:if>
	
	<xsl:value-of select="$className"/>DataType()
		{
		
		}
	<xsl:if test="@min">
	@Override
	public BigInteger getMinInclusive()
		{
		return this.min_inclusive;
		}
	</xsl:if>
	
	<xsl:if test="@max">
	@Override
	public BigInteger getMaxExclusive()
		{
		return this.max_exclusive;
		}
	</xsl:if>
	}
private <xsl:value-of select="$className"/>DataType dataType = new  <xsl:value-of select="$className"/>DataType();

/*********************************************************************************************************/
</xsl:template>


<xsl:template match="EDataType[@type='decimal']">
<xsl:variable name="className"><xsl:apply-templates select=".." mode="localName"/></xsl:variable>
/** <xsl:value-of select="$className"/>DataType ********************************************************/
private class <xsl:value-of select="$className"/>DataType
	extends BigDecimalDataType
	{
	<xsl:if test="@min">
	private BigDecimal min_inclusive=new BigDecimal(&quot;<xsl:value-of select="@min"/>&quot;);
	</xsl:if>
	<xsl:if test="@max">
	private BigDecimal max_inclusive=new BigDecimal(&quot;<xsl:value-of select="@max"/>&quot;);
	</xsl:if>
	
	<xsl:value-of select="$className"/>DataType()
		{
		
		}
	<xsl:if test="@min">
	@Override
	public BigInteger getMinInclusive()
		{
		return this.min_inclusive;
		}
	</xsl:if>
	
	<xsl:if test="@max">
	@Override
	public BigInteger getMaxInclusive()
		{
		return this.max_inclusive;
		}
	</xsl:if>
	}
private <xsl:value-of select="$className"/>DataType dataType = new  <xsl:value-of select="$className"/>DataType();

/*********************************************************************************************************/
</xsl:template>

<xsl:template match="EDataType">
<xsl:message terminate="yes">DataType @type=<xsl:value-of select="@type"/> not implemented</xsl:message>
</xsl:template>

<xsl:template match="EAttribute">
<xsl:variable name="className"><xsl:apply-templates select="." mode="localName"/></xsl:variable>
		/** data property */
		private class <xsl:value-of select="$className"/>
			extends AbstractDataProperty
			{
			<xsl:choose>
			  <xsl:when test="EDataType">
			    <xsl:apply-templates select="EDataType"/>
			  </xsl:when>
			  <xsl:otherwise>
			     /** data type generated as default */
			     StringDataType dataType=new StringDataType();
			  </xsl:otherwise>
			</xsl:choose>
			
			
			<xsl:value-of select="$className"/>()
				{
				<xsl:if test="@icon">
				super._icon=AbstractOntNode.loadIcon(&quot;<xsl:value-of select="@icon"/>&quot;);
				</xsl:if>
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
				<xsl:if test="@icon">
				super._icon=AbstractOntNode.loadIcon(&quot;<xsl:value-of select="@icon"/>&quot;);
				</xsl:if>
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
	
	<!-- create the enums if needed -->
	<xsl:apply-templates select="EAttribute/EDataType[@type='enum']" mode="enum-decl"/>
	
	<xsl:apply-templates select="EAttribute|EReference"/>
	
	/**
	 *  InstanceOf<xsl:value-of select="$className"/>TableModel
	 */ 
	@SuppressWarnings("serial")
	private class  InstanceOf<xsl:value-of select="$className"/>TableModel
		extends	SimpleInstanceTableModel&lt;InstanceOf<xsl:value-of select="$className"/>&gt;
		{
		private List&lt;DataProperty&gt; columns=new ArrayList&lt;DataProperty&gt;();
		InstanceOf<xsl:value-of select="$className"/>TableModel()
			{
			for(OntProperty p:<xsl:value-of select="$className"/>.this.getProperties())
				{
				if(!p.isDataProperty()) continue;
				DataProperty dp=p.asDataProperty();
				if(dp.getMaxCardinality()&gt;1 || dp.getMaxCardinality()==-1) continue;
				this.columns.add(dp);
				}
			}
		@Override
		public OntClass getOntClass()
			{
			return <xsl:value-of select="$className"/>.this;
			}
		@Override
		public List&lt;DataProperty&gt; getDataProperties()
			{
			return this.columns;
			}
		}
	
	/**
	 *  Instance
	 *
	 */ 
	private class InstanceOf<xsl:value-of select="$className"/>
		extends AbstractInstance
		{
		<xsl:for-each select="EAttribute|EReference">
		<xsl:variable name="propName"><xsl:apply-templates select="." mode="localName"/></xsl:variable>
		<xsl:choose>
		  <xsl:when test="not(@maxCardinality) or number(@maxCardinality)&lt;2">
		  	Object v_<xsl:value-of select="$propName"/>=null;
		  </xsl:when>
		  <xsl:otherwise>
		  	List&lt;Object&gt; v_<xsl:value-of select="$propName"/>=new ArrayList&lt;Object&gt;();
		  </xsl:otherwise>
		</xsl:choose>
		</xsl:for-each>
		InstanceOf<xsl:value-of select="$className"/>()
		 	{
		 	}
		@Override
		public Object get(OntProperty property)
			{
			<xsl:for-each select="EAttribute|EReference">
			<xsl:variable name="propName"><xsl:apply-templates select="." mode="localName"/></xsl:variable>
			<xsl:if test="position()&gt;1">else</xsl:if> if(property==<xsl:value-of select="$className"/>.this.<xsl:value-of select="concat('m_',$propName)"/>)//warning using '==' , not 'equals'
				{
				return this.v_<xsl:value-of select="$propName"/>;
				}
			</xsl:for-each>
			throw new IllegalStateException("undefined property "+property.getLocalName());
			}
		@Override
		public Object getId()
			{
			return get(<xsl:value-of select="$className"/>.this.idProperty);
			}
		
		@Override
		public OntClass getOntClass()
			{
			return <xsl:value-of select="$className"/>.this;
			}
		void write(XMLStreamWriter w) throws XMLStreamException
			{
			w.writeStartElement(getOntClass().getLocalName());
			<xsl:for-each select="EAttribute">
			<xsl:variable name="propName"><xsl:apply-templates select="." mode="localName"/></xsl:variable>
			<xsl:choose>
			  <xsl:when test="not(@maxCardinality) or number(@maxCardinality)&lt;2">
			  //<xsl:value-of select="$className"/>.this.<xsl:value-of select="concat('m_',$propName)"/>==null
			  if(this.v_<xsl:value-of select="$propName"/>!=null)
			  	{
			  	w.writeStartElement(<xsl:value-of select="$className"/>.this.<xsl:value-of select="concat('m_',$propName)"/>.getLocalName());
			  	w.writeCharacters(String.valueOf(this.v_<xsl:value-of select="$propName"/>));
			  	w.writeEndElement();
			  	}
			  else
			  	{
			  	//TODO write nothing but could be xsi:nil
			  	}
			  </xsl:when>
			  <xsl:otherwise>
			  for(Object item: v_<xsl:value-of select="$propName"/>)
		  		{
		  		w.writeStartElement(<xsl:value-of select="$className"/>.this.<xsl:value-of select="concat('m_',$propName)"/>.getLocalName());
			  	w.writeCharacters(String.valueOf(o));
			  	w.writeEndElement();
		  		}
			  </xsl:otherwise>
			</xsl:choose>
			//TODO reference !!
			</xsl:for-each>
			w.writeEndElement();
			}
		}
	
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
		
		<xsl:if test="@icon">
		super._icon=AbstractOntNode.loadIcon(&quot;<xsl:value-of select="@icon"/>&quot;);
		</xsl:if>
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
	
	@Override
	public Instance parseInstance(XMLEventReader r,StartElement e) throws XMLStreamException
		{
		InstanceOf<xsl:value-of select="$className"/> instance=new InstanceOf<xsl:value-of select="$className"/>();
		XMLEvent evt;
		int depth=0;
		<xsl:for-each select="EAttribute|EReference">
		<xsl:variable name="propName"><xsl:apply-templates select="." mode="localName"/></xsl:variable>
		int <xsl:value-of select="concat('count_',$propName)"/>=0;
		</xsl:for-each>
		while(r.hasNext())
			{
			evt=r.nextEvent();
			if(evt.isStartElement())
				{
				String propName= evt.asStartElement().getName().getLocalPart();
				<xsl:for-each select="EAttribute|EReference">
				<xsl:variable name="propName"><xsl:apply-templates select="." mode="localName"/></xsl:variable>
				<xsl:if test="position()&gt;1">else</xsl:if> if(propName.equals(this.<xsl:value-of select="concat('m_',$propName)"/>.getLocalName()))
					{
					<xsl:value-of select="concat('count_',$propName)"/>++;
					Object v= this.<xsl:value-of select="concat('m_',$propName)"/>.parseInstance(r,e);
					<xsl:choose>
					  <xsl:when test="not(@maxCardinality) or number(@maxCardinality)&lt;2">
					  	instance.v_<xsl:value-of select="$propName"/>=v;
					  </xsl:when>
					  <xsl:otherwise>
					  	instance.v_<xsl:value-of select="$propName"/>.add(v);
					  </xsl:otherwise>
					</xsl:choose>
					}
				</xsl:for-each>
				else
					{
					throw new XMLStreamException("Unknown property "+propName);
					}
				}
			else if(evt.isEndElement() &amp;&amp;
				evt.asEndElement().getName().getLocalPart().equals(getLocalName()))
				{
				break;
				}
			else if(evt.isEndDocument())
				{
				throw new XMLStreamException("Unexpected end of document!");
				}
			}
		return instance;
		}
	
	@Override
	public void writeInstance(XMLStreamWriter w,Instance instance) throws XMLStreamException
		{
		InstanceOf<xsl:value-of select="$className"/>.class.cast(instance).write(w);
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

@SuppressWarnings("serial")
class Frame extends JFrame
	{
	private XmlDataStore dataStore;
	private JPanel contentPane;
	private Frame(XmlDataStore dataStore)
		{
		super("Frame");
		this.dataStore=dataStore;
		this.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
		this.addWindowListener(new WindowAdapter()
			{
			@Override
			public void windowClosing(WindowEvent e)
				{
				doMenuClosing();
				}
			});
		this.addWindowListener(new WindowAdapter()
			{
			@Override
			public void windowOpened(WindowEvent e)
				{
				JComponent j=createListClassesPane();
				Frame.this.contentPane.add(j,BorderLayout.CENTER);
				Frame.this.removeWindowListener(this);
				}
			});
		
		this.contentPane=new JPanel(new BorderLayout(5,5));
		this.contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(this.contentPane);
		
		
		JMenuBar bar=new JMenuBar();
		setJMenuBar(bar);
		JMenu menu=new JMenu("File");
		bar.add(menu);
		AbstractAction action;
		
		action=new AbstractAction("Quit")
			{
			@Override
			public void actionPerformed(ActionEvent e)
				{
				doMenuClosing();
				}
			};
		menu.add(action);
		}
		
	Ontology getOntology()
		{
		return getDataStore(). getOntology();
		}
	
	XmlDataStore getDataStore()
		{
		return this.dataStore;
		}
	
	private void doMenuClosing()
		{
		this.dataStore.close();
		this.setVisible(false);
		this.dispose();
		}
	
	private JComponent createListClassesPane()
		{
		JPanel pane=new JPanel(new BorderLayout(5,5));
		TableModel tm=new OntClassTableModel(getOntology().getClasses());
		final JTable table=new JTable(tm);
		JScrollPane scroll=new JScrollPane(table);
		pane.add(scroll,BorderLayout.CENTER);
		final AbstractAction action1=new AbstractAction("List Instances")
			{
			@Override
			public void actionPerformed(ActionEvent ae)
				{
				int i=table.getSelectedRow();
				if(i==-1) return;
				OntClass o=OntClassTableModel.class.cast(table.getModel()).getItemAt(i);
				JOptionPane.showMessageDialog(table,o);
				} 
			};
		action1.setEnabled(false);
		final AbstractAction action2=new AbstractAction("New Instance")
			{
			@Override
			public void actionPerformed(ActionEvent ae)
				{
				int i=table.getSelectedRow();
				if(i==-1) return;
				OntClass o=OntClassTableModel.class.cast(table.getModel()).getItemAt(i);
				JOptionPane.showMessageDialog(table,o);
				} 
			};
		action2.setEnabled(false);
		
		
		table.getSelectionModel().addListSelectionListener(new ListSelectionListener()
			{
			@Override
			public void valueChanged(ListSelectionEvent e)
				{
				action1.setEnabled(table.getSelectedRow()!=-1);
				action2.setEnabled(table.getSelectedRow()!=-1);
				}
			});
		table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		JPanel top=new JPanel(new FlowLayout(FlowLayout.LEADING));
		pane.add(top,BorderLayout.NORTH);
		top.add(new JButton(action1));
		top.add(new JButton(action2));
		return pane;
		}
	
	
	public static void main(String[] args) throws Exception
		{
		JFrame.setDefaultLookAndFeelDecorated(true);
		JDialog.setDefaultLookAndFeelDecorated(true);
		int optind=0;
		while(optind&lt; args.length)
			{
			if(args[optind].equals("-h") ||
			   args[optind].equals("-help") ||
			   args[optind].equals("--help"))
				{
				System.err.println("Options:");
				System.err.println(" -h help; This screen.");
				System.err.println(" -stdin read config from stdin");
				return;
				}
			else if(args[optind].equals("-stdin"))
				{
				
				}
			else if(args[optind].equals("--"))
				{
				optind++;
				break;
				}
			else if(args[optind].startsWith("-"))
				{
				System.err.println("Unknown option "+args[optind]);
				return;
				}
			else 
				{
				break;
				}
			++optind;
			}
		
		Ontology ontology=new OntologyImpl();
		XmlDataStore dataStore=new XmlDataStore(ontology,new File("/tmp/jeter.xml"));
		Dimension screen=Toolkit.getDefaultToolkit().getScreenSize();
		final Frame app=new Frame(dataStore);
		app.setBounds(50, 50, screen.width-100, screen.height-100);
		SwingUtilities.invokeAndWait(new Runnable()
			{
			@Override
			public void run()
				{
				app.setVisible(true);
				};
			});
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
	return <xsl:value-of select="."/>;
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

