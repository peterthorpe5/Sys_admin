# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin
source /storage/home/users/pjt6/qstatFunctions.sh

# this is where the nr nt diamond db are
export BLASTDB=/shelf/public/blastntnr/blastDatabases

# conda. Force it to find it:
#export PATH=/shelf/apps/pjt6/conda/bin/:$PATH

# ausustus!!
export AUGUSTUS_CONFIG_PATH=~/shelf_apps/apps/augustus-3.2.1/config/
export PATH=$HOME/shelf_apps/apps/augustus-3.2.1/bin/:$HOME/shelf_apps/apps/augustus-3.2.1/src/:$HOME/shelf_apps/apps/augustus-3.2.1/scripts/:$PATH

# old blast clust form metapy and transposon psi
export PATH=/storage/home/users/pjt6/shelf_apps/apps/OLD_BLAST_FOR_BLASTCLUST/blast-2.2.26/bin/:$PATH

# recon for repeatmodeller
export PATH=/storage/home/users/pjt6/shelf_apps/apps/RECON-1.08/bin/:/storage/home/users/pjt6/shelf_apps/apps/RECON-1.08/scr/:$PATH

# latest version of blast
export PATH=/shelf/apps/ncbi-blast-2.7.1+/bin/:$PATH

# mcscanx
export PATH=/storage/home/users/pjt6/shelf_apps/apps/MCScanx-master//:$PATH

#genomtools
export PATH=/storage/home/users/pjt6/shelf_apps/apps/genometools/bin/:$PATH

# rmblast
#export PATH=/storage/home/users/pjt6/shelf_apps/apps/rmblast-2.2.28/rmblastn-2.2.28/bin/$PATH

# repeatmasker
#export PATH=$HOME/shelf_apps/apps/RepeatMasker/:$PATH

# repeatscout 
export PATH=/storage/home/users/pjt6/shelf_apps/apps/RepeatScout-1/:$PATH

export PATH

# load gcc version 6.3.1 - i think
#source /opt/rh/devtoolset-6/enable


# MCR matlab stuff for GapFinisher:
#export LD_LIBRARY_PATH=/shelf/apps/pjt6/apps/mcr/v717/runtime/glnxa64:/shelf/apps/pjt6/apps/mcr/v717/bin/glnxa64:/shelf/apps/pjt6/apps/mcr/v717/sys/os/glnxa64:/shelf/apps/pjt6/apps/mcr/v717/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:/shelf/apps/pjt6/apps/mcr/v717/sys/java/jre/glnxa64/jre/lib/amd64/server:/shelf/apps/pjt6/apps/mcr/v717/sys/java/jre/glnxa64/jre/lib/amd64/:$LD_LIBRARY_PATH


#Next, set the XAPPLRESDIR environment variable to the following value:
#export XAPPLRESDI=/shelf/apps/pjt6/apps/mcr/v717/X11/app-defaults/:$XAPPLRESDI

