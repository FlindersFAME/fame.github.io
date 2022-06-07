---
layout: single
show_date: true
title: "Therapeutic Annotation of Phage Genomes"
tags: phage genomics annotation
author: Rob Edwards
excerpt: "What should we worry about before we inject phage into people?"
---

# Annotating phage for therapeutics

It is always therapeutic to annotate phages, but in this instance we are specifically thinking about how we annotate phages so that we can use them for therapeutic purposes.

Rob is giving a talk at [ESCMID](https://www.escmid.org/fileadmin/src/media/PDFs/1Dates_Events/event_flyers/ESGNTA_Course22_web.pdf) entitled "The annotation of therapeutic phages" where he discusses some of the issues that come up. This blog post accompanies that talk and provides links to some of the papers that he discusses.


# Host lifestyle prediction

It is generally accepted that lysogeny is bad for therapeutic phages, but there are ways around it.
Lysogeny can lead to superinfection exclusion, recombination with other phages, and the development of phage resistance.

Here are some tools that can be used to predict whether phages are lytic or lysogenic

- [PHACTS](https://academic.oup.com/bioinformatics/article/28/5/614/248018) and Kate's [GitHub Repo](https://github.com/deprekate/PHACTS)
- [BACPHLIP](https://peerj.com/articles/11396/) and the associated [GitHub Repo](https://github.com/adamhockenberry/bacphlip)
- [DeePhage](https://academic.oup.com/gigascience/article/10/9/giab056/6366926) and their [GitHub Repo](https://github.com/shufangwu/DeePhage)

We can overcome lysogeny, either through engineering phages, or through Gibson Assembly based on prophage sequences. These two papers suggest some cutting edge approaches to making that happen!

- [Engineering phages](https://www.nature.com/articles/s41591-019-0437-z)
- [Gibson Assembly](https://journals.asm.org/doi/10.1128/mSystems.00659-20) of prophages without their integration cassettes


# Toxins

Phages encode a lot of toxins! They help the bacteria replicate and escape a nasty death, and provide a mechanism for the spread of the phage. 

In _Streptococcus_, the presence of toxins [helps the bacteria spread](https://journals.asm.org/doi/full/10.1128/JB.187.10.3311-3318.2005), and we know phages [control bacterial virulence](https://journals.asm.org/doi/10.1128/IAI.70.8.3985-3993.2002).




# Antibiotic resistance

Obviously it would be bad if the phage encoded an antibiotic resistance cassette, and there is some evidence that they do occassionally:
- [Antibiotic treatment expands the resistance reservoir and ecological network of the phage metagenome](https://www.nature.com/articles/nature12212)
- [Bacteriophages Contribute to the Spread of Antibiotic Resistance Genes among Foodborne Pathogens of the Enterobacteriaceae Family](https://www.frontiersin.org/articles/10.3389/fmicb.2017.01108/full)

But the jury is still out on how important this is! For many, espeically lytic phages, they may not care about antibiotics since they are going to kill the host anyway. There is some debate as to the importance of antibiotic resistance genes in phages.

- [Phages rarely encode antibiotic resistance genes](https://www.nature.com/articles/ismej201690)


## Databases

Nonetheless, because of the overall importance of antibiotic resistance in bacterial genomes (which, after all, is the reason we are here), there are lots of databases that you can use to search for different antibiotic resistance genes.

- [National Database of Antibiotic Resistant Organisms](https://www.ncbi.nlm.nih.gov/pathogens/antimicrobial-resistance/)
- [ABRICATE](https://github.com/tseemann/abricate)
- [AMRfinder](https://journals.asm.org/doi/full/10.1128/AAC.00483-19) and the [NCBI AMRfinder Plus](https://www.ncbi.nlm.nih.gov/pathogens/antimicrobial-resistance/AMRFinder/) 
- [ARG=ANNOT](https://journals.asm.org/doi/10.1128/AAC.01310-13?url_ver=Z39.88-2003)
- [ResFinder](https://academic.oup.com/jac/article/67/11/2640/707208)
- [CARD](https://academic.oup.com/nar/article/45/D1/D566/2333912)
- [VFDB](https://academic.oup.com/nar/article/44/D1/D694/2503049)
- [PATRIC Antibiotic Resistance Database](https://docs.patricbrc.org/user_guides/data/data_types/antimicrobial_resistance.html)


# Ensemble approaches for therapeutic phages

New ways of identifying phages that have the potential for therapy are starting to emerge, and these are some of the ensemble tools that are trying to integrate multiple lines of evidence and provide support for phages for therapy.

- [Phage Leads](https://www.mdpi.com/1999-4915/14/2/342)
- [MultiPHATE](https://academic.oup.com/bioinformatics/article/35/21/4402/5488969) and Carol's [GitHub Repo](https://github.com/carolzhou/multiPhATE)
- [MultiPHATE2](https://academic.oup.com/g3journal/article/11/5/jkab074/6178284) and Carol's [GitHub Repo](https://github.com/carolzhou/multiPhATE2)
- [Characterizing Phage Genomes for Therapeutic Applications](https://www.mdpi.com/1999-4915/10/4/188)



