---
layout: single
show_date: true
title: "Converting a phyloseq object to text files"
author: Rob Edwards
tags: R python phyloseq tsv
excerpt: How to convert a phyloseq object from R to tab-separated values that can be read anywhere
---

# Converting phyloseq objects

[Phyloseq](https://www.bioconductor.org/packages/release/bioc/html/phyloseq.html) is an R package for microbiome analysis that incorporates several data types. 

Occassionally our colleagues share a `phyloseq object` with as an `.rds` file (`R Data Serialization` format). It is quite simple to convert that for use in other languages (e.g. python or even Excel!)


## Converting the data to `.tsv` format 

This approach requires an R installation somewhere, but we don't need many commands, so you can probably use a remote R installation on a server!

If you have not yet installed `phyloseq`, you can do so with bioconductor:

```R
if (!require("BiocManager", quietly = TRUE))
install.packages("BiocManager")
BiocManager::install("phyloseq")
```

Next, we load the phyloseq package and read the `.RDS` file:

```R
library("phyloseq");
packageVersion("phyloseq"); # check the version we are using
# you may need to use setwd("C:/Users/username/Downloads") to move to whereever you downloaded the file!
p <- readRDS("phyloseq.rds"); # change the filename here! 
print(p)
```

This will print typical output from a phyloseq object like:

```text
phyloseq-class experiment-level object
otu_table()   OTU Table:         [ 3210 taxa and 11 samples ]
sample_data() Sample Data:       [ 11 samples by 12 sample variables ]
tax_table()   Taxonomy Table:    [ 3210 taxa by 7 taxonomic ranks ]
```

These are our base phyloseq objects, and we can explore them:

```R
print(otu_table(p))
print(sample_data(p))
```

And we can also write them to tab separated text in a `.tsv` file:

```R
write.table(otu_table(p), "p_otu.tsv", sep="\t")
write.table(sample_data(p), "p_sample.tsv", sep="\t")
write.table(tax_table(p), "p_tax.tsv", sep="\t")
```


