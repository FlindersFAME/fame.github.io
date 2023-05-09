---
layout: single
show_date: true
title: "How to clone a git repository to develop code"
author: Rob Edwards
tags: git
excerpt: a quick set of commands to clone a repository to update code
---


We're going to clone [PHANOTATE](https://github.com/deprekate/PHANOTATE) so that you can edit the code, and if required make PRs

## Step 1: Fork

Go to the [PHANOTATE](https://github.com/deprekate/PHANOTATE) website and fork this repository to your own account, and then clone this to the machine you are working on: 

```
git clone git@github.com:username/PHANOTATE.git
```

## Step 2: 

Steps to use development phanotate:

1. Fork the git repository to your github account
2. Clone the forked repository to your working machine (`git clone git@github.com:username/PHANOTATE.git`)
3. Create a virtual environment and activate it
```
cd PHANOTATE
virtualenv venv
source venv/bin/activate
```
4. Check the location of your `python` or `pip`: `which python` or `which pip`
5. Install the dependencies: `pip install -r requirements.txt`
6. Make sure you have tRNAScan-SE in your conda environment (`mamba install -c bioconda trnascan-se`)


# Forked Git Repo - how do you update?

If you have forked a `git` repo, and the upstream code has changed, how do you update your code base with the new changes.

## Step 1: add the remote upstream

Check that you have a remote set upstream

```
$ git remote -v                                                                                                               
```

This will show you the current upstreams:

```
origin  git@github.com:linsalrob/Phicore.git (fetch)                                                                                                                   
origin  git@github.com:linsalrob/Phicore.git (push)                                                                                                                    
```

Note that I don't have an upstream set, so now I need to add that. This is the upstream remote for this project, so change it to your project. Note that the upstream user is different from me!

```
$ git remote add upstream git@github.com:npbhavya/Phicore.git                                                                 
```

Now we can see both in our upstreams:

```
$ git remote -v

origin  git@github.com:linsalrob/Phicore.git (fetch)                                                                                                                   
origin  git@github.com:linsalrob/Phicore.git (push)
upstream        git@github.com:npbhavya/Phicore.git (fetch)
upstream        git@github.com:npbhavya/Phicore.git (push)
```

## Step 2: Fetch the upstream code

This updates you with whatever is upstream that has changed:

```
git fetch upstream
```

## Step 3: Switch back to the main branch.

If you are on a new branch that you made, switch back to the `main` branch, or another branch that you want to get the upstream code from

```
git checkout main
```

## Step 4: merge your main with the code from upstream

This will run a merge on your main branch and the upstream users main branch. Hopefully, you haven't made changes (because you've been working on your own branch) and so it should just easily merge.

```
git merge upstream/main
```

## Step 5: fetch and merge

If you need to pull again, use the two commands fetch/merge to get the new data and merge it into your codebase:

```
git fetch upstream
git merge upstream/main
```


