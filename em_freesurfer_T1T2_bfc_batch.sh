# Job submission for Freesurfer T1T2 on WBIC

#!/bin/bash

# Author: Elijah Mak
# Date: 22nd September 2020

# Estimated time on HPHI is _ minutes

# Time
time="10:00:00"

# Memory
mem="7000"

# Number of tasks
nTask=1

# List of subjects to process
input=${1}

# Execute job submission
for subject in `cat $input`; do

sbatch --job-name=fs7_t1t2bfc --account hphi --qos=long.q --partition wbic-cs --error=${subject%.*}_%j.err \
--output=${subject%.*}_%j.out --time=${time} --nodes=1 --ntasks-per-node=${nTask} --mem=${mem} \
--wrap="bash ${code}/em_freesurfer_T1T2_bfc.sh ${subject}"

done
