<?xml version='1.0' encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
 	xmlns:psi="net:sf:psidev:mi"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	version='1.0'
	>
<!--

psi2sql.xslt

Author:
	Pierre Lindenbaum PhD
Mail:
	plindenbaum@yahoo.fr

transform a psi/xml description of protein/protein interactions to
mysql statements to load it into a sqlite database.



Usage:

	xsltproc psi2sql.xslt interactions.xml | sqlite3 db.sql



Pierre

-->


<xsl:param name="temporary">false</xsl:param>


<xsl:output method="text" encoding="UTF-8"/>

<xsl:template match="/">
<xsl:variable name="tmp">
<xsl:choose>
	<xsl:when test="$temporary = 'false'"><xsl:text> </xsl:text></xsl:when>
	<xsl:otherwise><xsl:text> temporary </xsl:text></xsl:otherwise>
</xsl:choose>
</xsl:variable>

create <xsl:value-of select="$tmp"/> table if not exists interactor
	(
	pk varchar(50) not null unique,
	shortLabel varchar(255),
	fullName text,
	ncbiTaxId int
	);

create <xsl:value-of select="$tmp"/> table if not exists experiment
	(
	pk varchar(50) not null unique,
	shortLabel varchar(255) not null,
	fullName text,
	pmid int,
	interactionDetectionMethod text
	);

create <xsl:value-of select="$tmp"/> table if not exists xref
	(
	interactor_pk varchar(50) not null,
	xrefType int not null,
	db varchar(50),
	dbAc varchar(150), 
	pk varchar(50),
	refType varchar(50),
	refTypeAc varchar(50),
	FOREIGN KEY(interactor_pk) REFERENCES interactor(pk)
	);

create index if not exists xref_pk on xref(pk);

create <xsl:value-of select="$tmp"/> table  if not exists interaction
	(
	pk varchar(50) not null,
	unitLabel varchar(50),
	unitFullName varchar(100),
	confidence float,
	experiment_pk int not null,
	interactionType text,
	pmid NULL,
	foreign key (experiment_pk)  references experiment(pk)
	);
	
create <xsl:value-of select="$tmp"/> table  if not exists interaction2interactor
	(
	interaction_pk varchar(50) not null,
	interactor_pk varchar(50) not null,
	foreign key (interaction_pk) references interaction(pk),
	foreign key (interactor_pk) references interactor(pk)
	);

create index if not exists i2il on interaction2interactor(interaction_pk);
create index if not exists i2ir on interaction2interactor(interactor_pk);

BEGIN TRANSACTION;
<xsl:apply-templates/>
COMMIT;
</xsl:template>


<xsl:template match="psi:entrySet">
<xsl:apply-templates select="psi:entry"/>
</xsl:template>

<xsl:template match="psi:entry">
<xsl:apply-templates select="psi:experimentList/psi:experimentDescription"/>
<xsl:apply-templates select="psi:interactorList"/>
<xsl:apply-templates select="psi:interactionList/psi:interaction"/>
</xsl:template>

<xsl:template match="psi:interactorList">
<xsl:apply-templates select="psi:proteinInteractor|psi:interactor"/>
</xsl:template>

<xsl:template match="psi:experimentDescription">
<xsl:if test="not(@id)"><xsl:message terminate="yes">experimentDescription: no @id</xsl:message></xsl:if>
<xsl:text>insert or ignore into experiment(pk,shortLabel,fullName,pmid,interactionDetectionMethod) values(</xsl:text>
	<xsl:apply-templates select="@id" mode="quote"/>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="psi:names/psi:shortLabel/text()"><xsl:apply-templates select="psi:names/psi:shortLabel[1]/text()" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="psi:names/psi:fullName/text()"><xsl:apply-templates select="psi:names/psi:fullName[1]/text()" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="psi:bibref/psi:xref/psi:primaryRef[@db='pubmed' and number(@id)&gt;0]"><xsl:value-of select="psi:bibref/psi:xref/psi:primaryRef[@db='pubmed']/@id"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="psi:interactionDetectionMethod/psi:names/psi:shortLabel/text()"><xsl:apply-templates select="psi:interactionDetectionMethod/psi:names/psi:shortLabel[1]/text()" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>
	<xsl:text>);
</xsl:text>
</xsl:template>


<xsl:template match="psi:proteinInteractor|psi:interactor">
<xsl:if test="not(@id)"><xsl:message terminate="yes">experimentDescription: no @id</xsl:message></xsl:if>


<xsl:text>insert or ignore into interactor(pk,shortLabel,fullName,ncbiTaxId) values (</xsl:text>
	<xsl:apply-templates select="@id" mode="quote"/>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="psi:names/psi:shortLabel/text()"><xsl:apply-templates select="psi:names/psi:shortLabel[1]/text()" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="psi:names/psi:fullName/text()"><xsl:apply-templates select="psi:names/psi:fullName[1]/text()" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="psi:organism[number(@ncbiTaxId)&gt;0]"><xsl:value-of select="psi:organism/@ncbiTaxId"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>	
<xsl:text>);
</xsl:text>


<xsl:for-each select="psi:xref/psi:primaryRef|psi:xref/psi:secondaryRef">
<xsl:text>insert or ignore into xref(interactor_pk,xrefType,db,dbAc,pk,refType,refTypeAc) values (</xsl:text>
	<xsl:apply-templates select="../../@id" mode="quote"/>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="local-name(.)='primaryRef'">1</xsl:when>
		<xsl:otherwise>2</xsl:otherwise>
	</xsl:choose>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="@db"><xsl:apply-templates select="@db" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>	
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="@dbAc"><xsl:apply-templates select="@dbAc" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>	
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="@id"><xsl:apply-templates select="@id" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>		
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="@refType"><xsl:apply-templates select="@refType" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>	
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="@refTypeAc"><xsl:apply-templates select="@refTypeAc" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>
	<xsl:text>);
</xsl:text>
</xsl:for-each>
</xsl:template>


<xsl:template match="psi:interaction">

<xsl:text>insert into interaction(pk,unitLabel,unitFullName,confidence,experiment_pk,interactionType,pmid) values (</xsl:text>
	<xsl:apply-templates select="@id" mode="quote"/>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="psi:confidenceList/psi:confidence[1]/psi:unit/psi:names[1]/psi:shortLabel"><xsl:apply-templates select="psi:confidenceList/psi:confidence[1]/psi:unit/psi:names[1]/psi:shortLabel/text()" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="psi:confidenceList/psi:confidence[1]/psi:unit/psi:names[1]/psi:fullName"><xsl:apply-templates select="psi:confidenceList/psi:confidence[1]/psi:unit/psi:names[1]/psi:fullName/text()" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="psi:confidenceList/psi:confidence[1]/psi:value"><xsl:apply-templates select="psi:confidenceList/psi:confidence[1]/psi:value/text()" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="psi:experimentList/psi:experimentRef/@ref"><xsl:apply-templates select="psi:experimentList/psi:experimentRef[1]/@ref" mode="quote"/></xsl:when>		<xsl:when test="psi:experimentList/psi:experimentRef/text()"><xsl:apply-templates select="psi:experimentList/psi:experimentRef[1]/text()" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="psi:interactionType/psi:names/psi:shortLabel/text()"><xsl:apply-templates select="psi:interactionType/psi:names/psi:shortLabel/text()" mode="quote"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>
	<xsl:text>,</xsl:text>
	<xsl:choose>
		<xsl:when test="psi:xref/psi:primaryRef[@db='pubmed' and number(@id)&gt;0]"><xsl:value-of select="psi:xref/psi:primaryRef[@db='pubmed']/@id"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>
<xsl:text>);
</xsl:text>

<xsl:apply-templates select="psi:participantList/*"/>

</xsl:template>


<xsl:template match="psi:proteinParticipant">

<xsl:text>insert into interaction2interactor(interaction_pk,interactor_pk) values (</xsl:text>
<xsl:apply-templates select="../../@id" mode="quote"/>
<xsl:text>,</xsl:text>
<xsl:apply-templates select="psi:proteinInteractorRef/@ref" mode="quote"/>
<xsl:text>);
</xsl:text>
</xsl:template>

<xsl:template match="psi:participant">
<xsl:text>insert into interaction2interactor(interaction_pk,interactor_pk) values (</xsl:text>
<xsl:apply-templates select="../../@id" mode="quote"/>
<xsl:text>,</xsl:text>
<xsl:apply-templates select="psi:interactorRef/text()" mode="quote"/>
<xsl:text>);
</xsl:text>
</xsl:template>



<xsl:template match="@*" mode="quote">
<xsl:text>&quot;</xsl:text>
<xsl:call-template name="escape">
	<xsl:with-param name="s" select="."/>
</xsl:call-template>
<xsl:text>&quot;</xsl:text>
</xsl:template>

<xsl:template match="text()" mode="quote">
<xsl:text>&quot;</xsl:text>
<xsl:call-template name="escape">
	<xsl:with-param name="s" select="."/>
</xsl:call-template>
<xsl:text>&quot;</xsl:text>
</xsl:template>

<xsl:template name="escape">
 <xsl:param name="s"/>
        <xsl:choose>
        <xsl:when test="contains($s,'&quot;')">
                <xsl:value-of select="substring-before($s,'&quot;')"/>
                <xsl:text>\&quot;</xsl:text>
                <xsl:call-template name="escape">
                        <xsl:with-param name="s" select="substring-after($s,'&quot;')"/>
                </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
                <xsl:value-of select='$s'/>
        </xsl:otherwise>
        </xsl:choose>
</xsl:template>


</xsl:stylesheet>
