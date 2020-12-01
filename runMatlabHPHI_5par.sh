#!/bin/bash
cd /lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi/lastbatch/
tfile=file_$RANDOM
echo "$1('$2','$3','$4','$5','$6');exit" > ${tfile}.m
chmod 777 $tfile.m
matlab -nodisplay -r "${tfile}"
