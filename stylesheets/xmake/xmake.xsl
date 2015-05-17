<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>
<!--
Author:
        Pierre Lindenbaum
Motivation:

Reference:

Usage :

	
-->

<xsl:output method="text" />

<xsl:template match="/">
<xsl:apply-templates select="xmake"/>
</xsl:template>

<xsl:template match="xmake">

import java.io.*;
import java.util.*;

public class XMake
	{
	private class Context
		{
		Context parent =null;
		Map&lt;String,String&gt; variables = new HashMap&lt;String,String&gt;();
		Context(Context parent)
			{
			this.parent = parent;
			}
		}
	
	private abstract class Node
		{
		
		}
	
	private class PlainNode extends Node
		{
		private String content;
		PlainNode(String content)
			{
			this.content = content;
			}
		}
	
	private class DefaultNode extends Node
		{
		Node next = null;
		Node child = null;
		public DefaultNode add(Node n)
			{
			if(this.child==null)
				{
				this.child=n;
				}
			else
				{
				Node curr=child;
				while(curr.next!=null) curr=curr.next;
				curr.next = n;
				}
			return this;
			}
		}
	
	private class AddPrefixNode extends Node
		{
		Node prefix = null;
		Node bodyx = null;
		}
	
	private class AddSuffixNode extends Node
		{
		Node suffix = null;
		Node bodyx = null;
		}
	
	
	private class Target
		{
		private File file;
		private Rule rule;
		private Context context;
		public Target(File file,Rule rule,Context context)
			{
			this.file=file;
			this.rule=rule;
			this.context=context;
			}
		
		public Rule getRule()
			{
			return this.rule;
			}
		
		public File getFile()
			{
			return this.file;
			}
		
		@Override
		public int hashCode()
			{
			return getFile().hashCode();
			}
		
		@Override
		public boolean equals(Object o)
			{
			if(o==null || !(o instanceof Target)) return false;
			if(this==o) return true;
			return this.getFile().equals(Target.class.cast(o).getFile());
			}
		
		@Override
		public String toString()
			{
			return getFile().toString();
			}
		
		private void gexfNode(XMLStreamWriter w) throws XMLStreamException
			{
			
			}
		private void gexfEdge(XMLStreamWriter w) throws XMLStreamException
			{
			
			}
		}
	
	<xsl:apply-templates select="rule"/>
	
	private Rule rules = new Rule[]{
		<xsl:for-each select="rule">
		<xsl:if test="position()&gt;0">,</xsl:if>
		<xsl:apply-templates select="." mode="instance"/>
		</xsl:for-each>
		};
	
	private abstract class Rule
		{
		protected Node ouput = new DefaultNode();
		protected Node input = new DefaultNode();
		protected Node root = new DefaultNode();
		
		private List&lt;Target&gt; targets = null;
		List&lt;Target&gt; getTargets(Context ctx)
			{
			if(this.targets == null)
			 	{
			 	String targetStr[]=//TODO
			 	for(String s: )
			 		{
			 		}
			 	}
			return this.targets;
			}
		
		
		public abstract String getId();
		
		public String getName()
			{
			return this.getId();
			}
		public String getDescription()
			{
			return this.getName();
			}
		@Override
		public int hashCode()
			{
			return getId().hashCode();
			}
		@Override
		public boolean equals(Object o)
			{
			if(o==null || !(o instanceof Task)) return false;
			if(this==o) return true;
			return this.getId().equals(Task.class.cast(o).getId());
			}
		@Override
		public String toString()
			{
			return getName();
			}
		}
	
	public XMake()
		{
		}
	
	public void init()
		{
		<xsl:for-each select="rule">
		<xsl:value-of select="concat(generate-id(),'Rule')"/> <xsl:value-of select="concat('instance_',generate-id())"/> = new <xsl:value-of select="concat(generate-id(),'Rule')"/>();
		this.rules.add(<xsl:value-of select="concat('instance_',generate-id())"/>);
		</xsl:for-each>
		}
	
	public void instanceMain(String args[])
		{
		
		}
	
	public static void main(String args[])
		{
		XMake app = new XMake();
		app.instanceMain(args); 
		}
	}
</xsl:template>

<xsl:template match="rule">

private class <xsl:apply-templates select="."  mode="class"/> extends Rule
	{

	
	public <xsl:apply-templates select="."  mode="class"/>()
		{
		Node current;
		current = this.input;
		<xsl:apply-templates select="input"/>
		current = this.output;
		<xsl:apply-templates select="output"/>
		current = this.command;
		<xsl:apply-templates select="command"/>
		current=null;
		}
	
	public String getId()
		{
		return "<xsl:value-of select="generate-id()"/>;
		}
	<xsl:if test="@name">
	@Override
	public String getName()
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
	
	public List&lt;String&gt; getOutputList()
		{
		StringBuilder w = new StringBuilder();
		<xsl:apply-templates select=""/>
		}
	public String getInputList()
		{
		StringBuilder w = new StringBuilder();
		<xsl:apply-templates select=""/>
		}
	public String write()
		{
		StringBuilder w = new StringBuilder();
		<xsl:apply-templates select="command"/>
		}x
	}


private final <xsl:apply-templates select="."  mode="class"/><xsl:text> </xsl:text><xsl:apply-templates select="."  mode="instance"/> = new <xsl:apply-templates select="."  mode="class"/>();

</xsl:template>

<xsl:template match="rule" mode="class">
<xsl:value-of select="concat(generate-id(),'Rule')"/>
</xsl:template>


<xsl:template match="rule" mode="instance">
<xsl:value-of select="concat('instance_',generate-id())"/>
</xsl:template>

<xsl:template match="text()|@*">
current.append("<xsl:value-of select="."/>");
</xsl:template>


<!-- functions -->
<xsl:template match="addsuffix">
AddSuffixNode <xsl:value-of select="generate-id()"/> = new AddSuffixNode();
current.add(<xsl:value-of select="generate-id()"/>);
Node <xsl:value-of select="concat(generate-id(),'_old')"/> = current;
current = <xsl:value-of select="generate-id()"/>;
<xsl:choose>
	<xsl:when test="@suffix">
		current = new DefaultNode();
		<xsl:apply-templates select="@suffix"/>
		<xsl:value-of select="generate-id()"/>.prefix = current;
		current = new DefaultNode();
		<xsl:apply-templates select="*|text()"/>
		<xsl:value-of select="generate-id()"/>.body = current;
	</xsl:when>
	<xsl:otherwise>
		<xsl:message terminate="yes">Bad syntax</xsl:message>
	</xsl:otherwise>
</xsl:choose>
current = <xsl:value-of select="concat(generate-id(),'_old')"/>;
</xsl:template>

<xsl:template match="addprefix">
<xsl:choose>
	<xsl:when test="@prefix">
		_addprefix(cxt,<xsl:apply-templates select="@prefix"/>,_list(<xsl:apply-templates select="*|text()"/>));
	</xsl:when>
	<xsl:otherwise>
		<xsl:message terminate="yes">Bad syntax</xsl:message>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
