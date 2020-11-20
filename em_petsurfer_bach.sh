#!/bin/bash


# Number of tasks
nTask=1

# Time
time="02:30:0"
input=${1}
mem="2000"
for subject in `cat $input`;

do

  sbatch --job-name=fs7_t1t2bfc --account hphi --qos=long.q --partition wbic-cs --error=${subject%.*}_%j.err \
  --output=${subject%.*}_%j.out --time=${time} --nodes=1 --ntasks-per-node=${nTask} --mem=${mem} \
  --wrap="bash ${code}/em_petsurfer.sh ${subject}"

  done
=

done
