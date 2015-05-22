<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        version='1.0'
        >
<xsl:output method="text" />

<xsl:key name="nodeids" match="*" use="@id" />

<xsl:template match="/">
/**


The MIT License (MIT)

Copyright (c) 2015 Pierre Lindenbaum

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


<xsl:apply-templates select="workflow"/>
</xsl:template>

<xsl:template match="workflow">

@javax.annotation.Generated("xslt-sandbox/worklow")
public class Workflow
	{
	/** XMLEventFactory used to serialize data as XML */
	private static XMLEventFactory xmlEventFactory = XMLEventFactory newInstance();
	/** Logger */
	private static final Logger LOG=Logger.getLogger("Workflow");

	/** Exception */
	private static class WorkflowException extends Exception
		{
		WorkflowException() {}
		WorkflowException(Throwable t) {super(t);}
		WorkflowException(String s) {super(s);}
		}
	
	private static interface DataType
		extends Comparator&lt;Object&gt;
		{
		public Class&lt;?&gt; getDataClass();
		public String getName();
		public DataValue parseString(String s);
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
		
		}
	
	private static final  DataType stringType = new AbstractDataType(String.class)
		{
		@Override
		public int compare(Object o,Object o1) { return 0;}
		@Override
		public DataValue parseString(String s)
			{
			return new DefaultDataValue(s);
			}
		};
	
	private static final  DataType intType = new AbstractDataType(Integer.class)
		{
		@Override
		public int compare(Object o,Object o1) { return 0;}
		@Override
		public DataValue parse(String s)
			{
			return new DefaultDataValue(this,new Integer(s));
			}
		};
	
	private static final  DataType doubleType = new AbstractDataType(Double.class)
		{
		@Override
		public int compare(Object o1,Object o2) { return Double.class.cast(o1).compareTo(Double.class.cast(o2);}
		@Override
		public DataValue parse(String s)
			{
			return new DefaultDataValue(this,new Double(s));
			}
		};
		
	private static DataType getDataTypeByName(String typeName)
		{
		if(typeName==null) return stringType;
		typeName=typeName.toLowerCase();
		if(typeName.equals("int") || typeName.equals("integer")) return intType;
		if(typeName.equals("double") || typeName.equals("float")) return doubleType;
		return stringType;
		}
	
	private static interface DataValue extends Comparable&lt;DataValue&gt;
		{
		public DataType getDataType();
		public Object getValue();

		}
	
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
			this(stringType,value.toString());
			}
		DefaultDataValue(int value)
			{
			this(intType,value);
			}		
		DefaultDataValue(double value)
			{
			this(doubleType,value);
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
			if(getValue()==null &amp;&amp; other.getValue()==null) return true;
			return getValue().equals(other.getValue());
			}
		
		public int compareTo(DataValue dv)
			{
			return getDataType().compare(this.getValue(),dv.getValue());
			}
		
		}
	
	private static interface Column 
		{
		public String getName();
		public DataType getDataType();
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
		public void write(XMLEventWriter w) throws XMLStreamException
			{
			QName qName = new QName("column");
			w.add( xmlEventFactory.createStartElement(qName,null,null) );
			w.add( xmlEventFactory.createCharacters(getName()) );
			w.add( xmlEventFactory.createEndElement(qName,null);
			}	
		}

	
	private interface ColumnList extends Iterable&lt;Column&gt;
		{
		public int size();
		public Column get(int index);
		public boolean contains(String name);
		public int findColumnIndex(String name);
		public Column findColumnByName(String name);
		}
	
	private abstract class AbstractColumnList implements ColumnList
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
		public void write(XMLEventWriter w) throws XMLStreamException
			{
			for(Column c:this) c.write(w);
			}
		}
		
	private class DefaultColumnList extends AbstractColumnList
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
	
	
	private interface DataRow extends Iterable&lt;DataValue&gt;
		{
		public ColumnList getColumnList();
		public DataValue get(int i);
		public int size();
		public void write(XMLEventWriter w) throws XMLStreamException;
		}
	
	private class DefaultRow implements DataRow
		{
		private ColumnList columns;
		private List&lt;DataValue&gt; values = null;
		DefaultRow( ColumnList columns, List&lt;DataValue&gt; values)
			{
			this.columns = columns;
			this.values = Collections.unmodifiableList(values);
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
			
		public void write(XMLEventWriter w) throws XMLStreamException
			{
			QName qName = new QName("row");
			w.add( xmlEventFactory.createStartElement(qName,null,null) );
			for(DataValue dv : this)
				{
				dv.write(w);
				}
			w.add( xmlEventFactory.createEndElement(qName,null);
			}	
			
		}
	

	


	public class ExecutionContext
		{
		}

	public interface NodeModel
		{
		}
	
	public interface InputNodeModel extends NodeModel
		{
		public void execute(ExecutionContext context) throws WorkflowException;
		}
	
	public interface OutputNodeModel extends NodeModel
		{
		}
	
	public static abstract class AbstractOutputNodeModel
		implements OutputNodeModel
		{
		public abstract void execute(ExecutionContext context) throws WorkflowException;
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
	
	abstract class AbstractOutput
	{
	class OutputSlot
		{
		String name;
		boolean is_default;
		String getName() { return name;}
		boolean isDefault() { return is_default;}
		}
	
	abstract List&lt;OutputSlot&gt; getOutputSlots();
	
	OutputSlot getOutputSlotByName(String name)
		{
		OutputSlot sel = null;
		for(OutputSlot slot: getOutputSlots())
			{
			if(slot.getName().equals(name))
				{
				if( sel == null ) throw new RuntimeException("");
				sel = slot;
				}
			}
		if( sel == null ) throw new RuntimeException("");
		return sel;
		}

	OutputSlot getDefaultOutputSlot() 
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
	
	private static class Named
		{
		String id;
		String name;
		String description;
		}
	
	private abstract class Pipeline
		{
		List inputs= new ArrayList();
		List outputs= new ArrayList();		
			
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
		private JTextField <xsl:apply-templates select="." mode="id"> = null;
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
	private DataValue <xsl:apply-templates select="." mode="id"> = null;
	</xsl:for-each>
	
	private void readConfig(File f)
		{
		FileInputStream in =new FileInputStream(f);
		Properties props=new Properties();
		if(f.getName().endsWith(".xml"))
			{
			props.loadFromXML(in);
			}
		else
			{
			prpos.load(in);
			}
		in.close();
		<xsl:for-each select="param">
		if(<xsl:apply-templates select="." mode="id">==null &amp;&amp; props.containsKey("<xsl:value-of select="@name"/>"))
			{
			<xsl:apply-templates select="." mode="id"> = getDataTypeByName("<xsl:apply-templates select="." mode="datatype"/>").
				parseString(props.getProperty("<xsl:value-of select="@name"/>"));
			}
		</xsl:for-each>
		}
	
	private void usage(PrintWriter pw)
		{
		pw.println("Pierre Lindenbaum PhD. 2015");
		pw.println("Options:");
		pw.println(" -h help; This screen.");
		<xsl:for-each select="param">
		pw.println(" --<xsl:value-of select="@name"/>");
		</xsl:for-each>
		pw.println();
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

				return 0;
				}
			<xsl:for-each select="param">
			else if(args[optind].equals("--<xsl:value-of select="@name"/>))
				{
				this.<xsl:apply-templates select="." mode="id"> = getDataTypeByName("<xsl:apply-templates select="." mode="datatype"/>").parseDataValue(args[++optind]);
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
		if(<xsl:apply-templates select="." mode="id"> == null )
			{
			<xsl:choose>
				<xsl:when test="@default">
				 	<xsl:apply-templates select="." mode="id"> = parseDataValue("<xsl:value-of select="@default"/>");
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
	};

</xsl:template>

<xsl:template match="add-column">
class AddColumnNodeModel
	{
	
	}

</xsl:template>


<xsl:template match="read-fasta">
class ReadFasta
	{
	private final ColumnList  cols = new DefaultColumnList(
			new DefaultColumn(stringType,"Name"),
			new DefaultColumn(stringType,"Sequence")
			);
	
	@Override
	public 	ColumnList getColumns()
		{
		return this.cols;
		}
	
	BufferedReader open()
		{
		}
	public void execute() throws Exception
		{
		String line;
		String name=null;
		StringBuilder seq = new StringBuilder();
		BufferedReader r= open();
		fireHeader(cols,null);
		for(;;)
			{
			String line= seq.readLine();
			if( line == null || line.startsWith(">") )
				{
				if(seq!=null)
					{
					fireRowEvent(new DefaultRow(
						ReadFasta.this.cols,
						new DefaultDataValue(name),
						new DefaultDataValue(seq),
						));
					}
				if(line==null) break;
				name=line;
				seq=new StringBuilder();
				continue;
				}
			seq.append(line);
			}
		fireFooter(cols,null);
		}
	public void fireRowEvent(FireRowEvent evt)
		{
		
		}
	}
ReadFasta <xsl:apply-templates select="." mode="id"/> = new ReadFasta()
	{
	
	};
this.inputs.add(<xsl:apply-templates select="." mode="id"/>);
</xsl:template>

<xsl:template match="write-fasta">
class WriteFasta
	{
	
	}
WriteFasta <xsl:apply-templates select="." mode="id"/> = new WriteFasta()
	{
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

<xsl:template match="text()" mode="escape">
<xsl:value-of select="."/>
</xsl:template>


</xsl:stylesheet>
