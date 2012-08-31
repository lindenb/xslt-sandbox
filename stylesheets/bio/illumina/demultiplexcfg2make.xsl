<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:x="http://exslt.org/dates-and-times"
	version='1.0'
	>

<!--


Author:
   Pierre Lindenbaum PhD plindenbaum@yahoo.fr

WWW:
   http://plindenbaum.blogspot.com

Motivation:
   creates a Makefile to generate a Makefile from an Illumina
   DemultiplexConfig.
   files must have been generated using CASAVA/configureBclToFastq.pl with the option 'fastq-cluster-count 0'
   This makefile creates a workflow that goes from the fastq to the VCF using samtools, gatk, etc...
   This shouldn't be considered as a state-of-the-art pipeline of analysis.
Options:
	count (int) : if set, only run on a subset of 'count' reads.
	outdir  (directory) : output directory
	indir (directory): input directory default: '.'
	reference (fasta): path to genome reference
Usage:
   xsltproc pubmed4biodb.xsl "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=19846593&retmode=xml

-->
<xsl:output method="text" encoding="UTF-8"/>
<xsl:param name="sequencingcenter">MyLaboratory</xsl:param>
<xsl:param name="reference">/path/to/human_g1k_v37.fasta</xsl:param>
<xsl:param name="outdir"><xsl:value-of select="concat(x:year(),x:month-in-year(),x:day-in-month(),'.OUTPUT.',generate-id(/))"/></xsl:param>
<xsl:param name="indir">.</xsl:param>
<xsl:param name="testcount">-1</xsl:param>

<xsl:key name="samples" match="Sample" use="@SampleId"/>


<!-- /(root) ==================================================================== -->
<xsl:template match="/">
  <xsl:text>#
#files must have been generated using CASAVA/configureBclToFastq.pl with --fastq-cluster-count 0
#path to bwa
override BWA=/path/to/bwa-0.6.1/bwa
BWASAMPEFLAG= -a 600
BWAALNFLAG= -t 4
#path to samtools
SAMTOOLS=/path/to/samtools
#path to BEDTOOLS
BEDTOOLS=/path/to/bedtools/bin
#output directory
OUTDIR=</xsl:text><xsl:value-of select="$outdir"/><xsl:text>
INPUTDIR=</xsl:text><xsl:value-of select="$indir"/><xsl:text>
REF=</xsl:text><xsl:value-of select="$reference"/><xsl:text>
JAVA=java

PICARDLIB=/path/to/picard-tools
TABIX=/path/to/tabix
GATK=/path/to/GenomeAnalysisTK.jar
GATKFLAGS=
VCFDBSNP=/path/to/ncbi/snp/00-All.vcf.gz
</xsl:text>
  <xsl:apply-templates/>
</xsl:template>
<!-- DemultiplexConfig ==================================================================== -->
<xsl:template match="DemultiplexConfig">
<xsl:text>
#rule how to create a bai from a bam:
%.bam.bai: %.bam
	#indexing BAM $&lt;
	$(SAMTOOLS) index $&lt;

#create the default output directory
$(OUTDIR):
	mkdir -p $@

#index the reference for bwa
$(REF).bwt $(REF).ann $(REF).amb $(REF).pac $(REF).sa : $(REF)
	$(BWA) index -a bwtsw $&lt;

#index the reference for samtools
$(REF).fai: $(REF)
	$(SAMTOOLS) faidx $&lt;

#create sequence dict for picard
$(REF).dict: $(REF)
	$(JAVA) -jar $(PICARDLIB)/CreateSequenceDictionary.jar REFERENCE=$(REF) OUTPUT=$&lt;


</xsl:text>
<xsl:apply-templates select="FlowcellInfo"/>
</xsl:template>

<!-- FlowcellInfo ==================================================================== -->
<xsl:template match="FlowcellInfo">



<xsl:text>
#intermediate see http://plindenbaum.blogspot.fr/2012/08/next-generation-sequencing-gnu-make-and.html
.INTERMEDIATE : </xsl:text>
<xsl:for-each select="Lane/Sample[generate-id() = generate-id(key('samples',@SampleId)) and @Ref!='unknown']">
<xsl:variable name="sampleID" select="@SampleId"/>
<xsl:text> \
	</xsl:text>
<xsl:apply-templates select="." mode="bam"/>
<xsl:text>.bai \
	</xsl:text>
<xsl:apply-templates select="." mode="bam"/>
<xsl:for-each select="../../Lane/Sample[@SampleId = $sampleID ]">
<xsl:text> \
	</xsl:text>
<xsl:apply-templates select="." mode="bam_lane"/>
</xsl:for-each>

</xsl:for-each>

<xsl:text>


#main target : generate the VCFs
all : vcfs


vcfs: </xsl:text>
<xsl:for-each select="Lane/Sample[generate-id() = generate-id(key('samples',@SampleId)) and @Ref!='unknown']">
<xsl:text> \
	</xsl:text>
<xsl:apply-templates select="." mode="gatkvcf"/><xsl:text>.gz</xsl:text>
</xsl:for-each>
<xsl:text>


</xsl:text>

<xsl:for-each select="Lane/Sample[generate-id() = generate-id(key('samples',@SampleId)) and @Ref!='unknown']">
<xsl:apply-templates select="." mode="realign"/>
<xsl:apply-templates select="." mode="merge"/>
<xsl:apply-templates select="." mode="align"/>
<xsl:apply-templates select="." mode="generatevcf"/>
</xsl:for-each>
</xsl:template>


<!-- Sample (VCF) ==================================================================== -->
<xsl:template match="Sample" mode="generatevcf">
<xsl:text>

#create a VCF for &apos;</xsl:text><xsl:value-of select="@SampleId"/><xsl:text>&apos;
</xsl:text>
<xsl:apply-templates select="." mode="gatkvcf"/>
<xsl:text>.gz : </xsl:text>
<xsl:apply-templates select="." mode="bamrealigned"/>
<xsl:text>
	$(JAVA) -jar $(GATK) \
		-T UnifiedGenotyper \
		-glm BOTH \
		-baq OFF \
		-R $(REF) \
		-I $&lt; \
		--dbsnp $(VCFDBSNP) \
		-o </xsl:text>
<xsl:apply-templates select="." mode="gatkvcf"/><xsl:text>
	$(TABIX)/bgzip </xsl:text>
<xsl:apply-templates select="." mode="gatkvcf"/><xsl:text>
	$(TABIX)/tabix -f -p vcf </xsl:text>
<xsl:apply-templates select="." mode="gatkvcf"/><xsl:text>.gz
</xsl:text>
</xsl:template>

<!-- Sample ==================================================================== -->
<xsl:template match="Sample" mode="realign">
<xsl:apply-templates select="." mode="bamrealigned"/>
<xsl:text> : </xsl:text>
<xsl:apply-templates select="." mode="bam"/>
<xsl:text> </xsl:text>
<xsl:apply-templates select="." mode="bam"/>
<xsl:text>.bai
	$(JAVA) -jar $(GATK) $(GATKFLAGS) \
		-T RealignerTargetCreator \
		-R $(REF) \
		-I $&lt; \
		-o $&lt;.intervals \
		--known $(VCFDBSNP)
	$(JAVA) -jar $(GATK) $(GATKFLAGS) \
		-T IndelRealigner \
		-R $(REF) \
		-I $&lt; \
		-o $@ \
		-targetIntervals $&lt;.intervals \
		--knownAlleles $(VCFDBSNP)
	rm -f $&lt;.intervals
</xsl:text>
</xsl:template>


<xsl:template match="Sample" mode="merge">

<!-- Loop for merging the BAM -->

  <xsl:variable name="sampleID" select="@SampleId"/>
  <xsl:text>

#create a BAM for &apos;</xsl:text><xsl:value-of select="@SampleId"/><xsl:text>&apos; by merging the other lanes
</xsl:text>
<xsl:apply-templates select="." mode="bam"/>
<xsl:text>: $(OUTDIR) </xsl:text>
<xsl:for-each select="../../Lane/Sample[@SampleId = $sampleID ]">
<xsl:text> \
		</xsl:text>
<xsl:apply-templates select="." mode="bam_lane"/>
</xsl:for-each>
<xsl:text>
	#merge BAMS
	$(JAVA) -jar $(PICARDLIB)/MergeSamFiles.jar SORT_ORDER=coordinate OUTPUT=$@</xsl:text>
<xsl:for-each select="../../Lane/Sample[@SampleId = $sampleID ]">
<xsl:text> \
		INPUT=</xsl:text>
<xsl:apply-templates select="." mode="bam_lane"/>
</xsl:for-each>
<xsl:text>
	#fix mate information
	$(JAVA) -jar $(PICARDLIB)/FixMateInformation.jar \
		INPUT=$@
	#validate
	$(JAVA) -jar $(PICARDLIB)/ValidateSamFile.jar \
		VALIDATE_INDEX=true \
		I=$@
</xsl:text>
</xsl:template>

<xsl:template match="Sample" mode="align">
<!-- Create each  BAM for each lane for each index -->
<xsl:variable name="sampleID" select="@SampleId"/>
<xsl:text>

#Create a BAM for &apos;</xsl:text><xsl:apply-templates select="." mode="basename"/><xsl:text>&apos;
</xsl:text>
<xsl:for-each select="../../Lane/Sample[@SampleId = $sampleID ]">
<xsl:variable name="tmp" select="concat('$(OUTDIR)/',generate-id(.))"/>
<xsl:variable name="sam" select="concat($tmp,'.sam')"/>
<xsl:variable name="sai1" select="concat($tmp,'_1.sai')"/>
<xsl:variable name="sai2" select="concat($tmp,'_2.sai')"/>
<xsl:variable name="unsortedbam" select="concat($tmp,'_unsorted.bam')"/>
<xsl:variable name="markdup" select="concat($tmp,'_dup.bam')"/>
<xsl:variable name="sortedbamnoprefix" select="concat($tmp,'_sorted')"/>
<xsl:text>
</xsl:text>
<xsl:apply-templates select="." mode="bam_lane"/>
<xsl:text>: $(REF).bwt \
	</xsl:text>
<xsl:apply-templates select="." mode="fastq1"/>
<xsl:text> \
	</xsl:text>
<xsl:apply-templates select="." mode="fastq2"/>

	<xsl:variable name="newfastq1">
		<xsl:choose>
			<xsl:when test="number($testcount) &gt;0">
				<xsl:value-of select="concat($tmp,'_1.new.',$testcount,'.fastq.gz')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="fastq1"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="newfastq2">
		<xsl:choose>
			<xsl:when test="number($testcount) &gt;0">
				<xsl:value-of select="concat($tmp,'_2.new.',$testcount,'.fastq.gz')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="fastq2"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:text>
	#create directory
	mkdir -p $(OUTDIR)/</xsl:text><xsl:value-of select="concat('Project_',@ProjectId,'/Sample_',@SampleId)"/><xsl:text>
	</xsl:text>

	<xsl:if test="number($testcount) &gt;0">
	<xsl:text>#Create a subset of FASTQ_1
	gunzip -c </xsl:text>
	<xsl:apply-templates select="." mode="fastq1"/>
	<xsl:text> | head -n </xsl:text>
	<xsl:value-of select="$testcount"/>
	<xsl:text> | gzip --best  &gt; </xsl:text>
	<xsl:value-of select="$newfastq1"/>
	<xsl:text>
	#Create a subset of FASTQ_2
	gunzip -c </xsl:text>
	<xsl:apply-templates select="." mode="fastq2"/>
	<xsl:text> | head -n </xsl:text>
	<xsl:value-of select="$testcount"/>
	<xsl:text> | gzip --best  &gt; </xsl:text>
	<xsl:value-of select="$newfastq2"/>
	<xsl:text>
	</xsl:text>
	</xsl:if>

	<xsl:text>#align fastq1 with BWA
	$(BWA) aln $(BWAALNFLAG) $(REF) -f </xsl:text>
	<xsl:value-of select="$sai1"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="$newfastq1"/><xsl:text>
	#align fastq2 with BWA
	$(BWA) aln $(BWAALNFLAG) $(REF) -f </xsl:text>
	<xsl:value-of select="$sai2"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="$newfastq2"/><xsl:text>
	#sampe those files
	$(BWA) sampe $(BWASAMPEFLAG)  -r &apos;</xsl:text>
	<xsl:apply-templates select="." mode="rg"/>
	<xsl:text>&apos; $(REF) \
		-f </xsl:text>
	<xsl:value-of select="$sam"/>
	<xsl:text> \
		</xsl:text>
	<xsl:value-of select="$sai1"/>
	<xsl:text> \
		</xsl:text>
	<xsl:value-of select="$sai2"/>
	<xsl:text> \
		</xsl:text>
	<xsl:value-of select="$newfastq1"/>
	<xsl:text> \
		</xsl:text>
	<xsl:value-of select="$newfastq2"/>
	<xsl:text>
	#remove sai
	rm -f </xsl:text>
	<xsl:value-of select="$sai1"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="$sai2"/>
	<xsl:text>
	</xsl:text>

	<xsl:if test="number($testcount) &gt;0">
	<xsl:text>#Remove subset of FASTQ_1 and FASTQ2
	rm -f </xsl:text>
	<xsl:value-of select="$newfastq1"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="$newfastq2"/>
	<xsl:text>
	</xsl:text>
	</xsl:if>


	<xsl:text>#convert sam to bam
	$(SAMTOOLS) view -b -T $(REF) -o </xsl:text>
	<xsl:value-of select="$unsortedbam"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="$sam"/>
	<xsl:text>
	#remove the sam
	rm -f </xsl:text>
	<xsl:value-of select="$sam"/>
	<xsl:text>
	#sort this bam
	$(SAMTOOLS) sort  </xsl:text>
	<xsl:value-of select="$unsortedbam"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="$sortedbamnoprefix"/>
	<xsl:text>
	#remove the unsorted bam
	rm -f </xsl:text>
	<xsl:value-of select="$unsortedbam"/>
	<xsl:text>
	#mark duplicates
	$(JAVA) -jar $(PICARDLIB)/MarkDuplicates.jar VALIDATION_STRINGENCY=LENIENT ASSUME_SORTED=true TMP_DIR=$(OUTDIR) \
		INPUT=</xsl:text>
	<xsl:value-of select="concat($sortedbamnoprefix,'.bam')"/>
	<xsl:text> \
		OUTPUT=</xsl:text>
	<xsl:value-of select="$markdup"/>
	<xsl:text> \
		METRICS_FILE=</xsl:text>
	<xsl:apply-templates select="." mode="picardmetrics"/>
	<xsl:text>
	#remove before duplicate
	rm -f </xsl:text>
	<xsl:value-of select="concat($sortedbamnoprefix,'.bam')"/>
	<xsl:text>
	#move to final bam
	mv </xsl:text>
	<xsl:value-of select="$markdup"/>
	<xsl:text> $@


</xsl:text>
</xsl:for-each>
</xsl:template>

<xsl:template match="Sample" mode="gatkvcf">
<xsl:text>$(OUTDIR)/</xsl:text>
<xsl:apply-templates select="." mode="basename2"/>
<xsl:text>.vcf</xsl:text>
</xsl:template>


<xsl:template match="Sample" mode="bamrealigned">
<xsl:text>$(OUTDIR)/</xsl:text>
<xsl:apply-templates select="." mode="basename2"/>
<xsl:text>.realigned.bam</xsl:text>
</xsl:template>

<xsl:template match="Sample" mode="picardmetrics">
<xsl:text>$(OUTDIR)/</xsl:text>
<xsl:apply-templates select="." mode="basename2"/>
<xsl:text>.metrics</xsl:text>
</xsl:template>

<xsl:template match="Sample" mode="rg">
<xsl:text>@RG	ID:</xsl:text>
<xsl:value-of select="generate-id(.)"/>
<xsl:text>	CN:</xsl:text>
<xsl:value-of select="$sequencingcenter"/>
<xsl:text>	LB:</xsl:text>
<xsl:value-of select="@SampleId"/>
<xsl:text>	PG:bwa	SM:</xsl:text>
<xsl:value-of select="@SampleId"/>
<xsl:text>	PL:ILLUMINA</xsl:text>
</xsl:template>

<xsl:template match="Sample" mode="bam">
<xsl:text>$(OUTDIR)/Project_</xsl:text>
<xsl:value-of select="@ProjectId"/>
<xsl:text>/Sample_</xsl:text>
<xsl:value-of select="@SampleId"/>
<xsl:text>/</xsl:text>
<xsl:value-of select="@SampleId"/>
<xsl:text>.bam</xsl:text>
</xsl:template>

<xsl:template match="Sample" mode="bam_lane">
<xsl:text>$(OUTDIR)/</xsl:text>
<xsl:apply-templates select="." mode="basename"/>
<xsl:text>.bam</xsl:text>
</xsl:template>


<xsl:template match="Sample" mode="sai1">
<xsl:apply-templates select="." mode="basename"/>
<xsl:text>_R1_001.sai</xsl:text>
</xsl:template>

<xsl:template match="Sample" mode="sai2">
<xsl:text>$(OUTDIR)/</xsl:text>
<xsl:apply-templates select="." mode="basename"/>
<xsl:text>_R2_001.sai</xsl:text>
</xsl:template>


<xsl:template match="Sample" mode="fastq1">
<xsl:text>$(INPUTDIR)/</xsl:text>
<xsl:apply-templates select="." mode="basename"/>
<xsl:text>_R1_001.fastq.gz</xsl:text>
</xsl:template>

<xsl:template match="Sample" mode="fastq2">
<xsl:text>$(INPUTDIR)/</xsl:text>
<xsl:apply-templates select="." mode="basename"/>
<xsl:text>_R2_001.fastq.gz</xsl:text>
</xsl:template>


<xsl:template match="Sample" mode="basename">
<xsl:apply-templates select="." mode="basename2"/>
<xsl:text>_</xsl:text>
<xsl:value-of select="@Index"/>
<xsl:text>_L</xsl:text>
<xsl:choose>
<xsl:when test="string-length(../@Number)=1">
	<xsl:value-of select="concat('00',../@Number)"/>
  </xsl:when>
<xsl:when test="string-length(../@Number)=2">
	<xsl:value-of select="concat('0',../@Number)"/>
  </xsl:when>
<xsl:otherwise>
	<xsl:value-of select="../@Number"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="Sample" mode="basename2">
<xsl:text>Project_</xsl:text>
<xsl:value-of select="@ProjectId"/>
<xsl:text>/Sample_</xsl:text>
<xsl:value-of select="@SampleId"/>
<xsl:text>/</xsl:text>
<xsl:value-of select="@SampleId"/>
</xsl:template>

</xsl:stylesheet>








