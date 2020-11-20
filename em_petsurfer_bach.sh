#!/bin/bash


# Number of tasks
nTask=1

# Time
time="02:30:0"
input=${1}

for subject in `cat $input`;

do

sbatch --exclusive --job-name=noddi --account MAK-SL3-GPU --partition pascal --error=${subject%.*}_%j.err \
--output=${subject%.*}_%j.out --time=${time} --nodes=1 --ntasks-per-node=$nTask --mem=2500 \
--wrap="bash /home/fkm24/em_code/em_petsurfer.sh $subject "

sleep 1

done
