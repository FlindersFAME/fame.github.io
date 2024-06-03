---
layout: single
show_date: true
tags: DeepThought Jupyter Tutorial
author: Susie Grigson
title: How to run an R Jupyter notebook on a deepthought node
---

This blog post covers how to set up an R environment to run on a deepthought node. This is useful if you have analysis to do in R that requires too much memory to run locally! 

If you haven't already gotten access to the DeepThought HPC follow the instructions [here](https://fame.flinders.edu.au/blog/2020/09/01/deepthought) and then set up conda following the instructions [here](https://fame.flinders.edu.au/blog/2020/09/02/condadeepthought). Then come back for the rest of the tutorial. 


# Installing R

This should be pretty straightforward. We will create a conda environment named ```R_notebook_env``` and then install R into it. 

```
mamba create -n R_notebook_env conda-forge::r-base
```

**Note 1:** I use `R_notebook_env` as the name, and that name appears in the slurm script below. If you use a different environment name, be sure to change it below
**Note 2:** This will install the latest version of R that is available on conda. If you know you need a specific version you can specify this as ```mamba create -n R_notebook_env conda-forge::r-base=4.X.X```

# Installing Jupyter 
In order to run a jupyter session we need jupyter! We are going to activate our conda environment: 

```
mamba activate R_notebook_env
```

Then install jupyter: 
```
mamba install anaconda::jupyterlab
```

BUT in order for R and jupyter to talk to each other we need to  install some additional kernels: 

```
mamba install conda-forge::r-irkernel
mamba install nb_conda_kernels
```

Now our R jupyter environment is ready to go!

# Setting up a slurm script 

You can use [this slurm script](/assets/slurm/jupyter_deepthought.slurm) to submit your R job to DeepThought. I've downloaded this script and saved it in a directory called ```slurm```.  

Submit your script to the cluster by running these commands: 
```
mkdir -p jupyter # you only need to do this once!
sbatch slurm/jupyter_deepthought.slurm
```

It will put the log files in `~/jupyter` and the notebooks by default will be where ever you run the `sbatch` command from.

It will also print a bunch of information into a log file in `~/jupyter` that you will need to ssh tunnel to your session. 

# ssh tunnelling 

We will use  the log file that has just been created in your  `~/jupyter` directory to connect to your jupyter session. You should have something that looks like this: 


```text
Windows MobaXterm info
Forwarded port: 8100
Remote server: hpc-node023
Remote port: 8281
SSH server: deepthought.flinders.edu.au
SSH login: grig0076
SSH port: 22

Use a Browser on your local machine to go to:
localhost:8281  (prefix w/ https:// if using password)

If ypu have a command line, you can also use this version

ssh grig0076@deepthought.flinders.edu.au -p 22 -L 8100:hpc-node023:8281

and then open chrome and go to

https://localhost:8100


[W 2024-06-03 14:14:41.207 ServerApp] ServerApp.password config is deprecated in 2.0. Use PasswordIdentityProvider.hashed_password.
[W 2024-06-03 14:14:41.321 ServerApp] A `_jupyter_server_extension_points` function was not found in nbclassic. Instead, a `_jupyter_server_extension_paths` function was found and will be used for now. This function name will be deprecated in future releases of Jupyter Server.
[I 2024-06-03 14:14:41.328 ServerApp] jupyter_server_fileid | extension was successfully linked.
[I 2024-06-03 14:14:41.333 ServerApp] jupyter_server_terminals | extension was successfully linked.
[I 2024-06-03 14:14:41.338 ServerApp] jupyter_server_ydoc | extension was successfully linked.
...
[I 2024-06-03 14:14:43.563 LabApp] JupyterLab extension loaded from /home/grig0076/miniconda3/envs/R_notebook_env/lib/python3.11/site-packages/jupyterlab
[I 2024-06-03 14:14:43.563 LabApp] JupyterLab application directory is /home/grig0076/miniconda3/envs/R_notebook_env/share/jupyter/lab
[I 2024-06-03 14:14:43.567 ServerApp] jupyterlab | extension was successfully loaded.
[I 2024-06-03 14:14:43.574 ServerApp] nbclassic | extension was successfully loaded.
[I 2024-06-03 14:14:43.575 ServerApp] Serving notebooks from local directory: /home/grig0076
[I 2024-06-03 14:14:43.576 ServerApp] Jupyter Server 2.14.1 is running at:
[I 2024-06-03 14:14:43.576 ServerApp] http://hpc-node023:8281/lab
[I 2024-06-03 14:14:43.576 ServerApp]     http://127.0.0.1:8281/lab
```

Rather than explain this again, use this output and refer to the instructions [here](https://fame.flinders.edu.au/blog/2022/07/16/jupyter-deepthought2#ssh-tunneling) to create your ssh tunnel. If you have a Windows device, you will need to use mobaXterm and if you have Windows Subsystem for Linux, Mac, Chromebook or Linux, you can set up an ssh tunnel via the command line.  


# Troubleshooting 
Sometimes R can be picky about what versions a package will run with. Sometimes you might need to install a package manually (I have needed to do this to get the MASS and Matrix packages to run). You can do this by downloading the source code for your desired package then run an R session on the head node by running: 

```
R
```

Then install your package: 
```
install.packages(path_to_package, repos = NULL, type="source")
```

# Working with Jupyter 

Jupyter is little different from RStudio which you might be used to if you work with R often. In Jupyter you can create blocks of code that can be run individually. Any figures or output will be shown directly below your block. 

You can install packages that you might need from inside these code blocks. 

![install packages](/assets/images/install_R_packages.png)



