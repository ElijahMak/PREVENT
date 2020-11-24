# Create skull-stripped T1 from CAT12
# Author: Elijah Mak

i=${1}

fslmaths p1${i}.nii -add p2${i}.nii -add p3${i}.nii ${i}.brain.tmp.nii
fslmaths ${i}.brain.tmp.nii -thr 0.001 ${i}.brain.mask.nii
fslmaths ${i}.nii -mul ${i}.brain.mask.nii ${i}.brain.nii
rm ${i}.brain.tmp*
