<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        xmlns:d="http://exslt.org/dates-and-times"
        version='1.0'
        >
<xsl:output method="text" />

<xsl:key name="nodeids" match="*" use="@id" />

<xsl:template match="/">
/**


The MIT License (MIT)

Copyright (c) <xsl:value-of select="d:year()"/> Pierre Lindenbaum

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


**/
import java.io.*;
import java.util.*;
import javax.xml.stream.*;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;
import javax.xml.namespace.*; 
import javax.swing.*;


<xsl:apply-templates select="workflow"/>
</xsl:template>

<xsl:template match="workflow">

@javax.annotation.Generated("xslt-sandbox/worklow")
public class Workflow
	{
	/** XMLEventFactory used to serialize data as XML */
	private static XMLEventFactory xmlEventFactory = XMLEventFactory.newInstance();
	/** Logger */
	private static final Logger LOG=Logger.getLogger("Workflow");

	/** Exception */
	private static class WorkflowException extends Exception
		{
		public WorkflowException() {}
		public WorkflowException(Throwable t) {super(t);}
		public WorkflowException(String s) {super(s);}
		}
	
	private static interface DataType
		extends Comparator&lt;Object&gt;
		{
		public Class&lt;?&gt; getDataClass();
		public String getName();
		public DataValue parseString(String s);
		public int compare(Object o1,Object o2);
		public Comparator&lt;Object&gt; createComparator();
		}
	
	private static abstract class AbstractDataType
		implements DataType
		{
		private Class&lt;?&gt; _class;
		protected AbstractDataType(Class&lt;?&gt; c)
			{
			this._class = c;
			}
		@Override
		public Class&lt;?&gt; getDataClass()
			{
			return this._class;
			}
		@Override
		public String getName()
			{
			return getDataClass().getName();
			}
		@Override
		public int hashCode()
			{
			return getDataClass().hashCode();
			}
		@Override
		public boolean equals(Object o)
			{
			return this==o;
			}
		@Override
		public String toString()
			{
			return getName();
			}
		@Override
		public Comparator&lt;Object&gt; createComparator()
			{
			return new Comparator&lt;Object&gt;()
				{
				@Override
				public int compare(Object o1,Object o2)
					{
					return AbstractDataType.this.compare(o1,o2);
					}
				};
			}
		}
	
	private static final  DataType stringType = new AbstractDataType(String.class)
		{
		@Override
		public int compare(Object o1,Object o2)
			{
			if(o1==null)
				{
				return o2==null?0:-1;
				}
			return String.class.cast(o1).compareTo(String.class.cast(o2));
			}
		@Override
		public DataValue parseString(String s)
			{
			return new DefaultDataValue(s);
			}
		};
	
	private static final  DataType intType = new AbstractDataType(Integer.class)
		{
		@Override
		public int compare(Object o1,Object o2)
			{
			if(o1==null)
				{
				return o2==null?0:-1;
				}
			return Integer.class.cast(o1).compareTo(Integer.class.cast(o2));
			}
			
		@Override
		public DataValue parseString(String s)
			{
			return new DefaultDataValue(this,new Integer(s));
			}
		};
	
	private static final  DataType doubleType = new AbstractDataType(Double.class)
		{
		@Override
		public int compare(Object o1,Object o2)
			{
			if(o1==null)
				{
				return o2==null?0:-1;
				}
			return Double.class.cast(o1).compareTo(Double.class.cast(o2));
			}
			
		@Override
		public DataValue parseString(String s)
			{
			return new DefaultDataValue(this,new Double(s));
			}
		};
		
	private static DataType getDataTypeByName(String typeName)
		{
		if(typeName==null) return Workflow.stringType;
		typeName=typeName.toLowerCase();
		if(typeName.equals("int") || typeName.equals("integer")) return Workflow.intType;
		if(typeName.equals("double") || typeName.equals("float")) return Workflow.doubleType;
		return Workflow.stringType;
		}
	
	private static interface DataValue extends Comparable&lt;DataValue&gt;
		{
		public DataType getDataType();
		public Object getValue();
		public void writeXml(XMLEventWriter w) throws XMLStreamException;
		}
	
	/** default implementation of DataValue */
	private static class DefaultDataValue
		implements DataValue
		{
		DataType type;
		Object value;
		DefaultDataValue(DataType type,Object value)
			{
			this.type=type;
			this.value=value;
			}
		
		DefaultDataValue(CharSequence value)
			{
			this(Workflow.stringType,value.toString());
			}
		DefaultDataValue(int value)
			{
			this(Workflow.intType,value);
			}		
		DefaultDataValue(double value)
			{
			this(Workflow.doubleType,value);
			}
		
		public DataType getDataType()
			{
			return this.type;
			}
		public Object getValue()
			{
			return this.value;
			}
		@Override
		public int hashCode()
			{
			return 31*getDataType().hashCode() + 
				(getValue()==null?0:getValue().hashCode());
			}
		
		public boolean equals(Object o)
			{
			if(o==this) return true;
			if(o==null || !(o instanceof DataValue)) return false;
			DataValue other=DataValue.class.cast(o);
			if(!getDataType().equals(other.getDataType())) return false;
			if(this.getValue()==null &amp;&amp; other.getValue()==null) return true;
			return getValue().equals(other.getValue());
			}
		
		public int compareTo(DataValue dv)
			{
			return getDataType().compare(this.getValue(),dv.getValue());
			}
		@Override
		public String toString()
			{
			return String.valueOf(this.getValue());
			}
		
		@Override
		public void writeXml(XMLEventWriter w) throws XMLStreamException
			{
			//TODO
			}
		}
	
	private static interface Column 
		{
		public String getName();
		public DataType getDataType();
		public void writeXml(XMLEventWriter w) throws XMLStreamException;
		}
	
	
	private static class DefaultColumn implements Column
		{
		private DataType type;
		private String name;
		DefaultColumn(DataType type,String name)
			{
			this.type=type;
			this.name=name;
			}
		public DataType getDataType()
			{
			return this.type;
			}
		public String getName()
			{
			return this.name;
			}
		@Override
		public void writeXml(XMLEventWriter w) throws XMLStreamException
			{
			QName qName = new QName("column");
			w.add( xmlEventFactory.createStartElement(qName,null,null) );
			w.add( xmlEventFactory.createCharacters(getName()) );
			w.add( xmlEventFactory.createEndElement(qName,null) );
			}	
		}

	
	private static interface ColumnList extends Iterable&lt;Column&gt;
		{
		public int size();
		public Column get(int index);
		public boolean contains(String name);
		public int findColumnIndex(String name);
		public Column findColumnByName(String name);
		public void writeXml(XMLEventWriter w) throws XMLStreamException;
		}
	
	private static abstract class AbstractColumnList implements ColumnList
		{
		public abstract List&lt;Column&gt; getColumns();
		@Override
		public int size()
			{
			return this.getColumns().size();
			}
		@Override
		public Column get(int index)
			{
			return this.getColumns().get(index);
			}
		@Override
		public boolean contains(String name)
			{
			return findColumnIndex(name)!=-1;
			}
		@Override
		public int findColumnIndex(String name)
			{
			for(int i=0;i&lt;this.size();++i)
				if(get(i).getName().equals(name))
					return i;
			return -1;
			}
		@Override
		public Column findColumnByName(String name)
			{
			int idx = findColumnIndex(name);
			return idx==-1?null:get(idx);
			}
		@Override
		public  Iterator&lt;Column&gt; iterator()
			{
			return getColumns().iterator();
			}
		@Override
		public void writeXml(XMLEventWriter w) throws XMLStreamException
			{
			for(Column c:this) c.writeXml(w);
			}
		}
		
	private static class DefaultColumnList extends AbstractColumnList
		{
		private  List&lt;Column&gt; columns = null;
		
		DefaultColumnList()
			{
			this.columns = new ArrayList&lt;Column&gt;();
			}
		DefaultColumnList(Column...cols)
			{
			this.columns = Arrays.asList(cols);
			}
		@Override
		public List&lt;Column&gt; getColumns()
			{
			return this.columns;
			}
		}
	
	
	private static interface DataRow extends Iterable&lt;DataValue&gt;
		{
		public ColumnList getColumnList();
		public DataValue get(int i);
		public int size();
		public void writeXml(XMLEventWriter w) throws XMLStreamException;
		}
	
	private static class DefaultRow implements DataRow
		{
		private ColumnList columns;
		private List&lt;DataValue&gt; values = null;
		DefaultRow( ColumnList columns, List&lt;DataValue&gt; values)
			{
			this.columns = columns;
			this.values = Collections.unmodifiableList(values);
			}
		DefaultRow( ColumnList columns, DataValue...values)
			{
			this(columns,Arrays.asList(values));
			}
		@Override
		public ColumnList getColumnList()
			{
			return this.columns;
			}
		@Override
		public DataValue get(int i)
			{
			return this.values.get(i);
			}
		@Override
		public int size()
			{
			return this.values.size();
			}
		@Override
		public Iterator&lt;DataValue&gt; iterator()
			{
			return this.values.iterator();
			}
		@Override
		public int hashCode()
			{
			return this.columns.hashCode()* 31 + this.values.hashCode();
			}
		
		@Override
		public void writeXml(XMLEventWriter w) throws XMLStreamException
			{
			QName qName = new QName("row");
			w.add( xmlEventFactory.createStartElement(qName,null,null) );
			for(DataValue dv : this)
				{
				dv.writeXml(w);
				}
			w.add( xmlEventFactory.createEndElement(qName,null) );
			}	
			
		}
	

	


	public class ExecutionContext
		{
		}

	
	
	private class RowEvent
		{
		}

	private interface RowListener
		{
		public void handle(RowEvent evt);
		}
	
	private class RowListenerSupport
		{
		protected List&lt;RowListener&gt; listeners = new ArrayList&lt;RowListener&gt;();
		void addRowListener(RowListener listener)
			{
			this.listeners.add(listener);
			}
		}
	
	private class Filter
		extends RowListenerSupport
		implements RowListener
		{
		public RowEvent wrap(RowEvent evt)
			{
			return evt;
			}
		
		
		@Override
		public void handle(RowEvent evt)
			{
			if(evt==null) return;
			evt = wrap(evt);
			if(evt==null) return;
			for(RowListener listener: super.listeners)
				{
				listener.handle(evt);
				}
			}
		}
		
	private static interface Named
		{
		public String getId();
		public String getLabel();
		public String getDescription();
		}
	
	/** implementation of Named */
	private static abstract class AbstractNamed
		implements Named
		{
		@Override
		public abstract String getId();
		@Override
		public String getLabel()
			{
			return this.getId();
			}
		@Override
		public String getDescription()
			{
			return this.getLabel();
			}
		@Override
		public int hashCode()
			{
			return getId().hashCode();
			}
		@Override
		public String toString()
			{
			return getLabel();
			}
		}	
	
	public static interface NodeModel extends Named
		{
		}
	
	public static interface ProducingDataNodeModel extends NodeModel
		{
		public void execute(ExecutionContext context) throws WorkflowException;
		}
	
	public static interface ConsummingDataNodeModel extends NodeModel
		{

		}
	
	private abstract class OutputSlot extends AbstractNamed
		{
		public boolean isDefault() { return false;}
		List&lt;ConsummingSlot&gt; consummers = new ArrayList&lt;ConsummingSlot&gt;();
		
		List&lt;ConsummingSlot&gt; getConsummers()
			{
			return this.consummers;
			}
		
		public void fireDataRow(ExecutionContext context,final DataRow row)  throws WorkflowException
			{
			for(ConsummingSlot c:getConsummers())
				{
				c.handleDataRow(context,row);
				}
			}
		}
	
	private abstract class ConsummingSlot extends AbstractNamed
		{
		public abstract void handleDataRow(ExecutionContext context,final DataRow row)  throws WorkflowException;
		}
	
	
	abstract class AbstractConsummingDataNodeModel
		extends AbstractNamed
		implements ConsummingDataNodeModel
		{
		protected AbstractConsummingDataNodeModel()
			{
			}
		
		}  
	
	abstract class AbstractProducingDataNodeModel
		extends AbstractNamed
		implements ProducingDataNodeModel
		{
		protected AbstractProducingDataNodeModel()
			{
			}
		
		public abstract List&lt;OutputSlot&gt; getOutputSlots();
	
		public OutputSlot getOutputSlotByName(String name)
			{
			OutputSlot sel = null;
			for(OutputSlot slot: getOutputSlots())
				{
				if(slot.getLabel().equals(name))
					{
					if( sel == null ) throw new RuntimeException("");
					sel = slot;
					}
				}
			if( sel == null ) throw new RuntimeException("");
			return sel;
			}

		public OutputSlot getDefaultOutputSlot() 
			{
			if(  getOutputSlots().isEmpty() )
				{
				throw new RuntimeException("");
				}
			else if( getOutputSlots().size() == 1 )
				{
				return getOutputSlots().get(0);
				}
			else
				{
				OutputSlot sel = null;
				for(OutputSlot slot: getOutputSlots())
					{
					if(slot.isDefault())
						{
						if( sel == null ) throw new RuntimeException("");
						sel = slot;
						}
					}
				if( sel == null ) throw new RuntimeException("");
				return sel;
				}
			}
		}
	

	
	private abstract class Pipeline
		extends AbstractNamed
		{
		List&lt;Object&gt; inputs= new ArrayList&lt;Object&gt;();
		List&lt;Object&gt; outputs= new ArrayList&lt;Object&gt;();		
			
		abstract public Pipeline build();
		}
	
	private Pipeline buildWorkflow()
		{
		<xsl:if test="count(pipeline)!=1">
			<xsl:message terminate="yes">
			workflow should contain one and only one &lt;pipeline&gt;
			</xsl:message>
		</xsl:if>
		<xsl:apply-templates select="pipeline"/>
		return <xsl:apply-templates select="pipeline" mode="id"/>;
		}
	
	private Workflow()
		{
		final SimpleDateFormat datefmt=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		LOG.setUseParentHandlers(false);
		LOG.addHandler(new Handler()
			{
			@Override
			public void publish(LogRecord record) {
				Date now = new Date(record.getMillis());
				System.err.print("["+record.getLevel()+"]");
				System.err.print(" ");
				System.err.print(datefmt.format(now));
				System.err.print(" \"");
				System.err.print(record.getMessage());
				System.err.println("\"");
				if(record.getThrown()!=null)
					{
					record.getThrown().printStackTrace(System.err);
					}
				}
			
			@Override
			public void flush() {
				System.err.flush();
				}
			
			@Override
			public void close() throws SecurityException {
				
				}
			});
		}
		
	private static class Frame extends JFrame
		{
		<xsl:for-each select="param">
		private JTextField <xsl:apply-templates select="." mode="id"/> = null;
		</xsl:for-each>
		
		private void install()
			{
			JLabel label=null;
			<xsl:for-each select="param">
			label = new JLabel("<xsl:value-of select="@name"/>");
			</xsl:for-each>
			}
		}	
	
	<xsl:for-each select="param">
	/** <xsl:value-of select="@name"/> */
	private DataValue <xsl:apply-templates select="." mode="id"/> = null;
	</xsl:for-each>
	
	private int readConfig(File f)
		{
		try
			{
			FileInputStream in =new FileInputStream(f);
			Properties props=new Properties();
			if(f.getName().endsWith(".xml"))
				{
				props.loadFromXML(in);
				}
			else
				{
				props.load(in);
				}
			in.close();
			<xsl:for-each select="param">
			if(<xsl:apply-templates select="." mode="id"/>==null &amp;&amp; props.containsKey("<xsl:value-of select="@name"/>"))
				{
				<xsl:apply-templates select="." mode="id"/> = getDataTypeByName("<xsl:apply-templates select="." mode="datatype"/>").
					parseString(props.getProperty("<xsl:value-of select="@name"/>"));
				}
			</xsl:for-each>
			return 0;
			}
		catch(Exception err)
			{
			return -1;
			}
		}
	
	private void usage(PrintWriter pw)
		{
		pw.println("Pierre Lindenbaum PhD. <xsl:value-of select="d:year()"/>");
		pw.println("Options:");
		pw.println(" -h help; This screen.");
		<xsl:for-each select="param">
		pw.println(" --<xsl:value-of select="@name"/>");
		</xsl:for-each>
		pw.println();
		pw.flush();
		}
	
	private int instanceMain(String args[])
		{
		int optind=0;
		while(optind &lt; args.length)
			{
			if(args[optind].equals("-h") ||
			   args[optind].equals("-help") ||
			   args[optind].equals("--help"))
				{
				usage(new PrintWriter(System.out));
				return 0;
				}
			else if(args[optind].equals("--config"))
				{
				//TODO
				}
			<xsl:for-each select="param">
			else if(args[optind].equals("--<xsl:value-of select="@name"/>))
				{
				this.<xsl:apply-templates select="." mode="id"/> = getDataTypeByName("<xsl:apply-templates select="." mode="datatype"/>").parseDataValue(args[++optind]);
				}
			</xsl:for-each>
			else if(args[optind].equals("--"))
				{
				optind++;
				break;
				}
			else if(args[optind].startsWith("-"))
				{
				System.err.println("Unknown option "+args[optind]);
				return -1;
				}
			else 
				{
				break;
				}
			++optind;
			}
		<xsl:for-each select="param">
		if(<xsl:apply-templates select="." mode="id"/> == null )
			{
			<xsl:choose>
				<xsl:when test="@default">
				 	<xsl:apply-templates select="." mode="id"/> = parseDataValue("<xsl:value-of select="@default"/>");
				</xsl:when>
				<xsl:otherwise>
					LOG.exiting("Workflow","Main","variable <xsl:value-of select="@name"/> was not set by user");
					return -1;
				</xsl:otherwise>
			</xsl:choose>
			}
		</xsl:for-each>
		
		return 0;
		}
	
	private void instanceMainWithExit(String args[])
		{
		System.exit(instanceMain(args));
		}
		
	
	public static void main(String args[])
		{
		new Workflow().instanceMainWithExit(args);
		}
	}
</xsl:template>

<xsl:template match="file-reader">

FileReaderModel <xsl:value-of select="generate-id()"/> = new FileReaderModel();
this.inputs.add(<xsl:value-of select="generate-id()"/>);

</xsl:template>


<xsl:template match="file-writer">
FileWriterNode <xsl:value-of select="generate-id()"/> = new FileWriterNode()
	{


	};
this.outputs.add(<xsl:value-of select="generate-id()"/>);
</xsl:template>

<xsl:template match="cut">
CutNode <xsl:value-of select="generate-id()"/> = new CutNode()
	{
	
	};

</xsl:template>


<xsl:template match="pipeline">
Pipeline <xsl:apply-templates select="." mode="id"/> = new Pipeline() 
	{
	@Override
	public Pipeline build()
		{
		<xsl:apply-templates select="*"/>
		return this;
		}
	<xsl:apply-templates select="." mode="named"/>
	};

</xsl:template>

<xsl:template match="add-column">
class AddColumnNodeModel
	{
	
	}

</xsl:template>


<xsl:template match="read-fasta">
abstract class ReadFasta extends AbstractProducingDataNodeModel
	{
	private final ColumnList  cols = new DefaultColumnList(
			new DefaultColumn(stringType,"Name"),
			new DefaultColumn(stringType,"Sequence")
			);
	private final OutputSlot outputSlot= new OutputSlot()
		{
		<xsl:apply-templates select="." mode="named"/>
		};
	
	public 	ColumnList getColumns()
		{
		return this.cols;
		}
	
	BufferedReader open()
		{
		return null;
		}
	@Override
	public void execute(ExecutionContext context) throws WorkflowException
		{
		try
			{
			String line =null;
			String name=null;
			StringBuilder seq = new StringBuilder();
			BufferedReader r= open();
			/* fireHeader(cols,null); */
			for(;;)
				{
				line= r.readLine();
				if( line == null || line.startsWith(">") )
					{
					if(seq!=null)
						{
						DataRow newrow = new DefaultRow(
							this.getColumns(),
							new DefaultDataValue(name),
							new DefaultDataValue(seq)
							);
						this.outputSlot.fireDataRow(context,newrow); 
						}
					if(line==null) break;
					name=line;
					seq=new StringBuilder();
					continue;
					}
				seq.append(line);
				}
			}
		catch(IOException err)
			{
			throw new WorkflowException(err);
			}
		/* fireFooter(cols,null); */
		}
	
	
	@Override
	public List&lt;OutputSlot&gt; getOutputSlots()
		{
		return Collections.singletonList(this.outputSlot);
		}
	}
ReadFasta <xsl:apply-templates select="." mode="id"/> = new ReadFasta()
	{
	<xsl:apply-templates select="." mode="named"/>
	};
this.inputs.add(<xsl:apply-templates select="." mode="id"/>);
</xsl:template>

<xsl:template match="write-fasta">
abstract class WriteFasta extends AbstractConsummingDataNodeModel
	{
			
	
	}
WriteFasta <xsl:apply-templates select="." mode="id"/> = new WriteFasta()
	{
	<xsl:apply-templates select="." mode="named"/>
	};
this.outputs.add(<xsl:apply-templates select="." mode="id"/>);
</xsl:template>


<xsl:template match="output">
OutputSlot <xsl:apply-templates select="." mode="id"/> = new OutputSlot();
<xsl:choose>
	<xsl:when test="@name">
		<xsl:apply-templates select="." mode="id"/>.setName("<xsl:apply-templates select="." mode="escape"/>");
	</xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates select="." mode="id"/>.setName("<xsl:apply-templates select="generate-id(.)"/>");
	</xsl:otherwise>
</xsl:choose>

<xsl:choose>
	<xsl:when test="@default='true'">
		<xsl:apply-templates select="." mode="id"/>.setDefault(true);
	</xsl:when>
	<xsl:otherwise>
	</xsl:otherwise>
</xsl:choose>


</xsl:template>

<xsl:template match="*" mode="input-slot">
<xsl:choose>
	<xsl:when test="input[@url]">
	</xsl:when>
	<xsl:when test="input[@slot and @name]">
		<xsl:variable name="parent" select="key('nodeids',@slot)"/>
		<xsl:if test="not($parent)">
			<xsl:message terminate="yes">Cannot get node id defined by slot=<xsl:value-of select="@slot"/></xsl:message>
		</xsl:if>
		<xsl:apply-templates select="$parent" mode="id"/>
		<xsl:text>.getOutputSlotByName("</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>").add(</xsl:text>
		<xsl:apply-templates select="." mode="id"/>
		<xsl:text>);
		</xsl:text>
	</xsl:when>
	<xsl:when test="input[@slot]">
		<xsl:variable name="parent" select="key('nodeids',@slot)"/>
		<xsl:if test="not($parent)">
			<xsl:message terminate="yes">Cannot get node id defined by slot=<xsl:value-of select="@slot"/></xsl:message>
		</xsl:if>
		<xsl:apply-templates select="$parent" mode="id"/>
		<xsl:text>.getDefaultOutputSlot().add(</xsl:text>
		<xsl:apply-templates select="." mode="id"/>
		<xsl:text>);
		</xsl:text>
	</xsl:when>
	<xsl:when test="./preceding-sibling::*[1]">
		<xsl:apply-templates select="./preceding-sibling::*[1]" mode="id"/>
		<xsl:text>.getDefaultOutputSlot().add(</xsl:text>
		<xsl:apply-templates select="." mode="id"/>
		<xsl:text>);
		</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:message terminate="yes">No input defined for <xsl:value-of select="name(.)"/></xsl:message>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="*" mode="id">
<xsl:value-of select="generate-id(.)"/>
</xsl:template>

<xsl:template match="*" mode="getid">
	@Override
	public String getId()
		{
		return "<xsl:value-of select="generate-id()"/>";
		}
</xsl:template>


<xsl:template match="*" mode="named">
	<xsl:apply-templates select="." mode="getid"/>
	<xsl:if test="@name">
	@Override
	public String getLabel()
		{
		return "<xsl:value-of select="@name"/>";
		}
	</xsl:if>
	<xsl:if test="@description">
	@Override
	public String getDescription()
		{
		return "<xsl:value-of select="@description"/>";
		}
	</xsl:if>	
</xsl:template>


<xsl:template match="text()" mode="escape">
<xsl:value-of select="."/>
</xsl:template>


</xsl:stylesheet>
