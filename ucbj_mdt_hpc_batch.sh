#!/bin/bash

# Example: bash code/em_noddi_batch.sh list v1(or v2)

module load openmpi-4.0.0-intel-17.0.8-tnwn5io
module load cuda/8.0

# Number of tasks
nTask=1

ListOfSubjects="${1}"

for subject in `cat $ListOfSubjects`;

do
mem="2000"
time="02:30:00"

sbatch --gres=gpu:1 --job-name=noddi --account MAK-SL3-GPU --partition pascal --error$
--output=${subject%.*}_%j.out --time=$time --nodes=1 --ntasks-per-node=$nTask --mem=$$
--wrap="bash /home/fkm24/em_code/ucbj_mdt_hpc.sh ${subject}" \
--mail-type=ALL

sleep 1
