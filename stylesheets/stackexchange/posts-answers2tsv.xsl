<?xml version='1.0'  encoding="ISO-8859-1" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        xmlns:date='http://exslt.org/dates-and-times'
        version='1.0'
        >

<xsl:output method='text' encoding="ISO-8859-1"/>



<xsl:template match="/">
<xsl:apply-templates select="Posts"/>
</xsl:template>


<xsl:template match="Posts">
<xsl:text>ID	Date	Response.Id	Response.OwnerUserId	Response.Score	Response.CreationDate	minutes	status	first
</xsl:text>
<xsl:apply-templates select="row[PostTypeId='1' and not(DeletionDate)]" mode="q"/>
</xsl:template>

<xsl:template match="row" mode="q">
<xsl:variable name="id" select="Id"/>
<xsl:variable name="date" select="CreationDate/text()"/>
<xsl:variable name="accepted" select="AcceptedAnswerId/text()"/>
<xsl:variable name="responses" select="/Posts/row[PostTypeId='2' and ParentId= $id and not(DeletionDate)]"/>
<xsl:choose>
   <xsl:when test="count($responses)=0">
      
   </xsl:when>
   <xsl:otherwise>
      <xsl:for-each select="$responses"> 
      <xsl:value-of select="$id"/><xsl:text>	</xsl:text>
      <xsl:value-of select="$date"/><xsl:text>	</xsl:text>
      <xsl:value-of select="Id"/><xsl:text>	</xsl:text>
      <xsl:value-of select="OwnerUserId"/><xsl:text>	</xsl:text>
      <xsl:value-of select="Score"/><xsl:text>	</xsl:text>
      <xsl:value-of select="CreationDate"/><xsl:text>	</xsl:text>
      <xsl:value-of select="date:seconds(date:difference($date,CreationDate)) div 60.0"/><xsl:text>	</xsl:text>
      <xsl:choose>
         <xsl:when test="Id/text() = $accepted">
            <xsl:text>ACCEPTED</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>.</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:text>	</xsl:text>
      <xsl:choose>
         <xsl:when test="position()=1">
            <xsl:text>FIRST</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>.</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
<xsl:text>
</xsl:text>
      </xsl:for-each>
   </xsl:otherwise>
</xsl:choose>

</xsl:template>


</xsl:stylesheet>