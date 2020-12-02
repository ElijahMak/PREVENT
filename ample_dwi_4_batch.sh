# Job submission for DWI preprocessing on WBIC
# Approx 20 subjects

#!/bin/bash

# Author: Elijah Mak
# Date: 22nd September 2020

# Estimated time on HPHI is _ minutes

# Time
time="2:00:00"

# Memory
mem="4000"

# Number of tasks
nTask=1

# List of subjects to process
input=${1}

# Execute job submission
for subject in `cat $input`; do

sbatch --job-name=em_dwi2 --account hphi --qos=short.q --partition wbic-cs --error=${subject%.*}_%j.err \
--output=${subject%.*}_%j.out --time=${time} --nodes=1 --ntasks-per-node=${nTask} --mem=${mem} \
--wrap="bash ${code}/ample_dwi_4.sh ${subject}"

done
