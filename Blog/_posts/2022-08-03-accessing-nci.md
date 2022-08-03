---
layout: single
show_date: true
author: Vijini Mallawaarachchi
title: Accessing NCI resources  
excerpt: "Instructions and guidelines for Flinders researchers\n" 
---

Welcome to the NCI workshop for Flinders researchers wanting to access NCI resources!

[Download the slides](https://cloudstor.aarnet.edu.au/plus/s/foHYWK13zvZAvEW)

# Getting started

You should first create an account at [https://my.nci.org.au](https://my.nci.org.au). Then you can request an allocation for your own project or join and existing project.

Once you have an account on NCI, you can login to NCI using ssh as follows. You can also use PuTTY on Windows or the [Australian Research Environment](https://are.nci.org.au/). You have to replace `<username>` with your username.

```shell
ssh <username>@gadi.nci.org.au
```

Once you are logged in, you can check the path on the login node using `pwd` or `echo $HOME`. 

You can check your default project using `echo $PROJECT` and your default shell using `echo $SHELL`. `$PROJECT` and `$SHELL` are set in the file `$HOME/.config/gadi-login.conf`.

You can move to your scratch directory using the following command. You have to replace `<project_code>` with your own project code and `<username>` with your username.

```shell
cd /scratch/<project_code>/<username>
```

Similarly, you can move to your gdata directory using the following command.

```shell
cd /d/data/<project_code>/<username>
```

# Sample job script

You can create a job script (e.g., `job.sh`) using any text editor such as `nano` or `vi`. A sample job script is provided below. The lines starting with `#PBS` are known as **PBS directives**. More details about PBS directives can be found [here](https://opus.nci.org.au/display/Help/PBS+Directives+Explained).

```shell
#!/bin/bash
#PBS -P <project_code>
#PBS -q normal
#PBS -l ncpus=16
#PBS -l mem=1GB
#PBS -l jobfs=64GB
#PBS -l walltime=01:00:00
#PBS -l wd
#PBS -l other=hyperthread
#PBS -l storage=scratch/<project_code>+gdata/<project_code>

# Your code/commands
echo "Hello World!"
```

# Gadi commands cheatsheet

## Storage allocation and usage

Check home quota

```shell
quota –s
```

Check the grant/usage of the project on gdata

```shell
nci_account -P <project_code>
```

Check how much storage you have access to on scratch and gdata through which projects

```shell
lquota
```

Files created by user/project

```shell
nci-files-report
nci-files-report --project <project_code>
```

## Transferring files to/from Gadi

Upload data to Gadi from local PC

```shell
scp –r <file/folder> <username>@gadi-dm.nci.org.au:<destination>
rsync -ravPS <file/folder> <username>@gadi-dm.nci.org.au:<destination>
```

Download data from Gadi to local PC

```shell
scp –r <username>@gadi-dm.nci.org.au:<file/folder> <destination>
rsync -ravPS <username>@gadi-dm.nci.org.au:<file/folder> <destination>
```

## Software

List out software applications centrally available on Gadi

```shell
module avail <software>
```

Load the module into your current shell environment and check

```shell
module load <software>/<version>
which <software>
```

List currently loaded modules

```shell
module list 
```

Remove a module from your environment

```shell
module unload <software>
```

## Jobs

Submit a job script. 

```shell
qsub job.sh
```

Delete a job from the queue

```shell
qdel <job_id>
```

Check status of your jobs

```shell
qstat 
qstat -u <username>
```

Check status of your jobs

```shell
qstat 
qstat -u <username>
```

Check status of a particular job in the queue 

```shell
qstat -sw <job_id>
```

Check CPU and memory usage the job

```shell
nqstat_anu <job_id>
```

# Useful NCI links

Gadi Quick Reference Guide - [https://opus.nci.org.au/display/Help/Gadi+Quick+Reference+Guide](https://opus.nci.org.au/display/Help/Gadi+Quick+Reference+Guide)

PBS Directives Explained - [https://opus.nci.org.au/display/Help/PBS+Directives+Explained](https://opus.nci.org.au/display/Help/PBS+Directives+Explained)

Compute Grant and Job Debiting - [https://opus.nci.org.au/display/Help/2.+Compute+Grant+and+Job+Debiting](https://opus.nci.org.au/display/Help/2.+Compute+Grant+and+Job+Debiting)

Queue Limits - [https://opus.nci.org.au/display/Help/Queue+Limits](https://opus.nci.org.au/display/Help/Queue+Limits)

NCI helpdesk - [https://nci.org.au/users/nci-helpdesk](https://nci.org.au/users/nci-helpdesk)