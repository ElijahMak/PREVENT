# Job submission for BEDPOSTX preprocessing on WBIC

#!/bin/bash

# Author: Elijah Mak
# Date: 22nd September 2020

# Estimated time on HPHI is 15 hours

# Time
time="50:00:00"

# Memory
mem="8000"

# Number of tasks
nTask=1

# List of subjects to process
input=${1}

# Execute job submission
for subject in `cat $input`; do

sbatch --job-name=bedpostx --account hphi --qos=day.q --partition wbic-cs --error=${subject%.*}_%j.err \
--output=${subject%.*}_%j.out --time=${time} --nodes=1 --ntasks-per-node=${nTask} --mem=${mem} \
--wrap="module unload fsl/5.0.10; module load fsl/6.0.3; bedpostx ${subject}" --mail-type=ALL

sleep 1
done
