# motivation

converts 'Sequence ontology in OWL' to a C/java/... code to recreate the ontology tree in memory

# stylesheet

https://github.com/lindenb/xslt-sandbox/blob/master/stylesheets/bio/so/so2java.xsl


# Usage

```
curl -L  "https://github.com/The-Sequence-Ontology/SO-Ontologies/blob/master/so-simple.owl?raw=true" | xsltproc so2java.xsl -|
```

# Output

function:

```c
newTerm(term_accession, term_label, term_parent1, term_parent2, .... term_parentN);
```


```c
newTerm("SO:0000001","region","SO:0000110");
newTerm("SO:0000002","sequence_secondary_structure","SO:0001411");
newTerm("SO:0000003","G_quartet","SO:0000002");
newTerm("SO:0000004","interior_coding_exon","SO:0000195");
newTerm("SO:0000005","satellite_DNA","SO:0000705");
newTerm("SO:0000006","PCR_product","SO:0000695");
newTerm("SO:0000007","read_pair","SO:0000150");
newTerm("SO:0000010","protein_coding","SO:0000401");
newTerm("SO:0000011","non_protein_coding","SO:0000401");
newTerm("SO:0000012","scRNA_primary_transcript","SO:0000483");
newTerm("SO:0000013","scRNA","SO:0000655");
newTerm("SO:0000014","INR_motif","SO:0001660");
newTerm("SO:0000015","DPE_motif","SO:0001660");
newTerm("SO:0000016","BREu_motif","SO:0001660");
newTerm("SO:0000017","PSE_motif","SO:0000713");
newTerm("SO:0000018","linkage_group","SO:0001411");
newTerm("SO:0000020","RNA_internal_loop","SO:0000715");
newTerm("SO:0000021","asymmetric_RNA_internal_loop","SO:0000020");
newTerm("SO:0000022","A_minor_RNA_motif","SO:0000715");
newTerm("SO:0000023","K_turn_RNA_motif","SO:0000021");
newTerm("SO:0000024","sarcin_like_RNA_motif","SO:0000021");
newTerm("SO:0000026","RNA_junction_loop","SO:0000715");
newTerm("SO:0000027","RNA_hook_turn","SO:0000026");
newTerm("SO:0000028","base_pair","SO:0000002");
newTerm("SO:0000029","WC_base_pair","SO:0000028");
newTerm("SO:0000030","sugar_edge_base_pair","SO:0000028");
newTerm("SO:0000031","aptamer","SO:0000696");
newTerm("SO:0000032","DNA_aptamer","SO:0000031");
newTerm("SO:0000033","RNA_aptamer","SO:0000031");
(...)
newTerm("SO:1001281","flanking_three_prime_quadruplet_recoding_signal","SO:1001277");
newTerm("SO:1001282","UAG_stop_codon_signal","SO:1001288");
newTerm("SO:1001283","UAA_stop_codon_signal","SO:1001288");
newTerm("SO:1001284","regulon","SO:0005855");
newTerm("SO:1001285","UGA_stop_codon_signal","SO:1001288");
newTerm("SO:1001286","three_prime_repeat_recoding_signal","SO:1001277");
newTerm("SO:1001287","distant_three_prime_recoding_signal","SO:1001277");
newTerm("SO:1001288","stop_codon_signal","SO:1001268");
newTerm("SO:2000061","databank_entry","SO:0000695");
newTerm("SO:3000000","gene_segment","SO:0000842");
```

