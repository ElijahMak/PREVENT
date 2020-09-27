# Generate brain mask from CAT12 segmentations
module load freesurfer/7.1.0

subject=${1}

fslmaths p1T1w_${subject} -add p2T1w_${subject} ${subject}_cat12_brain.nii
mri_binarize --i ${subject}_cat12_brain.nii --min 0.001 --o ${subject}_cat12_brain_mask.nii
fslmaths T1w_${subject} -mul ${subject}_cat12_brain_mask.nii T1w_${subject}_cat12_brain
