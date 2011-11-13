<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:c="http://exslt.org/crypto"
	xmlns:crypt="uri:encryption"
	version="1.0"
	>

<!--
Author
    Pierre Lindenbaum PhD

Mail:
    plindenbaum@yahoo.fr

Motivation:
   decrypt/encrypt the text node of an XML file.
   
Example:

   xsltproc -\-novalid -\-stringparam password "mypassword" crypt.xsl source.xml > encrypted.xml
   xsltproc -\-novalid -\-stringparam crypt false -\-stringparam password "mypassword" crypt.xsl encrypted.xml > decrypted.xml

-->

  <xsl:output method="xml"/>

  <xsl:param name="password"/>
  <xsl:param name="crypt">true</xsl:param>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:choose>
      <xsl:when test="count(*)!=0">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:when>
      <xsl:when test="count(child::node())=0">
        <xsl:copy-of select=".|@*"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*[name()!='crypt:crypted']"/>
            <xsl:choose>
              <xsl:when test='$crypt="true"'>
                <xsl:attribute name="crypt:crypted">true</xsl:attribute>
                <xsl:value-of select="c:rc4_encrypt($password,.)"/>
              </xsl:when>
              <xsl:when test='$crypt!="true"'>
                <xsl:value-of select="c:rc4_decrypt($password,.)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
