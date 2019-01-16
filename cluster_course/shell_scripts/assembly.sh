#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N AssemblyTrain ## job name
#$ -S /bin/bash ## shell where it will run this job
#$ -j y ## join error output to normal output
#$ -cwd ## Execute the job from the current working directory


cd $HOME/ngs

# load the velvet module
module load velvet/gitv0_9adf09f


# velvet : https://github.com/dzerbino/velvet 

##########################################################################################
# set this up with the trimmed reads.  We can compare all the assemblis after
# THE FOLLOWING LINE NEEDS YOUR INPUT (CHANGE ME)
# velveth directory_trim kmer_length(CHANGE_ME) -shortPaired -fastq R1.fq.gz R2.fq.gz
# velvetg directory_trim

#########################################################################################
# raw reads have been subsampled. Every 100th read taken
#velveth directory_subsampled 53 -shortPaired -fastq  ./reads/subsampled_R1.fastq.gz ./reads/subsampled_R2.fastq.gz ./reads/subsampled_R2.fastq.gz
#velvetg directory_subsampled


# the unknown data
velveth unknown_data 53 -shortPaired -fastq  ./reads/unknown_r1.fq.gz ./reads/unknown_r2.fq.gz
velvetg unknown_data


#########################################################################################
# qc trimmedd 
velveth directory_trim 53 -shortPaired -fastq ./subsampled_R1_paired.fastq.gz ./subsampled_R2_paired.fastq.gz
velvetg directory_subsampled


##########################################################################################
# this is the raw data. possibly better to use this for trianing to get a better assembly. 

velveth directory_raw kmer_length(CHANGE_ME) -shortPaired -fastq ./reads/DRR016013_1.fastq.gz ./reads/DRR016013_2.fastq.gz
velvetg directory_raw





