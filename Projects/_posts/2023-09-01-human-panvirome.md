---
layout: single
tags: Virus Metagenome,
title: Human Panvirome
author: Michael Roach
---

The 2020 pandemic has brought viruses to the forefront of everyone’s minds. This is a drop in the ocean compared to
the impact that viruses (including bacteriophages, hereafter phages) have on our daily lives. Not all viruses are bad,
and viruses influence every environment including human health and disease. The human body itself contains a
multitude of disparate microbial communities with viruses constituting a ubiquitous component of these microbiomes.

Understanding viromes—the viral population of a microbiome—as a key component of human microbiomes is crucial to the future of
human health. Unfortunately, this human meta-virome is currently poorly understood.
Viral metagenomics is fraught with challenges. Despite being the most abundant and diverse organism on the planet,
viruses constitute a minority of reference genomes in GenBank—due to the difficulties in studying them (reviewed in
Krishnamurthy and Wang (13)). Viral genomes share large portions of sequence homology with other kingdoms of life and frequently
‘donate’ and ‘steal’ genes (13). The combination of ‘viral dark matter’ and cross-Kingdom sequence homology creates
ideal conditions for incorrect viral annotations of metagenomic samples. 

[Hecatomb](https://github.com/shandley/hecatomb) is a software pipeline developed in
a collaboration between Flinders University, Washington University in Saint Louis, and San Diego State University to
address many of the pitfalls outlined above. This project will apply Hecatomb to, together with other phage tools such
as [Phables](https://github.com/Vini2/phables), [Pharokka](https://github.com/gbouras13/pharokka), and 
[Phynteny](https://github.com/susiegriggo/Phynteny) to analyse tens of thousands of human metagenomics samples publicly 
available on the Sequence Read Archive (SRA) to create a human meta-virome. 
We will include gut samples of cancer and IBD patients that we are already collecting for other
projects, identify candidate dark-matter viruses, and we will apply a novel strategy to sequence and assemble them.

## Aims
1. __Generate a human meta-virome.__ I will identify human metagenome samples from SRA metagenomics accessions
and run Hecatomb to generate virome profiles for the different human microbiomes, the compendium of which will
form the human meta-virome.
   
2. __Identify novel associations between human viromes and their microbiomes.__ I will combine the human metavirome with SRA metadata and microbial compositions to identify novel associations to showcase the value of a
human meta-virome database.
   
3. __Characterise dark-matter viruses.__ Hecatomb provides an essential platform for deconvoluting dark-matter
viruses. I will demonstrate a proof-of-concept method to identify candidate novel viruses from dark-matter sequences
and performed target enriched sequencing of these dark-matter viruses directly from the human gut samples.