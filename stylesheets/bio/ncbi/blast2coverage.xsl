<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        version='1.0'
        >
<!--

This stylesheet find the coverage of the BLAST query


-->

<xsl:output method="text" />

<xsl:template match="/">
<xsl:text>#ID	DEF	POS	LENGTH	CONSENSUS	DEPTH
</xsl:text>
<xsl:apply-templates select="/BlastOutput/BlastOutput_iterations/Iteration"/>
</xsl:template>


<xsl:template match="Iteration">
<xsl:call-template name="coverage">
	<xsl:with-param name="iteration" select="."/>
	<xsl:with-param name="start" select="number(1)"/>
	<xsl:with-param name="end" select="number(Iteration_query-len/text())"/>
</xsl:call-template>
</xsl:template>


<xsl:template name="coverage">
<xsl:param name="iteration"/>
<xsl:param name="start"/>
<xsl:param name="end"/>
<xsl:param name="qlen" select="number($iteration/Iteration_query-len/text())"/>


<xsl:choose>
	<xsl:when test="$start &gt; $end"></xsl:when>
	<xsl:when test="$start = $end">
		<xsl:variable name="pos" select="$start"/>
		<xsl:variable name="consensus">
		<xsl:for-each select="$iteration/Iteration_hits/Hit/Hit_hsps/Hsp">
			<xsl:variable name="qStart" select="number(Hsp_query-from/text())"/>
			<xsl:variable name="qEnd" select="number(Hsp_query-to/text())"/>
			<xsl:if test="not($qEnd &lt; $pos or $pos &lt; $qStart)">
				<xsl:value-of select="translate(substring(Hsp_hseq/text(), 1 + $pos - $qStart,1),' -','')"/>
			</xsl:if>
		</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="$iteration/Iteration_query-ID"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="$iteration/Iteration_query-def"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="$pos"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="$qlen"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="$consensus"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="string-length($consensus)"/>
		<xsl:text>
</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:variable name="mid" select="floor(($start + $end) div 2)"/>
		<xsl:call-template name="coverage">
			<xsl:with-param name="iteration" select="$iteration"/>
			<xsl:with-param name="start" select="$start"/>
			<xsl:with-param name="end" select="$mid"/>
		</xsl:call-template>
		<xsl:call-template name="coverage">
			<xsl:with-param name="iteration" select="$iteration"/>
			<xsl:with-param name="start" select="$mid + 1"/>
			<xsl:with-param name="end" select="$end"/>
		</xsl:call-template>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>


</xsl:stylesheet>
