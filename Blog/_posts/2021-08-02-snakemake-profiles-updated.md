---
layout: single
show_date: true
tags : Snakemake Deepthought
title: Snakemake profiles updated
author: Michael Roach
---

This is an update from a previous post [https://fame.flinders.edu.au/blog/2020/09/04/snakemakeprofile](https://fame.flinders.edu.au/blog/2020/09/04/snakemakeprofile)
where Rob outlines a simple Snakemake profile for running Snakemake on the HPC cluster here at Flinders University.
While this is a good profile to get you started, we can make it better. 

__TLDR at the bottom for those just wanting a profile to copy-paste__

### Cookiecutter profiles

You can generate profiles for Snakemake using cookiecutter; more info here: [cookiecutter profiles](https://github.com/Snakemake-Profiles).
These will generate a config.yaml file, as well as python scripts for submitting and checking jobs.
However, you'll probably still want to do some customisation, so this post will instead continue with 
Rob's original manually created profile, and will go through the different components.

### Original profile

The original profile Rob created looked something like this (I've just reformatted it to look pretty).

```yaml
# ~/.config/snakemake/slurm/config.yaml
cluster:
  sbatch
    --cpus-per-task={resources.cpus}
    --mem={resources.mem_mb}
    --time={resources.time_min}
    --output=logs/{rule}_{jobid}.out
    --error=logs/{rule}_{jobid}.err
default-resources:
  - mem_mb=2000
  - cpus=1
  - time_min=480
jobs: 100
latency-wait: 60
local-cores: 8
```

Here "cluster" is the Snakemake option to specify the command (or script) responsible for submitting a job, and default 
values for all "resources" variables in "cluster" should be specified under the "default-resources" option (to keep the 
Snakefiles simple).

### Follow conventions
The first thing to change is to make sure we're following Snakemake conventions. 
The Snakemake [cookiecutter profiles](https://github.com/Snakemake-Profiles)
expect time in minutes to be mapped as "time", "runtime", or "walltime" so we'll change that.
You can pass anything you want under "resources" but following conventions will help others run your pipeline under their
profiles. Second, you should always specify the number of CPUs under "threads" in your rule to allow for proper thread 
management in both cluster and local running modes, and hence we can simply map --cpus-per-task to the 'threads' variable 
rather than specifying it twice in the Snakemake rule.

```python
rule yeet:
    # Example rule to specify 2 CPUs, 1 day runtime, 4GB RAM
    output:
        'yeet.done'
    threads:
        2
    resources:
        time=1440,
        mem_mb=4000
    shell:
        'touch {output}'
```

```yaml
# ~/.config/snakemake/slurm/config.yaml
cluster:
  sbatch
    --cpus-per-task={threads}
    --mem={resources.mem_mb}
    --time={resources.time}
    --output=logs/{rule}_{jobid}.out
    --error=logs/{rule}_{jobid}.err
default-resources:
  - mem_mb=2000
  - time=480
jobs: 100
latency-wait: 60
local-cores: 8
```

### Improved logging
The first issue with the log files is that the `logs/` directory needs to exist or slurm won't accept the job. We can add
a command to create the directories if they don't exist. 
We can customise the names of the snakemake jobs in slurm with "--job-name".
If your workflow generates lots of jobs, and the same rules are reused for different wildcards then debugging can be 
made easier with a better structure and filenames for the logs. You can create directories for each rule and name the 
logs by their wildcards rather than just the jobid. __HOWEVER, this will break Snakemake if your wildcards includes the 
path to the file as well as the filename itself, so use with caution.__ 
I may or may not have learned this the hard way.


```yaml
# ~/.config/snakemake/slurm/config.yaml
cluster:
  mkdir -p logs/{rule}/ &&
  sbatch
    --cpus-per-task={threads}
    --mem={resources.mem_mb}
    --time={resources.time}
    --job-name=smk-{rule}-{wildcards}
    --output=logs/{rule}/{jobid}-{wildcards}.out
    --error=logs/{rule}/{jobid}-{wildcards}.err
default-resources:
  - mem_mb=2000
  - time=480
jobs: 100
latency-wait: 60
local-cores: 8
```

### Other Snakemake options
We currently have three Snakemake behaviour options set: "jobs: 100" (don't submit more that 100 jobs at a time), 
"latency-wait: 60" (wait up to 60s for the file to appear after job completion), 
and "local-cores: 8" (use at most 8 cores on the head node), 
as well as the "cluster" and "default-resources" options. 
Other Snakemake options (list with `snakemake --help`) can be specified in the configuration file to change Snakemake's 
behaviour when running in cluster mode. 
Let's add some more: "max-jobs-per-second: 20" (don't spam the queue too hard), 
"keep-going: True" (don't immediately stop on a job fail), 
"restart-times: 1" (if a job fails, rerun it 1 times), 
"rerun-incomplete: True" (rerun incomplete jobs from a previous Snakemake run), 
"printshellcmds: True" (print the shell commands that are being run to the teminal, useful for debugging), 
"scheduler: greedy" (use the greedy scheduler, helps with some snakemake issues), 
"use-conda: True" and "conda-frontend: mamba" (use conda envs and use mamba for installing conda dependencies).

```yaml
# ~/.config/snakemake/slurm/config.yaml
cluster:
  mkdir -p logs/{rule}/ &&
  sbatch
    --cpus-per-task={threads}
    --mem={resources.mem_mb}
    --time={resources.time}
    --job-name=smk-{rule}
    --output=logs/{rule}/{jobid}.out
    --error=logs/{rule}/{jobid}.err
default-resources:
  - mem_mb=2000
  - time=480
jobs: 100
latency-wait: 60
local-cores: 8
restart-times: 1
max-jobs-per-second: 20
keep-going: True
rerun-incomplete: True
printshellcmds: True
scheduler: greedy
use-conda: True
conda-frontend: mamba
```

### Cluster status script

Snakemake has an option to take a cluster status script which it will run, passing the jobid, to return either a 
'running', 'success', or 'failed' message. This is useful as occasionally a job will fail or terminate and Snakemake will
not always realise, leaving the whole pipeline waiting for a job that will never finish. The cluster status script lets 
Snakemake check on the status of the jobs that it has sent to the queue. 
Here is an example that I've been using (credit to a github post that I forgot to bookmark); 
don't forget to make the cluster status script executable with `chmod +x slurm-status.py`

```python
#!/usr/bin/env python3
# ~/.config/snakemake/slurm/slurm-status.py
import subprocess
import sys
jobid = sys.argv[-1]
output = str(subprocess.check_output("sacct -j %s --format State --noheader | head -1 | awk '{print $1}'" % jobid, shell=True).strip())
running_status=["PENDING", "CONFIGURING", "COMPLETING", "RUNNING", "SUSPENDED", "PREEMPTED"]
if "COMPLETED" in output:
  print("success")
elif any(r in output for r in running_status):
  print("running")
else:
  print("failed")
```

In the config.yaml file we add: "cluster-status: ~/.config/snakemake/slurm/slurm-status.py" (path to the cluster status
script, which I've saved to my slurm profile directory), and "max-status-checks-per-second: 10" (to make sure Snakemake
isn't spamming slurm too hard).

```yaml
# ~/.config/snakemake/slurm/config.yaml
cluster:
  mkdir -p logs/{rule}/ &&
  sbatch
    --cpus-per-task={threads}
    --mem={resources.mem_mb}
    --time={resources.time}
    --job-name=smk-{rule}
    --output=logs/{rule}/{jobid}.out
    --error=logs/{rule}/{jobid}.err
default-resources:
  - mem_mb=2000
  - time=480
jobs: 100
latency-wait: 60
local-cores: 8
restart-times: 1
max-jobs-per-second: 20
keep-going: True
rerun-incomplete: True
printshellcmds: True
scheduler: greedy
use-conda: True
conda-frontend: mamba
cluster-status: ~/.config/snakemake/slurm/slurm-status.py
max-status-checks-per-second: 10
```

### Partitions

The Flinders Deepthought HPC has nodes with GPUs that are available to use.
This requires submitting jobs to a different slurm partition, and specifying the number of GPUs to use.
To allow for GPU-accelerated jobs we need to pass --partition={resources.partition} and --gres=gpu:{resources.gpu} to 
"cluster", and we need to specify the default partition and GPUs under "default-resources". 
For Deepthought the default partition is 'hpc_general', and the GPU partition 'hpc_gpu'.
The config file looks like this:

```yaml
# ~/.config/snakemake/slurm/config.yaml
cluster:
  mkdir -p logs/{rule}/ &&
  sbatch
    --cpus-per-task={threads}
    --mem={resources.mem_mb}
    --time={resources.time}
    --job-name=smk-{rule}
    --output=logs/{rule}/{jobid}.out
    --error=logs/{rule}/{jobid}.err
    --partition={resources.partition}
    --gres=gpu:{resources.gpu}
default-resources:
  - mem_mb=2000
  - time=480
  - partition=hpc_general
  - gpu=0
jobs: 100
latency-wait: 60
local-cores: 8
restart-times: 1
max-jobs-per-second: 20
keep-going: True
rerun-incomplete: True
printshellcmds: True
scheduler: greedy
use-conda: True
conda-frontend: mamba
cluster-status: ~/.config/snakemake/slurm/slurm-status.py
max-status-checks-per-second: 10
```

A GPU rule would then request the number of GPUs and the required partition under "resources".

<small>_NOTE: To make your pipeline compatible with other clusters you should use a config variable for the GPU partition name
instead of simply "hpc_gpu"._</small>

```python
rule yeet:
    # Example rule to request 1 GPU
    output:
        'yeet.done'
    threads:
        2
    resources:
        partition="hpc_gpu",
        gpu=1
    shell:
        'touch {output}'
```

### TLDR 

_UPDATE 02-08-2022: add `--parsable` to `slurm/config.yaml` for compatibility with Snakemake > 7.10 ish_

my current config.yaml file (save to `~/.config/snakemake/slurm/config.yaml`):

```yaml
cluster:
  mkdir -p logs/{rule}/ &&
  sbatch
    --cpus-per-task={threads}
    --mem={resources.mem_mb}
    --time={resources.time}
    --job-name=smk-{rule}
    --parsable
    --output=logs/{rule}/{jobid}.out
    --error=logs/{rule}/{jobid}.err
#    --partition={resources.partition}
#    --gres=gpu:{resources.gpu}
default-resources:
  - mem_mb=2000
  - time=480
#  - partition=hpc_general
#  - gpu=0
jobs: 100
latency-wait: 60
local-cores: 8
restart-times: 1
max-jobs-per-second: 20
keep-going: True
rerun-incomplete: True
printshellcmds: True
scheduler: greedy
use-conda: True
conda-frontend: mamba
cluster-status: ~/.config/snakemake/slurm/slurm-status.py
max-status-checks-per-second: 10
```

my current cluster status file (save to `~/.config/snakemake/slurm-status.py` and make executable):

```python
#!/usr/bin/env python3
import subprocess
import sys
jobid = sys.argv[-1]
output = str(subprocess.check_output("sacct -j %s --format State --noheader | head -1 | awk '{print $1}'" % jobid, shell=True).strip())
running_status=["PENDING", "CONFIGURING", "COMPLETING", "RUNNING", "SUSPENDED", "PREEMPTED"]
if "COMPLETED" in output:
  print("success")
elif any(r in output for r in running_status):
  print("running")
else:
  print("failed")
```
