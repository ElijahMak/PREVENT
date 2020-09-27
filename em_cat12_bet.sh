# Generate brain mask from CAT12 segmentations
module load freesurfer/7.1.0
dir="/lustre/archive/p00423/PREVENT_Elijah/CAT12"

subject=${1}

fslmaths ${dir}/mri/p1T1w_${subject}.nii -add ${dir}/mri/p2T1w_${subject}.nii ${dir}/mri/${subject}_cat12_brain.nii

mri_binarize --i ${dir}/mri/${subject}_cat12_brain.nii.gz --min 0.001 --o ${dir}/mri/${subject}_cat12_brain_mask.nii

fslmaths ${dir}/T1w_${subject}.nii -mul ${dir}/mri/${subject}_cat12_brain_mask.nii ${dir}/mri/T1w_${subject}_cat12_brain.nii
