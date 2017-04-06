# Stylesheet

https://github.com/lindenb/xslt-sandbox/blob/master/stylesheets/owl/owl2tree.xsl

# Motivation

print a OWL-OBO file as an ascii tree

# Example

```bash
wget -O - "https://github.com/The-Sequence-Ontology/SO-Ontologies/raw/master/so-simple.owl" | xsltproc owl2tree.xsl -

```


output:

```
(...)
       + gene_variant
         + gene_fusion
           - unidirectional_gene_fusion
           - bidirectional_gene_fusion
         + transcript_variant
           + splicing_variant
             + cryptic_splice_site_variant
               - cryptic_splice_acceptor
               - cryptic_splice_donor
             - exon_loss_variant
             - intron_gain_variant
             + splice_site_variant
               - splice_acceptor_variant
               - splice_donor_variant
               - splice_donor_5th_base_variant
             + splice_region_variant
               - exonic_splice_region_variant
               - non_coding_transcript_splice_region_variant
             - extended_intronic_splice_region_variant
           - complex_transcript_variant
           + transcript_secondary_structure_variant
             - compensatory_transcript_secondary_structure_variant
           + non_coding_transcript_variant
             - mature_miRNA_variant
             - non_coding_transcript_exon_variant
             - non_coding_transcript_intron_variant
             - non_coding_transcript_splice_region_variant
           - NMD_transcript_variant
           + intron_variant
             + splice_site_variant
               - splice_acceptor_variant
               - splice_donor_variant
               - splice_donor_5th_base_variant
             + coding_transcript_intron_variant
               - 3_prime_UTR_intron_variant
               - 5_prime_UTR_intron_variant
             - non_coding_transcript_intron_variant
             - conserved_intron_variant
           + exon_variant
             + coding_sequence_variant
               + initiator_codon_variant
                 - start_lost
                 - start_retained_variant
               + terminator_codon_variant
                 - stop_retained_variant
                 - stop_lost
                 - incomplete_terminal_codon_variant
               + protein_altering_variant
                 + frameshift_variant
                   - frame_restoring_variant
                   - minus_1_frameshift_variant
                   - minus_2_frameshift_variant
                   - plus_1_frameshift_variant
                   - plus_2_frameshift_variant
                   - frameshift_elongation
                   - frameshift_truncation
                 + inframe_variant
                   - incomplete_terminal_codon_variant
                   + inframe_indel
                     + inframe_insertion
                       - conservative_inframe_insertion
                       - disruptive_inframe_insertion
                     + inframe_deletion
                       - conservative_inframe_deletion
                       - disruptive_inframe_deletion
                   + nonsynonymous_variant
                     - stop_lost
                     + missense_variant
                       - conservative_missense_variant
                       + non_conservative_missense_variant
                         + rare_amino_acid_variant
                           - selenocysteine_loss
                           - pyrrolysine_loss
                     - stop_gained
                     - start_lost
               + synonymous_variant
                 - stop_retained_variant
                 - start_retained_variant
             + UTR_variant
               + 5_prime_UTR_variant
                 + 5_prime_UTR_premature_start_codon_variant
                   - 5_prime_UTR_premature_start_codon_gain_variant
                   - 5_prime_UTR_premature_start_codon_loss_variant
                   - five_prime_UTR_premature_start_codon_location_variant
                 - 5_prime_UTR_truncation
                 - 5_prime_UTR_elongation
                 - 5_prime_UTR_intron_variant
                 - 5_prime_UTR_exon_variant
               + 3_prime_UTR_variant
                 - 3_prime_UTR_truncation
                 - 3_prime_UTR_elongation
                 - 3_prime_UTR_exon_variant
                 - 3_prime_UTR_intron_variant
             - non_coding_transcript_exon_variant
           + coding_transcript_variant
             + coding_sequence_variant
               + initiator_codon_variant
                 - start_lost
                 - start_retained_variant
               + terminator_codon_variant
                 - stop_retained_variant
                 - stop_lost
                 - incomplete_terminal_codon_variant
               + protein_altering_variant
                 + frameshift_variant
                   - frame_restoring_variant
                   - minus_1_frameshift_variant
                   - minus_2_frameshift_variant
                   - plus_1_frameshift_variant
                   - plus_2_frameshift_variant
                   - frameshift_elongation
                   - frameshift_truncation
                 + inframe_variant
                   - incomplete_terminal_codon_variant
                   + inframe_indel
                     + inframe_insertion
                       - conservative_inframe_insertion
                       - disruptive_inframe_insertion
                     + inframe_deletion
                       - conservative_inframe_deletion
                       - disruptive_inframe_deletion
                   + nonsynonymous_variant
                     - stop_lost
                     + missense_variant
                       - conservative_missense_variant
                       + non_conservative_missense_variant
                         + rare_amino_acid_variant
                           - selenocysteine_loss
                           - pyrrolysine_loss
                     - stop_gained
                     - start_lost
               + synonymous_variant
                 - stop_retained_variant
                 - start_retained_variant
             + UTR_variant
               + 5_prime_UTR_variant
                 + 5_prime_UTR_premature_start_codon_variant
                   - 5_prime_UTR_premature_start_codon_gain_variant
                   - 5_prime_UTR_premature_start_codon_loss_variant
                   - five_prime_UTR_premature_start_codon_location_variant
                 - 5_prime_UTR_truncation
                 - 5_prime_UTR_elongation
                 - 5_prime_UTR_intron_variant
                 - 5_prime_UTR_exon_variant
               + 3_prime_UTR_variant
                 - 3_prime_UTR_truncation
                 - 3_prime_UTR_elongation
                 - 3_prime_UTR_exon_variant
                 - 3_prime_UTR_intron_variant
             + coding_transcript_intron_variant
               - 3_prime_UTR_intron_variant
               - 5_prime_UTR_intron_variant
           - intragenic_variant
(...)
```


