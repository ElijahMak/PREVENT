# Job submission for NODDI on HPC

# Author: Elijah Mak
# Date: 30th October 2020

# Time
time="2:00:00"

# Memory
mem="2500"

# Number of tasks
nTask=1

# List of subjects to process
input=${1}

# Execute job submission

for subject in `cat $input`;

do

sbatch --exclusive --job-name=mdt_mrtrix --account MAK-SL3-GPU --partition pascal --error=${subject%.*}_%j.err \
--output=${subject%.*}_%j.out --time=${time} --nodes=1 --ntasks-per-node=$nTask --mem=$mem \
--wrap="bash /home/fkm24/code/fwpk_0_mdt_mrtrix.sh $subject"

done
