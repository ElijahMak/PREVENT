i=${1}

tbss_fill ${i}.nii 1.3 mean_FA.nii.gz  filled_${i}.nii

applywarp -i ${i}.nii -o MNI152_${i}.nii -r $FSLDIR/data/standard/FMRIB58_FA_1mm.nii.gz --premat=flirt.mat --interp=nn

applywarp -i filled_${i}.nii -o MNI152_filled_${i}.nii -r $FSLDIR/data/standard/FMRIB58_FA_1mm.nii.gz --premat=flirt.mat --interp=nn

autoaq -i MNI152_${i}.nii -a "JHU White-Matter Tractography Atlas" -t 1.3 -o ${i}.txt -p
