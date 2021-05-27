---
layout: single
show_date: true
tags : Linux tmux conda 
title: Getting started with linux
author: Michael Roach
---

It can be daunting when you're just starting out using the Linux command line to access the University's HPC resources.<!--more-->
This post is intended to be a collection of helpful tutorials that will give you the essentials you need to get your 
analysis up and running on a Linux-based computing cluster.

_Pleast yeet me an email if I've forgotten anything or if you notice a dead link so I can update this page._

## Connecting to an external server

This section applies if you are connecting to a Linux server, rather than directly working on a Linux-based PC.
There are two types of connections that you will need to establish. 
 - SSH: will let you pull up a command line terminal on the server
 - FTP: will let you transfer files between the server and your computer

[MobaXterm](https://mobaxterm.mobatek.net/) will handle both of these connections for you and is your best choice.

[Putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/) will handle the SSH connection, and 
[WinSCP](https://winscp.net/eng/index.php) will handle the FTP connection, but MobaXterm is better.

The Documentation is thorough, but the live demo gives a good overview of the features 
[https://mobaxterm.mobatek.net/demo.html](https://mobaxterm.mobatek.net/demo.html)

## Linux command line

Ubuntu has a nice tutorial which walks through the basics of navigating the filesystem and basic operations:
[https://ubuntu.com/tutorials/command-line-for-beginners#1-overview](https://ubuntu.com/tutorials/command-line-for-beginners#1-overview)

There are plenty of tutorials available; here are a few:

[https://ryanstutorials.net/linuxtutorial/](https://ryanstutorials.net/linuxtutorial/) (Covers most of the important
stuff in excellent detail)

[https://www.educative.io/blog/bash-shell-command-cheat-sheet](https://www.educative.io/blog/bash-shell-command-cheat-sheet) 
(Handy quick reference guide for some common commands)

[https://www.guru99.com/linux-commands-cheat-sheet.html](https://www.guru99.com/linux-commands-cheat-sheet.html)
(A much bigger cheat sheet)

There are many useful programs for performing a plethora of functions, and when they are strung together in 'pipes'
allow you to do some pretty powerful processing of your files. Here is one excellent introduction to most of these
commands: [https://dev.to/awwsmm/101-bash-commands-and-tips-for-beginners-to-experts-30je](https://dev.to/awwsmm/101-bash-commands-and-tips-for-beginners-to-experts-30je)


## Installing software

You wont have the necessary permissions to install software in the system directories. Instead, you should aim to use
conda as much as possible.

[Download Miniconda](https://docs.conda.io/en/latest/miniconda.html)

[Linux install instructions](https://conda.io/projects/conda/en/latest/user-guide/install/linux.html)

[Getting started with conda](https://conda.io/projects/conda/en/latest/user-guide/getting-started.html)

## Persistent sessions

There are many benefits to using tmux but the biggest is that it allows you to shutdown your computer without having to 
end your session on the server. 

If it's not already installed and you're using conda, then you can install it like so:

`conda install tmux`

The wiki page has everything you need to know [https://github.com/tmux/tmux/wiki/Getting-Started](https://github.com/tmux/tmux/wiki/Getting-Started)
but a couple of commands are all you need to get started:
 - `tmux` will start a new session
 - _Ctrl_ + _b_, then _d_ detatch from the session
 - `tmux ls` will list the current sessions (by default they're numbered 0-9)
 - `tmux a -t 0` will attach to session number 0
 - `exit` will close the session you're in

## Submitting jobs

DeepThought uses slurm. Most of the time you will be given a template submission script by the HPC's sysadmin and you'll
just modify that whenever you want to submit something. 
[Rob has covered the basics here:](https://fame.flinders.edu.au/blog/2020/09/01/deepthought), and a more thorough 
explanation of the tools is covered in the [Slurm quickstart guide](https://slurm.schedmd.com/quickstart.html), and the 
[tutorial series](https://slurm.schedmd.com/tutorials.html).

If your HPC uses the Sun Grid Engine (SGE) instead of slurm you'll want something like this: 
[https://www.uibk.ac.at/zid/systeme/hpc-systeme/common/tutorials/sge-howto.html](https://www.uibk.ac.at/zid/systeme/hpc-systeme/common/tutorials/sge-howto.html)

