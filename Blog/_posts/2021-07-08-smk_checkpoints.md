# Snakemake Checkpoints

Snakemake checkpoints are a little complex to get your head around, and so here are two examples that will hopefully clarify some use cases.


Before we begin, we're going to design a rule that makes an unknown number of randomly named files (but less than 10 files maximum!)

Here is a simple snakemake rule that will do this, and put them in a directory called `first_directory`.



```python
OUTDIR = "first_directory"


rule all:
    input:
        OUTDIR


rule make_some_files:
    output:
        directory(OUTDIR)
    shell:
        """
        mkdir {output};
	N=$(((RANDOM%10)+1));
        for D in $(seq $N); do
            touch {output}/$RANDOM.txt
        done
        """
```

There are a couple of things you need to know about this block:
1. The `bash` variable `$RANDOM` issues a random number whose maximum size will depend on your particular computer.
2. By using the Modulo, (RANDOM%10) will reduce this to the remainder when you divide by 10. 
    i. If your number is 10, 20, 30, ... etc, the remainder will be zero, so we add one to it.
3. The `bash` command `seq` will make the sequence upto that number (e.g. `seq 10` will run ten times).


_We don't know what files are there!_ 

So we convert this `rule` to a `checkpoint`, by changing the first word in that definition from `rule` to `checkpoint`.

```python
OUTDIR = "first_directory"


rule all:
    input:
        OUTDIR


checkpoint make_some_files:
    output:
        directory(OUTDIR)
    shell:
        """
        mkdir {output};
	N=$(((RANDOM%10)+1));
        for D in $(seq $N); do
            touch {output}/$RANDOM.txt
        done
        """
```

_Notes:_ 
1. We have only changed one word: `rule` -> `checkpoint`.
2. You can run that snakemake pipeline as-is and it will still run


Now we can do something with that checkpoint.

## Check to see which files were made

We can use that checkpoint as an input to another rule. Here, we use it as the input to rule all.

We need to get the directory that the checkpoint makes (OUTDIR) and then the files that are in that directory



```python
OUTDIR = "first_directory"

def get_file_names(wildcards):
    # note 1: ck_output is the same as OUTDIR, but this requires
    # the checkpoint to complete before we can figure out what it is!

    # note 2: checkpoints will have attributes for each of the checkpoint
    # rules, accessible by name. Here we use make_some_files
    ck_output = checkpoints.make_some_files.get(**wildcards).output[0]
    SMP, = glob_wildcards(os.path.join(ck_output, "{sample}.txt"))
    return expand(os.path.join(ck_output, "{SAMPLE}.txt"), SAMPLE=SMP)



rule all:
    input:
        get_file_names


checkpoint make_some_files:
    output:
        directory(OUTDIR)
    shell:
        """
        mkdir {output};
	N=$(((RANDOM%10)+1));
        for D in $(seq $N); do
            touch {output}/$RANDOM.txt
        done
        """
```

_Note:_ See how we used a checkpoint called `make_some_files` and then asked for 
`checkpoints.make_some_files.get(**wildcards).output[0]` in the function? That's the connection!

At that point, snakemake knows not to complete the function until it has the checkpoint completed.

We can also use the output as wild cards in another rule. 


```python
OUTDIR = "first_directory"
SNDDIR = "second_directory"


def get_file_names(wildcards):
    ck_output = checkpoints.make_some_files.get(**wildcards).output[0]
    SMP, = glob_wildcards(os.path.join(ck_output, "{sample}.txt"))
    return expand(os.path.join(ck_output, "{SAMPLE}.txt"), SAMPLE=SMP)

def dup_file_names(wildcards):
    du_output = checkpoints.make_some_files.get(**wildcards).output[0]
    SMPLS, = glob_wildcards(os.path.join(du_output, "{smpl}.txt"))
    return expand(os.path.join(SNDDIR, "{SM}.tsv"), SM=SMPLS)



rule all:
    input: 
        get_file_names,
        dup_file_names,


checkpoint make_some_files:
    output:
        directory(OUTDIR)
    shell:
        """
        mkdir {output};
	N=$(((RANDOM%10)+1));
        for D in $(seq $N); do
            touch {output}/$RANDOM.txt
        done
        """

rule duplicate:
    input:
        get_file_names
    output:
        os.path.join(SNDDIR, "{SAMPLE}.tsv")
    shell:
        """
        touch {output}
        """

```


Here, I am going to use [global wildcards](https://edwards.flinders.edu.au/wildcards-in-snakemake/)
to allow us to read and use the wildcards in different places.

```python

OUTDIR = "first_directory"
SNDDIR = "second_directory"

SMP = None

def get_file_names(wildcards):
    ck_output = checkpoints.make_five_files.get(**wildcards).output[0]
    global SMP
    SMP, = glob_wildcards(os.path.join(ck_output, "{sample}.txt"))
    return expand(os.path.join(ck_output, "{SAMPLE}.txt"), SAMPLE=SMP)

def get_second_files(wildcards):
    ck_output = checkpoints.make_five_files.get(**wildcards).output[0]
    SMP2, = glob_wildcards(os.path.join(ck_output, "{sample}.txt"))
    return expand(os.path.join(SNDDIR, "{SM}.tsv"), SM=SMP2)


rule all:
    input: 
        "list_of_files.txt",
        get_second_files


checkpoint make_five_files:
    output:
        directory(OUTDIR)
    params:
        o = OUTDIR
    shell:
        """
        mkdir {output};
        for D in $(seq 1 5); do
            touch {params.o}/$RANDOM.txt
        done
        """

rule copy_files:
    input:
        get_file_names
    output:
        os.path.join(SNDDIR, "{SAMPLE}.tsv")
    shell:
        """
        touch {output}
        """


rule list_all_files:
    input:
        get_file_names,
        expand(os.path.join(SNDDIR, "{s}.tsv"), s=SMP)
    output:
        "list_of_files.txt"
    shell:
        """
        echo {input} > {output}
        """
```

## What about two different variables

No problem! We can use two checkpoints, and then combine them in a single expand statement.

For example, lets make two random sets of files, and then a third set of files that combines all their
filenames

_Note_: Here I only use 5 random files each time as we could end up with 100 files, but the answer is the same.



```python
OUTDIR = "first_directory"
SNDDIR = "second_directory"
THRDIR = "third_directory"


def combine(wildcards):
    # read the first set of outputs
    ck_output = checkpoints.make_some_files.get(**wildcards).output[0]
    FIRSTS, = glob_wildcards(os.path.join(ck_output, "{sample}.txt"))
    # read the second set of outputs
    sn_output = checkpoints.make_more_files.get(**wildcards).output[0]
    SECONDS, = glob_wildcards(os.path.join(sn_output, "{smpl}.txt"))
    return expand(os.path.join(THRDIR, "{first}.{second}.tsv"), first=FIRSTS, second=SECONDS)



rule all:
    input: 
        combine


checkpoint make_some_files:
    output:
        directory(OUTDIR)
    shell:
        """
        mkdir {output};
        N=$(((RANDOM%5)+1));
        for D in $(seq $N); do
            touch {output}/$RANDOM.txt
        done
        """

checkpoint make_more_files:
    output:
        directory(SNDDIR)
    shell:
        """
        mkdir {output};
        N=$(((RANDOM%5)+1));
        for D in $(seq $N); do
            touch {output}/$RANDOM.txt
        done
        """

rule make_third_files:
    input:
        directory(OUTDIR),
        directory(SNDDIR),
    output:
        os.path.join(THRDIR, "{first}.{second}.tsv")
    shell:
        """
        touch {output}
        """
```

Hopefully this will get you started, but let us know if not!
