# Download the data, filter

wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/DRR021/DRR021340/DRR021340_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/DRR021/DRR021340/DRR021340_2.fastq.gz

pigz -d *.gz

conda activate python27 
python Filter_fastq_for_every_nth_sequence.py -i DRR021340_1.fastq -n 10 -o subsampled_R1.fastq
python Filter_fastq_for_every_nth_sequence.py -i DRR021340_2.fastq -n 10 -o subsampled_R2.fastq
pigz *.fastq

# fastqc blahblahblah

# cp the folder over
cp -rv /shelf/training/ ~/ngs

# trim the reads. 
java -jar /shelf/training/Trimmomatic-0.38/trimmomatic-0.38.jar PE -summary trim_summary.txt -threads 2 -phred33 subsampled_R1.fastq.gz subsampled_R2.fastq.gz subsampled_R1_paired.fastq.gz subsampled_R1_unpaired.fastq.gz subsampled_R2_paired.fastq.gz subsampled_R2_unpaired.fastq.gz ILLUMINACLIP:/shelf/training/Trimmomatic-0.38/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:45 

module load velvet/gitv0_9adf09f

# https://www.ebi.ac.uk/ena/data/view/ERR861370

# velvet assembly - subasmpled
velveth directory_subsampled 77 -shortPaired -fastq  subsampled_R1.fastq.gz subsampled_R2.fastq.gz
velvetg directory_subsampled

# velvet assembly - trimmed
velveth directory_subsampled_trimed 77 -shortPaired -fastq  subsampled_R1_paired.fastq.gz subsampled_R2_paired.fastq.gz
velvetg directory_subsampled_trimed

# velvet assembly - raw
velveth directory_raw 77 -shortPaired -fastq  subsampled_R1_paired.fastq.gz subsampled_R2_paired.fastq.gz
velvetg directory_raw

# velvet assembly - trimmed
velveth directory_subsampled_trimed127 127 -shortPaired -fastq  subsampled_R1_paired.fastq.gz subsampled_R2_paired.fastq.gz
velvetg directory_subsampled_trimed127

# sudo get all stats:
perl /storage/home/users/pjt6/ngs/scripts/scaffold_stats.pl -f /storage/home/users/*/ngs/directory_raw/contigs.fasta > all_raw.txt
perl /storage/home/users/pjt6/ngs/scripts/scaffold_stats.pl -f /storage/home/users/*/ngs/directory_trimmed/contigs.fasta > all_trimmed.txt



blastn -task megablast -query first_20_lines.txt -db nt -outfmt '6 qseqid staxids bitscore std scomnames sscinames sblastnames sskingdoms stitle' -evalue 1e-20 -out n.first_20_lines.txt_versus_nt.out -num_threads 16

blastn -task megablast -query first_10_lines.txt -db nt -outfmt '6 qseqid staxids bitscore std scomnames sscinames sblastnames sskingdoms stitle' -evalue 1e-20 -out n.first_10_lines.txt_versus_nt.out -num_threads 16






