<?xml version='1.0'  encoding="UTF-8" ?>
<!--

Auhor: Pierre Lindenbaum
Motivation: transforms a "project.xml" to a Makefile for a NGS pipeline

example project:

<project>
  <sample name=Sample1">
    <sequences>
      <pair>
        <fastq index="1" path="....._1.fatq.gz"/>
        <fastq index="2" path="....._2.fatq.gz"/>
      </pair>
      <pair>
        <fastq index="1" path="....._1.fatq.gz"/>
        <fastq index="2" path="....._2.fatq.gz"/>
      </pair>
    </sequences>
  </sample>
  <sample name="Sample2">
    <sequences>
      <pair>
        <fastq index="1" path="....._1.fatq.gz"/>
        <fastq index="2" path="....._2.fatq.gz"/>
      </pair>
      <pair>
        <fastq index="1" path="....._1.fatq.gz"/>
        <fastq index="2" path="....._2.fatq.gz"/>
      </pair>
    </sequences>
  </sample>
</project>


-->
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
	>


<xsl:output method="text" encoding="UTF-8"/>
<xsl:param name="limit"/>
<xsl:param name="fragmentsize">600</xsl:param>
<xsl:param name="bwathreads">1</xsl:param>

<xsl:template match="/">
<xsl:apply-templates select="project"/>
</xsl:template>

<xsl:template match="project">
<xsl:text>include tools.mk config.mk
</xsl:text>

<!--
config.mk could be

TMPREFIX=jeter.
OUTDIR=../align/_ignore.backup

-->

<!-- tools.mk could be

REF=/commun/data/pubdb/broadinstitute.org/resources/human_g1k_v37.fasta
JAVA=/usr/bin/java
GATK=$(JAVA) -Xmx2g -jar /usr/local/package/gatk/GenomeAnalysisTK-1.6-13-g91f02df/GenomeAnalysisTK.jar  
SAMTOOLS=/usr/local/package/samtools-0.1.18/samtools
BCFTOOLS=/usr/local/package/samtools-0.1.18/bcftools/bcftools
PICARD=/usr/local/package/picard-tools-1.77
BEDTOOLS=/usr/local/package/bedtools/bin
BWA=/usr/local/package/bwa-0.6.1/bwa
VCFDBSNP=/commun/data/pubdb/ncbi/_ignore.backup/snp/00-All.vcf.gz
BAMSUFFIX=_realigned
VARKIT=${HOME}/src/variationtoolkit/bin
DELETEFILE=echo "DELETE-FILE: "
-->
LOCKFILE=$(OUTDIR)/<xsl:value-of select="concat('_tmp.',generate-id(.),'.lock')"/>
XMLSTATS=$(OUTDIR)/pipeline.stats.xml
INDEXED_REFERENCE=$(foreach S,.amb .ann .bwt .pac .sa .fai,$(addsuffix $S,$(REF))) $(addsuffix	.dict,$(basename $(REF)))
SAMPLES=<xsl:for-each select="sample"><xsl:value-of select="concat(' ',@name)"/></xsl:for-each>


<xsl:text>
.PHONY: indexed_reference bams bams_realigned  bams_sorted bams_merged bams_unsorted bams_recalibrated bams_markdup \
	coverage toptarget


define indexed_bam
    $(1) $(foreach B,$(filter %.bam,$(1)),  $(addsuffix .bai,$B) )
endef

define timebegindb
	lockfile $(LOCKFILE)
	$(VARKIT)/simplekeyvalue -f $(XMLSTATS) -p time-begin "$(1)" `date +"%s"`
	rm -f $(LOCKFILE)
endef

define timeenddb
	lockfile $(LOCKFILE)
	$(VARKIT)/simplekeyvalue -f $(XMLSTATS) -p time-end "$(1)" `date +"%s"`
	rm -f $(LOCKFILE)
endef


define sizedb
	lockfile $(LOCKFILE)
	stat -c "%s" $(1) | xargs $(VARKIT)/simplekeyvalue -f $(XMLSTATS) -p size "$(1)" 
	rm -f $(LOCKFILE)
endef



# doesn't work with qmake
#
#%.bai: %.bam
#	$(call timebegindb,$@)
#	$(SAMTOOLS) index $&lt;
#	$(call timeenddb,$@)
#	$(call sizedb,$@)
#

%.amb %.ann %.bwt %.pac %.sa : %.fasta
	$(BWA) index -a bwtsw $&lt; 

%.fasta.fai : %.fasta
	$(SAMTOOLS) faidx $&lt;

%.dict: %.fasta
	 $(JAVA) -jar $(PICARD)/CreateSequenceDictionary.jar \
		R=$&lt; \
		O=$@ \
		GENOME_ASSEMBLY=$(basename $(notdir $&lt;)) \
		TRUNCATE_NAMES_AT_WHITESPACE=true

.SECONDARY :</xsl:text><xsl:for-each select="sample"> \
	$(call indexed_bam,<xsl:apply-templates select="." mode="markdup"/>) \
	$(call indexed_bam,<xsl:apply-templates select="." mode="realigned"/>) \
	$(call indexed_bam,<xsl:apply-templates select="." mode="merged"/>) <xsl:for-each select="sequences/pair">
		<xsl:apply-templates select="." mode="sorted"/>
		<xsl:apply-templates select="." mode="unsorted"/>
		<xsl:for-each select="fastq">
			<xsl:apply-templates select="." mode="sai"/>
		</xsl:for-each>
	</xsl:for-each>

	</xsl:for-each>

<xsl:text>

toptarget:
	echo "This is the top target. Please select a specific target"

all: $(OUTDIR)/variations.samtools.snpEff.vcf.gz $(OUTDIR)/variations.gatk.snpEff.vcf.gz

indexed_reference: $(INDEXED_REFERENCE)




#coverage.tsv : ensembl.exons.bed  $(foreach S,$(SAMPLES),$(OUTDIR)/$(S)$(BAMSUFFIX).bam )
#	${VARKIT}/beddepth $(foreach S,$(SAMPLES),-f $(OUTDIR)/$(S)$(BAMSUFFIX).bam ) &lt; $&lt; &gt; $@

ensembl.exons.bed:
	 curl -s -d 'query=<![CDATA[<?xml version="1.0" encoding="UTF-8"?><Query virtualSchemaName="default" formatter="TSV" header="0" uniqueRows="0" count="" datasetConfigVersion="0.6" ><Dataset name="hsapiens_gene_ensembl" interface="default" ><Attribute name="chromosome_name" /><Attribute name="exon_chrom_start" /><Attribute name="exon_chrom_end" /></Dataset></Query>]]>' "http://www.biomart.org/biomart/martservice/result" |\
	grep -v '_' |grep -v 'GL' |grep -v 'MT' |\
	awk -F '	' '{S=int($$2)-100; if(S&lt;0) S=0; printf("%s\t%d\t%d\n",$$1,S,int($$3)+100);}' |\
	sort -t '	' -k1,1 -k2,2n -k3,3n |\
	$(BEDTOOLS)/mergeBed -d 100 -i - &gt; $@
	


#bams:bams$(BAMSUFFIX)
bams_realigned:</xsl:text><xsl:for-each select="sample"><xsl:apply-templates select="." mode="realigned"/></xsl:for-each><xsl:text>
bams_markdup: </xsl:text><xsl:for-each select="sample"><xsl:apply-templates select="." mode="markdup"/></xsl:for-each><xsl:text>
bams_merged: </xsl:text><xsl:for-each select="sample"><xsl:apply-templates select="." mode="merged"/></xsl:for-each><xsl:text>
bams_recalibrated: </xsl:text><xsl:for-each select="sample"><xsl:apply-templates select="." mode="recal"/></xsl:for-each><xsl:text>
bams_unsorted: </xsl:text><xsl:for-each select="sample/sequences/pair"><xsl:apply-templates select="." mode="unsorted"/></xsl:for-each><xsl:text>
bams_sorted: </xsl:text><xsl:for-each select="sample/sequences/pair"><xsl:apply-templates select="." mode="sorted"/></xsl:for-each><xsl:text>
coverage: </xsl:text><xsl:for-each select="sample"><xsl:apply-templates select="." mode="coverage"/></xsl:for-each>




$(OUTDIR)/variations.samtools.snpEff.vcf.gz: $(OUTDIR)/variations.samtools.vcf.gz
	gunzip -c  $&lt; |\
	egrep -v '^GL' |\
	$(JAVA) -jar $(SNPEFF)/snpEff.jar eff -i vcf -o vcf -c $(SNPEFF)/snpEff.config  $(SNPEFFBUILD) |\
	$(SNPEFF)/scripts/vcfEffOnePerLine.pl |\
	gzip &gt; $@

$(OUTDIR)/variations.samtools.vcf.gz: $(call indexed_bam,<xsl:for-each select="sample"><xsl:apply-templates select="." mode="recal"/></xsl:for-each>)
	$(call timebegindb,$@)
	$(SAMTOOLS) mpileup -uD -q 30 -f $(REF) $(filter %.bam,$^) |\
	$(BCFTOOLS) view -vcg - | gzip --best &gt; $@
	$(call timeenddb,$@)

$(OUTDIR)/variations.gatk.snpEff.vcf.gz: $(OUTDIR)/variations.gatk.vcf.gz
	gunzip -c  $&lt; |\
	egrep -v '^GL' |\
	$(JAVA) -jar $(SNPEFF)/snpEff.jar eff -i vcf -o vcf -c $(SNPEFF)/snpEff.config  $(SNPEFFBUILD) |\
	$(SNPEFF)/scripts/vcfEffOnePerLine.pl |\
	gzip &gt; $@

$(OUTDIR)/variations.gatk.vcf.gz: $(call indexed_bam,<xsl:for-each select="sample"><xsl:apply-templates select="." mode="recal"/></xsl:for-each>)
	$(call timebegindb,$@)
	$(JAVA) $(GATK.jvm) -jar $(GATK.jar) $(GATK.flags) \
		-R $(REF) \
		-T UnifiedGenotyper \
		-glm BOTH \
		-S SILENT \
		$(foreach B,$(filter %.bam,$^), -I $B ) \
		--dbsnp $(VCFDBSNP) \
		-o $(basename $@)
	gzip --best $(basename $@)
	$(call timeendb,$@)
	$(call sizedb,$@)




<xsl:for-each select="sample">

<xsl:apply-templates select="." mode="coverage"/>: $(call indexed_bam,<xsl:apply-templates select="." mode="recal"/>) ensembl.exons.bed
	$(call timebegindb,$@)
	$(JAVA) $(GATK.jvm) -jar $(GATK.jar) $(GATK.flags) \
		-R $(REF) \
		-T DepthOfCoverage \
		-L $(filter %.bed,$^) \
		-S SILENT \
		-omitBaseOutput \
		--summaryCoverageThreshold 5 \
		-I $(filter %.bam,$^) \
		-o $@
	$(call timeendb,$@)



<xsl:apply-templates select="." mode="dir"/>:
	mkdir -p $@


<xsl:call-template name="make.bai">
 <xsl:with-param name="bam">
  <xsl:apply-templates select="." mode="realigned"/>
 </xsl:with-param>
</xsl:call-template>

<xsl:call-template name="make.bai">
 <xsl:with-param name="bam">
  <xsl:apply-templates select="." mode="markdup"/>
 </xsl:with-param>
</xsl:call-template>

<xsl:if test="count(sequences/pair)&gt;1">
<xsl:call-template name="make.bai">
 <xsl:with-param name="bam">
  <xsl:apply-templates select="." mode="merged"/>
 </xsl:with-param>
</xsl:call-template>
</xsl:if>

<xsl:call-template name="make.bai">
 <xsl:with-param name="bam">
  <xsl:apply-templates select="." mode="recal"/>
 </xsl:with-param>
</xsl:call-template>



<xsl:apply-templates select="." mode="markdup"/> : $(call indexed_bam,<xsl:apply-templates select="." mode="realigned"/>)
	$(call timebegindb,$@_markdup)
	$(JAVA) $(PICARD.jvm) -jar $(PICARD)/MarkDuplicates.jar \
		TMP_DIR=$(OUTDIR) \
		INPUT=$(filter %.bam,$^) \
		O=$@ \
		MAX_FILE_HANDLES=400 \
		M=$@.metrics \
		AS=true \
		VALIDATION_STRINGENCY=SILENT
	$(call timeenddb,$@_markdup)
	#$(call timebegindb,$@_fixmate)
	#$(JAVA) $(PICARD.jvm) -jar $(PICARD)/FixMateInformation.jar  TMP_DIR=$(OUTDIR) INPUT=$@  VALIDATION_STRINGENCY=SILENT
	#$(call timendedb,$@_fixmate)
	#$(SAMTOOLS) index $@
	#$(call timebegindb,$@_validate)
	#$(JAVA) $(PICARD.jvm) -jar $(PICARD)/ValidateSamFile.jar TMP_DIR=$(OUTDIR) VALIDATE_INDEX=true I=$@  CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT IGNORE_WARNINGS=true
	#$(call timeenddb,$@_validate)
	$(DELETEFILE) $&lt; $@.metrics 
	$(call sizedb,$@)




<xsl:apply-templates select="." mode="recal"/> : $(call indexed_bam,<xsl:apply-templates select="." mode="markdup"/>) ensembl.exons.bed
	$(call timebegindb,$@_countCovariates)
	$(JAVA) $(GATK.jvm) -jar $(GATK.jar) $(GATK.flags) \
		-T BaseRecalibrator \
		-R $(REF) \
		-I $(filter %.bam,$^) \
		-l INFO \
		-o $@.recal_data.grp \
		-knownSites $(VCFDBSNP) \
		-L $(filter %.bed,$^) \
		-cov ReadGroupCovariate \
		-cov QualityScoreCovariate \
		-cov CycleCovariate \
		-cov ContextCovariate
	$(call timeenddb,$@_countCovariates)
	$(call timebegindb,$@_tableRecalibaration)
	$(JAVA) $(GATK.jvm) -jar $(GATK.jar) $(GATK.flags) \
		-T PrintReads \
		-R $(REF) \
		-BQSR $@.recal_data.grp \
		-I $(filter %.bam,$^) \
		-o $@ \
		-l INFO
	$(call timeenddb,$@_tableRecalibaration)
	$(call sizedb,$@)
	$(DELETEFILE) $&lt; $@.recal_data.grp

<xsl:apply-templates select="." mode="realigned"/>: $(call indexed_bam,<xsl:apply-templates select="." mode="merged"/>) ensembl.exons.bed
		$(call timebegindb,$@_targetcreator)
		$(JAVA) $(GATK.jvm) -jar $(GATK.jar) $(GATK.flags) \
			-T RealignerTargetCreator \
  			-R $(REF) \
			-L $(filter %.bed,$^) \
  			-I $(filter %.bam,$^) \
			-S SILENT \
  			-o $&lt;.intervals \
			--known $(VCFDBSNP)
		$(call timebegindb,$@_targetcreator)
		$(call timeenddb,$@_indelrealigner)
		$(JAVA) $(GATK.jvm) -jar  $(GATK.jar) $(GATK.flags) \
  			-T IndelRealigner \
  			-R $(REF) \
  			-I $(filter %.bam,$^) \
			-S SILENT \
  			-o $@ \
  			-targetIntervals $&lt;.intervals \
			--knownAlleles $(VCFDBSNP)
		$(call timeenddb,$@_indelrealigner)
		$(call sizedb,$@)
		$(DELETEFILE) $&lt; $&lt;.intervals






<xsl:if test="count(sequences/pair)&gt;1">
<xsl:apply-templates select="." mode="merged"/> : <xsl:for-each select="sequences/pair"><xsl:apply-templates select="." mode="sorted"/></xsl:for-each>
	$(call timebegindb,$@)
	$(JAVA) -jar $(PICARD)/MergeSamFiles.jar O=$@ AS=true \
		VALIDATION_STRINGENCY=SILENT COMMENT="Merged from $^" \
		$(foreach B,$^, I=$(B) )
	$(DELETEFILE) $^
	$(call timeenddb,$@)
	$(call sizedb,$@)

</xsl:if>

<xsl:for-each select="sequences/pair">

<xsl:call-template name="make.bai">
 <xsl:with-param name="bam">
  <xsl:apply-templates select="." mode="sorted"/>
 </xsl:with-param>
</xsl:call-template>


<xsl:apply-templates select="." mode="sorted"/> : <xsl:apply-templates select="." mode="unsorted"/>
	$(call timebegindb,$@)
	$(SAMTOOLS) sort $&lt; $(basename $@)
	$(DELETEFILE) $&lt;
	$(call timeenddb,$@)
	$(call sizedb,$@)

<xsl:apply-templates select="." mode="unsorted"/> : <xsl:apply-templates select="fastq[@index='1']" mode="fastq"/>
	<xsl:text> </xsl:text>
	<xsl:apply-templates select="fastq[@index='2']" mode="fastq"/>
	<xsl:text> </xsl:text>
	<xsl:apply-templates select="fastq[@index='1']" mode="sai"/>
	<xsl:text> </xsl:text>
	<xsl:apply-templates select="fastq[@index='2']" mode="sai"/>
	$(call timebegindb,$@)
	$(BWA) sampe -a <xsl:apply-templates select="." mode="fragmentSize"/> ${REF} \
		-r "@RG	ID:<xsl:value-of select="generate-id(.)"/>	LB:<xsl:value-of select="../../@name"/>	SM:<xsl:value-of select="../../@name"/>	PL:ILLUMINA" \
		<xsl:apply-templates select="fastq[@index='1']" mode="sai"/> \
		<xsl:apply-templates select="fastq[@index='2']" mode="sai"/> \
		<xsl:apply-templates select="fastq[@index='1']" mode="fastq"/> \
		<xsl:apply-templates select="fastq[@index='2']" mode="fastq"/> |\
	$(SAMTOOLS) view -S -b -o $@ -T ${REF} -
	$(DELETEFILE) <xsl:apply-templates select="fastq" mode="sai"/> <xsl:for-each select="fastq">
		<xsl:if test="number($limit)&gt;0 or substring(@path, string-length(@path)- 3)='.bz2'">
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="." mode="fastq"/>
		</xsl:if>
	</xsl:for-each> 
	$(call timeenddb,$@)
	$(call sizedb,$@)


<xsl:for-each select="fastq">
<xsl:text>

</xsl:text>

<xsl:choose>
<xsl:when test="substring(@path, string-length(@path)- 3)='.bz2'">

#need to convert from bz2 to gz
<xsl:apply-templates select="." mode="fastq"/>:<xsl:value-of select="@path"/><xsl:text> </xsl:text><xsl:apply-templates select="." mode="dir"/>
	bunzip -c $&lt; | <xsl:if test="number($limit)&gt;0"> head -n <xsl:value-of select="number($limit)*4"/> |</xsl:if> gzip --best &gt; $@

</xsl:when>

<xsl:when test="number($limit)&gt;0">
<xsl:apply-templates select="." mode="fastq"/>:<xsl:value-of select="@path"/><xsl:text> </xsl:text><xsl:apply-templates select="." mode="dir"/>
	gunzip -c $&lt; | head  -n <xsl:value-of select="number($limit)*4"/> | gzip --best &gt; $@	
</xsl:when>

</xsl:choose>



<xsl:apply-templates select="." mode="sai"/>:<xsl:apply-templates select="." mode="fastq"/><xsl:text> </xsl:text><xsl:apply-templates select="." mode="dir"/> $(INDEXED_REFERENCE)
	gunzip -c $&lt; | wc -l | sed 's%$$%/4%' | bc | while read C; do lockfile $(LOCKFILE); $(VARKIT)/simplekeyvalue -f $(XMLSTATS) -p count-reads $&lt; $$C ; rm -f $(LOCKFILE) ; done
	$(call timebegindb,$@)
	$(call sizedb,$&lt;)
	$(BWA) aln $(BWA.aln.options) -f $@ ${REF} $&lt;
	$(call timeenddb,$@)
	$(call sizedb,$@)

</xsl:for-each>
</xsl:for-each>
</xsl:for-each>


</xsl:template>


<xsl:template match="fastq" mode="dir">
	<xsl:apply-templates select="../../.." mode="dir"/>
</xsl:template>

<xsl:template match="fastq" mode="fastq">
<xsl:choose>
 <xsl:when test="number($limit)&gt;0 or substring(@path, string-length(@path)- 3)='.bz2'">
	<xsl:variable name="p"><xsl:apply-templates select=".." mode="pairname"/></xsl:variable>
	<xsl:text>$(OUTDIR)/</xsl:text><xsl:value-of select="concat(../../../@name,'/$(TMPREFIX)',$p,'_',@index,'.fastq.gz ')"/>
 </xsl:when>
 <xsl:otherwise>
	<xsl:value-of select="@path"/>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="fastq" mode="sai">
<xsl:variable name="p"><xsl:apply-templates select=".." mode="pairname"/></xsl:variable>
<xsl:text>$(OUTDIR)/</xsl:text><xsl:value-of select="concat(../../../@name,'/$(TMPREFIX)',$p,'_',@index,'.sai ')"/>
</xsl:template>

<xsl:template match="pair" mode="fragmentSize">
<xsl:choose>
  <xsl:when test="@fragmentSize"><xsl:value-of select="@fragmentSize"/></xsl:when>
  <xsl:when test="/project/fragmentSize"><xsl:value-of select="/project/fragmentSize"/></xsl:when>
  <xsl:otherwise>500</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="pair" mode="sorted">
<xsl:variable name="p"><xsl:apply-templates select="." mode="pairname"/></xsl:variable>
<xsl:text>$(OUTDIR)/</xsl:text><xsl:value-of select="concat(../../@name,'/$(TMPREFIX)',$p,'_sorted.bam ')"/>
</xsl:template>

<xsl:template match="sample" mode="merged">
<xsl:choose>
<xsl:when test="count(sequences/pair)&gt;1">
	<xsl:apply-templates select="." mode="dir"/>
	<xsl:value-of select="concat('/$(TMPREFIX)',@name,'_merged.bam ')"/>
</xsl:when>
<xsl:otherwise>
	<xsl:apply-templates select="sequences/pair[1]" mode="sorted"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="pair" mode="unsorted">
<xsl:variable name="p"><xsl:apply-templates select="." mode="pairname"/></xsl:variable>
<xsl:apply-templates select="../.." mode="dir"/>
<xsl:value-of select="concat('/$(TMPREFIX)',$p,'_unsorted.bam ')"/>
</xsl:template>

<xsl:template match="fastq" mode="gz">
<xsl:variable name="p"><xsl:apply-templates select=".." mode="pairname"/></xsl:variable>
<xsl:apply-templates select="../.." mode="dir"/>
<xsl:value-of select="concat('/$(TMPREFIX)',$p,'_',@index,'.fastq.gz')"/>
</xsl:template>


<xsl:template match="pair" mode="pairname">
<xsl:value-of select="concat(../../@name,'_pair',(1+count(preceding-sibling::pair)))"/>
</xsl:template>


<xsl:template match="sample" mode="coverage">
<xsl:apply-templates select="." mode="dir"/>
<xsl:value-of select="concat('/',@name,'_coverage ')"/>
</xsl:template>


<xsl:template match="sample" mode="sorted">
<xsl:apply-templates select="." mode="dir"/>
<xsl:value-of select="concat('/',@name,'_sorted.bam ')"/>
</xsl:template>

<xsl:template match="sample" mode="markdup">
<xsl:apply-templates select="." mode="dir"/>
<xsl:value-of select="concat('/',@name,'_markdup.bam ')"/>
</xsl:template>

<xsl:template match="sample" mode="recal">
<xsl:apply-templates select="." mode="dir"/>
<xsl:value-of select="concat('/',@name,'_recal.bam ')"/>
</xsl:template>

<xsl:template match="sample" mode="realigned">
<xsl:apply-templates select="." mode="dir"/>
<xsl:value-of select="concat('/',@name,'_realigned.bam ')"/>
</xsl:template>

<xsl:template match="sample" mode="dir">
<xsl:text>$(OUTDIR)/</xsl:text>
<xsl:value-of select="@name"/>
</xsl:template>

<xsl:template name="make.bai">
<xsl:param name="bam"/>
<xsl:text>
#
# create BAM index for </xsl:text>
<xsl:value-of select="$bam"/>
<xsl:text>
#
</xsl:text>
<xsl:value-of select="concat(normalize-space($bam),'.bai')"/> <xsl:text>: </xsl:text><xsl:value-of select="$bam"/><xsl:text>
	$(call timebegindb,$@)
	$(SAMTOOLS) index $&lt;
	$(call timeenddb,$@)
	$(call sizedb,$@)

</xsl:text>
</xsl:template>

</xsl:stylesheet>
