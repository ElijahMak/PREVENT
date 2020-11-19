# Create skull-stripped T1 from CAT12
# Author: Elijah Mak

i=${1}
cd ${i}

fslmaths p1${i}.nii -add p2${i}.nii -add p0${i}.nii ${i}_cat12_brain.nii.gz
mri_binarize --i ${i}_cat12_brain.nii.gz --min 0.0001 --o ${i}_cat12_brain_mask.nii.gz
fslmaths ${i}.nii -mul ${i}_cat12_brain_mask.nii.gz ${i}_cat12_brain.nii
