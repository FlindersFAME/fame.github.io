---
layout: single
show_date: true
tags: snakemake
author: Rob Edwards
title: Migrating Snakemake
excerpt: "How to migrate from snakemake 7 to snakemake 8"
---

## Migrating from snakemake 7 to snakemake 8

I finally bit the bullet and migrated from snakemake 7 to snakemake 8. The short answer its not too hard!

First, install the executor plugin for snakemake using mamba:

```
mamba install snakemake-executor-plugin-cluster-generic
```

Next, edit your config file and change the following:

If you have a `cluster:` section, change that to `cluster-generic-submit-cmd:`

Add the line: 

```
executor: cluster-generic
```

You need to remove these lines if you have them:

```
cluster-status
use-conda
conda-frontend
```

Here is my current snakemake config file

```
# non-slurm settings

conda-prefix: ~/.config/snakemake/conda/

# slurm settings

jobs: 600

executor: cluster-generic
cluster-generic-submit-cmd:
  mkdir -p logs_slurm/{rule} &&
  sbatch
    --cpus-per-task={threads}
    --mem={resources.mem_mb}
    --output=logs_slurm/{rule}/{jobid}.out
    --error=logs_slurm/{rule}/{jobid}.err
    --job-name=smk-{rule}
    --time={resources.runtime}
    --parsable

default-resources:
  - mem_mb=2000
  - runtime=7200
  - load_superfocus=0
  - load_kraken=0
  - load_onehundred=0

resources: [load_superfocus=100, load_kraken=100, load_onehundred=100]
local-cores: 32
latency-wait: 60
shadow-prefix: /scratch/user/edwa0468
keep-going: False
max-jobs-per-second: 20
max-status-checks-per-second: 10
scheduler: greedy

restart-times: 1

```

