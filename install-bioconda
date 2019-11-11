#!/bin/bash

INSTALLER=/tmp/$USER-miniconda.sh

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $INSTALLER

# if the old 2.6 default /usr/bin version is needed we need to alter this approach
#export PATH=/mnt/apps/Python/bin/:$PATH

############################################################################################
# put the location for the instal to happen eher. No spaces!!
Install_Path=/shelf/apps
# st andrews is weird. Normally $HOME will work.
home_directory_path=/storage/home/users

############################################################################################
sh $INSTALLER -b -p ${Install_Path}/$USER/conda -f

rm $INSTALLER

echo "# folling 3 lines are for conda install. Auto done with install-bioconda" >> ${home_directory_path}/$USER/.bashrc
echo ". ${Install_Path}/$USER/conda/etc/profile.d/conda.sh" >> ${home_directory_path}/$USER/.bashrc
echo "conda activate" >> ${home_directory_path}/$USER/.bashrc
echo "conda deactivate" >> ${home_directory_path}/$USER/.bashrc

# although conda complains about this, it is better to have this so it works through qsub
# otherwise you have to avtivate the conda envs and qsub with -V for it to work
#echo "# conda. Force it to find it:" >> ${home_directory_path}/$USER/.bash_profile
#echo "export PATH=${Install_Path}/$USER/conda/bin/:\$PATH" >> ${home_directory_path}/$USER/.bash_profile

# conda has to be activate to add the channels
source ${home_directory_path}/$USER/.bashrc

conda config --add channels R
conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels etetoolkit
conda config --add channels bioconda

echo "INFO: "
echo "you will have to log out and back in again for this to work. "
echo "Or run:" #echo "      source ~/.bashrc"
echo "We strongly advise using envs: https://conda.io/docs/user-guide/tasks/manage-environments.html"
echo "installing packages: https://bioconda.github.io/recipes.html"

####################
# more info 

extra="1)	Conda. THIS IS THE FUTURE. We highly recommend this:

We are testing Bioconda on Marvin on a per user basis, so you have total control over it. Would you please be our first actual user test? The default python in /usr/bin is python 2.6 which is too old. As a warning, running the following will update this to 2.7 and 3.7. So, only do so if you do not specifically require the python 2.6 version for your other work. Although, you could set up a conda environment with 2.6 if you really wanted. I can’t think of anything that requires 2.6.

1)	Log in and from the command line type (only do this once!):

install-bioconda

2)	Either log out  and back in or type:
source ~/.bashrc

3)	We strongly advise using environments: https://conda.io/docs/user-guide/tasks/manage-environments.html . You can do this in many ways. Please see the link for more details (here you can specifiy eact version etc ..). The easiest usage would be:    e.g.  conda create -n NAME_OF_ENV PACKAGE_TO_INSTALL (pick a package you are interested in from here: installing packages: https://bioconda.github.io/recipes.html ). Roary is a package name as an example. 

conda create -n roary roary

conda activate roary

conda update roary


You are now ready to use this package.

Conda deactivate        to leave this environment. 


This works for me and a test user. But may fail for you, so be patient with us. 

To list all the environments you have created:

conda info –envs

installing packages: https://bioconda.github.io/recipes.html 
"