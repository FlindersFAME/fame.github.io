---
layout: posts
category: blog
tag: deepthought
title: Snakemake profiles
excerpt: "Part 3: Using snakemake profiles"
---

# An Introduction To Using DeepThought For Bioinformatics

Rob Edwards, September 2020

# Part 4: Snakemake profiles

Please note: much of this information was distilled from [this great blog post](https://www.sichong.site/2020/02/25/snakemake-and-slurm-how-to-manage-workflow-with-resource-constraint-on-hpc/) about snakemake profiles

That post has more information and details and you should take some time to read it and the associated post about running snakemake on the cluster. However, this will get you started on deepthought.

> **Why make a snakemake profile?** A profile will allow us to define a default set of rules (e.g. memory requirements, number of CPUs, and total time to run) and then we can override those rules on a rule-by-rule basis in our `snakefile`.

## Making a profile

We start by making a directory for our profile:

```bash
mkdir -p ~/.config/snakemake/slurm
```

and then create a file in there with some simple rules: `vi ~/.config/snakemake/slurm/config.yaml` the file contents are: 

```yaml
jobs: 100
cluster: "sbatch -t {resources.time_min} --mem={resources.mem_mb} -c {resources.cpus} -o logs_slurm/{rule}_{jobid}.out -e logs_slurm/{rule}_{jobid}.err "
default-resources: [cpus=1, mem_mb=2000, time_min=60]
latency-wait: 60
local-cores: 32
```

This will submit at most 100 jobs, using the `sbatch` slurm command, and will use `resources.time_min`, `resources.mem_mb`, and `resources.cpus` as appropriate for time, memory, and ncpus. It needs a directory called logs_slurm to write the output files. It 


Now in our rules, we can add a `resources` directive that will override these default parameters.

This example is taken from the aforementioned blog post:

```
rule mapFASTQ:
    input: 
        f1 = "RawData/{sample}_1.fastq.gz", 
        f2 ="RawData/{sample}_2.fastq.gz", 
        ref = "Ref/ref.fa"
    output: temp("Alignment/{sample}.sam")
    resources: time_min=300, mem_mb=8000, cpus=8
    shell:
     """
     bwa mem -@ {resources.cpus} -R "@RG\\tID:{wildcards.sample}\\tSM:{wildcards.sample}" {input.ref} {input.f1} {input.f2} > {output}
     """
```

Now, to run the `snakefile` we no longer use the `--cluster` command, instead we use:

```bash
snakemake --profile slurm -s snakefile
```

## Important Note

In the above profile, we write the `slurm` output and error files to a directory called **logs_slurm**. The slurm submission may hang unless you make this directory before you run snakemake. If you run into trouble, make sure you mkdir!

```
mkdir -p logs_slurm
snakemake --profile slurm -s snakefile
```

