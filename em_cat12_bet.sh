fslmaths p1T1w_${subject} -add p2T1w_${subject} cat12_brain.nii
mri_binarize --i cat12_brain.nii --min 0.001 --o cat12_brain_mask.nii
fslmaths T1w_${subject} -mul cat12_brain_mask.nii T1w_${subject}_cat12_brain
