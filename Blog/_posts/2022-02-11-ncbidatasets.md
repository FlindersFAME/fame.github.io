---
layout: single
show_date: true
tags : ncbi ncbi_dataset
title: NCBI datasets and genome assembly data
author: Rob Edwards
---


Recently, [NCBI](https://www.ncbi.nlm.nih.gov/) released their new [datasets](https://www.ncbi.nlm.nih.gov/datasets/docs/) API that might replace [NCBI E-utils](https://github.com/NCBI-Hackathons/EDirectCookbook). At the moment, datasets is focused on genomes, genes, and viruses, but no doubt it will expand over time.

Here is a rough guide to extracting some data about genomes using `datasets`.

First, we have a list of all bacterial genome assemblies. There are currently just over a million genome assemblies, and you can download the latest list:

```bash
DATE=`date +%Y%m%d`
curl -Lo assembly_summary_$DATE.txt ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/assembly_summary.txt
```

Now we want to just get the report data about these genomes so we can figure out which ones are worth interrogating further. In particular we are concerned with the number of contigs and the overall assembly length, but you might want other data. Here is how to get all the data for a lot of organisms.

Before you begin, you'll need to install `ncbi_datasets`, and you can easily do that with `conda`:

```bash
mamba create -n ncbi_datasets -c conda-forge ncbi-datasets-cli
conda activate ncbi_datasets
```



First, we are going to get about 10 accessions to see if what happens, and then we'll build up to get all the accessions.

We create a variable called `$ACC` with the accession numbers separated by spaces.

```bash
ACC=$(head ../assembly_summary_20220130.txt | grep -v \# | cut -f 1 | tr \\n \ )
```

Now, we use `datasets` to get the genome assembly report:

```bash
datasets download genome accession $ACC --exclude-genomic-cds --exclude-gff3 --exclude-protein --exclude-rna --exclude-seq  --filename ncbi_data.zip
```

This will download three files:

 - README.md: a generic readme file
 - ncbi_dataset/data/assembly_data_report.jsonl: all the genome data in JSON format
 - ncbi_dataset/data/dataset_catalog.json: a JSON summary of what was downloaded


However, we don't really want to extract the archive, we can just access it directly using another ncbi datasets tool, [dataformat](https://www.ncbi.nlm.nih.gov/datasets/docs/v1/reference-docs/command-line/dataformat/). Let's extract that data into a tsv file:

```bash
dataformat tsv genome --package  ncbi_data.zip | awk -F"\t" '!s[$18]++ {print}' > ncbi_data.tsv
```

Note that we use `awk` to only print out one line per accession (otherwise we get lots of lines that appear mostly redundant per accession).

This table will have the following columns:


0. Annotation Info BUSCO Complete
1. Annotation Info BUSCO Duplicated
2. Annotation Info BUSCO Fragmented
3. Annotation Info BUSCO Lineage
4. Annotation Info BUSCO Missing
5. Annotation Info BUSCO Single Copy
6. Annotation Info BUSCO Total Count
7. Annotation Info BUSCO Version
8. Annotation Info Count Gene Non-coding
9. Annotation Info Count Gene Other
10. Annotation Info Count Gene Protein-coding
11. Annotation Info Count Gene Pseudogene
12. Annotation Info Count Gene Total
13. Annotation Info Name
14. Annotation Info Release Date
15. Annotation Info Report URL
16. Annotation Info Source
17. Assembly Accession
18. Assembly BioProject Lineage Accession
19. Assembly BioProject Lineage Parent Accessions
20. Assembly BioProject Lineage Title
21. Assembly BioSample Accession
22. Assembly BioSample Attribute Name
23. Assembly BioSample Attribute Value
24. Assembly BioSample BioProject Accession
25. Assembly BioSample BioProject Parent Accessions
26. Assembly BioSample BioProject Title
27. Assembly BioSample Description Comment
28. Assembly BioSample Description Organism Common Name
29. Assembly BioSample Description Organism Organism Name
30. Assembly BioSample Description Organism Pangolin Classification
31. Assembly BioSample Description Organism Strain
32. Assembly BioSample Description Organism Taxonomic ID
33. Assembly BioSample Description Title
34. Assembly BioSample Sample Identifiers Database
35. Assembly BioSample Sample Identifiers Label
36. Assembly BioSample Sample Identifiers Value
37. Assembly BioSample Last updated
38. Assembly BioSample Models
39. Assembly BioSample Owner Contact Lab
40. Assembly BioSample Owner Name
41. Assembly BioSample Package
42. Assembly BioSample Publication date
43. Assembly BioSample Status Status
44. Assembly BioSample Status When
45. Assembly BioSample Submission date
46. Assembly Blast URL
47. Assembly Description
48. Assembly GenBank Accession
49. Assembly Level
50. Assembly Linked Assembly
51. Assembly Name
52. Assembly Paired Accession
53. Assembly RefSeq Accession
54. Assembly Refseq Dategory
55. Assembly Sequencing Tech
56. Assembly Submission Date
57. Assembly Submitter
58. Assembly Type
59. Assembly UCSC Assembly Name
60. Assembly Stats Contig L50
61. Assembly Stats Contig N50
62. Assembly Stats Gaps Between Scaffolds Count
63. Assembly Stats GC Count
64. Assembly Stats Number of Component Sequences
65. Assembly Stats Number of Contigs
66. Assembly Stats Number of Scaffolds
67. Assembly Stats Scaffold L50
68. Assembly Stats Scaffold N50
69. Assembly Stats Total Number of Chromosomes
70. Assembly Stats Total Sequence Length
71. Assembly Stats Total Ungapped Length
72. Breed
73. Common name
74. Cultivar
75. Ecotype
76. Isolate
77. Organelle Assembly Name
78. Organelle BioProject Accessions
79. Organelle Description
80. Organelle Infraspecific Name
81. Organelle Submitter
82. Organelle Total Seq Length
83. Organism name
84. Sex
85. Strain
86. Taxonomic ID
87. WGS contigs URL
88. WGS project accession
89. WGS URL


