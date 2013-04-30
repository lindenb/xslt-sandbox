<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="str"
	version="1.1">
<xsl:output method="text"/>

<xsl:param name="package"></xsl:param>
<xsl:param name="orm">ORM</xsl:param>

<xsl:template match="/">
<xsl:apply-templates/>
</xsl:template>

 
<xsl:template match="schema">
<xsl:if test="$package!=''">
package <xsl:value-of select="$package"/>;
</xsl:if>
import java.util.List;
import java.util.ArrayList;
import java.sql.*;
import javax.sql.DataSource;
/**
 * 
 */
public class <xsl:value-of select="$orm"/>
	{
	private abstract class AbstractSQList&lt;T extends AbstractRecord &gt;
		extends java.util.AbstractList&lt;T &gt;
			{
			protected int cursor_index=0;
			protected List&lt;T&gt; buffer=null;
			private Integer _size=null;
			private int buffer_capacity=100;
			protected abstract T fromSQL(ResultSet row) throws SQLException;
			
			protected abstract Connection getConnection() throws SQLException;
			protected abstract void disposeConnection(Connection con);
			protected abstract PreparedStatement prepareStatement(Connection con,int index) throws SQLException;
			private T refillBuffer(int index) throws SQLException
				{
				PreparedStatement stmt=null;
				Connection con=null;
				buffer=null;
				cursor_index=-1;
				con=this.getConnection();
				stmt=prepareStatement(con,index);
				ResultSet row=stmt.executeQuery();
				this.buffer= new ArrayList&lt;T&gt;(this.buffer_capacity);
				while(row.next() &amp;&amp; this.buffer.size() &lt; this.buffer_capacity )
					{
					T t=fromSQL(row);
					this.buffer.add(t);
					}
				row.close();
				stmt.close();
				disposeConnection(con);
				this.cursor_index=index;
				return  this.buffer.get(index-this.cursor_index);
				}
				
			@Override
			public T get(int index)
				{
				if(buffer!=null  &amp;&amp;
					cursor_index>=0 &amp;&amp;
					this.cursor_index>=index  &amp;&amp;
					index - this.cursor_index &lt; buffer.size()
					)
					{
					return this.buffer.get(index - this.cursor_index);
					}
				try
					{
					return refillBuffer(index);
					}
				catch(SQLException err)
					{
					throw new RuntimeException(err);
					}
				}
			@Override
			public int size()
				{
				if(_size==null)
					{
					String sql="select ";
					}
				return _size;
				}
			}
	
	
	public abstract class AbstractRecord
		{
		public abstract Table getTable();
		public abstract void insert() throws SQLException;
		public abstract void update() throws SQLException;
		public abstract void refresh() throws SQLException;
		public abstract void delete() throws SQLException;
		public Database getDatabase()
			{
			return getTable().getDatabase();
			}
		}
	

	
	public abstract class Table
		{
		public boolean exists() throws SQLException
			{
			return false;
			}

		public void drop() throws SQLException
			{
			
			}
		public void truncate() throws SQLException
			{
			}
		
		public abstract void create() throws SQLException;
		public abstract AbstractRecord newRecord();
		
		public abstract String getName();
		public abstract Database getDatabase();
		abstract String alias();
		abstract String sqlColumns();
		public abstract AbstractRecord fromSQL(ResultSet row) throws SQLException;
		@Override
		public String toString()
			{
			return getDatabase().getName()+this.getName();
			}
		}
		
		
	public abstract class Database
		{
		public <xsl:value-of select="$orm"/> getORM()
			{
			return <xsl:value-of select="$orm"/>.this;
			}
		
		public abstract String getName();
		public abstract Table[] getTables();
		public Table getTableByName(String name)
			{
			for(Table t:getTables())
				{
				if(t.getName().equals(name))
					{
					return t;
					}
				}
			return null;
			}
		
		
		@Override
		public String toString()
			{
			return getName();
			}
		}
	
	
	private DataSource dataSource;
	public <xsl:value-of select="$orm"/>(DataSource dataSource)
		{
		this.dataSource=dataSource;
		}

	
	public DataSource getDataSource()
		{
		return this.dataSource;
		}
	
	
	<xsl:for-each select="database">
	
	<xsl:variable name="databaseName">
		 <xsl:apply-templates select="." mode="databaseName"/>
	</xsl:variable>
	
	/**
	 *
	 * Database for <xsl:value-of select="@name"/>
	 *
	 */
	public class <xsl:value-of select="$databaseName"/>
		extends Database
		{
		<xsl:for-each select="table">
		
		<xsl:variable name="tableName">
		 	<xsl:apply-templates select="." mode="tableName"/>
		</xsl:variable>
		<xsl:variable name="recordName">
		 	<xsl:apply-templates select="." mode="recordName"/>
		</xsl:variable>
		/**
		 *
		 * Database for <xsl:value-of select="concat(../@name,'.',@name)"/>
		 *
		 */
		public class <xsl:value-of select="$tableName"/>
			extends Table
			{
			/**
			 * <xsl:value-of select="$recordName"/>
			 */
			public class <xsl:value-of select="$recordName"/>
				extends AbstractRecord
				{
				/**
				 * Constructor
				 */ 
				public <xsl:value-of select="$recordName"/>()
					{
					}
				
				@Override
				public <xsl:value-of select="$tableName"/> getTable()
					{
					return <xsl:value-of select="$tableName"/>.this;
					}
				
				<xsl:apply-templates select="field" mode="getter.and.setter"/>
				
				@Override
				public String toString()
					{
					StringBuilder sb=new StringBuilder(getClass().getName());
					sb.append("[");
					<xsl:for-each select="field">
					<xsl:if test="positon()&gt;1">sb.append(" ");</xsl:if>
					sb.append("<xsl:value-of select="@name"/>:");
					sb.append(String.valueOf(this.<xsl:value-of select="." mode="getter"/>()));
					</xsl:for-each>
					sb.append("]");
					return sb.toString();
					}
				} /* end of <xsl:value-of select="$recordName"/> */
			
			/** transforms a ResultSet to a new <xsl:value-of select="$recordName"/> */	
			@Override		
			public <xsl:value-of select="$recordName"/> fromSQL(ResultSet row) throws SQLException
				{
				<xsl:value-of select="$recordName"/> rec=new <xsl:value-of select="$recordName"/>();
				<xsl:for-each select="field">
				<xsl:call-template name="from.sql">
				  <xsl:with-param name="index" select="position()"/>
				  <xsl:with-param name="field" select="."/>
				  <xsl:with-param name="record">rec</xsl:with-param>
				  <xsl:with-param name="row">row</xsl:with-param>
				</xsl:call-template>
				</xsl:for-each>
				return rec;
				}
			
			@Override
			String alias()
				{
				return "<xsl:value-of select="generate-id(.)"/>";
				}
				
			@Override
			String sqlColumns()
				{
				return "<xsl:for-each select="field"><xsl:if test="position()&gt;1">,</xsl:if><xsl:value-of select="@name"/></xsl:for-each>";
				}
			
			@Override
			public void create() throws SQLException
				{
				if(exists()) return;
				
				}
			
			@Override
			public <xsl:value-of select="$recordName"/>  newRecord()
				{
				return new <xsl:value-of select="$recordName"/>();
				}
			
			
			<xsl:for-each select="index">
			<xsl:variable name="indexNode" select="."/>
			<xsl:variable name="indexName"><xsl:value-of select="concat('Index',generate-id(.))"/></xsl:variable>
			<xsl:choose>
				<xsl:when test="@unique='true'">
					<xsl:value-of select="$recordName"/><xsl:text> </xsl:text> <xsl:apply-templates select="." mode="method.decl"/>
						{
						<xsl:value-of select="$recordName"/> record=null;
						PreparedStatement pstmt=null;
						ResultSet row=null;
						Connection con=null;
						try
							{
							con=getORM().getDataSource().getConnection();
							pstmt=con.prepareStatement("select "+sqlColumns()+" from "+getName()+" where <xsl:value-of select="@name"/>=?");
							pstmt.setString(1,"TOTO");
							row=pstmt.executeQuery();
							while(row.next())
								{
								record=fromSQL(row);
								break;
								}
							}
						finally
							{
							if(row!=null) row.close();
							if(pstmt!=null) pstmt.close();
							}
						return record;
						}
				</xsl:when>
				<xsl:otherwise>
				
				
				private class <xsl:value-of select="$indexName"/>
					extends AbstractSQList&lt;<xsl:value-of select="$recordName"/>&gt;
					{
					<xsl:value-of select="$indexName"/>()
						{
						
						}
					
					<xsl:for-each select="str:tokenize(@fields,',')">
					<xsl:variable name="fieldname" select="text()"/>
					<xsl:variable name="field" select="$indexNode/../field[@name=$fieldname]"/>

					<xsl:apply-templates select="$field" mode="getter.and.setter"/>

					</xsl:for-each>
					
					}
				
				java.util.List&lt;<xsl:value-of select="$recordName"/>&gt; <xsl:apply-templates select="." mode="method.decl"/>
						{
						<xsl:value-of select="$indexName"/> L=new <xsl:value-of select="$indexName"/>();
						<xsl:for-each select="str:tokenize(@fields,',')">
						
						</xsl:for-each>
						return L;
						}
				
				</xsl:otherwise>
			</xsl:choose>
			</xsl:for-each>
			
			
			@Override
			public String getName()
				{
				return "<xsl:value-of select="@name"/>";
				}
			@Override	
			public <xsl:value-of select="$databaseName"/> getDatabase()
				{
				return <xsl:value-of select="$databaseName"/>.this;
				}
			}
		public final <xsl:value-of select="$tableName"/><xsl:text> </xsl:text><xsl:value-of select="@name"/>=new  <xsl:value-of select="$tableName"/>();
		
		</xsl:for-each>
		
		/**
		 * constructor for database '<xsl:value-of select="@name"/>'
		 */
		public <xsl:value-of select="$databaseName"/>()
			{
			}
		
		@Override
		public Table[] getTables()
			{
			return new Table[]{<xsl:for-each select="table"><xsl:if test="position()&gt;1">,</xsl:if>this.<xsl:value-of select="@name"/></xsl:for-each>};
			}
			
		@Override
		public String getName()
			{
			return "<xsl:value-of select="@name"/>";
			}
		}
	
	</xsl:for-each>
	
	public static void main(String args[])
		{
		
		}
	
	}
</xsl:template>


<xsl:template match="table" mode="record">
</xsl:template>

<xsl:template match="table" mode="tableName">
</xsl:template>

<xsl:template match="database" mode="databaseName">
</xsl:template>


<xsl:template name="field" mode="getstmt">
<xsl:choose>
	<xsl:when test="@javaType">
		<xsl:value-of select="@javaType"/>
	</xsl:when>
	<xsl:when test="@type='string'">
		<xsl:text>String</xsl:text>
	</xsl:when>
	<xsl:otherwise>setString</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="field" mode="javaType">
<xsl:choose>
	<xsl:when test="@javaType">
		<xsl:value-of select="@javaType"/>
	</xsl:when>
	<xsl:when test="@type='string'">
		<xsl:text>String</xsl:text>
	</xsl:when>
	<xsl:otherwise>String</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="field" mode="getter">
<xsl:variable name="s">
<xsl:call-template name="titleize">
	<xsl:with-param name="s" select="@name"/>
</xsl:call-template>
</xsl:variable>
<xsl:value-of select="concat('get',$s)"/>
</xsl:template>

<xsl:template match="field" mode="setter">
<xsl:variable name="s">
<xsl:call-template name="titleize">
	<xsl:with-param name="s" select="@name"/>
</xsl:call-template>
</xsl:variable>
<xsl:value-of select="concat('set',$s)"/>
</xsl:template>

<xsl:template match="field" mode="getter.and.setter">
<xsl:variable name="javaType">
  <xsl:apply-templates select="." mode="javaType"/>
</xsl:variable>

/** placeholder for <xsl:value-of select="@name"/> */
private <xsl:value-of select="$javaType"/><xsl:text> </xsl:text><xsl:value-of select="@name"/>;

/** getter for  <xsl:value-of select="@name"/> */
public <xsl:value-of select="$javaType"/><xsl:text> </xsl:text><xsl:apply-templates select="." mode="getter"/>()
	{
	return this.<xsl:value-of select="@name"/>;
	}

/** setter for  <xsl:value-of select="@name"/> */
public void <xsl:apply-templates select="." mode="setter"/>(<xsl:value-of select="$javaType"/><xsl:text> </xsl:text><xsl:value-of select="@name"/>)
	{
	this.<xsl:value-of select="@name"/>=<xsl:value-of select="@name"/>;
	}	
</xsl:template>

<xsl:template match="@name" mode="title">
<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="database" mode="databaseName">
<xsl:variable name="s">
<xsl:call-template name="titleize">
	<xsl:with-param name="s" select="@name"/>
</xsl:call-template>
</xsl:variable>
<xsl:value-of select="concat($s,'Database')"/>
</xsl:template>


<xsl:template match="table" mode="tableName">
<xsl:variable name="s">
<xsl:call-template name="titleize">
	<xsl:with-param name="s" select="@name"/>
</xsl:call-template>
</xsl:variable>
<xsl:value-of select="concat($s,'Table')"/>
</xsl:template>

<xsl:template match="table" mode="recordName">
<xsl:variable name="s">
<xsl:call-template name="titleize">
	<xsl:with-param name="s" select="@name"/>
</xsl:call-template>
</xsl:variable>
<xsl:value-of select="concat($s,'Record')"/>
</xsl:template>


<xsl:template match="index" mode="method.decl">
<xsl:variable name="indexNode" select="."/>
get<xsl:apply-templates select=".." mode="recordName"/>By<xsl:for-each select="str:tokenize($indexNode/@fields,',')"><xsl:call-template name="titleize"><xsl:with-param name="s" select="."/></xsl:call-template></xsl:for-each>(
<xsl:for-each select="str:tokenize($indexNode/@fields,',')">
<xsl:variable name="fieldname" select="text()"/>
  <xsl:variable name="field" select="$indexNode/../field[@name=$fieldname]"/>
<xsl:variable name="javaType">
 <xsl:apply-templates select="$field" mode="javaType"/>
</xsl:variable>
<xsl:if test="position()&gt;1">,</xsl:if>
<xsl:value-of select="$javaType"/>
<xsl:text> </xsl:text>
<xsl:value-of select="$fieldname"/>
</xsl:for-each>) throws SQLException
</xsl:template>

<xsl:template name="from.sql">
  <xsl:param name="index"/>
  <xsl:param name="field"/>
  <xsl:param name="record"/>
  <xsl:param name="row"/>
 <xsl:variable name="type" select="$field/@sqlType"/>
 <xsl:variable name="var"><xsl:value-of select="concat($field/@name,'_',generate-id($field))"/></xsl:variable>
 /* fill data for field '<xsl:value-of select="@name"/>' */
 <xsl:choose>
 
 	<xsl:when test="$type='byte'">
	Byte <xsl:value-of select="$var"/>=<xsl:value-of select="$row"/>.getByte(<xsl:value-of select="$index"/>);
	</xsl:when>
	<xsl:when test="$type='byte'">
	Boolean <xsl:value-of select="$var"/>=<xsl:value-of select="$row"/>.getBoolean(<xsl:value-of select="$index"/>);
	</xsl:when>
 	<xsl:when test="$type='short'">
	Short <xsl:value-of select="$var"/>=<xsl:value-of select="$row"/>.getShort(<xsl:value-of select="$index"/>);
	</xsl:when>
	<xsl:when test="$type='int'">
	Integer <xsl:value-of select="$var"/>=<xsl:value-of select="$row"/>.getInt(<xsl:value-of select="$index"/>);
	</xsl:when>
	<xsl:when test="$type='long'">
	Long <xsl:value-of select="$var"/>=<xsl:value-of select="$row"/>.getLong(<xsl:value-of select="$index"/>);
	</xsl:when>
	<xsl:when test="$type='float'">
	Float <xsl:value-of select="$var"/>=<xsl:value-of select="$row"/>.getFloat(<xsl:value-of select="$index"/>);
	</xsl:when>
	<xsl:when test="$type='double'">
	Double <xsl:value-of select="$var"/>=<xsl:value-of select="$row"/>.getDouble(<xsl:value-of select="$index"/>);
	</xsl:when>
	<xsl:otherwise>
	String <xsl:value-of select="$var"/>=<xsl:value-of select="$row"/>.getString(<xsl:value-of select="$index"/>);
	</xsl:otherwise>
</xsl:choose>

<xsl:if test="$type!='string'">
if(<xsl:value-of select="$row"/>.wasNull())
	{
	<xsl:choose>
		<xsl:when test="$field/@null='true'"><xsl:value-of select="$var"/>=null;</xsl:when>
		<xsl:otherwise>throw new SQLException("null for <xsl:value-of select="$field/@name"/></xsl:otherwise>
	</xsl:choose>
	}
</xsl:if>

<xsl:value-of select="$record"/>.<xsl:apply-templates select="$field" mode="setter"/>(<xsl:value-of select="$var"/>);

</xsl:template>


<xsl:template name="titleize">
<xsl:param name="s"/>
<xsl:value-of select="concat(translate(substring($s,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),substring($s,2))"/>
</xsl:template>


</xsl:stylesheet>
