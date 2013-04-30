<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
 version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:svg="http://www.w3.org/2000/svg"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns="http://www.w3.org/1999/xhtml"
 >
<!--
Author
	Pierre Lindenbaum PhD
Mail:
	plindenbaum@yahoo.fr
Motivation:
	transforms a blast xml result to SQL statements for sqlite3
Example:
	xsltproc -\-novalid blast2sqlite.xsl blast.xml | sqlite3 db.sqlite


-->
<!-- ========================================================================= -->
<xsl:output method='text'/>



<xsl:template match="/">
<xsl:apply-templates select="BlastOutput"/>
</xsl:template>

<xsl:template match="BlastOutput">
<xsl:variable name="pkey">id INTEGER PRIMARY KEY AUTOINCREMENT</xsl:variable>
create table if not exists BlastOutput
	(
	<xsl:value-of select="$pkey"/>,
	program TEXT,
	version TEXT,
	reference TEXT,
	db TEXT,
	query_ID TEXT,
	query_def TEXT,
	query_len INT
	);

create table if not exists Parameters
	(
	<xsl:value-of select="$pkey"/>,
	blastOutput_id INTEGER,
	matrix TEXT,
	expect REAL,
	sc_match REAL,
	sc_mismatch REAL,
	gap_open REAL,
	gap_extend REAL,
	filter TEXT,
	FOREIGN KEY(BlastOutput_id ) REFERENCES BlastOutput(id)
	);

create table if not exists Iteration
	(
	<xsl:value-of select="$pkey"/>,
	blastOutput_id INTEGER,
	iter_num INT,
	query_ID TEXT,
	query_def TEXT,
	query_len INT,
	FOREIGN KEY(BlastOutput_id ) REFERENCES BlastOutput(id)
	);

create table if not exists  Statistics
	(
	<xsl:value-of select="$pkey"/>,
	iteration_id INTEGER,
	db_num INTEGER,
	db_len INTEGER,
	hsp_len INTEGER,
	eff_space REAL,
	kappa REAL,
	lambda REAL,
	entropy REAL,
	FOREIGN KEY(iteration_id ) REFERENCES Iteration(id)
	);

create table if not exists Hit
	(
	<xsl:value-of select="$pkey"/>,
	iteration_id INTEGER,
	num INTEGER,
	hit_id TEXT,
	def TEXT,
	accession TEXT,
	len INTEGER,
	FOREIGN KEY(iteration_id ) REFERENCES Iteration(id)
	);
	
create table if not exists Hsp
	(
	<xsl:value-of select="$pkey"/>,
	hit_id INTEGER,
	num INTEGER,
        bit_score REAL,
        score REAL,
        evalue REAL,
        query_from INTEGER,
        query_to INTEGER,
        hit_from INTEGER,
        hit_to INTEGER,
        query_frame INTEGER,
        hit_frame INTEGER,
        identity INTEGER,
        positive INTEGER,
        gaps INTEGER,
        align_len INTEGER,
        qseq TEXT,
        hseq TEXT,
        midline TEXT,
	FOREIGN KEY(hit_id ) REFERENCES Hit(id)
	);
	


BEGIN TRANSACTION;

insert into BlastOutput(
	program,
	version,
	reference,
	db,
	query_ID,
	query_def,
	query_len
	)
	values (
		<xsl:apply-templates select="BlastOutput_program"/>,
		<xsl:apply-templates select="BlastOutput_version"/>,
		<xsl:apply-templates select="BlastOutput_reference"/>,
		<xsl:apply-templates select="BlastOutput_db"/>,
		<xsl:choose>
		<xsl:when test="BlastOutput_query-ID"><xsl:apply-templates select="BlastOutput_query-ID"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
		</xsl:choose>,
		<xsl:choose>
			<xsl:when test="BlastOutput_query-def"><xsl:apply-templates select="BlastOutput_query-def"/></xsl:when>
			<xsl:otherwise>NULL</xsl:otherwise>
		</xsl:choose>,
		<xsl:value-of select="BlastOutput_query-len"/>
		);

<xsl:apply-templates select="BlastOutput_param/Parameters"/>
<xsl:apply-templates select="BlastOutput_iterations"/>

COMMIT TRANSACTION;
</xsl:template>

<xsl:template match="Parameters" >
insert into Parameters(
	blastOutput_id,
	expect,
	matrix,
	sc_match,
	sc_mismatch,
	gap_open,
	gap_extend,
	filter
	)
select MAX(id),
	<xsl:choose>
		<xsl:when test="Parameters_expect"><xsl:value-of select="Parameters_expect"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>,
	<xsl:choose>
		<xsl:when test="Parameters_matrix"><xsl:apply-templates select="Parameters_matrix"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>,
	<xsl:choose>
		<xsl:when test="Parameters_sc-match"><xsl:value-of select="Parameters_sc-match"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>,
	<xsl:choose>
		<xsl:when test="Parameters_sc-mismatch"><xsl:value-of select="Parameters_sc-mismatch"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>,
	<xsl:value-of select="Parameters_gap-open"/>,
	<xsl:value-of select="Parameters_gap-extend"/>,
	<xsl:choose>
		<xsl:when test="Parameters_filter"><xsl:apply-templates select="Parameters_filter"/></xsl:when>
		<xsl:otherwise>NULL</xsl:otherwise>
	</xsl:choose>
	from BlastOutput;
	
</xsl:template>


<xsl:template match="BlastOutput_iterations" >
<xsl:apply-templates select="Iteration"/>
</xsl:template>

<xsl:template match="Iteration" >

insert into Iteration(
	blastOutput_id,
	iter_num,
	query_id,
	query_def,
	query_len
	)
select MAX(id),
	<xsl:value-of select="Iteration_iter-num"/>,
	<xsl:apply-templates select="Iteration_query-ID"/>,
	<xsl:apply-templates select="Iteration_query-def"/>,
	<xsl:value-of select="Iteration_query-len"/>
from BlastOutput;
<xsl:apply-templates select="Iteration_hits/Hit"/>
<xsl:apply-templates select="Iteration_stat/Statistics"/>
</xsl:template>


<xsl:template match="Statistics">


insert into Statistics(iteration_id,db_num,db_len,hsp_len,eff_space,kappa,lambda,entropy)
select MAX(id),
	<xsl:value-of select="Statistics_db-num"/>,
	<xsl:value-of select="Statistics_db-len"/>,
	<xsl:value-of select="Statistics_hsp-len"/>,
	<xsl:value-of select="Statistics_eff-space"/>,
	<xsl:value-of select="Statistics_kappa"/>,
	<xsl:value-of select="Statistics_lambda"/>,
	<xsl:value-of select="Statistics_entropy"/>
from Iteration;
</xsl:template>


<xsl:template match="Hit" >
insert into Hit(iteration_id,num,hit_id,def,accession,len)
select MAX(id),
	<xsl:value-of select="Hit_num"/>,
	<xsl:apply-templates select="Hit_id"/>,
	<xsl:apply-templates select="Hit_def"/>,
	<xsl:apply-templates select="Hit_accession"/>,
	<xsl:value-of select="Hit_len"/>
from Iteration;

<xsl:apply-templates select="Hit_hsps/Hsp"/>
</xsl:template>

<xsl:template match="Hsp" >
insert into Hsp(hit_id,num,bit_score,score,evalue,query_from,query_to,hit_from,hit_to,query_frame,hit_frame,identity,positive,gaps,align_len,qseq,hseq,midline)
select MAX(id),
	<xsl:value-of select="Hsp_num"/>,
	<xsl:value-of select="Hsp_bit-score"/>,
	<xsl:value-of select="Hsp_score"/>,
	<xsl:value-of select="Hsp_evalue"/>,
	<xsl:value-of select="Hsp_query-from"/>,
	<xsl:value-of select="Hsp_query-to"/>,
	<xsl:value-of select="Hsp_hit-from"/>,
	<xsl:value-of select="Hsp_hit-to"/>,
	<xsl:value-of select="Hsp_query-frame"/>,
	<xsl:value-of select="Hsp_hit-frame"/>,
	<xsl:value-of select="Hsp_identity"/>,
	<xsl:value-of select="Hsp_positive"/>,
	<xsl:value-of select="Hsp_gaps"/>,
	<xsl:value-of select="Hsp_align-len"/>,
	'<xsl:value-of select="Hsp_qseq"/>',
	'<xsl:value-of select="Hsp_hseq"/>',
	'<xsl:value-of select="Hsp_midline"/>'
  from Hit;
</xsl:template>

<xsl:template match="text()" >
<xsl:text>'</xsl:text>
<xsl:call-template name="escape">
<xsl:with-param name="s" select="."/>
</xsl:call-template>
<xsl:text>'</xsl:text>
</xsl:template>


<xsl:template name="escape">
 <xsl:param name="s" />
 <xsl:variable name="a">&apos;</xsl:variable>

 <xsl:choose>
 <xsl:when test="contains($s,$a)">
       <xsl:value-of select="substring-before($s,$a)"/>
       <xsl:value-of select="$a"/>
       <xsl:value-of select="$a"/>
       <xsl:call-template name="escape">
	<xsl:with-param name="s" select="substring-after($s,$a)"/>
	</xsl:call-template>
 </xsl:when>
 <xsl:otherwise>
   <xsl:value-of select="$s"/>
 </xsl:otherwise>
 </xsl:choose>
</xsl:template>


</xsl:stylesheet>
