---
layout: single
category: blog
show_date: true
tags: DeepThought Snakemake
title: "Part 3: Using snakemake on deepthought"
author: Rob Edwards
---



[snakemake](https://snakemake.readthedocs.io/en/stable/) is a pipelining tool that allows you to recreate reusable pipelines to analyse data<!--more-->, and helps you to run things on the cluster.

In the [previous section](deepthought_conda.md) we installed `conda/mamba`, `prinseq++`, and `snakemake`. In this tutorial, we are going to write a small script to run `prinseq++` on a data set.

### What is prinseq++

When you sequence something you get the raw DNA sequence and it has not been cleaned or trimmed. [prinseq++](https://github.com/Adrian-Cantu/PRINSEQ-plus-plus) is a fast tool for taking fastq files (e.g. from BGI, Illumina, or Nanopore) and quality trimming them. You can read more at the [prinseq++ website](https://github.com/Adrian-Cantu/PRINSEQ-plus-plus)

The command that we are going to run is

```
        prinseq++ -min_len 60 -min_qual_mean 25 -ns_max_n 1 -derep 1 \
            -out_format 0 -trim_tail_left 5 -trim_tail_right 5 \
            -trim_qual_type min -trim_qual_left 30 \
            -trim_qual_right 30 -trim_qual_window 10 \
            -out_good r1.fastq -out_single r1.single -out_bad r1.bad \
            -out_good2 r2.fastq -out_single2 r2.single -out_bad2 r2.bad \
            -fastq r1.fastq \
            -fastq2 r2.fastq;
```

Lets break these parameters down and take a look.

#### Filter on the length and overall quality
`-min_len 60`   -- the minimum length of sequences to include. Assuming Illumina sequencing, you probably have read lengths between 150 and 300bp. Anything shorter will be a bad read. 
`-min_qual_mean 25` -- minimum quality score for the mean of the read should be >25. (1 in 10^2.5 error ~ 1:300) which is about 1 bp error per read for 300 bp reads

#### Filter N's
`-ns_max_n 1`  Filter sequences with more than a single N in the sequence. The more N's we have the less sure we are of the read. 

#### Remove exact duplicate sequences
For (non-16S samples) we would expect exactly duplicated sequences to be diminishingly rare, and they are most likely an artefact of the sequencing reaction. Some sequencing technologies (those that involve amplification) are much more prone to this than others. 

```
-derep 1
```

#### Poly A/T Trimming 
You can remove poly-A and poly-T sequences at the end of the read with at least 5 A's. These can be an artefact of mRNA sequencing.

```
-trim_tail_left 5
-trim_tail_right 5 
```

#### Quality based trimming of the reads

You can trim based on min, mean, max, or sum quality scores. In this case, trim using the min score. We take a window of size `trim_qual_window` bp (so in this case 10 bp) and remove it if the 
score is less than stated. So in this case, we trim 10 bp off either end if the score is less than 30. We repeat that until we have a 10 bp window whose min score >= 30.

```
-trim_qual_type min
-trim_qual_left 30 
-trim_qual_right 30 
-trim_qual_window 10
```

#### Output options

`-out_format 0`  - ouput either fastq (0) or fasta (1) format sequences. 

The file names of reads 1 (R1) and reads 2 (R2) for paired (R1/2), single (unpaired reads, e.g. if the other read fails quality) (S1/2), or bad (b1/2) reads 

```
-out_good {output.r1} -out_single {output.s1} -out_bad {output.b1}
-out_good2 {output.r2} -out_single2 {output.s2} -out_bad2 {output.b2}
```

#### Input reads

Assuming left (R1) and right (R2) reads.

`-fastq {input.r1}` 
`-fastq2 {input.r2}`



But we are going to use some `snakemake` magic to make the input/output file names automatically.


### What is snakemake?

[snakemake](https://snakemake.readthedocs.io/en/stable/) is a way to write reproducible code. There are lots of [tutorials about snakemake](https://www.google.com/search?q=snakemake+tutorial) and I recommend that you take a look at them. Here we are going to do something very simple: use `snakemake` to run `prinseq++` on a data set.

### The dataset

You can use any dataset you like for this step. There are some test data in `/home/edwa0468/Tutorials/01snakemake/fastq` that you can copy like so:

---

```bash
mkdir example_snakemake
cd example_snakemake
cp -r /home/edwa0468/Tutorials/01snakemake/fastq .
ls fastq/
```

---

This will make a directory called `fastq` with two files, `16714_19_ar.qc_R1.fastq.gz` and `16714_19_ar.qc_R2.fastq.gz`.

## Writing the snakefile

This is coming. For the moment, use the one I wrote for you!

# Running snakemake

For now, the example snakefile is in `/home/edwa0468/Tutorials/01snakemake/prinseq.snakefile`, and you can copy that and run with this command:


```bash
snakemake -s prinseq.snakefile --cores 1
```

This will run on the head node and create a directory called `prinseq` with all the output files.

```bash
$ ls -l prinseq/
total 401536
-rw-r--r-- 1 edwa0468 staff  93655245 Sep 18 15:18 16714_19_ar.qc_R1.bad.fastq
-rw-r--r-- 1 edwa0468 staff 104756189 Sep 18 15:18 16714_19_ar.qc_R1.good.fastq
-rw-r--r-- 1 edwa0468 staff   7983090 Sep 18 15:18 16714_19_ar.qc_R1.single.fastq
-rw-r--r-- 1 edwa0468 staff  64568138 Sep 18 15:18 16714_19_ar.qc_R2.bad.fastq
-rw-r--r-- 1 edwa0468 staff 103598005 Sep 18 15:18 16714_19_ar.qc_R2.good.fastq
-rw-r--r-- 1 edwa0468 staff  36600191 Sep 18 15:18 16714_19_ar.qc_R2.single.fastq
```

If you try and run that snakefile again, snakemake will say that there is nothing to do.

Now lets run it on the cluster:

```bash
snakemake -s prinseq.snakefile --cluster 'sbatch -t 60 --mem=2g -c 1' -j 10 --latency-wait 60
```

Let's break this command down: 

- The first part `snakemake -s prinseq.snakefile` means run the `snakefile` we wrote above.
- `--cluster 'sbatch -t 60 --mem=2g -c 1'` means run this on the cluster using:
  - `-t 60` means a amximum time of 60 minutes. In fact, the process finishes much faster.
  - `--mem=2g` means request 2GB of RAM
  - `-c 1` means run on a single CPU.
- `-j 10` means at most 10 jobs. Actually, at the moment we only have a single job!
- `--latency-wait 60` means to wait for the output files for 60 seconds. It takes a while to transfer the files around the system, and we need to ensure that we wait for all the output files before we declare success ... or failure!



### Up next

[Making a snakemake profile](deepthought_snakemake_profile.md)










