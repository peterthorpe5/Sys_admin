#!/bin/bash

# make a symlink to the in /etc/profile.d
# it is essential this is a symlink as it will be wiped by the system

# make qstat work better
alias qstat='qstat -u \*'

# Ensure all normal users get a personal apps directory
if [ `id -u` -gt 999 ]; then
  mkdir -p /shelf/apps/$USER/apps/
  export APPS=/shelf/apps/$USER/apps/
fi

#export PATH=/mnt/apps/conda/:$PATH

#export PATH=/mnt/apps/openmpi/3.0.0/bin/:$PATH

  #export PATH=/mnt/apps/Python/bin/:$PATH
export PATH=/mnt/apps/:$PATH
export PATH=/shelf/apps/$USER/conda/bin/:$PATH
export PATH=/shelf/apps/$USER/conda/etc/profile.d/:$PATH


#export PATH=/mnt/apps/singularity/2.5.1/bin/:$PATH

#export PATH=/opt/sge/greenify/:$PATH

