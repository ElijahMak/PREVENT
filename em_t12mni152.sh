i=${i}
flirt -in T1w_${i}.nii -ref $FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz -dof 12 -omat flirt_T1_${i}.mat

fnirt --in=T1w_${i}.nii --aff=flirt_T1_${i}.mat --config=T1_2_MNI152_1mm.cnf --iout=T1w_${i}_MNI.nii  --fout=T1toMNI_warp_${i}.nii.gz
