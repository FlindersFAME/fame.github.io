---
layout: single
show_date: true
tags : phage genome host prediction
title: "Phage genome sequencing for host prediction"
author: Rob Edwards
---

# Global Phage Host Prediction Consortium
## White Paper
## Robert Edwards, Flinders University
### September 2023

## For comment
*Please contact Rob Edwards (robert.edwards@flinders.edu.au)*

# Executive Summary


Infectious diseases are already one of the leading causes of mortality, and the rapid spread of antibiotic resistant bacteria is worsening this threat. Phage therapy is the most promising treatment to tackle the global threat of antimicrobial-resistant bacteria. However, numerous hurdles prevent its widespread implementation. The major benefit of phages is that they are highly specific, infecting only one or a few kinds of bacteria. However, this specificity defines one of the major hurdles: identifying, and accessing, the phages that might treat a patient. Currently, we have to ship the patient’s bacteria around the world to identify phages that might treat it, and then ship candidate phages back to where the treatment is needed. However, we are on the cusp of being able to choose appropriate therapeutic phages based on genome sequencing alone. This will open a new area for phage therapy: phages on demand. As Jean-Paul Pirnay describes it, PhageBeam to send phages via the internet. We should be able to sequence a patient’s bacterial isolate and use machine learning to identify the phage sequences that are most likely to infect that bacterium. Immediately, this would remove one step: the candidate phages could be retrieved and tested. In the long term, those phages could be synthesised locally and tested on the patient’s infection much faster than is currently possible. This project will enable scientists in less developed countries, will discover fundamentals of phage biology, and will save lives by reducing the threat of AMR.

# Current State of the Art

Phages are being used worldwide to treat antimicrobial-resistant bacterial infections. However, successfully using a phage to kill bacteria depends on numerous factors: recognition of capsular polysaccharides (CPS) and lipopolysaccharides (LPS) on the cell surface; recognition of the bacterial receptor by the phage receptor binding protein; DNA translocation from the phage into the cell, and evasion of CRISPR/Cas and restriction/modification systems; eluding the bacterial defence mechanisms; replication; packing; and cell lysis. In the millions of years of evolution between bacteria and phages, they have both developed an arsenal to stop the other, and weapons to stop that arsenal. We know many of the actors that drive this warfare: there are approximately 200 bacterial defence mechanisms described so far, and almost as many anti-defence mechanisms. All of this makes it impossible, a priori, to predict which phage will infect which bacteria, based on the genome sequences alone.

# What the field needs

That prediction is not impossible! Given enough sequenced phages and enough sequenced bacteria, we can build machine learning algorithms to predict which phages successfully kill which bacteria, and importantly, those algorithms will teach us why phages can, or cannot, kill a bacterium. From this, we can learn new bacterial defence mechanisms (e.g., CRISPR/Cas), new phage attack mechanisms, the role of prophages in regulating these interactions, the nature of the bacterial-CPS and bacterial-LPS interactions, and more about fundamental phage biology. We can use this information to select a suitable phage to treat a patient’s bacterial infection, identify where that phage is in the world, and speed up finding phages to cure infections.

The unknowns, which we can’t answer right now, are how may phages is enough, and how many bacteria is enough? We can’t answer these questions because we don’t have the underlying datasets needed to tackle this important challenge. This project will deliver those datasets.


# How can we deliver enough data to create accurate machine learning algorithms?

We need to generate a massive dataset that covers the genomes of phages, the genomes of the bacteria, and the efficiency of plating of each phage on each bacterium (i.e., how many plaques does it form?). Although this sounds like an insurmountable challenge, the hardest part of this has already been done by labs all over the world: they have identified thousands of phages and compared them to thousands of bacteria because this is a cheap and easy experiment that only requires a few laboratory supplies. Almost every phage lab in the world does this experiment: They isolate a new phage from the environment, test it against all the bacteria in their collections and generate a matrix where the rows are bacterial species, the columns are phage species, and the cell contents are a number representing the efficiency of plating. If we can sequence the bacteria and phages that constitute those tables, and capture the sequence data, EOP data, and other data that is generated we can build machine learning algorithms that will predict phage infectivity.

We propose to distribute Oxford Nanopore Mk1C DNA sequencers to phage labs all over the world and have them sequence the bacteria and the phages that they are isolating. We will ask that they provide that data to our central database, and we will encourage them to publish their sequences and analyses of their results and make their data publicly available (e.g., through the NCBI, ENA, and DDBJ). We specifically propose the Mk1C because it will enable researchers in less developed countries to become engaged in this research experience. The Mk1C is a standalone unit that does not require internet access which has been a limiting factor in many countries (e.g., India, Africa) to using the Mk1B MinION

We estimate that one Nanopore Mk1C sequencing run can be used to sequence between 15 and 46 bacterial genomes together with 50 phage genomes.

We will build the computational infrastructure to allow the collaborators to upload their phage and bacterial genomes, the efficiency of plating metrics, and other data they measure (e.g., one-step growth curves, synograms, etc.)  and to integrate them into a publicly available resource. All sequences will be annotated and shared using the RAST database at Argonne National Labs/ the University of Chicago, to ensure consistent and accurate annotations. RAST is the most widely used phage and bacterial genome annotation resource. We will complement those analyses with local analyses using new computational tools we will develop for this process.


# Estimated Budget

For each sample, we estimate that the budget will be (prices are current in AUD):
 - $845 - 50 Bacterial DNA extraction 
 - $1,289 - 50 Phage DNA extractions
 - $699 - V14 barcoding kit for 96 samples
 - $900 - for one V14 flow cell 
 - $218 - 100 assays Qubit

Total: $3,951 (approximately US$2,500 // €2,400)
Therefore, with ~€100,000 we will provide approximately 40 sequencing kits globally, and sequence approximately 2,000 bacterial and phage genomes.



