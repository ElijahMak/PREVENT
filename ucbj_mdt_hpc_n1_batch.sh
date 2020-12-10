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
time="01:00:00"

sbatch --gres=gpu:1 --job-name=noddi_n1 --account MAK-SL3-GPU --partition pascal --output=${subject%.*}_%x.out --time=$time --nodes=1 --ntasks-per-node=$nTask --mem=$mem --wrap="bash /home/fkm24/em_code/ucbj_mdt_n1.sh ${subject}"
done
sleep 1
