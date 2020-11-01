#!/bin/bash
cd /lustre/scratch/hphi/fkm24/em_code
tfile=file_$RANDOM
echo "$1('$2','$3','$4','$5','$6');exit" > ${tfile}.m
chmod 777 $tfile.m
matlab -nodisplay -r "${tfile}"
