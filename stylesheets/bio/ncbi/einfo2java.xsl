<?xml version='1.0' encoding="UTF-8"?>
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Motivation:

Reference:
     

Usage :
      xsltproc einfo2java.xsl "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi"
-->

<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:svg="http://www.w3.org/2000/svg"
        xmlns:xlink="http://www.w3.org/1999/xlink"
	version='1.0'
	>
<xsl:output method="text" encoding="UTF-8"/>

<xsl:template match="/">
public class EInfo
{
public interface Link
	{
	public String getName();
	public String getDescription();
	public String getMenu();
	public DbInfo getDbInfo();
	public String getDbToName();
	public DbTo getDbTo();
	}

public interface DbInfo
	{
	public String getName();
	public EInfo getEInfo();
	public java.util.List&lt;Link&gt; getLinks();
	}
	
private class DbInfoImpl
	implements DbInfo
	{
	private class LinkImpl implements Link
		{
		String name;
		String menu;
		String description;
		String dbTo;
		LinkImpl(String name,String menu,String description,String dbTo)
			{
			this.name=name;
			this.menu=menu;
			this.description=description;
			this.dbTo=dbTo;
			}
		public String getName() { return name;}
		public String getDescription()  { return description;}
		public String getMenu() { return menu;}
		public DbInfo getDbInfo()
			{
			return DbInfoImpl.this;
			}
		public String getDbToName()
			{
			return this.dbTo;
			}
		public DbTo getDbTo()
			{
			return getDbInfo().getEInfo().getDbByName(this.getDbToName());
			}
		public String toString()
			{
			return this.name;
			}
		}
	private java.util.List&lt;Link&gt; links=new java.util.Array&lt;Link&gt;();
	private String name;
	public DbInfoImpl(String name)
		{
		this.name=name;
		}
	@Override
	public String getName()
		{
		return this.name;
		}
	@Override
	public EInfo getEInfo()
		{
		return EInfo.this;
		}
	void addLink(String name,String menu,String description,String dbTo)
		{
		links.add(new LinkImpl(name,menu,description,dbTo));
		}
	@Override
	public java.util.List&lt;Link&gt; getLinks()
		{
		return this.links;
		}
	@Override
	public String toString()
		{
		return this.name;
		}
	}
private java.util.Map&lt;String,DbInfo&gt; name2db=new java.util.HashMap&lt;String,DbInfo&gt;();
private static EInfo INSTANCE=new EInfo();
	
private EInfo()
	{
	<xsl:apply-templates/>
	}

public DbInfo getDbByName(String name)
	{
	return name2db.get(name);
	}
	

public static EInfo getInstance()
	{
	return INSTANCE;
	}

}
</xsl:template>

<xsl:template match="eInfoResult">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="DbList">
<xsl:apply-templates select="DbName"/>
</xsl:template>

<xsl:template match="DbName">
<xsl:variable name="url">
	<xsl:value-of select="concat('http://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi?db=',.)"/>
</xsl:variable>
<xsl:message>Downloading <xsl:value-of select="$url"/></xsl:message>
<xsl:apply-templates select='document($url,/)'/>
</xsl:template>

<xsl:template match="DbInfo">

dbInfo = new DbInfoImpl( &quot;<xsl:value-of select="DbName"/>&quot;);
<xsl:for-each select="LinkList/Link">
dbInfo.addLink(
  &quot;<xsl:value-of select="Name"/>&quot;,
  &quot;<xsl:value-of select="Menu"/>&quot;,
  &quot;<xsl:value-of select="Description"/>&quot;,
  &quot;<xsl:value-of select="DbTo"/>&quot;
  );

</xsl:for-each>

</xsl:template>


</xsl:stylesheet>
