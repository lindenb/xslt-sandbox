<?xml version='1.0' ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:x="http://www.ibm.com/xmlns/prod/2009/jsonx"
	version='1.0'
	>
<!--

Author:
	Pierre Lindenbaum PhD
	plindenbaum@yahoo.fr

Motivation:
	JSONX to gjson
Usage:
	xsltproc  x
-->
<xsl:output method="text" />


<xsl:template match="/">
<xsl:apply-templates select="*" mode="leaf"/>
</xsl:template>

<xsl:template match="*" mode="leaf">
<xsl:choose>
	<xsl:when test="count(*) != 0">
		<xsl:apply-templates select="*" mode="leaf"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates select="." mode="up0"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="*" mode="allup">
<xsl:if test="parent::*">
	<xsl:apply-templates select="parent::*" mode="up"/>
</xsl:if>
<xsl:choose>
	<xsl:when test="@name">if(o==null || !o.isJsonObject() || !o.getAsJsonObject().has("<xsl:value-of select="@name"/>")) return null;
o = o.getAsJsonObject().get("<xsl:value-of select="@name"/>");
</xsl:when>
	<xsl:when test="local-name(..)='array'">if(o==null || !o.isJsonArray() ||  o.getAsJsonArray().size() &lt;= <xsl:value-of select="count(preceding-sibling::*)"/> ) return null;
o = o.getAsJsonArray().get(<xsl:value-of select="count(preceding-sibling::*)"/>);
</xsl:when>
</xsl:choose>
</xsl:template>



<xsl:template match="x:object" mode="up">
<xsl:apply-templates select="." mode="allup"/>
if(o==null || !o.isJsonObject()) return null;
</xsl:template>

<xsl:template match="x:array" mode="up">
<xsl:apply-templates select="." mode="allup"/>
if(o==null || !o.isJsonArray()) return null;
</xsl:template>

<xsl:template match="x:string" mode="up">
<xsl:apply-templates select="." mode="allup"/>
if(o==null || !o.isJsonPrimitive() || !o.getAsJsonPrimitive().isString()) return null;
</xsl:template>

<xsl:template match="x:number" mode="up">
<xsl:apply-templates select="." mode="allup"/>
if(o==null || !o.isJsonPrimitive() || !o.getAsJsonPrimitive().isNumber()) return null;
</xsl:template>

<xsl:template match="x:boolean" mode="up">
<xsl:apply-templates select="." mode="allup"/>
if(o==null || !o.isJsonPrimitive() || !o.getAsJsonPrimitive().isBoolean()) return null;
</xsl:template>


<xsl:template match="x:null" mode="up">
<xsl:apply-templates select="." mode="allup"/>
if(o==null || !o.isJsonNull()) return null;
</xsl:template>



<xsl:template match="x:object" mode="up0">
public JsonObject get() {
JsonElement o = this.root;
<xsl:apply-templates select="." mode="allup"/>
if(o==null || !o.isJsonObject()) return null;
return o.getAsJsonObject();
};
</xsl:template>

<xsl:template match="x:array" mode="up0">
public JsonArray get() {
JsonElement o = this.root;
<xsl:apply-templates select="." mode="allup"/>
if(o==null || !o.isJsonArray()) return null;
return o.getAsJsonArray();
};
</xsl:template>

<xsl:template match="x:string" mode="up0">
public String get() {
JsonElement o = this.root;
<xsl:apply-templates select="." mode="allup"/>
if(o==null || !o.isJsonPrimitive() || !o.getAsJsonPrimitive().isString()) return null;
return o.getAsJsonPrimitive().getAsString(); /* <xsl:value-of  select="text()"/> */
};
</xsl:template>

<xsl:template match="x:number" mode="up0">
public Number get() {
JsonElement o = this.root;
<xsl:apply-templates select="." mode="allup"/>
if(o==null || !o.isJsonPrimitive() || !o.getAsJsonPrimitive().isNumber()) return null;
return o.getAsJsonPrimitive().getAsNumber(); /* <xsl:value-of  select="text()"/> */
};
</xsl:template>

<xsl:template match="x:boolean" mode="up0">
public Boolean get() {
JsonElement o = this.root;
<xsl:apply-templates select="." mode="allup"/>
if(o==null || !o.isJsonPrimitive() || !o.getAsJsonPrimitive().isBoolean()) return null;
return o.getAsJsonPrimitive().getAsBoolean(); /* <xsl:value-of  select="text()"/> */
};
</xsl:template>


<xsl:template match="x:null" mode="up0">
public JsonNull get() {
JsonElement o = this.root;
<xsl:apply-templates select="." mode="allup"/>
return o.getAsJsonNull();
}
</xsl:template>






</xsl:stylesheet>
