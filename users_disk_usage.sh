#!/bin/bash
#####################################################################
# script to calculate the usage of all users.
# report how much disc space is used.
# compare users usage to yesterday.
# Over time this can be plotted and we can see changes and spikes
# Author: Peter Thorpe 20181013
#####################################################################
d=$(date +%Y_%m_%d)
yest=$(date --date="yesterday" +"%Y_%m_%d")
echo "$d"

cd /mnt/system_usage

# STEP: 1
# get the disk space info
df_cmd="df > ./data/current_disks_status_${d}.txt"
echo ${df_cmd}
eval ${df_cmd}


# command to calc and sort the usage of all the users:
cd /storage/home/users

# STEP: 2
#  command to calc and sort the usage of all the users:
echo "calc: users usage."
# removed sort as this then requires du to have finished and 
# takes too long  | sort -n -rn
du_cmd="du -s * > 
	   /mnt/system_usage/data/users_usage_${d}.txt"
echo ${du_cmd}
eval ${du_cmd}
wait


# STEP: 4
#  python convert bytes to human readable and compare with yesterday:
cd /mnt/system_usage
echo "chewing with python."
py_cmd="/mnt/apps/Python3.7/bin/python3.7 compare_usage.py 
	--today /mnt/system_usage/data/users_usage_${d}.txt 
	--yesterday /mnt/system_usage/data/users_usage_${yest}.txt 
	-o /mnt/system_usage/data/USAGE_and_USAGE_CHANGE_${d}.txt"
echo ${py_cmd}
eval ${py_cmd}
wait

 
 
