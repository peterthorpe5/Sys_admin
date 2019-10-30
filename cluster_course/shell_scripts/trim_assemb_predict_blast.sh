#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N pipeline ## job name
#$ -S /bin/bash ## shell where it will run this job
#$ -j y ## join error output to normal output
#$ -cwd ## Execute the job from the current working directory
#$ -pe multi 6
#$ -m e
#$ -M ${USER}@st-andrews.ac.uk



cd $HOME/ngs
# set up some variables
kmer=127
threads=6
trim_path=/shelf/training/Trimmomatic-0.38/

echo "loading required modules"
module load FASTQC

# download the reads:
echo "downloading the reads"
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/DRR021/DRR021340/DRR021340_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/DRR021/DRR021340/DRR021340_2.fastq.gz


# QC the raw
fqc_cmd="fastqc DRR*.fastq.gz"
echo ${fqc_cmd}
eval ${fqc_cmd}

# trim the raw reads
trim_cmd="java -jar ${trim_path}/trimmomatic-0.38.jar PE 
    -summary trim_summary.txt 
    -threads ${threads} -phred33 DRR*_R1.fastq.gz DRR*_R2.fastq.gz DRR_R1_paired.fastq.gz 
    DRR__R1_unpaired.fastq.gz DRR__R2_paired.fastq.gz DRR_R2_unpaired.fastq.gz 
    ILLUMINACLIP:/shelf/training/Trimmomatic-0.38/adapters/TruSeq3-PE.fa:2:30:10 
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:30 MINLEN:147"
echo ${trim_cmd}
eval ${trim_cmd}

# QC the trimmed reads:
fqc_cmd="fastqc DRR*paired.fastq.gz"
echo ${fqc_cmd}
eval ${fqc_cmd}

# assemble with velvet
#########################################################################################
# qc trimmed 
velveth_raw_cmd="velveth unknown_raw_${kmer} ${kmer} -shortPaired 
        -fastq DRR021340_1.fastq.gz DRR021340_2.fastq.gz"
velvethg_raw="velvetg unknown_raw_${kmer}"
echo ${velveth_raw_cmd}
eval ${velveth_raw_cmd}
echo ${velvethg_raw}
eval ${velvethg_raw}

#########################################################################################
# qc trimmedd 
velveth_trim_cmd="velveth unknown_trimmed ${kmer} -shortPaired 
        -fastq DRR_R1_paired.fastq.gz DRR_R2_paired.fastq.gz"
velveg_assembl="velvetg unknown_trimmed"
echo ${velveth_trim_cmd}
eval ${velveth_trim_cmd}
echo ${velveg_assembl}
eval ${velveg_assembl}

# assembly stats
stats="perl $HOME/ngs/scripts/scaffold_stats.pl 
     -f ./unknown*/contigs.fasta 
     > contig_${kmer}_len.stats.txt"
echo ${stats}
eval ${stats}

# blast something ....
# this is where the nr nt diamond db are
export BLASTDB=/shelf/public/blastntnr/blastDatabases

# latest version of blast - this will now be in your path
export PATH=/shelf/apps/ncbi-blast-2.7.1+/bin/:$PATH

# just grab some of the contigs file. Otherwise, it will take ages. 
head -n 10 ./unknown_trimmed/contigs.fa >  first_10_lines.txt

# long lines split up with \ character. Interpreted as one line
blast_cmd="blastn -query first_10_lines.txt -db nt 
        -outfmt 1 \
        -evalue 1e-40 -out n.first_10_lines.txt_versus_nt_outfmt1.out 
        -num_threads ${threads}"
echo ${blast_cmd}
eval ${blast_cmd}
 
# predict genes
conda activate prokka
annotate="prokka --cpus ${threads} ./unknown_trimmed/contigs.fa "
echo ${annotate}
eval ${annotate}

# do assemblies over a whole range of kmers, odd numbers only:
# you should only assemble with odd kmer due to palindromes. 
for kmer in {55..127}
do
    rem=$(($kmer % 2))
    if [ "$rem" -ne "0" ]; then
        echo $kmer
        velveth_trim_cmd="velveth unknown_trimmed ${kmer} -shortPaired 
        -fastq DRR_R1_paired.fastq.gz DRR_R2_paired.fastq.gz"
        velveg_assembl="velvetg unknown_trimmed"
        echo ${velveth_trim_cmd}
        eval ${velveth_trim_cmd}
        echo ${velveg_assembl}
        eval ${velveg_assembl}
    fi
done

