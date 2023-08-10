---
layout: single
show_date: true
tags: Hecatomb Phables NCBI genomes
author: Michael Roach
title: Uploading you Phables genomes
excerpt: "You've run our awesome tools and have some viral genomes. Now what?"
---

Assuming you have already run Hecatomb and Phables to produce some nice new phage genomes.
How do we go about uploading them? Just use NCBI's BankIt. It's easy.
You probably don't even need this guide.

# Checks

First, run [CheckV](https://bitbucket.org/berkeleylab/checkv/src/master/) to make sure you're only uploading the best quality genomes.

```bash
conda install checkv
checkv download_database ~/.checkvDB
checkv end_to_end resolved_paths.fasta checkvResults -d ~/.checkvDB
```

I had three nice looking genomes in this dataset.

```text
contig_id              contig_length  provirus  proviral_length  gene_count  viral_genes  host_genes  checkv_quality  miuvig_quality  completeness  completeness_method      contamination  kmer_freq  warnings
phage_comp_48_cycle_1  156191         No        NA               197         71           11          Complete        High-quality    100.0         DTR (medium-confidence)  0.0            1.01
phage_comp_72_cycle_1  34944          No        NA               53          21           0           Complete        High-quality    100.0         DTR (high-confidence)    0.0            1.01
phage_comp_75_cycle_1  39484          No        NA               46          9            0           Complete        High-quality    100.0         DTR (high-confidence)    0.0            1.01
```

# Annotation

Next, annotate the high quality phage genomes with [Pharokka](https://github.com/gbouras13/pharokka).
Example for phage_comp_72_cycle_1 is shown.

```bash
conda install pharokka
install_databases.py -d
pharokka.py -i resolved_phages/phage_comp_72_cycle_1.fasta -o resolved_phages/phage_comp_72_cycle_1.out -t 4
```

# Preparation for submission

Concatenate all the strains you will be submitting into one multi-fasta file.

```bash
cat resolved_phages/*.fasta > allSeqs.fasta
```

Concatenate all of Pharokka's .tbl files into one file.

```bash
cat p48/pharokka.tbl p72/pharokka.tbl p75/pharokka.tbl > allSeqs.tbl
```

Create a tab-separated [organism file](https://www.ncbi.nlm.nih.gov/WebSub/html/help/organism.html) that tells NCBI what the genome is.
I won't go into detail here, but this step is important and do your best to have detailed and correct annotations.
In my case, we could designate p48 as a _Kyanoviridae_ but the other two we could only determine were some sort of _Caudoviricetes_.
I've also added isolate names to make sure they're unique. 
This is my `allSeqs.tsv` organism file.

```text
Sample_ID               Organism
phage_comp_48_cycle_1   Kyanoviridae phage C48C1
phage_comp_72_cycle_1   Caudoviricetes phage C72C1
phage_comp_75_cycle_1   Cudoviricetes phage C75C1
```

Optionally, create a tab-separated source modifiers file. 
This is the same format as the organism file, you need 'Sample_ID' and add as many of the available 
[source modifiers](https://www.ncbi.nlm.nih.gov/WebSub/html/help/genbank-source-table.html#modifiers) as you can.

# NCBI BankIt

NCBI's BankIt tool makes submitting these genome much much easier than if you were to create the
BioSample accessions and do Genome submissions.
 - Go to the [BankIt submission page](https://www.ncbi.nlm.nih.gov/WebSub/), 
   select 'sequence data not listed above', hit start, and hit 'start BankIt submission'.
 - Add your details and continue.
 - Add authors and publication details and continue.
 - Select sequencing platform, select 'assembled sequences', and add the assembly programs.
    I put in 'MEGAHIT' version '1.2.9' which is what Hecatomb uses, and 'Phables', version '0.2.0'.
    Assembly name and coverage is optional, so I left it blank. Continue.
 - Select release date, 'Molecule type' will probably be genomic DNA, 
   'topology' of Phables genomes is circular, 'yes' for submitting the complete sequence, 
   select fasta format, now, __upload your concatenated fasta file__ e.g.`allSeqs.fasta`. Continue.
 - __Upload your organism file__ e.g. `allSeqs.tsv`. Continue. 
   It'll ask to confirm spelling if it's not a know species (which is probably all of them). Continue.
 - Submission set/batch, this section doesn't seem relevant, 
   but I want them all published at the same time so I selected Environment set. Continue.
 - Select if it's Original or Third-party submission (i.e. is it your data?). Continue.
 - Organelle/location - leave blank (I think). 
   __upload your modifiers file__, this is optional, but you should add all the extra information you can. 
   The more metadata the better. Upload and continue.
 - Features, __upload your concatenated tbl file__ e.g. `allSeqs.tbl`. Continue.
 - Finish submission!

You can view your past submissions by the same portal in BankIt [here](https://www.ncbi.nlm.nih.gov/WebSub/?tool=genbank&form=history).
