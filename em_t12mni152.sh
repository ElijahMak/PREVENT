i=${i}

flirt -in T1w_${i}.nii -ref $FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz -dof 12 -omat flirt_T1_${i}.mat

fnirt --in=T1w_${i}.nii --aff=flirt_T1_${i}.mat --iout=T1w_${i}_MNI.nii  --fout=T1toMNI_warp_${i}.nii.gz --ref=$FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz

applywarp -i wmh_${i}A_FLAIR_T1.nii.gz -r $FSLDIR/data/standard/MNI152_T1_1mm.nii.gz -w T1toMNI_warp_${i}.nii.gz --interp=nearestneighbour -o wmh_${i}A_FLAIR_T1_MNI.nii.gz
