---
layout: single
category: blog
show_date: true
title: "Part 1: DeepThought General Overview"
author: Rob Edwards
tag: DeepThought
excerpt: Introduction To Using the Flinders HPC 'DeepThought' For Bioinformatics
---

### _Series: An Introduction To Using DeepThought For Bioinformatics_


## Getting access

Before you begin, you need to request access to deepthought. Open a service one ticket

 - Technology
   - Request something
   - Access
   - Ask for access to the HPC.

It will take a couple of hours for the access to propogate once it has been approved, so be patient!

Once your account is approved, you need to login using one of the `ssh` applications. On windows that is probably [putty](https://putty.org/), on a Mac or Linux you can use a terminal.

Access `deepthought` using ssh. Be sure to replace `FAN` with your FAN (e.g. edwa0468 - but not that one because it is mine!).

```bash
ssh FAN@deepthought.flinders.edu.au
```

## Looking around

`DeepThought` has a master node that you have just logged into, and some compute nodes that you are going to run your jobs on. At the moment, you have a very vanilla access to `DeepThought`, but we will change that soon.

Let's see what sort of capacity you have access to.

### How much disk space is free?

Runing this command:

```bash
df -h
```

Will summarize the disks that are mounted on the system. There are two that are of main interest to you - `/home` and `/scratch`.

#### /home

This is where you are now, and where most of your files reside. This machine (at the time I wrote this), has a total capacity of 11 TB but only has about 5 TB free.

You should use this disk for your general storage and moving data in and out (see the section on [scp](#scp) below).

#### /scratch

This is a much larger disk (currently 86 TB capacity, 20 TB free) that you should put your data on to be computed against. Access from this disk to the nodes is much faster.


### Computers and Nodes

#### Total resources available

Let's take a look at the computers. First, lets see what nodes are on the cluster. Here, the `sinfo` command is our friend. (this command uses the lower case l, el)

```bash
sinfo -lN 
```

> **Tip:** If you need more information about one of these commands, you can use the built in `man` function to find out details, options, and other information. e.g. this command will show you the manual for the `sinfo` command: `man sinfo`


The `sinfo -lN` command will give you an output that looks like:

```
NODELIST     NODES    PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON
hpc-node001      1 hpc_general*       mixed   64    8:8:1 257630     2036      1   (null) none
hpc-node002      1 hpc_general*       mixed   64    8:8:1 257630     2036      1   (null) none
hpc-node003      1 hpc_general*       mixed   64    8:8:1 257630     2036      1   (null) none
hpc-node004      1 hpc_general*       mixed   64    8:8:1 257630     2036      1   (null) none
hpc-node005      1 hpc_general*       mixed   64    8:8:1 257630     2036      1   (null) none
hpc-node006      1 hpc_general*       mixed   64    8:8:1 257630     2036      1   (null) none
hpc-node007      1 hpc_general*        idle   64    8:8:1 257630     2036      1   (null) none
hpc-node008      1 hpc_general*       mixed   64    8:8:1 257630     2036      1   (null) none
hpc-node009      1 hpc_general*       mixed   64    8:8:1 257630     2036      1   (null) none
hpc-node010      1 hpc_general*       mixed   64    8:8:1 257630     2036      1   (null) none
hpc-node011      1 hpc_general*       mixed   64    8:8:1 257630     2036      1   (null) none
hpc-node012      1 hpc_general*        idle   64    8:8:1 257630     2036      1   (null) none
hpc-node013      1 hpc_general*        idle   64    8:8:1 257630     2036      1   (null) none
hpc-node014      1 hpc_general*        idle   64    8:8:1 257630     2036      1   (null) none
hpc-node015      1 hpc_general*        idle   64    8:8:1 257630     2036      1   (null) none
hpc-node016      1 hpc_general*       mixed   64    8:8:1 257630     2036      1   (null) none
hpc-node019      1 hpc_general*       mixed  128   2:64:1 205991     2036      1   (null) none
```

Here you can see there are 17 nodes in the `hpc_general` queue (numbered 1-16 and 19), and that nodes 1-16 have 64 CPUs while node 19 has 128 CPUs. The 7<sup>th</sup> column (`MEMORY`) shows the total amount of memory available, but it is actually incorrect for `hpc-node19` as it should read 2059911 and the last `1` has been trimmed off!

We can get a more detailed view of the cluster with `sinfo`:

```
sinfo -N -o "%N %C %e %m"
```

Output:
```
NODELIST CPUS(A/I/O/T) FREE_MEM MEMORY
hpc-node001 14/50/0/64 141760 257630
hpc-node002 13/51/0/64 63845 257630
hpc-node003 10/54/0/64 93446 257630
hpc-node004 10/54/0/64 171371 257630
hpc-node005 10/54/0/64 2768 257630
hpc-node006 16/48/0/64 161281 257630
hpc-node007 0/64/0/64 248048 257630
hpc-node008 0/64/0/64 186572 257630
hpc-node009 0/64/0/64 189368 257630
hpc-node010 0/64/0/64 9408 257630
hpc-node011 0/64/0/64 130621 257630
hpc-node012 0/64/0/64 208122 257630
hpc-node013 0/64/0/64 238717 257630
hpc-node014 0/64/0/64 240312 257630
hpc-node015 0/64/0/64 208728 257630
hpc-node016 60/4/0/64 8833 257630
hpc-node019 20/108/0/128 1235660 2059911
```

Here, we are selecting some specific information (see `man sinfo` for more details). 
Specifically:
 - `%N` means the node name
 - `%C` means the CPU information which tells you the total number of CPUs that are `A`ctive, `I`dle, `O`ther, and `T`otal (ie. A+I+O = T). This is a neat way to see how many CPUs are available for your computation.
 - `%e` means the amount of free memory in megabytes
 - `%m` means the total amount of memory on that node. Note that in this case, `node19` is reported correctly!

> *Aside*: here is a little script to tell you free CPUs: `sinfo -N -o %C | cut -f 2 -d /  | awk '!/I/ {s+=$1} END {print "Free CPUs: ",s}'`
> When I ran this, there were 999 CPUs free!


#### What is being used?

To see what is currently being used by other people, we use the `squeue` command.

This gives a lot of output about _all_ the running jobs. If you don't care about anyone else's jobs, you can add your username (FAN) (e.g. `squeue -u edwa0468` will show you my jobs)

```bash
$ squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
             63566 hpc_gener runJupyt   to0019 PD       0:00      1 (Resources)
             61882 hpc_gener     bash ande0548  R 51-05:55:00      1 hpc-node001
         61914_195 hpc_gener   Farzin shab0021  R 51-02:54:27      1 hpc-node001
         61914_196 hpc_gener   Farzin shab0021  R 51-02:54:27      1 hpc-node002
         61914_169 hpc_gener   Farzin shab0021  R 51-02:54:34      1 hpc-node001
         61914_156 hpc_gener   Farzin shab0021  R 51-02:54:37      1 hpc-node001
         61914_157 hpc_gener   Farzin shab0021  R 51-02:54:37      1 hpc-node002
         61914_143 hpc_gener   Farzin shab0021  R 51-02:54:41      1 hpc-node001
         61914_144 hpc_gener   Farzin shab0021  R 51-02:54:41      1 hpc-node002
         61914_130 hpc_gener   Farzin shab0021  R 51-02:54:45      1 hpc-node001
         61914_131 hpc_gener   Farzin shab0021  R 51-02:54:45      1 hpc-node002
         61914_117 hpc_gener   Farzin shab0021  R 51-02:54:49      1 hpc-node001
         61914_118 hpc_gener   Farzin shab0021  R 51-02:54:49      1 hpc-node002
         61914_105 hpc_gener   Farzin shab0021  R 51-02:54:53      1 hpc-node001
         61914_106 hpc_gener   Farzin shab0021  R 51-02:54:53      1 hpc-node002
          61914_11 hpc_gener   Farzin shab0021  R 51-02:55:00      1 hpc-node002
          61914_22 hpc_gener   Farzin shab0021  R 51-02:55:00      1 hpc-node002
          61914_33 hpc_gener   Farzin shab0021  R 51-02:55:00      1 hpc-node001
          61914_34 hpc_gener   Farzin shab0021  R 51-02:55:00      1 hpc-node002
          61914_57 hpc_gener   Farzin shab0021  R 51-02:55:00      1 hpc-node001
          61914_58 hpc_gener   Farzin shab0021  R 51-02:55:00      1 hpc-node002
          61914_69 hpc_gener   Farzin shab0021  R 51-02:55:00      1 hpc-node001
          61914_70 hpc_gener   Farzin shab0021  R 51-02:55:00      1 hpc-node002
          61914_81 hpc_gener   Farzin shab0021  R 51-02:55:00      1 hpc-node001
          61914_82 hpc_gener   Farzin shab0021  R 51-02:55:00      1 hpc-node002
          61914_93 hpc_gener   Farzin shab0021  R 51-02:55:00      1 hpc-node001
          61914_94 hpc_gener   Farzin shab0021  R 51-02:55:00      1 hpc-node002
             62406 hpc_gener     make sand0335  R 22-23:43:55      1 hpc-node005
             63507 hpc_gener sekh0009 sekh0009  R 1-02:19:37      1 hpc-node006
             63607 hpc_gener sekh0009 sekh0009  R    4:36:35      3 hpc-node[003-004,019]
             62848 hpc_gener     bash qiao0015  R 13-06:05:51      1 hpc-node016
```

This is a little less informative than the `sinfo` command at this stage since we don't have anything queued, and mostly what we want to know is are there free resources we can accesss. However, it also shows you who is running what on the cluster.

You can modify this as we did before to see more specific information about the jobs running on the cluster, e.g.:

```
squeue   -o "%i %j %N %C %m"
```

Mostly we will use `squeue` to monitor our own jobs and ensure that they are running on the cluster.


## Getting started with a simple job submission

Let's just make a really simple job submission so that we can see the cluster in action and make sure we can run things. This is a trivial starting point, but it will allow you to submit a job and provide a template that you can modify later.

We are going to use `vim` to create this script. There are [lots of tutorials](https://www.google.com/search?q=vim+tutorial) about `vim` and we won't cover the details here, but we'll provide you with the key commands you need to complete these steps. 

> You should invest the time to learn one of the text editors, as it makes life a lot easier working in the command line. Common editors include `nano`, `vim`, and `emacs`. `nano` is definitely the most straightforward, but `vim` and `emacs` have a lot of hidden power!

Start by creating a simple text file called `simple.slurm`:

```bash
vim simple.slurm
```

This will open a blank document with a daunting blank `vim` screen. The `~` signs on the left tell you that you are at the end of the file (because it is empty). The white line a the bottom tells you the file name on the left, and the position in the file on the right. As you will see, the numbers on the right will change as we add text.

The very bottom line (in black) tells you that you have a new file.

Press the `i` key, and notice that the bottom line changes to **`-- INSERT --`**

Now you can type in the screen. 

You can copy and paste this text:

---

```text
#!/bin/bash

# How many tasks and processes.
# Most of the time you will only have a single task. 
# But often that task may want multiple threads, and we 
# set --cpus-per-task to the number of threads we request.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

# How much memory
#SBATCH --mem=10M

# Put your code to run here:
echo "Hello from the cluster. We are running on node " $HOSTNAME
```

---

Once you have pasted that text, press the `Esc` key (top left on your keyboard). This takes you out of `--INSERT--` mode, and the bottom line changes. 

Now type `:w`. Note that the `:` (colon) is very important. This means `write` the file out.

Finally, press `:q` (again, the `:` is important), and this will quit the file.

---

Let's break that file down line by line to see what each line does:

The first line tells the cluster that we are going to use a shell called `bash`. You should always use `bash`, unless you know what you are doing <small>(but then why are you reading this?)</small>
```
#!/bin/bash
```

> Tip: make sure that the line that begins `#!/` is the first line in the file, or you will get an error later (that says the first line should start with `#!`)

The next two lines specify how many tasks we want to run. In this case, we are just running a single task, but later we might add more tasks or CPUs per task. However, this is a good way to get started.

```
# How many tasks and processes
#SBATCH --ntasks=1
```

The next two lines say how much memory we want to consume. In this case, we are asking for 10 MB of memory, which is not very much, but we don't really need a lot for this command. You may want to ask for 100M or 1G. There is a penalty for asking for more, but we will see that later.

```
# How much memory
#SBATCH --mem=10M
```

Finally, you put whatever command you want to run. Here, we just print a message out.

```
# Put your code to run here:
echo "Hello from the cluster. We are running on node " $HOSTNAME
```

_Remember:_ To save the file and exit `vim` we use the command `:wq` and press enter.


### Run your command on the cluster

To submit this code to the cluster, we use this command:

```
sbatch simple.slurm
```

It will tell you that you have submitted a batch job, and tell you the ID of the job. 

To see your jobs, you can use:

```
squeue
```

or 

```
squeue -u FAN
```
(where FAN is your FAN)

Initially it will say something like this:

```
63699 hpc_gener simple.s edwa0468 PD       0:00      1 (Priority)
```
 
and the `PD` means that the job is in the queue. Eventually the `PD` will turn to `R` and that will mean that the job is running.

This job will not take a long time to run, and so you may not see that in the queue! 

Once you no longer see your job in the queue, you should look for the output. If you use `ls -ltr` it will show you the files with the newest one _last_, and that should be your output. It will be called something like `slurm-63699.out` (but the number will be different, that is your job number!)

You can `cat` the contents of the file to see the output by typing `cat` and then the name of the file. e.g.

```
cat slurm-63699.out
```


### Other commands

You can change the line that starts `echo` to something else, or add stuff below it. For example, if you want to see what files you have available, you can add `ls -l`. 

Here are some other suggestions that you could add after the line beginning `echo`

```
echo "Current directory is $PWD"
```

```
echo "number of processors is one more than this: "
cat /proc/cpuinfo  | grep ^processor | tail -n 1
```

```
echo "The current load on this node is:
top -b -n 1 |grep Cpu
```

```
echo "The amount of memory is:
free -h
```

```
echo "The amount of disk space is:"
df -h .
```

### Adding more complex scripts

Instead of calling the commands like we did here, you can put them (or anything else!) into a script, and call that from the end of this slurm submission script!


# Up Next

In the [next section](condadeepthought) we will start to install some bioinformatics tools and use them.













