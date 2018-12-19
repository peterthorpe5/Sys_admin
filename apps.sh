#!/bin/bash

# make a symlink to the in /ect/profile.d

alias qstat='qstat -u \*'

# Ensure all normal users get a personal apps directory
#if [ `id -u` -gt 999 ]; then
if [ $USER == 'te01' ]; then
  mkdir -p /shelf/apps/$USER/apps/
  export APPS=/shelf/apps/$USER/apps/
fi

#export PATH=/mnt/apps/conda/:$PATH

#export PATH=/mnt/apps/openmpi/3.0.0/bin/:$PATH
if [ $USER == 'te01' ]; then
  #export PATH=/mnt/apps/Python/bin/:$PATH
  export PATH=/mnt/apps/:$PATH
  export PATH=/shelf/apps/$USER/conda/bin/:$PATH
  export PATH=/shelf/apps/$USER/conda/etc/profile.d/:$PATH
fi

#export PATH=/mnt/apps/singularity/2.5.1/bin/:$PATH

#export PATH=/opt/sge/greenify/:$PATH

