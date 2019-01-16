#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N BLASTTraining ## job name
#$ -S /bin/bash ## shell where it will run this job
####$ -j y ## join error output to normal output
#$ -cwd ## Execute the job from the current working directory
#$ -pe multi 2


cd $HOME/ngs/unknown_data/

######################################################################
# lets use BLAST to try and see what the mistery data set was. 
# The likely hood is, it didnt assemble well.
# Let BLASTN a contig against GenBank nt

# this is where the nr nt diamond db are
export BLASTDB=/shelf/public/blastntnr/blastDatabases


# latest version of blast - this will now be in your path
export PATH=/shelf/apps/ncbi-blast-2.7.1+/bin/:$PATH

# just grab some of the contigs file. Otherwise, it will take ages. 
head -n 10 contigs.fa >  first_10_lines.txt

# long lines split up with \ character. Interpreted as one line
blastn -query first_10_lines.txt -db nt -outfmt 1 \
 -evalue 1e-40 -out n.first_10_lines.txt_versus_nt_outfmt1.out -num_threads 2



