<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

<!-- source: github ftp://ftp.samba.org/pub/unpacked/samba-docs/xslt/db2latex-xsl/xsl/scape.mod.xsl -->
   <xsl:template name="escapeLaTeX">
    <xsl:param name="string"/>
    <xsl:call-template name="latex-string-replace">
      <xsl:with-param name="from">&lt;</xsl:with-param>
      <xsl:with-param name="to">\textless{}</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:call-template name="latex-string-replace">
          <xsl:with-param name="from">&gt;</xsl:with-param>
          <xsl:with-param name="to">\textgreater{}</xsl:with-param>
          <xsl:with-param name="string">
            <xsl:call-template name="latex-string-replace">
              <xsl:with-param name="from">~</xsl:with-param>
              <xsl:with-param name="to">\textasciitilde{}</xsl:with-param>
              <xsl:with-param name="string">
                <xsl:call-template name="latex-string-replace">
                  <xsl:with-param name="from">^</xsl:with-param>
                  <xsl:with-param name="to">\textasciicircum{}</xsl:with-param>
                  <xsl:with-param name="string">
                    <xsl:call-template name="latex-string-replace">
                      <xsl:with-param name="from">&amp;</xsl:with-param>
                      <xsl:with-param name="to">\&amp;</xsl:with-param>
                      <xsl:with-param name="string">
                        <xsl:call-template name="latex-string-replace">
                          <xsl:with-param name="from">#</xsl:with-param>
                          <xsl:with-param name="to">\#</xsl:with-param>
                          <xsl:with-param name="string">
                            <xsl:call-template name="latex-string-replace">
                              <xsl:with-param name="from">_</xsl:with-param>
                              <xsl:with-param name="to">\_</xsl:with-param>
                              <xsl:with-param name="string">
                                <xsl:call-template name="latex-string-replace">
                                  <xsl:with-param name="from">$</xsl:with-param>
                                  <xsl:with-param name="to">\$</xsl:with-param>
                                  <xsl:with-param name="string">
                                    <xsl:call-template name="latex-string-replace">
                                      <xsl:with-param name="from">%</xsl:with-param>
                                      <xsl:with-param name="to">\%</xsl:with-param>
                                      <xsl:with-param name="string">
                                        <xsl:call-template name="latex-string-replace">
                                          <xsl:with-param name="from">|</xsl:with-param>
                                          <xsl:with-param name="to">\docbooktolatexpipe{}</xsl:with-param>
                                          <xsl:with-param name="string">
                                            <xsl:call-template name="latex-string-replace">
                                              <xsl:with-param name="from">{</xsl:with-param>
                                              <xsl:with-param name="to">\{</xsl:with-param>
                                              <xsl:with-param name="string">
                                                <xsl:call-template name="latex-string-replace">
                                                  <xsl:with-param name="from">}</xsl:with-param>
                                                  <xsl:with-param name="to">\}</xsl:with-param>
                                                  <xsl:with-param name="string">
                                                    <xsl:call-template name="latex-string-replace">
                                                      <xsl:with-param name="from">\textbackslash </xsl:with-param>
                                                      <xsl:with-param name="to">\textbackslash \ </xsl:with-param>
                                                      <xsl:with-param name="string">
                                                        <xsl:call-template name="latex-string-replace">
                                                          <xsl:with-param name="from">\</xsl:with-param>
                                                          <xsl:with-param name="to">\textbackslash </xsl:with-param>
                                                          <xsl:with-param name="string" select="$string"/>
                                                        </xsl:call-template>
                                                      </xsl:with-param>
                                                    </xsl:call-template>
                                                  </xsl:with-param>
                                                </xsl:call-template>
                                              </xsl:with-param>
                                            </xsl:call-template>
                                          </xsl:with-param>
                                        </xsl:call-template>
                                      </xsl:with-param>
                                    </xsl:call-template>
                                  </xsl:with-param>
                                </xsl:call-template>
                              </xsl:with-param>
                            </xsl:call-template>
                          </xsl:with-param>
                        </xsl:call-template>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>



<xsl:template name="latex-string-replace">
    <xsl:param name="string"/>
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    
    <xsl:if test="string-length($from)=0"><xsl:message terminate="yes">BOUM:'<xsl:value-of select="$from"/>' vs '<xsl:value-of select="$to"/>'</xsl:message></xsl:if>
    
    <xsl:choose>
      <xsl:when test="contains($string,$from)">
        <xsl:value-of select="substring-before($string,$from)"/>
        <xsl:value-of select="$to"/>
        <xsl:call-template name="latex-string-replace">
          <xsl:with-param name="string" select="substring-after($string,$from)"/>
          <xsl:with-param name="from" select="$from"/>
          <xsl:with-param name="to" select="$to"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
