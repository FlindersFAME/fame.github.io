---
layout: single
show_date: true
tags: DeepThought Snakemake Tutorial
title: "Part 4: Snakemake profiles for DeepThought"
author: Rob Edwards
excerpt: "Setting up a snakemake profile for deepthought will make your life much easier"
---

### _Series: An Introduction To Using DeepThought For Bioinformatics_

*Please note:* Mike posted a [much better and more detailed](https://fame.flinders.edu.au/blog/2021/08/02/snakemake-profiles-updated) profile explanation. You should use that!

Please note: much of this information was distilled from [this great blog post](https://www.sichong.site/workflow/2021/11/08/how-to-manage-workflow-with-resource-constraint.html) about snakemake profiles

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

