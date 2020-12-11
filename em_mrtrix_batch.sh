# Job submission for MRTRIX pipeline

#!/bin/bash

# Author: Elijah Mak
# Date: 21st Nov 2020

# Estimated time on HPHI is 4 minutes

# Time
time="15:00:00"

# Memory
mem="10000"

# Number of tasks
nTask=1

# List of subjects to process
input=${1}

# Execute job submission
for subject in `cat $input`; do

sbatch --job-name=dwi_ap --account hphi --qos=long.q --partition wbic-cs --error=${subject%.*}_%j.err \
--output=${subject%.*}_%j.out --time=${time} --nodes=1 --cpus-per-task=5 --ntasks-per-node=${nTask} --mem=${mem} \
--wrap="bash ${code}/em_mrtrix.sh ${subject}"

done
