i=${1}

tbss_fill ${i}.nii 1.3 mean_FA.nii.gz filled_${i}.nii

deformationScalarVolume -in ${i}.nii -trans mean_combined.df.nii.gz -target IITmean_tensor_256.nii.gz -out ${i}_IIT_NN.nii -vsize 1 1 1 -interp 1
fslorient -setsform 1 0 0 -128 0 1 0 -145 0 0 1 -109 0 0 0 1 ${i}_IIT_NN.nii

deformationScalarVolume -in filled_${i}.nii -trans mean_combined.df.nii.gz -target IITmean_tensor_256.nii.gz -out filled_${i}_IIT_NN.nii -vsize 1 1 1 -interp 1
fslorient -setsform 1 0 0 -128 0 1 0 -145 0 0 1 -109 0 0 0 1 filled_${i}_IIT_NN.nii

autoaq -i ${i}_IIT_NN.nii -a "JHU White-Matter Tractography Atlas" -t 1.3 -o ${i}_IIT_peak.txt -p


# FSL
# fkm24@wbic-gate-1:~/scratch/projects/prevent_dtitk$ flirt -in mean_final_high_res.nii.gz -ref $FSLDIR/data/standard/FMRIB58_FA_1mm.nii.gz -omat flirt.mat -bins 257 -cost corratio -dof 12 -searchrx -90 90 -searchry -90 90 -searchrz -90 90

applywarp -i ${i}.nii -o ${i}_MNI152.nii.gz -r $FSLDIR/data/standard/FMRIB58_FA_1mm.nii.gz --premat=flirt.mat --interp=nn
applywarp -i filled_${i}.nii -o filled_${i}_MNI152.nii.gz -r $FSLDIR/data/standard/FMRIB58_FA_1mm.nii.gz --premat=flirt.mat --interp=nn

autoaq -i ${i}_MNI152.nii.gz -a "JHU White-Matter Tractography Atlas" -t 1.3 -o ${i}_MNI152_peak.txt -p
