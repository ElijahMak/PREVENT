# Job submission for quick processes on WBIC

#!/bin/bash

# Author: Elijah Mak
# Date: 22nd September 2020

# Estimated time on HPHI is _ minutes

# Time
time="1:00:00"

# Memory
mem="2000"

# Number of tasks
nTask=1

# List of subjects to process
input=${1}
script=${2}
task=${3}
options=${4}

# Execute job submission
for subject in `cat $input`; do
sbatch --job-name=${task} --account hphi --qos=long.q --partition wbic-cs --error=${subject}/${subject%.*}_%x.err \
--output=${subject}/${subject%.*}_%j.out --time=${time} --nodes=1 --ntasks-per-node=${nTask} --mem=${mem} \
--wrap="bash ${script} ${subject} ${task}"


done
