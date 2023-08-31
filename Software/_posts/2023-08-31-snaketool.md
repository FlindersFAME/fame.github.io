---
layout: single
tags: Snaketool, Snakemake
title: Snaketool and Nektool
author: Michael Roach
---

Snaketool and Nektool are frameworks for building command line tools using the Snakemake or Nextflow workflow managers<!--more-->

- [Snaketool GitHub page](https://github.com/beardymcjohnface/Snaketool)

Writing reliable command line tools requires a lot of boilerplate to ensure input and generated files are valid, catch errors with subprocesses, log stderr messages etc. 
It's very time-consuming and annoying.

Snakemake does a lot of heavy lifting in this regard and is an obvious alternative to a command line tool.
While Snakemake pipelines are excellent, cloning a pipeline repo every time you want to run an analysis is also annoying. 
So too is manually punching in the full path to a Snakefile somewhere on your system, as well as copying and manually updating the config file for your analysis.
Building a Snakemake pipeline with a convenience launcher offers the best of both worlds:

 - Developing command line applications is quicker and easier
 - Installing, running, and rerunning is easier and more convenient
 - You can have subcommands for utility scripts and Snakefiles
 - You can trick NextFlow users into running Snakemake and vice versa
 - Your pipelines have help messages!
