#!/bin/bash
#$ -cwd
set -euo pipefail
# Title:
# script to convert download NR, swiss prot, 
# human stuff and make blastdb with it.

cd /shelf/public/blastntnr/blastDatabases

# Define a timestamp function
timestamp() {
  date +"%Y-%m-%d_%H"
}

# remove old files. 
rm_cmd="rm -rf prot.accession2taxid.gz.md5 prot.accession2taxid.gz categories.dmp 
        delnodes.dmp  gencode.dmp
        names.dmp citations.dmp   division.dmp  merged.dmp   nodes.dmp  \
        taxcat.zip taxdump.tar.gz nr.faa taxdb.btd  taxdb.bti  taxdb.tar.gz"
echo ${rm_cmd} > Update_blast_db_(timestamp).log


# get the accession to txid db -N (dont if time stamp is the same. 
wget  -N ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/prot.accession2taxid.gz.md5
wget  -N ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/prot.accession2taxid.gz
md5sum -c prot.accession2taxid.gz.md5
pigz -d prot.accession2taxid.gz

# get the tax id files
wget  -N ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxcat.zip
unzip -o taxcat.zip

# download the tx id database. Yes yet more files
wget  -N ftp://ftp.ncbi.nlm.nih.gov/blast/db/taxdb.tar.gz

# get the tax dump files
wget  -N ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz
#tar -zxvf taxdump.tar.gz

# download human genomic
perl update_blastdb.pl --passive --force human_genomic

# download nr
perl update_blastdb.pl --passive --force blastdb nr

# download nt
perl update_blastdb.pl --passive --force blastdb nt

# download swissprot
wget  -N ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz

# uncompress all folder
folders=*.tar.gz
for folder in ${folders}
do
    tar -zxvf ${folder}
done


export BLASTDB=/shelf/public/blastntnr/blastDatabases

# diamond can only use protein databases. Gnerate AA fasta
blastdbcmd -entry 'all' -db nr > nr.faa

echo "im making the nr fasta file"

# load diamond v0.7.11.60
module load diamond
diamond makedb --in nr.faa -d nr.module_load

/storage/home/users/pjt6/shelf_apps/apps/diamond makedb --in nr.faa -d nr

echo "nr fasta done"
pigz -d uniprot_sprot.fasta.gz 
diamond makedb --in uniprot_sprot.fasta -d uniprot_moduleload

/storage/home/users/pjt6/shelf_apps/apps/diamond makedb --in uniprot_sprot.fasta -d uniprot

# we could do uniref90 - but not needed for us so far ...
# diamond makedb --in /mnt/shared/cluster/blast/ncbi/extracteduniref90.faa -d uniref90


# files required for python script to get tax id and species name ..

echo "downloading and unzipping done"
pigz -d prot.accession2taxid.gz

python prepare_accession_to_description_db.py

echo "four discription to accession number database done"

pigz prot.accession2taxid

echo "deleting nr.faa"
rm nr.faa
echo "finished"
