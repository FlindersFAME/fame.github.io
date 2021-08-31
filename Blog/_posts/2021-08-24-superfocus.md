---
layout: single
show_date: true
tags : superfocus super-focus deepthought
title: How to install and use super-focus on deepthought
author: Rob Edwards
---

# super-FOCUS 

Super-FOCUS is a tool to identify the functions that the sequences in your metagenome are doing. As a benefit, it also identifies the taxonomy associated with those functions.

Super-FOCUS uses a reduced, optimized, database and fast aligners to run.

To run Super-FOCUS you need two things:
1. Your data, probably in fasta or fastq format
2. A database of things we know about. Note that this is a databse in _super-FOCUS_ format, not in another format!

# Installing Super-FOCUS on deepthought

To install Super-FOCUS on deepthought we are going to use conda. Once you [have conda installed](2020-09-02-condadeepthought.md), \[[here are more install instructions](https://fame.flinders.edu.au/blog/2021/05/27/linux-getting-started#installing-software)\] you can just type:

```bash
conda create -y -n superfocus -c bioconda super-focus
```

This will figure out all the things that need to be installed, and then install them for you. It should not take _too_ long for the installer to complete.

Once it has completed, you will need to activate the `conda environment`:

```
conda activate superfocus
```


Next, we need to get the databases. You can use the `superfocus_downloadDB` command to download them, you can download them [indvidually](https://github.com/metageni/SUPER-FOCUS/issues/66), or if you are on deepthought you can use Rob's version of the databases.  If you are in a class, just link to Rob's copy using this code:


```
ln -s ~edwa0468/superfocus_db/version1 ~/superfocus_db
```

The installation is complete and now you can use it to explore your metagenomes.

## Using super-FOCUS on deepthought

### Before you begin

Super-FOCUS requires that your input fastq files be in a directory. We're going to make a directory called `fastq` and copy the data into there. Change `barcode_01.fastq` to the name of your fastq file!!

```bash
mkdir fastq
cp barcode_01.fastq fastq
```

(remember, the `ls` command will show you the files and directories that you have)

### Also note:

`super-focus` takes quite a lot of computing resources so we are just going to run this straight on the cluster. It is bad practice to run it on the login node!


### Running super-FOCUS


### To run superfocus directly

Use this command

```bash
superfocus --threads 8 -q fastq -b ~/superfocus_db -a diamond -dir superfocus_results
```






We are going to make a batch file to submit the command to the cluster. Lets call our file `superfocus.slurm`:

```bash
nano superfocus.slurm
```

And then put these lines in that file


```bash
#!/bin/bash

#SBATCH --ntasks=8

superfocus --threads 8 -q fastq -b ~/superfocus_db -a diamond -dir superfocus_results
```

In this command:

- The `fastq` option is the name of our input directory and is the same name we used above under `Before you begin`
- The `~/superfocus_db` option is the name of our database. If you have downloaded your own databases you should omit that information. This is the database that currently works with the version of super-FOCUS and diamond in conda
- The `diamond` option is the aligner that we are going to run.
- The `superfocus_results` option is where we are going to find the output

Then, we are going to submit that to run on the cluster


```bash
sbatch superfocus.slurm
```

and you can monitor the progress with

```bash
squeue
```

or 


```bash
squeue -u <FAN>
```

where `<FAN>` is your FAN!


Notice that `super-FOCUS` will also output a lot of information in a file that will be called something like `slurm-1709843.out` (but the number will be totally different). That tells you whether the command has worked or if there was some kind of error.







