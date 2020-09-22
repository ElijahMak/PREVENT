# Job submission for diffusion preprocessing on HPC
#!/bin/bash
# Author: Elijah Mak
# Date: 16th September 2020

# Estimated time on HPC is 35 minutes

# Time

time="00:35:00"

# Memory

mem="2500"

# Number of tasks

nTask=1

# List of subjects to process

input=${1}
BET=${2}

# Execute job submission

for subject in `cat $input`;

do

sbatch --exclusive --job-name=edc --account MAK-SL3-GPU --partition pascal --error=${subject%.*}_%j.err \
--output=${subject%.*}_%j.out --time=${time} --nodes=1 --ntasks-per-node=$nTask --mem=$mem \
--wrap="bash /home/fkm24/rds/hpc-work/prevent_700/PREVENT/em_hpc_diffusion_prevent_acqparams2.sh $subject $BET" --mail-type=ALL

sleep 1

done
