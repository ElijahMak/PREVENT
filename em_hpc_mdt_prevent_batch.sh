#!/bin/bash

# This is the job submission script to perform NODDI fitting using the MDT toolbox for all PREVENT subjects.

# Number of tasks
nTask=1

# Time
time="02:30:0"
input=${1}

for subject in `cat $input`;

do

sbatch --exclusive --job-name=noddi --account MAK-SL3-GPU --partition pascal --error=${subject%.*}_%j.err \
--output=${subject%.*}_%j.out --time=${time} --nodes=1 --ntasks-per-node=$nTask --mem=2500 \
--wrap="bash /home/fkm24/em_code/em_hpc_mdt_prevent.sh $subject 1"

sleep 1

done
