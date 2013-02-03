<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:p='http://github.com/lindenb/xslt-sandbox/stylesheets/java/pojo2va/'
	version='1.0'
	>
<!--

Author:
	Pierre Lindenbaum PhD
	plindenbaum@yahoo.fr

-->
<xsl:output method="text" />
<xsl:param name="listener">false</xsl:param>
<xsl:param name="outdir">generated</xsl:param>

<xsl:template match="/">
<xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="p:package">
<xsl:apply-templates select="p:class|p:package"/>
</xsl:template>


<xsl:template match="p:class">




<xsl:variable name="pack">
<xsl:for-each select="ancestor-or-self::p:package[@name]">
<xsl:if test='position()&gt;1'>.</xsl:if>
<xsl:value-of select="@name"/>
</xsl:for-each>
</xsl:variable>


<xsl:variable name="filename">

<xsl:if test="string-length($outdir)&gt;0">
 <xsl:value-of select="concat($outdir,'/')"/>
</xsl:if>

<xsl:if test="string-length($pack)&gt;0">
<xsl:value-of select="translate($pack,'.','/')"/>
<xsl:text>/</xsl:text>
</xsl:if>

<xsl:apply-templates select="." mode="javaName"/>
<xsl:text>.java</xsl:text>

</xsl:variable>

<xsl:message><xsl:value-of select="$filename"/></xsl:message>

<!-- <xsl:document href="{$filename}"> -->
<xsl:if test="string-length($pack)&gt;0">
package <xsl:value-of select="$pack"/>;
</xsl:if>

@javax.annotation.Generated(
	value="pojo2java.xsl",
	comments = "generated with pojo2java", 
	date="2013"
	)
public <xsl:apply-templates select="." mode="class"/>
<!-- </xsl:document> -->
</xsl:template>

<xsl:template match="p:class" mode="class">

<xsl:if test="@abstract='true'">abstract </xsl:if> class <xsl:apply-templates select="." mode="javaName"/>
	{
	<xsl:if test="$listener='true'">
	private final transient java.beans.PropertyChangeSupport _propertyChangleListener= new java.beans.PropertyChangeSupport(this);
	<xsl:for-each select="p:property">
	public static final String <xsl:apply-templates select="." mode="ppty"/>="<xsl:apply-templates select=".." mode="javaName"/>.<xsl:value-of select="@name"/>.property";
	</xsl:for-each>
	
	</xsl:if>
	<xsl:apply-templates select="p:property" mode="decl"/>
	
	public <xsl:apply-templates select="." mode="javaName"/>()
		{
		}
		
	public <xsl:apply-templates select="." mode="javaName"/>(final <xsl:apply-templates select="." mode="javaName"/> cp)
		{
		<xsl:for-each select="p:property">
		this.<xsl:value-of select="@name"/>=cp.<xsl:value-of select="@name"/>;
		</xsl:for-each>
		}
	
	<xsl:if test="p:property">
	public <xsl:apply-templates select="." mode="javaName"/>(<xsl:for-each select="p:property">
		<xsl:if test="position()&gt;1">,</xsl:if>
		<xsl:value-of select="@type"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@name"/>
		</xsl:for-each>)
		{
		<xsl:for-each select="p:property">
		this.<xsl:value-of select="@name"/>=<xsl:value-of select="@name"/>;
		</xsl:for-each>
		}
	</xsl:if>
	

	
	<xsl:if test="$listener='true'">
	
	protected  java.beans.PropertyChangeSupport changeSupport()
		{
		return this._propertyChangleListener;
		}
	
	 public void addPropertyChangeListener(PropertyChangeListener listener)
               {
               changeSupport().addPropertyChangeListener(listener);
               }
           

         public void removePropertyChangeListener(PropertyChangeListener listener)
               {
               changeSupport().removePropertyChangeListener(listener);
               }
        </xsl:if>
	
	<xsl:apply-templates select="p:property" mode="gettersetter"/>
	
	
	<xsl:apply-templates select="p:code"/>
	}
</xsl:template>


<xsl:template match="p:class" mode="javaName">
	<xsl:call-template name="titleize">
		<xsl:with-param name="name" select="@name"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="p:property" mode="decl">
        /** 
         * <xsl:value-of select="@name"/>
         * <xsl:value-of select="@description"/>
         */
        private <xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:value-of select="@name"/>=null;
        
</xsl:template>


<xsl:template match="p:property" mode="ppty">
<xsl:value-of select="concat('PROPERTY_',translate(@name,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'))"/>
        
</xsl:template>

<xsl:template match="p:property" mode="javaName">
	<xsl:call-template name="titleize">
		<xsl:with-param name="name" select="@name"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="p:property" mode="gettersetter">
<xsl:variable name="javaName">
	<xsl:apply-templates select="." mode="javaName"/>
</xsl:variable>
        /** 
         * getter for <xsl:value-of select="@name"/>
         * <xsl:value-of select="@description"/>
         */
        public <xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:value-of select="concat('get',$javaName)"/>()
        	{
        	return this.<xsl:value-of select="@name"/>;
        	}
        
        /** 
         * setter for <xsl:value-of select="@name"/>
         * <xsl:value-of select="@description"/>
         */
        public  void <xsl:value-of select="concat('set',$javaName)"/>(<xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:value-of select="@name"/>)
        	{
        	<xsl:if test="$listener='true'">
        	<xsl:value-of select="@type"/> oldValue=this.<xsl:value-of select="@name"/>;
        	</xsl:if>
        	this.<xsl:value-of select="@name"/>=<xsl:value-of select="@name"/>;
        	<xsl:if test="$listener='true'">
        	changeSupport().firePropertyChange(<xsl:apply-templates select="." mode="ppty"/>,oldValue, this.<xsl:value-of select="@name"/>);
        	</xsl:if>
        	}
        
</xsl:template>


<xsl:template name="titleize">
 <xsl:param name="name"/>
 <xsl:value-of select="translate(substring($name,1,1),'abcdefghijklmnopqrstuvwxy
z','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
 <xsl:value-of select="substring($name,2)"/>
</xsl:template>

</xsl:stylesheet>

